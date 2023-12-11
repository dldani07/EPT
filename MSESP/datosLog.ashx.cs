using DocumentFormat.OpenXml.Bibliography;
using DocumentFormat.OpenXml.Spreadsheet;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosLog
    /// </summary>
    public class datosLog : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", DOCS = "", detLog="";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("exec dbo.LOG_SOL @solicitud = " + context.Request["id"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                  "<log>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                detLog = detLog + "[<b>" + dsQuery.Tables[0].Rows[cont]["fecha"].ToString() +
                    "</b>] " + dsQuery.Tables[0].Rows[cont]["usr"].ToString() + " - " +
                           dsQuery.Tables[0].Rows[cont]["Accion"].ToString();

                if (dsQuery.Tables[0].Rows[cont]["OBSERVACIONES"].ToString() != "" 
                    && dsQuery.Tables[0].Rows[cont]["OBSERVACIONES"].ToString() != "Contacto Inicial a Empresa")
                {
                detLog = detLog + " con las Siguientes Observaciones : " +
                    dsQuery.Tables[0].Rows[cont]["OBSERVACIONES"].ToString();
                }

                detLog = detLog + "--FIN--";
            }
            detLog = detLog.ToString().Replace("Recepción Informes, En Revisión con las Siguientes Observaciones : ", "Recepción Informes, En Revisión ");
            xml = xml + "<row>" +
                                        "<LOG>" + detLog + "</LOG>" +
                               "</row>";
            xml = xml + "</log>";

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