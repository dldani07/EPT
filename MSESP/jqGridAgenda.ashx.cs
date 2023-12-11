using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridAgenda
    /// </summary>
    public class jqGridAgenda : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", id_prof="0", fecha="";
            funciones fn = new funciones();
            //fn.dsSql("DELETE FROM tmp_agenda; DELETE FROM tmp_agenda_dia;");

            if (context.Request["p"].ToString()!="")
            {
                id_prof = context.Request["p"].ToString();
            }

            if (context.Request["f"].ToString() != "")
            {
                fecha = context.Request["f"].ToString();
            }

            
            fn.dsSql("exec dbo.pro_agenda " + id_prof + ", '" + fecha + "'");
            fn.dsSql("exec dbo.pro_agenda_dia " + id_prof + ", '" + fecha + "'");

            DataSet dsQuery = fn.dsSql("select * from fun_agenda(" + id_prof + ", '" + fecha + "')");
 
            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>" +
                    "<page>1</page>" +
                    "<total>1</total>" +
                    "<records>1</records>";
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row id='" + cont.ToString() + "'>";

                    if (dsQuery.Tables[0].Rows[cont]["status_hora"].ToString()=="Agendada") {
                        xml = xml + "<cell><![CDATA[<b>" + dsQuery.Tables[0].Rows[cont]["hora"].ToString() + "</b>]]></cell>" +
                                    "<cell><![CDATA[<b>" + dsQuery.Tables[0].Rows[cont]["status_hora"].ToString() + "</b>]]></cell>";
                    }
                    else
                    {
                        xml = xml + "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["hora"].ToString() + "]]></cell>" +
                                    "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["status_hora"].ToString() + "]]></cell>";
                    }


                         xml = xml + "</row>";
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