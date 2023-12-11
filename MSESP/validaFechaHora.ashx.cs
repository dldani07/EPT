using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de validaFechaHora
    /// </summary>
    public class validaFechaHora : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT REGISTRA=(CASE WHEN GETDATE()>CONVERT(DATETIME,CONVERT(VARCHAR(16), CONVERT(DATE, GETDATE())) + ' 00:02', 120) " +
                                       " AND GETDATE()<CONVERT(DATETIME,CONVERT(VARCHAR(16), CONVERT(DATE, GETDATE())) + ' 23:58', 120) " +
                                       " /*AND (SELECT COUNT(*) FROM CALENDARIO C WHERE C.FECHA=CONVERT(DATE, GETDATE()))=0*/ THEN '1' ELSE '0' END)");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<orden>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<REGISTRA>" + dsQuery.Tables[0].Rows[cont]["REGISTRA"].ToString() + "</REGISTRA>" +
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