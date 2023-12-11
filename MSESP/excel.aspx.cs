using Spire.Xls.Core;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class excel : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //String Valor = Request["rut"].ToString();

            string reg = "", com = "", sol = "", tipo = "", mes = "", ano = "", rutp = "", rute = "", orden = "", usrIngreso = "", fi = "", ff = "", est = "", di = "", nc = "", tc = "", tpexcel= "";

            reg = "";
            if (Request["r"] != "" && Request["r"] != "0" && Request["r"] != "null" && Request["r"] != null)
            {
                reg = " and ID_REGION_EPT='" + Request["r"] + "'";
            }

            com = "";
            if (Request["c"] != "null" && Request["c"] != "0" && Request["c"] != null)
            {
                com = " and ID_COMUNA_EPT='" + Request["c"] + "'";
            }

            sol = "";
            if (Request["s"] != "" && Request["s"] != "0" && Request["s"] != "null" && Request["s"] != null)
            {
                sol = " and ID_USUARIO_INGRESO in (SELECT u.ID_USUARIO from usuarios u where u.ID_TIPO_USUARIO=3 and u.ID_AGENCIA in (" + Request["s"] + ")) ";
            }

            tipo = "";
            if (Request["t"] != "" && Request["t"] != "0")
            {
                tipo = " and ID_TIPO_SOLICITUD='" + Request["t"] + "'";
            }

            mes = "";
            /*if (Request["m"] != "0")
            {
                mes = " and month(a.FECHA_SOLICITUD)='" + Request["m"] + "'";
            }*/

            ano = "";
            /*if (Request["a"] != "0")
            {
                ano = " and year(a.FECHA_SOLICITUD)='" + Request["a"] + "'";
            }*/

            rutp = "";
            if (Request["rp"] != "")
            {
                rutp = " and [RUT PACIENTE] like '%" + Request["rp"] + "%'";
            }

            rute = "";
            if (Request["re"] != "")
            {
                rute = " and [RUT EMPRESA] like '%" + Request["re"] + "%'";
            }

            orden = "";
            if (Request["os"] != "")
            {
                orden = " and ORDEN_SINIESTRO like '%" + Request["os"] + "%'";
            }

            fi = "";
            if (Request["fi"] != "")
            {
                fi = " and [FECHA SOLICITUD]>=convert(date, '" + Request["fi"] + "')";
            }

            ff = "";
            if (Request["ff"] != "")
            {
                ff = " and [FECHA SOLICITUD]<=convert(date, '" + Request["ff"] + "')";
            }

            est = "";
            if (Request["est"] != "" && Request["est"] != "0")
            {
                est = " and ESTADOid=" + Request["est"];
            }

            di = "";
            if (Request["di"] != "")
            {
                di = " and DATEDIFF(day, [FECHA SOLICITUD], GETDATE())=" + Request["di"];
            }

            nc = "";
            if (Request["nc"] != "")
            {
                nc = " and [NUMERO SOLICITUD] like '%" + Request["nc"] + "%'";
            }

            usrIngreso = "";
            //if (Request["tp"].ToString() == "3")
            //{
                //usrIngreso = " and a.FECHA_SOLICITUD>=CONVERT(date,'07-04-2017')";
            //}

            tc = "";
            if (Request["tc"] != "0")
            {
                tc = " and ESTADOid NOT IN (9,7,0) ";
            }

            tpexcel = Request["tpexcel"];

            ExportToExcel(reg, com, sol, tipo, mes, ano, rutp, rute, orden, usrIngreso, fi, ff, est, di, nc, Request["p"], tc, tpexcel);
        }

        protected void ExportToExcel(string reg, string com, string sol, string tipo, string mes, string ano, string rutp, string rute, string orden, string usrIngreso, string fi, string ff, string est, string di, string nc, string p, string tc, string tpexcel)
        {
            funciones fn = new funciones();
            string Query = "", tagDerivacion = "";
            /*DataSet dsQuery = fn.dsSql("select 'Nº'=(case when s.NUM_SOLICITUD is null THEN " +
                                       "CONVERT(VARCHAR(4), YEAR(S.FECHA_SOLICITUD))+right('00' + CONVERT(VARCHAR(2),MONTH(S.FECHA_SOLICITUD)), 2)+'-'+ " +
                                       "CONVERT(VARCHAR(4), s.ID_SOLICITUD) else s.NUM_SOLICITUD END), " +
                                       "Tipo=TP.NOMBRE,Fecha=CONVERT(VARCHAR(10),s.FECHA_SOLICITUD, 105),  " +
                                       "Hora=S.HORA_SOLICITUD,Solicitante=u.NOMBRE, " +
                                       "'Región EPT'=(select r.NOMBRE from regiones r where r.ID_REGION=S.ID_REGION_EPT), " +
                                       "'Comuna EPT'=(select c.NOMBRE from COMUNA c where c.ID_COMUNA=S.ID_COMUNA_EPT), " +
                                       "'Forma Ingreso'=f.NOMBRE,Observaciones=dbo.MayMinTexto(s.Observaciones), " +
                                       "'Rut Paciente'=p.RUT, " +
                                       "'Nombre Paciente'=p.NOMBRE,'Orden Siniestro'=s.ORDEN_SINIESTRO, " +
                                       "'Teléfono Fijo'=p.FONO_FIJO,'Teléfono Móvil'=p.FONO_MOVIL, " +
                                       "'Email'=LOWER(P.EMAIL), " +
                                       "'Región'=(select r.NOMBRE from regiones r where r.ID_REGION=p.ID_REGION), " +
                                       "'Comuna'=(select c.NOMBRE from COMUNA c where c.ID_COMUNA=p.ID_COMUNA), " +
                                       "'Dirección'=dbo.MayMinTexto(p.DIRECCION), " +
                                       "'Rut Empresa'=e.RUT,'Nombre Empresa'=dbo.MayMinTexto(e.NOMBRE), " +
                                       "'Región'=(select r.NOMBRE from regiones r where r.ID_REGION=S.ID_REGION_EMPRESA), " +
                                       "'Comuna'=(select c.NOMBRE from COMUNA c where c.ID_COMUNA=S.ID_COMUNA_EMPRESA), " +
                                       "'Dirección'=dbo.MayMinTexto(S.DIRECCION_EMPRESA),  " +
                                       "'Contacto'=dbo.MayMinTexto(S.CONTACTO_NOMBRE), " +
                                       "'Contacto Telefono'=S.CONTACTO_FONO,'Contacto Email'=LOWER(S.CONTACTO_EMAIL), " +
                                       "'Tipo de Caso'=(case S.ID_CASO when 1 then 'STP' ELSE 'CTP' END), " +
                                       "'Profesional Sugerido'=(SELECT PR.NOMBRE FROM PROFESIONALES PR  " +
                                       "WHERE PR.ID_PROFESIONAL=s.ID_PROFESIONAL),'Observaciones'=dbo.MayMinTexto(S.OBSERVACIONES), " +
                                       "[PROF. ASIG. EVA. PSICO. AGENDAMIENTO],[PROF. ASIG. SM EPT AGENDAMIENTO],[PROF. ASIG. ME EPT AGENDAMIENTO],[PROF. ASIG. DERMA AGENDAMIENTO],"+
                                       " from SOLICITUDES s   " +
                                       " inner join empresas e on e.ID_EMPRESA=s.ID_EMPRESA   " +
                                       " inner join pacientes p on p.ID_PACIENTE=s.ID_PACIENTE   " +
                                       " inner join usuarios u on u.ID_USUARIO=s.ID_USUARIO_INGRESO   " +
                                       " INNER JOIN TIPO_SOLICITUD TP ON TP.ID_TIPO_SOLICITUD=S.ID_TIPO_SOLICITUD   " +
                                       " inner join FORMAS_INGRESO f on f.ID_FORMA_INGRESO=s.ID_FORMA_INGRESO  " +
                                       " where 1=1" + reg + sol + com + tipo + ano + mes + rutp + rute + orden + usrIngreso + " order by s.NUM_SOLICITUD desc");
            
            if (p == "1")
            {
                Query = "SELECT 'ESTADO EPT'=[ESTADO],[ESTADO EV.PS.],[NUMERO SOLICITUD],[TIPO SOLICITUD],[TIPO SERVICIO],[FECHA SOLICITUD],[AGENCIA],[DIAS CASO ABIERTO]" +
                                      ",[DIAS PROGRAMACION],[DIA SEMANA INGRESO],[MES INGRESO],[FORMA INGRESO],[HORA INGRESO],[SOLICITANTE],[COMUNA EPT]" +
                                      ",[REGION EPT],[OBSERVACION],[NOMBRE PACIENTE],[RUT PACIENTE],[ORDER SINIESTRO],[FONO FIJO PACIENTE],[FONO MOVIL PACIENTE]" +
                                      ",[DIRECCION PACIENTE],[EMAIL PACIENTE],[RAZON SOCIAL EMPLEADOR],[CONTACTO EMPRESA],[RUT EMPRESA],[FONO EMPRESA]" +
                                      ",[DIRECCION EMPRESA],[COMUNA EMPRESA],[EMAIL EMPRESA],[EMAIL DIRECTOR CARTERA],[TIPO CASO],[PROFESIONAL PREFERENCIA]" +
                                      ",[NUMERO SEGMENTOS],[SEGMENTOS/LATERALIDAD],[CONTACTO PACIENTE],[OBS. CONTACTO PACIENTE],[LLAMADA TELEFONICA]" +
                                      ",[OBS. LLAMADA TELEFONICA],[SOLICITUD DATOS FALTANTES],[OBS. DATOS FALTANTES],[ENVIO CORREO EMPRESA],[OBS. CORREO EMPRESA]" +
                                      ",[ASIGNACION PROFESIONAL],[OBS. ASIGNACION PROFESIONAL],[COORDINACION],[OBS. COORDINACION],[CONFIRMACION],[OBS. CONFIRMACION]" +
                                      ",[RECONTACTAR],[OBS. RECONTACTAR],[SM EVAL. PSICO. AGENDAMIENTO],[OBS. SM EVAL. PSICO AGENDAMIENTO],[PROF. ASIG. EVA. PSICO. AGENDAMIENTO]" +
                                      ",[SM EPT AGENDAMIENTO],[OBS. SM EPT AGENDAMIENTO],[PROF. ASIG. SM EPT AGENDAMIENTO],[ME EPT AGENDAMIENTO]" +
                                      ",[OBS. ME EPT AGENDAMIENTO],[PROF. ASIG. ME EPT AGENDAMIENTO],[DERMA EPT AGENDAMIENTO],[OBS. DERMA EPT AGENDAMIENTO]" +
                                      ",[PROF. ASIG. DERMA AGENDAMIENTO],[RESPALDO MUTUAL DOCS],[OBS. RESPALDO MUTUAL DOCS],[CANCELA SOLICITUD],[OBS. CANCELA SOLICITUD]" +
                                      ",[ANULA SOLICITUD],[OBS. ANULA SOLICITUD],[REABRIR CASO],[OBS. REABRIR CASO] " +
                                      " FROM [MSESP].[dbo].[EXPORT_EXCEL_NEW] " +
                                      " where 1=1 and id_proyecto=" + p + reg + sol + com + tipo + rutp + rute + orden + fi + ff + di + est + nc + tc + " order by [NUMERO SOLICITUD] desc";
            }
            else
            {
                Query = "select [N° Caso],[Estado EPT],[Fecha EPT],[Estado EV.PS.],[Fecha Ev.PS.],[N° Siniestro],[Fecha de Solicitud],[Nombre Paciente],[Rut Paciente],[Teléfono],[Dirección Trabajador]," +
                        "[Correo Electrónico],[Razón Social Empleador],[Contacto Empresa],[Rut Empresa],[Dirección]," +
                        "[Teléfono Empresa],[Comuna Empresa],[N° Segmentos],[Segmentos],[Informado a Mutual] from dbo.EXPORT_EXCEL_RM " +
                        " where 1=1 " + reg + sol + com + tipo + rutp + rute + orden + fi + ff + di + est + nc + tc + 
                        " order by [Fecha Ingreso] asc";
            }*/

            tagDerivacion = " A REGIONES";
            if (p == "1")
            {
                tagDerivacion = " A RM";
            }

            if (tpexcel == "2")
            {
              Query = "select [ESTADO EPT],[ESTADO EV.PS.],[NUMERO SOLICITUD],[TIPO SOLICITUD]," + 
                      "[TIPO SERVICIO],[FECHA SOLICITUD],[AGENCIA]," +
                      "[DIAS CASO ABIERTO],[DIAS PROGRAMACION],[SOLICITANTE],[COMUNA EPT],[REGION EPT]," +
                      "[NOMBRE PACIENTE],[RUT PACIENTE],[FONO FIJO PACIENTE],[FONO MOVIL PACIENTE],[DIRECCION PACIENTE],[ORDER SINIESTRO]," +
                      "[RAZON SOCIAL EMPLEADOR],[CONTACTO EMPRESA],[RUT EMPRESA],[FONO EMPRESA],[DIRECCION EMPRESA],[CONTACTO PACIENTE],[COMUNA EMPRESA]," +
                      "[NUMERO SEGMENTOS],[SEGMENTOS/LATERALIDAD],[SM EVAL. PSICO. AGENDAMIENTO]," +
                      "[SM EPT AGENDAMIENTO],[ME EPT AGENDAMIENTO],[DERMA EPT AGENDAMIENTO]," +
                      "[RESPALDO MUTUAL DOCS EPT],[CANCELA SOLICITUD],[ANULA SOLICITUD]," +
                      "[REABRIR CASO],[INFORMADO A MUTUAL],[USUARIO ÚLTIMA ACCIÓN],[FECHA ÚLTIMA ACCIÓN],[ÚLTIMA ACCIÓN]," +
                      "[PROF. ASIG. EVA. PSICO. AGENDAMIENTO],[PROF. ASIG. SM EPT AGENDAMIENTO],[PROF. ASIG. ME EPT AGENDAMIENTO],[PROF. ASIG. DERMA AGENDAMIENTO], " +
                      "[MACRO AGENTE RIESGO 1],[CRITERIOS OBSERVACIÓN 1],[MACRO AGENTE RIESGO 2],[CRITERIOS OBSERVACIÓN 2],[MACRO AGENTE RIESGO 3],[CRITERIOS OBSERVACIÓN 3] " +
                      "FROM [MSESP].[dbo].[EXPORT_EXCEL_2018] " +
                      " where 1=1 and id_proyecto=" + p + reg + sol + com + tipo + rutp + rute + orden + fi + ff + di + est + nc + tc + " order by [NUMERO SOLICITUD] desc";
            }
            else{
                Query = "SELECT [ESTADO EPT], [ESTADO EV.PS.],[NUMERO SOLICITUD],[TIPO SOLICITUD]," +
                        "[TIPO SERVICIO],[FECHA SOLICITUD],[AGENCIA],[DIAS CASO ABIERTO]," +
                        "[DIAS PROGRAMACION],[DIA SEMANA INGRESO],[MES INGRESO],[FORMA INGRESO]," +
                        "[HORA INGRESO],[SOLICITANTE],[COMUNA EPT],[REGION EPT],[OBSERVACION]," +
                        "[NOMBRE PACIENTE],[RUT PACIENTE],[GENERO PACIENTE],[ORDER SINIESTRO],[FONO FIJO PACIENTE]," +
                        "[FONO MOVIL PACIENTE],[DIRECCION PACIENTE]," +
                        "[EMAIL PACIENTE],[RAZON SOCIAL EMPLEADOR],[CONTACTO EMPRESA]," +
                        "[RUT EMPRESA],[FONO EMPRESA],[DIRECCION EMPRESA]," +
                        "[COMUNA EMPRESA],[EMAIL EMPRESA],[EMAIL DIRECTOR CARTERA]," +
                        "[TIPO CASO],[PROFESIONAL PREFERENCIA]," +
                        "[NUMERO SEGMENTOS],[SEGMENTOS/LATERALIDAD],[CONTACTO PACIENTE],[OBS. CONTACTO PACIENTE]," +
                        "[LLAMADA TELEFONICA],[OBS. LLAMADA TELEFONICA],[SOLICITUD DATOS FALTANTES]," +
                        "[OBS. DATOS FALTANTES],[ENVIO CORREO EMPRESA],[OBS. CORREO EMPRESA]," +
                        "[ASIGNACION PROFESIONAL],[OBS. ASIGNACION PROFESIONAL],[COORDINACION]," +
                        "[OBS. COORDINACION],[CONFIRMACION],[OBS. CONFIRMACION],[RECONTACTAR],[OBS. RECONTACTAR],[SM EVAL. PSICO. AGENDAMIENTO]," +
                        "[OBS. SM EVAL. PSICO AGENDAMIENTO],[PROF. ASIG. EVA. PSICO. AGENDAMIENTO],[FECHA COORD. ASIG. EVA. PSICO.]," +
                        "[COORD. ASIG. EVA. PSICO.],[FECHA REC. INFORME EVA. PSICO.],[REC. INTERNO EVA. PSICO.],[FECHA REC. INTERNO EVA. PSICO.]," +
                        "[REC. COMITE EVA. PSICO.],	[FECHA REC. COMITE EVA. PSICO.],[FECHA CORR. INFORME EVA. PSICO.],[SM EPT AGENDAMIENTO]," +
                        "[OBS. SM EPT AGENDAMIENTO],[PROF. ASIG. SM EPT AGENDAMIENTO],[FECHA COORD. ASIG. SM EPT],[COORD. ASIG. SM EPT]," +
                        "[FECHA REC. INFORME SM EPT],[REC. INTERNO SM EPT],	[FECHA REC. INTERNO SM EPT],[REC. COMITE SM EPT]," +
                        "[FECHA REC. COMITE SM EPT],[FECHA CORR. INFORME SM EPT],[ME EPT AGENDAMIENTO],	[OBS. ME EPT AGENDAMIENTO]," +
                        "[PROF. ASIG. ME EPT AGENDAMIENTO], [FECHA COORD. ASIG. ME EPT],[COORD. ASIG. ME EPT],[FECHA REC. INFORME ME EPT]," +	
                        "[REC. INTERNO ME EPT],	[FECHA REC. INTERNO ME EPT],[REC. COMITE ME EPT],[FECHA REC. COMITE ME EPT],	" +
                        "[FECHA CORR. INFORME ME EPT],[DERMA EPT AGENDAMIENTO],[OBS. DERMA EPT AGENDAMIENTO],[PROF. ASIG. DERMA AGENDAMIENTO], " +	
                        "[FECHA COORD. ASIG. DERMA EPT],[COORD. ASIG. DERMA EPT],[FECHA REC. INFORME DERMA EPT]," +
                        "[REC. INTERNO DERMA EPT],	[FECHA REC. INTERNO DERMA EPT],	[REC. COMITE DERMA EPT],[FECHA REC. COMITE DERMA EPT]," +
                        "[FECHA CORR. INFORME DERMA EPT],[RESPALDO MUTUAL DOCS EV.PSI.],[OBS. RESPALDO MUTUAL DOCS EV.PSI.]," +
                        "[RESPALDO MUTUAL DOCS EPT],[OBS. RESPALDO MUTUAL DOCS EPT]," +
                        "[CANCELA SOLICITUD],[OBS. CANCELA SOLICITUD],[ANULA SOLICITUD],[OBS. ANULA SOLICITUD]," +
                        "[REABRIR CASO],[OBS. REABRIR CASO],[INFORMADO A MUTUAL]," +
                        "(case id_proyecto when 2 then [DERIVACIÓN A RM] when 1 then " +
                        "[DERIVACIÓN A REGIONES] else '' END) as 'DERIVADO" + tagDerivacion + "' " +
                        ",[FECHA SEG.1 AGREGADO],[SEG.1 AGREGADO],[FECHA SEG.2 AGREGADO],[SEG.2 AGREGADO],[FECHA SEG.3 AGREGADO],[SEG.3 AGREGADO]," +
                        "[FECHA SEG.4 AGREGADO],[SEG.4 AGREGADO],[USUARIO ÚLTIMA ACCIÓN],[FECHA ÚLTIMA ACCIÓN],[ÚLTIMA ACCIÓN], " +
                        "[NOMBRE GRUPO],[OCUPACIÓN],[MACRO AGENTE RIESGO 1],[CRITERIOS OBSERVACIÓN 1],[MACRO AGENTE RIESGO 2],[CRITERIOS OBSERVACIÓN 2],[MACRO AGENTE RIESGO 3],[CRITERIOS OBSERVACIÓN 3],[CLASIFICACIÓN COMITE],[ENVIÓ ECT]," +
                        "[MODALIDAD SM EPT AGENDAMIENTO],[MODALIDAD ME EPT AGENDAMIENTO], [MODALIDAD DERMA EPT AGENDAMIENTO]" +
                        " FROM [MSESP].[dbo].[EXPORT_EXCEL_2018] " +
                        " where 1=1 and id_proyecto=" + p + reg + sol + com + tipo + rutp + rute + orden + fi + ff + di + est + nc + tc + " order by [NUMERO SOLICITUD] desc";
            }

            DataSet dsQuery = fn.dsSql(Query);
           
            HttpResponse response = HttpContext.Current.Response;

           response.Clear();
          // response.Charset = Encoding.UTF8.WebName;  //Encoding.UTF8.ToString(); 

           response.ContentType = "application/vnd.ms-excel";

           //response.AddHeader("Content-Disposition", "attachment;filename=\"" + "Sol_EPT_" + DateTime.Now.ToString("ddMMyyyyHHmmss") + "\".xls");

           response.AddHeader("Content-Disposition", "attachment;filename=Sol_EPT_" + DateTime.Now.ToString("ddMMyyyyHHmmss") + ".xls");

           response.Charset = "UTF-8";
           response.ContentEncoding = Encoding.Default;

           using (StringWriter sw = new StringWriter())
           {
            using (HtmlTextWriter htw = new HtmlTextWriter(sw))
            {
             // instantiate a datagrid
             DataGrid dg = new DataGrid();
                    foreach (DataRow row in dsQuery.Tables[0].Rows)
                    {
                        foreach (DataColumn col in dsQuery.Tables[0].Columns)
                        {
                            if(col.ColumnName!= "EMAIL PACIENTE" && col.ColumnName != "EMAIL EMPRESA")
                            {
                                row[col.ColumnName] = row[col.ColumnName].ToString().ToUpper();
                            }
                            else
                            {
                                row[col.ColumnName] = row[col.ColumnName].ToString().ToLower();
                            }
                        }
                    }

             dg.DataSource = dsQuery.Tables[0];
             dg.DataBind();
             dg.RenderControl(htw);
             response.Write(sw.ToString());
             response.End(); 
            }
           }
          

            /*var data;
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                data = new[]{
                              new{ Name="Ram", Email="ram@techbrij.com", Phone="111-222-3333" }
                };
            }
            

           Response.ClearContent();
           Response.AddHeader("content-disposition", "attachment;filename=Contact.xls");
           Response.AddHeader("Content-Type", "application/vnd.ms-excel");
           WriteTsv(data, Response.Output);
           Response.End();*/
        }

        /*public void WriteExcelWithNPOI(DataTable dt, String extension)
        {

            IWorkbook workbook;

            if (extension == "xlsx")
            {
                workbook = new XSSFWorkbook();
            }
            else if (extension == "xls")
            {
                workbook = new HSSFWorkbook();
            }
            else
            {
                throw new Exception("This format is not supported");
            }

            ISheet sheet1 = workbook.CreateSheet("Sheet 1");

            //make a header row
            IRow row1 = sheet1.CreateRow(0);

            for (int j = 0; j < dt.Columns.Count; j++)
            {

                ICell cell = row1.CreateCell(j);
                String columnName = dt.Columns[j].ToString();
                cell.SetCellValue(columnName);
            }

            //loops through data
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IRow row = sheet1.CreateRow(i + 1);
                for (int j = 0; j < dt.Columns.Count; j++)
                {

                    ICell cell = row.CreateCell(j);
                    String columnName = dt.Columns[j].ToString();
                    cell.SetCellValue(dt.Rows[i][columnName].ToString());
                }
            }

            using (var exportData = new MemoryStream())
            {
                Response.Clear();
                workbook.Write(exportData);
                if (extension == "xlsx") //xlsx file format
                {
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "ContactNPOI.xlsx"));
                    Response.BinaryWrite(exportData.ToArray());
                }
                else if (extension == "xls")  //xls file format
                {
                    Response.ContentType = "application/vnd.ms-excel";
                    Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", "ContactNPOI.xls"));
                    Response.BinaryWrite(exportData.GetBuffer());
                }
                Response.End();
            }
        }*/

        /*public void WriteTsv<T>(IEnumerable<T> data, TextWriter output)
        {
            PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));
            foreach (PropertyDescriptor prop in props)
            {
                output.Write(prop.DisplayName); // header
                output.Write("\t");
            }
            output.WriteLine();
            foreach (T item in data)
            {
                foreach (PropertyDescriptor prop in props)
                {
                    output.Write(prop.Converter.ConvertToString(
                         prop.GetValue(item)));
                    output.Write("\t");
                }
                output.WriteLine();
            }
        }*/
    }
}