using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridSolicitudes
    /// </summary>
    public class jqGridSolicitudes : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "texto/normal";
            //context.Response.Write("Hola a todos");
            string usrIngreso = " where s.id_proyecto=" + context.Request["p"].ToString(); 

            if (context.Request["t"].ToString() == "3")
            {
                usrIngreso = usrIngreso + " and S.ID_USUARIO_INGRESO=" + context.Request["u"].ToString() + 
                             " and s.FECHA_INGRESO>=CONVERT(date,'07-04-2017')";
            }

            string xml = "";
            funciones fn = new funciones();

            string _search = context.Request["_search"];
            string numberOfRows = context.Request["rows"];
            string pageIndex = context.Request["page"];
            string sortColumnName = context.Request["sidx"];
            string sortOrderBy = context.Request["sord"];
            string nodeid = context.Request["nd"];

            DataSet dsQuery = fn.dsSql("SELECT S.ID_SOLICITUD,F_SOLICITUD=CONVERT(VARCHAR(10),S.FECHA_SOLICITUD, 105),TIPO=TP.NOMBRE,SOL=dbo.MayMinTexto(U.NOMBRE),RUT_E=E.RUT," +
                                       "NOM_E=dbo.MayMinTexto(E.NOMBRE),TRAB_RUT=P.RUT,TRAB_NOM=P.NOMBRE,S.ORDEN_SINIESTRO,S.ESTADO," +
                                       "E_SOL=(case S.ESTADO when 4 then 'Agendado Clinico' when 5 then 'Agendado' " +
                                       " when 6 then 'En Auditoria Revisión EPT' when 3 then 'En Espera Respuesta' when 1 then 'En Gestión' " +
                                       " when 7 then 'Finalizado' when 2 then 'Por Agendar' when 8 then 'Fecha de Programación Vencida' when 9 then 'Anulado' when 10 then 'Reagendado' else 'Cancelado' end)," +
                                       "cod=(case when s.NUM_SOLICITUD is null THEN " +
                                       "CONVERT(VARCHAR(4), YEAR(S.FECHA_SOLICITUD))+right('00' + CONVERT(VARCHAR(2),MONTH(S.FECHA_SOLICITUD)), 2)+'-'+ " +
                                       "CONVERT(VARCHAR(4), s.ID_SOLICITUD) else s.NUM_SOLICITUD END),cod2=dbo.RemoveChars(s.NUM_SOLICITUD) FROM SOLICITUDES S " +
                                       " INNER JOIN PACIENTES P ON P.ID_PACIENTE=S.ID_PACIENTE " +
                                       " INNER JOIN TIPO_SOLICITUD TP ON TP.ID_TIPO_SOLICITUD=S.ID_TIPO_SOLICITUD " +
                                       " INNER JOIN USUARIOS U ON U.ID_USUARIO=S.ID_USUARIO_INGRESO " +
                                       " INNER JOIN EMPRESAS E ON E.ID_EMPRESA=S.ID_EMPRESA " + usrIngreso + " ORDER BY " + "S.ID_SOLICITUD" + " " + sortOrderBy);//sortColumnName
                                        //" /*WHERE S.ESTADO=1*/"
            int total_pages = 0;
            if (dsQuery.Tables[0].Rows.Count > 0)
            {
                if ((dsQuery.Tables[0].Rows.Count % Convert.ToInt32(numberOfRows)) > 0)
                {
                    total_pages = (int)Math.Ceiling(Convert.ToDouble(dsQuery.Tables[0].Rows.Count / Convert.ToInt32(numberOfRows) + 1)); // 1
                }
                else
                {
                    total_pages = Convert.ToInt32(dsQuery.Tables[0].Rows.Count) / Convert.ToInt32(numberOfRows);
                }
            }
            else
            {
                total_pages = 1;
            }

            if (Convert.ToInt32(pageIndex) > Convert.ToInt32(total_pages)) { pageIndex = total_pages.ToString(); }
            int inicio = (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)) - Convert.ToInt32(numberOfRows);
            int fila = 0;

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>" +
                    "<page>" + pageIndex.ToString() + "</page>" +
                    "<total>" + total_pages.ToString() + "</total>" +
                    "<records>" + dsQuery.Tables[0].Rows.Count.ToString() + "</records>";
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                if (fila >= inicio && fila < (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)))
                {

                xml = xml + "<row id='" + cont.ToString() + "'>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["cod"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["F_SOLICITUD"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["SOL"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT_E"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["NOM_E"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_RUT"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_NOM"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["ORDEN_SINIESTRO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["E_SOL"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Seguimiento' class='ui-icon ui-icon-pencil' onclick='Seguimiento(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + "," + dsQuery.Tables[0].Rows[cont]["cod2"].ToString().Replace("-", "").Replace("RM", "") + ");'></a></span>]]></cell>" +
                            "</row>";
                }
                fila = fila + 1;
            }
            xml = xml + "</rows>";

            context.Response.Write(xml);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}