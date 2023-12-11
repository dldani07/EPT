using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaHoras
    /// </summary>
    public class listaHoras : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", id_prof="0", fecha="01-01-1990";
            funciones fn = new funciones();

            if (context.Request["p"].ToString() != "")
            {
                id_prof = context.Request["p"].ToString();
            }

            if (context.Request["f"].ToString() != "")
            {
                fecha = context.Request["f"].ToString();
            }

            //fn.dsSql("DELETE FROM tmp_agenda; DELETE FROM tmp_agenda_dia;");

            //fn.dsSql("exec dbo.pro_agenda_dia @profesional = '" + id_prof + "', @fecha = '" + fecha + "'");
            //fn.dsSql("exec dbo.pro_agenda @profesional = '" + id_prof + "', @fecha = '" + fecha + "'");

            //DataSet dsQuery = fn.dsSql("select * from fun_agenda_disp(" + id_prof + ",'" + fecha + "','" + context.Request["h"].ToString() + "');");

            DataSet dsQuery = fn.dsSql("select * from fun_agenda_disp(" + id_prof + ", '" + fecha + "', '')");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<comuna>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<hora>" + dsQuery.Tables[0].Rows[cont]["hora"].ToString() + "</hora>" +
                            "<status_hora>" + dsQuery.Tables[0].Rows[cont]["status_hora"].ToString() + "</status_hora>" +
                            "</row>";
            }
            xml = xml + "</comuna>";

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