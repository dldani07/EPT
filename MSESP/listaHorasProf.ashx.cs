using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaHorasProf
    /// </summary>
    public class listaHorasProf : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select a.ID_HORA from HORARIO_AGENDA a " +
                                       " where a.JORNADA=" + context.Request["jornada"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<HORAS>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_HORA"].ToString() + "</ID>" +
                                "<HORA>" + dsQuery.Tables[0].Rows[cont]["ID_HORA"].ToString() + "</HORA>" +
                            "</row>";
            }
            xml = xml + "</HORAS>";

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