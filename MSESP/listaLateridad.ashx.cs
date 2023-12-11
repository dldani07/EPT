using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaLateridad
    /// </summary>
    public class listaLateridad : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select l.ID_LATERIDAD,l.LATERIDAD from LATERIDAD l where l.ESTADO=1 order by l.LATERIDAD  ");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<lateridad>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_LATERIDAD"].ToString() + "</ID>" +
                                "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["LATERIDAD"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</lateridad>";

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