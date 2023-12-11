using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosFechaRecepcion
    /// </summary>
    public class datosFechaRecepcion : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select fecha=CONVERT(VARCHAR(10), MAX(FECHA_RECEPCION_INFORME), 105)  FROM ACTIVIDADES " +
                                       " where ID_SOLICITUD=" + context.Request["id_solicitud"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                  "<solicitud>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {

                xml = xml + "<row>" +
                                "<FECHA>" + dsQuery.Tables[0].Rows[cont]["FECHA"].ToString() + "</FECHA> " +
                            "</row> ";
            }
            xml = xml + "</solicitud>";

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