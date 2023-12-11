using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
namespace MSESP
{
    public partial class subeAccion : System.Web.UI.Page
    {
        int nContArch = 0;
        string fIngresoSol = DateTime.Now.ToString().Replace("/", "").Replace(":", "").Replace(" ", "").Replace("-", "");
        protected void Page_Load(object sender, EventArgs e)
        {
            SubeDocAccion();
        }

        private void SubeDocAccion()
        {
            funciones fn = new funciones();

            var obs = HttpContext.Current.Request["obs"];
            var tipo = HttpContext.Current.Request["tipo"];
            var usr = HttpContext.Current.Request["usr"];
            var id_sol = HttpContext.Current.Request["id_sol"];
            var fecha = HttpContext.Current.Request["fecha"];
            var accDestinatario = HttpContext.Current.Request["accDestinatario"];
            var accCorreo = HttpContext.Current.Request["accCorreo"];

            /*segmentos*/
            var accsolSegAccion = HttpContext.Current.Request["accsolSegAccion"];
            var accsolLatAccion = HttpContext.Current.Request["accsolLatAccion"];

            string insAccion = "", strAcc = "", insAccionDet = "", dcorreo = "Null", ddest = "Null", strEstado = "", acEstado = "", SegAccion = "Null", LatAccion = "Null";

            if (accDestinatario != "")
            {
                ddest = "'" + accDestinatario + "'";
            }

            if (accCorreo != "")
            {
                dcorreo = "'" + accCorreo + "'";
            }

            if (accsolSegAccion != "" && accsolLatAccion != "")
            {
                SegAccion = accsolSegAccion;
                LatAccion = accsolLatAccion;
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO,POSTERIOR) values('" +
                         id_sol + "','" + SegAccion + "','" + LatAccion + "',1,GETDATE(),1,1);");

                //fn.dsSql("update ACTIVIDADES set estado=0 where ESTADO IN (2,4) and ID_TIPO_ACTIVIDAD=5 and ID_SOLICITUD=" + id_sol);
            }

            insAccion = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                      "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('" + tipo + "'," +
                      "getdate(),1,'" + id_sol + "') " +
                      " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END " +
                      " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END ";

            strAcc = "Set Nocount on ";
            strAcc = strAcc + insAccion;
            strAcc = strAcc + " set nocount off";

            DataSet rsAccion = fn.dsSql(strAcc);

            acEstado = "IF EXISTS (select * from SOLICITUDES where ID_SOLICITUD='" + id_sol + "' and ESTADO=2 and (TIPO_SERVICIO=2 or TIPO_SERVICIO is null)) BEGIN " +
                       "    update SOLICITUDES set ESTADO=1 where ID_SOLICITUD='" + id_sol + "' and ESTADO=2; " +
                       " end else begin " +
                       "    update SOLICITUDES set ESTADO_EP=1 where ID_SOLICITUD='" + id_sol + "' and ESTADO_EP=2; " +
                       " end ";

            strEstado = "Set Nocount on ";
            strEstado = strEstado + acEstado;
            strEstado = strEstado + " set nocount off";

            fn.dsSql(strEstado);

            if (tipo == "20")
            {
                //fn.dsSql("update SOLICITUDES set estado=3 where ID_SOLICITUD='" + id_sol + "'");
            }

            HttpFileCollection files = Request.Files;
            if (files.Count > 0)
            {
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    if (file.ContentLength > 0)
                    {
                        nContArch = nContArch + 1;
                        string nomArch = String.Format("{0}_{1:yyyyMMddhhmmss}{2}",
                                                   "Res_Accion_Sol_" + nContArch.ToString(), fIngresoSol,
                                                   System.IO.Path.GetExtension(file.FileName));

                        var guardarArch = Path.Combine(HttpContext.Current.Server.MapPath("~/Documentos"), nomArch);

                        file.SaveAs(guardarArch);

                        insAccionDet = "insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO,CORREO,DOCUMENTO,FECHA_CREACION,ID_SEGMENTO,ID_LATERAL) values(" +
                                     "'" + rsAccion.Tables[0].Rows[0]["ID"].ToString() + "','" + usr + "',CONVERT(datetime,'" + fecha + "'),'" + obs + "'," + ddest + "," + dcorreo + ",'" + nomArch + "',getdate()," + SegAccion + "," + LatAccion + "); ";

                        fn.dsSql(insAccionDet);
                    }
                }
            }
            else
            {
                insAccionDet = "insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO,CORREO,DOCUMENTO,FECHA_CREACION,ID_SEGMENTO,ID_LATERAL) values(" +
                                     "'" + rsAccion.Tables[0].Rows[0]["ID"].ToString() + "','" + usr + "',CONVERT(datetime,'" + fecha + "'),'" + obs + "'," + ddest + "," + dcorreo + ",null,getdate()," + SegAccion + "," + LatAccion + "); ";

                fn.dsSql(insAccionDet);
            }
        }
    }
}