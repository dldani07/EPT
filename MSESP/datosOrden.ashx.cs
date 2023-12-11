using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosOrden
    /// </summary>
    public class datosOrden : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select total=COUNT(*) from solicitudes s " +
                                       " where /**/s.estado not in (0,9) " +
                                       " and s.ID_PROYECTO=" + context.Request["proy"].ToString().Trim() + 
                                       " and s.ORDEN_SINIESTRO='" + context.Request["orden"].ToString().Trim() + 
                                       "' and s.ORDEN_SINIESTRO not in ('')");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<orden>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<TOTAL>" + dsQuery.Tables[0].Rows[cont]["total"].ToString() + "</TOTAL>" +
                            "</row>";
            }
            xml = xml + "</orden>";

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