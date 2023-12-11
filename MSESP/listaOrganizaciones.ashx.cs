using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaRegiones
    /// </summary>
    public class listaOrganizaciones : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*context.Response.ContentType = "texto/normal";
            context.Response.Write("Hola a todos");*/

            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select r.ID_ORGANIZACION,r.NOMBRE from ORGANIZACIONES r order by r.ID_ORGANIZACION");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<organizacion>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_ORGANIZACION"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</organizacion>";

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