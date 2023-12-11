using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de ListaCombos
    /// </summary>
    public class ListaCombos : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", filtro = "0";
            funciones fn = new funciones();

            filtro = context.Request["filtro"];
            if (context.Request["filtro"] == "")
            {
                filtro = "0";
            }

            DataSet dsQuery = fn.dsSql("EXEC LISTA_COMBOS " + context.Request["query"] + ", " + filtro);

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</rows>";

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