using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaAgencias
    /// </summary>
    public class listaAgencias : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {

            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select a.ID_AGENCIA,a.AGENCIA from AGENCIA_PROYECTO AP " +
                                       " INNER JOIN AGENCIAS a ON a.ID_AGENCIA=AP.ID_AGENCIA " +
                                       " where a.ESTADO=1 AND AP.ESTADO=1 AND AP.ID_PROYECTO=" + 
                                       context.Request["proy"].ToString().Trim() + " order by a.AGENCIA");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<regiones>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_AGENCIA"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["AGENCIA"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</regiones>";

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