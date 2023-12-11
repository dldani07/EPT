using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listarProfesionales
    /// </summary>
    public class listarProfesionales : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*context.Response.ContentType = "texto/normal";
            context.Response.Write("Hola a todos");*/

            string xml = "", Proyecto = "";
            funciones fn = new funciones();

            if (context.Request["proy"] != "")
            {
                Proyecto = " and PP.ID_PROYECTO=" + context.Request["proy"];
            }

            DataSet dsQuery = fn.dsSql("select p.ID_PROFESIONAL,p.RUT,NOMBRE=dbo.MayMinTexto(P.NOMBRE) from PROFESIONALES p " +
                                       " inner join PROFESIONALES_PROVEEDOR ppv on ppv.ID_PROFESIONAL = p.ID_PROFESIONAL " +
                                       " inner join PROVEEDORES pr on pr.ID_PROVEEDOR=ppv.ID_PROVEEDOR " +
                                       " INNER JOIN PROFESIONALES_PROYECTO PP ON PP.ID_PROFESIONAL=p.ID_PROFESIONAL " +
                                       " where /**/pp.ESTADO=1 and p.estado2='A' and pr.ID_REGION='" + context.Request["r"] + "' " + Proyecto + " order by p.NOMBRE");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<profesionales>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_PROFESIONAL"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</profesionales>";

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