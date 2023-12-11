using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listarProfesionalesTipo
    /// </summary>
    public class listarProfesionalesTipo : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*context.Response.ContentType = "texto/normal";
                       context.Response.Write("Hola a todos");*/

            string xml = "", idprofSel = "", Proyecto="";
            funciones fn = new funciones();

            if (context.Request["s"] != "0" && context.Request["s"] != "" && context.Request["s"] != "Null" && context.Request["s"] != null)
            {
                idprofSel = " and s.ID_PROFESIONAL not in (" + context.Request["s"] + ")";
            }

            if (context.Request["proy"] != "")
            {
                Proyecto = " and PP.ID_PROYECTO=" + context.Request["proy"];
            }


            DataSet dsQuery = fn.dsSql("SELECT s.ID_PROFESIONAL,NOMBRE=dbo.MayMinTexto(s.NOMBRE),s.REALIZA,EPT=item " + 
                                       "FROM PROFESIONALES s " +
                                       " inner join PROFESIONALES_PROVEEDOR ppv on ppv.ID_PROFESIONAL = s.ID_PROFESIONAL " +
                                       " inner join PROVEEDORES pr on pr.ID_PROVEEDOR=ppv.ID_PROVEEDOR " + 
                                       " INNER JOIN PROFESIONALES_PROYECTO PP ON PP.ID_PROFESIONAL=s.ID_PROFESIONAL " +
                                       " CROSS APPLY dbo.SplitCadena(SUBSTRING(s.REALIZA, 1, len(s.REALIZA)-1), '/') " + 
                                       " where item in (select tp.ID_TIPO_ACTIVIDAD from TIPO_ACTIVIDAD tp  " + 
                                       " where tp.ID_TIPO_SOLICITUD='" + context.Request["t"] + "') and PP.estado=1 and s.estado2='A' and pr.ID_REGION='" + context.Request["r"] + "' " + idprofSel + Proyecto +
                                       " order by s.NOMBRE");

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