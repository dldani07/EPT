using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaSegmentos
    /// </summary>
    public class listaSegmentos : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select ID_SEGMENTO,SEGMENTO from SEGMENTOS where ESTADO=1 order by SEGMENTO");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<segmentos>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_SEGMENTO"].ToString() + "</ID>" +
                                "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["SEGMENTO"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</segmentos>";

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