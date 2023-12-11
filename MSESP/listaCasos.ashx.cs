using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaCasos
    /// </summary>
    public class listaCasos : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT TP.ID_CASO,TP.CASO FROM TIPO_CASOS TP WHERE TP.ESTADO=1 ORDER BY TP.CASO");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<CASO>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_CASO"].ToString() + "</ID>" +
                                "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["CASO"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</CASO>";

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