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
    public partial class Solicitud2 : System.Web.UI.Page
    {
        int nContArch = 0;
        string fIngresoSol = DateTime.Now.ToString().Replace("/", "").Replace(":", "").Replace(" ", "").Replace("-", "");
        protected void Page_Load(object sender, EventArgs e)
        {
            SubeDocFinal();
        }

        private void SubeDocFinal()
        {
            funciones fn = new funciones();

            var obs = HttpContext.Current.Request["obs"];
            var tipo = HttpContext.Current.Request["tipo"];
            var usr = HttpContext.Current.Request["usr"];
            var id_sol = HttpContext.Current.Request["id_sol"];
            var fecha = HttpContext.Current.Request["fecha"];

            HttpFileCollection files = Request.Files;
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                if (file.ContentLength > 0)
                {
                    nContArch = nContArch + 1;
                    /**/string nomArch = String.Format("{0}_{1:yyyyMMddhhmmss}{2}",
                                                   "Res_Final_Sol_" + nContArch.ToString(), fIngresoSol,
                                                   System.IO.Path.GetExtension(file.FileName));
                    //string nomArch = file.FileName.ToString();
                    var guardarArch = Path.Combine(HttpContext.Current.Server.MapPath("~/Documentos"), nomArch);


                    file.SaveAs(guardarArch);

                    //fn.dsSql("insert into SOLICITUDES_DETALLE (ID_SOLICITUD,ARCHIVO,FECHA_INGRESO,ESTADO,COD_SOL) values(1,'" + nomArch + "',GETDATE(),1,'" + codSol + "');");

                    string insAccion = "", strAcc = "";

                    insAccion = "IF NOT EXISTS (select * from ACTIVIDADES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                          "insert into ACTIVIDADES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,FECHA_PROGRAMACION,ID_USUARIO,ID_SOLICITUD) values(" +
                          "'" + tipo + "',getdate(),2,CONVERT(datetime,'" + fecha + "'),'" + usr + "','" + id_sol + "') " +
                          " select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END " +
                          " ELSE begin select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END ";

                    strAcc = "Set Nocount on ";
                    strAcc = strAcc + insAccion;
                    strAcc = strAcc + " set nocount off";

                    DataSet rsFinal = fn.dsSql(strAcc);

                    fn.dsSql("insert into ACTIVIDAD_DETALLE(ID_ACTIVIDAD,DOCUMENTO,OBSERVACIONES,ESTADO) values(" + rsFinal.Tables[0].Rows[0]["ID"].ToString() + ",'" + nomArch + "','" + obs + "',2);");

                    fn.dsSql("update SOLICITUDES set estado=7 where ID_SOLICITUD='" + id_sol + "'");
                }
            }
        }
    }
}