using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class ReportesXLS : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string fi = "", ft = "";

            fi = "";
            if (Request["fi"] != "" && Request["fi"] != "null" && Request["fi"] != null)
            {
                fi = " and s.FECHA_SOLICITUD>=convert(date, '" + Request["fi"] + "')";
            }

            ft = "";
            if (Request["ft"] != "" && Request["ft"] != "null" && Request["ft"] != null)
            {
                ft = " and s.FECHA_SOLICITUD<=convert(date, '" + Request["ft"] + "')";
            }

            if (Request["t"] == "1")
            {
                ExportarLog(fi, ft, Request["p"]);
            }
            else if (Request["t"] == "2")
            {
                ExportarAsignaciones(fi, ft, Request["p"]);
            }
            else if (Request["t"] == "3")
            {
                ExportarUsuarios(Request["p"]);
            }
            else if (Request["t"] == "4")
            {
                ExportarProfesionales(Request["p"]);
            }
        }

        protected void ExportarUsuarios(string p)
        {
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("EXEC dbo.LISTADO_USUARIOS " + p + ";");

            HttpResponse response = HttpContext.Current.Response;

            response.Clear();
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=Usuarios_" + DateTime.Now.ToString("ddMMyyyyHHmmss") + ".xls");

            response.Charset = "UTF-8";
            response.ContentEncoding = Encoding.Default;

            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    // instantiate a datagrid
                    DataGrid dg = new DataGrid();
                    dg.DataSource = dsQuery.Tables[0];
                    dg.DataBind();
                    dg.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }
        }

        protected void ExportarProfesionales(string p)
        {
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("EXEC dbo.LISTADO_PROFESIONALES " + p + ";");

            HttpResponse response = HttpContext.Current.Response;

            response.Clear();
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=Profesionales_" + DateTime.Now.ToString("ddMMyyyyHHmmss") + ".xls");

            response.Charset = "UTF-8";
            response.ContentEncoding = Encoding.Default;

            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    // instantiate a datagrid
                    DataGrid dg = new DataGrid();
                    dg.DataSource = dsQuery.Tables[0];
                    dg.DataBind();
                    dg.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }
        }

        protected void ExportarLog(string fi, string ft, string p)
        {
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select 'Nº Caso'=s.NUM_SOLICITUD,Estado=dbo.EstadoEPT(s.ESTADO)," +
                                    "lg.Fecha, 'Usuario'=lg.usr, lg.Accion, lg.Observaciones from solicitudes s " +
                                       " inner join vista_log lg on lg.ID_SOLICITUD=s.ID_SOLICITUD " +
                                       " where 1=1 and s.id_proyecto=" + p + fi + ft +
                                       " order by s.NUM_SOLICITUD desc, lg.fecha asc");

            HttpResponse response = HttpContext.Current.Response;

            response.Clear();
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=Sol_Log_" + DateTime.Now.ToString("ddMMyyyyHHmmss") + ".xls");

            response.Charset = "UTF-8";
            response.ContentEncoding = Encoding.Default;

            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    // instantiate a datagrid
                    DataGrid dg = new DataGrid();
                    dg.DataSource = dsQuery.Tables[0];
                    dg.DataBind();
                    dg.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }
        }

        protected void ExportarAsignaciones(string fi, string ft, string p)
        {
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select 'Nº Caso'=s.NUM_SOLICITUD," +
                                       "CONVERT(NVARCHAR(10), s.FECHA_SOLICITUD, 105) AS 'FECHA SOLICITUD'," +
                                       "'Nombre Trabajador'=dbo.MayMinTexto(pa.NOMBRE)," +
                                       "'Rut Trabajador'=pa.RUT,ag.Agencia,"+
                                       "Estado=dbo.EstadoEPT(s.ESTADO)," +
                                       " Usuario=U.NOMBRE,'Profesional'=P.NOMBRE," +
                                       " 'Fecha Programación'=CONVERT(VARCHAR(10),A.FECHA_PROGRAMACION, 105),'Desde'=a.HORA1,'Hasta'=a.HORA2,TIPO=TP.NOMBRE," +
                                       " 'Región'=rg.NOMBRE,'Observacón'=a.DIRECCION,'Estado Asignación'=(case a.estado when 5 then 'Reprogramado' else 'Programado' end)" +
                                       " from ACTIVIDADES a " +
                                       "  inner join SOLICITUDES s on s.ID_SOLICITUD=a.ID_SOLICITUD " +
                                       "  left join PACIENTES pa on pa.ID_PACIENTE=s.ID_PACIENTE " +
                                       "  left join USUARIOS us on us.ID_USUARIO=s.ID_USUARIO_SOLICITUD " +
                                       " left join AGENCIAS ag on ag.ID_AGENCIA=us.ID_AGENCIA " +  
                                       "  left join USUARIOS u on u.ID_USUARIO=a.ID_USUARIO " +
                                       "  left join PROFESIONALES p on p.ID_PROFESIONAL=a.ID_PROFESIONAL " +
                                       "  left JOIN TIPO_ACTIVIDAD TP ON TP.ID_TIPO_ACTIVIDAD=A.ID_TIPO_ACTIVIDAD " +
                                       "  left join PROVEEDORES pr on pr.ID_PROVEEDOR=p.ID_PROVEEDOR " +
                                       "  left join regiones rg on rg.ID_REGION=pr.ID_REGION " +
                                       "  where tp.tipo=2 and s.id_proyecto=" + p + fi + ft +
                                       "  order by s.NUM_SOLICITUD desc");

            HttpResponse response = HttpContext.Current.Response;

            response.Clear();
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=Sol_Asignaciones_" + DateTime.Now.ToString("ddMMyyyyHHmmss") + ".xls");

            response.Charset = "UTF-8";
            response.ContentEncoding = Encoding.Default;

            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    // instantiate a datagrid
                    DataGrid dg = new DataGrid();
                    dg.DataSource = dsQuery.Tables[0];
                    dg.DataBind();
                    dg.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }
        }
    }
}