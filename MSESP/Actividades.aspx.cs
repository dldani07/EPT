using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Services;
using System.IO;

namespace MSESP
{
    public partial class Actividades : System.Web.UI.Page
    {
        int nContArch = 0;
        string fIngresoSol = DateTime.Now.ToString().Replace("/", "").Replace(":", "").Replace(" ", "").Replace("-", "");

        protected void Page_Load(object sender, EventArgs e)
        {
            SubeDoc();
        }

        public string nomArchivo(string input)
        {
            string nomArchivo = "";
            if (input=="1")
            {
                nomArchivo = "PSI_";
            }
            else if (input == "2")
            {
                nomArchivo = "EPT_";
            }
            else if (input == "3")
            {
                nomArchivo = "ECT_";
            }
            else if (input == "4")
            {
                nomArchivo = "OTROS_";
            }

            return nomArchivo;
        }
        private void SubeDoc()
        {
            funciones fn = new funciones();

            var obsAct = HttpContext.Current.Request["obs"];
            var idAct = HttpContext.Current.Request["id"];

            fn.dsSql("update ACTIVIDAD_DETALLE set REEMPLAZADO=1 where ESTADO NOT IN (4) AND ID_ACTIVIDAD='" + idAct + "'");

            HttpFileCollection files = Request.Files;
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                if (file.ContentLength > 0)
                {
                        nContArch = nContArch + 1;
                        string nomArch = String.Format("{0}_{1:yyyyMMddhhmmss}{2}",
                                                       nomArchivo(files.AllKeys[i].ToString().Replace("fileUpload", "")) + idAct.ToString() + "_" + nContArch.ToString(), fIngresoSol, 
                                                       System.IO.Path.GetExtension(file.FileName));

                        var guardarArch = Path.Combine(HttpContext.Current.Server.MapPath("~/Documentos"), nomArch);

                        file.SaveAs(guardarArch);

                        fn.dsSql("insert into ACTIVIDAD_DETALLE(ID_ACTIVIDAD,DOCUMENTO,OBSERVACIONES,ESTADO,FECHA_REALIZACION,ID_TIPO_DOCUMENTO,REEMPLAZADO) values('" + idAct +
                                                                "','" + nomArch + "','" + obsAct + "',2,GETDATE(),'" + files.AllKeys[i].ToString().Replace("fileUpload", "") + "',0);");
                }
            }

            fn.dsSql("update ACTIVIDADES set ESTADO=2 where ID_ACTIVIDAD='" + idAct + "'");

            fn.dsSql("update SOLICITUDES set estado=6 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                     " where a.ID_ACTIVIDAD='" + idAct + "')");
        }
    }
}