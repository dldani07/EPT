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
    /// <summary>
    /// Descripción breve de generaExcel
    /// </summary>
    public class generaExcel : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "texto/normal";
            //context.Response.Write("Hola a todos");
            funciones fn = new funciones();
            HttpResponse response = HttpContext.Current.Response;

            // first let's clean up the response.object
            response.Clear();
            response.Charset = "";

            // set the response mime type for excel
            response.ContentType = "application/vnd.ms-excel";
            response.AddHeader("Content-Disposition", "attachment;filename=\"" + "excel" + "\"");

            // create a string writer
            using (StringWriter sw = new StringWriter())
            {
                using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                {
                    // instantiate a datagrid
                    DataGrid dg = new DataGrid();
                    DataSet dsTrab = fn.dsSql("select ID_USUARIO='', NOMBRE='Seleccione' union all  SELECT ID_USUARIO, NOMBRE FROM USUARIOS WHERE ID_TIPO_USUARIO=3 and ESTADO=1");
                    dg.DataSource = dsTrab.Tables[0];
                    dg.DataBind();
                    dg.RenderControl(htw);
                    response.Write(sw.ToString());
                    response.End();
                }
            }
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