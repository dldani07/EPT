using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listarComunas
    /// </summary>
    public class listarComunas : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*context.Response.ContentType = "texto/normal";
            context.Response.Write("Hola a todos");*/

            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select c.ID_COMUNA,c.NOMBRE from comuna c WHERE c.ID_REGION=" + context.Request["r"] + " order by c.NOMBRE");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<comuna>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_COMUNA"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</comuna>";

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