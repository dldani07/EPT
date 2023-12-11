using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaProveedores
    /// </summary>
    public class listaProveedores : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*context.Response.ContentType = "texto/normal";
            context.Response.Write("Hola a todos");*/

            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select p.ID_PROVEEDOR,p.RUT,p.NOMBRE from proveedores p " +
                                       " where p.ESTADO=1 order by p.NOMBRE");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<proveedores>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_PROVEEDOR"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</proveedores>";

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