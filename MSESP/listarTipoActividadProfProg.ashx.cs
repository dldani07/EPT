using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listarTipoActividadProfProg
    /// </summary>
    public class listarTipoActividadProfProg : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*context.Response.ContentType = "texto/normal";
            context.Response.Write("Hola a todos");*/

            string xml = "", tipoSol = "";
            funciones fn = new funciones();

            if (context.Request["tipoSol"] == "2" || context.Request["tipoSol"] == "5")
            {
                tipoSol = " and ta.ID_TIPO_SOLICITUD in (2,5)";
            }
            else
            {
                tipoSol = " and ta.ID_TIPO_SOLICITUD in (" + context.Request["tipoSol"] + ")";
            }

            DataSet dsQuery2 = fn.dsSql("select tipo=ISNULL(replace(p.REALIZA,'/',',')+'0',0) FROM profesionales p " +
                                        " where p.ID_PROFESIONAL='" + context.Request["pf"] + "'");

            DataSet dsQuery = fn.dsSql("select ta.ID_TIPO_ACTIVIDAD,ta.NOMBRE from TIPO_ACTIVIDAD ta " +
                           " where ta.TIPO=" + context.Request["t"] +
                           " and ta.ID_TIPO_ACTIVIDAD in (" + dsQuery2.Tables[0].Rows[0]["tipo"].ToString() + ") " + tipoSol +
                           " and ta.ESTADO=1 order by ta.NOMBRE");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<tipo>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_TIPO_ACTIVIDAD"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</tipo>";

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