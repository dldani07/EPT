using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosEmpresa
    /// </summary>
    public class datosEmpresa : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", detSolicitudes="";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT E.RUT,E.NOMBRE,E.N_ADHERENTE,E.ID_EMPRESA," +
                                       "solPen=(select count(*) from SOLICITUDES s where s.ID_EMPRESA=E.ID_EMPRESA and s.ESTADO=1)" +
                                       " FROM EMPRESAS E " +
                                       " WHERE E.rut='" + context.Request["rut"].ToString()+ "'");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<empresa>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                                "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                                "<SOLPEN>" + dsQuery.Tables[0].Rows[cont]["SOLPEN"].ToString() + "</SOLPEN>";

                if (Convert.ToInt32( dsQuery.Tables[0].Rows[cont]["SOLPEN"].ToString()) > 0)
                {
                        DataSet dsQuerySol = fn.dsSql("select s.FECHA_SOLICITUD,tp.NOMBRE from SOLICITUDES s " +
                                                      " inner join TIPO_SOLICITUD tp on tp.ID_TIPO_SOLICITUD=s.ID_TIPO_SOLICITUD " +
                                                      " where s.ID_EMPRESA='" + dsQuery.Tables[0].Rows[cont]["ID_EMPRESA"].ToString() + "' and s.ESTADO=1" +
                                                      " order by s.FECHA_SOLICITUD asc");

                        for (int contE = 0; contE < dsQuerySol.Tables[0].Rows.Count; contE++)
                        {
                            detSolicitudes = detSolicitudes + "[" + dsQuerySol.Tables[0].Rows[contE]["FECHA_SOLICITUD"].ToString() + "] " +
                                                               dsQuerySol.Tables[0].Rows[contE]["NOMBRE"].ToString() + "--FIN--";
                        }

                        xml = xml + "<DETSOLPEN>" + detSolicitudes + "</DETSOLPEN>";
                }
                else
                {
                    xml = xml + "<DETSOLPEN></DETSOLPEN>";
                }

                xml = xml + "</row>";
            }
            xml = xml + "</empresa>";

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