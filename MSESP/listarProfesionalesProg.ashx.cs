using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listarProfesionalesProg
    /// </summary>
    public class listarProfesionalesProg : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT s.ID_PROFESIONAL,NOMBRE=dbo.MayMinTexto(s.NOMBRE),s.REALIZA,EPT=item " +
                                       "FROM PROFESIONALES s " +
                                       " inner join PROVEEDORES pr on pr.ID_PROVEEDOR=s.ID_PROVEEDOR " +
                                       " CROSS APPLY dbo.SplitCadena(SUBSTRING(s.REALIZA, 1, len(s.REALIZA)-1), '/') " +
                                       " where item in (select tp.ID_TIPO_ACTIVIDAD from TIPO_ACTIVIDAD tp  " +
                                       " where tp.ID_TIPO_SOLICITUD='" + context.Request["t"] + "') and s.estado=1 and pr.ID_REGION='" + context.Request["r"] + "' " + 
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