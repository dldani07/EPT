using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosEmpresas
    /// </summary>
    public class datosEmpresas : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT E.RUT,E.NOMBRE,E.N_ADHERENTE FROM EMPRESAS E " + 
                                       " WHERE E.ID_EMPRESA=" + context.Request["id"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<empresa>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "<ADH>" + dsQuery.Tables[0].Rows[cont]["N_ADHERENTE"].ToString() + "</ADH>" +
                            "</row>";
            }
            xml = xml + "</empresa>";

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