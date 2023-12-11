using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosTrabajador
    /// </summary>
    public class datosTrabajador : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", detSolicitudes = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT NOMBRE,RUT,FONO_FIJO,FONO_MOVIL,DIRECCION,EMAIL,ID_paciente,ID_GENERO," +
                                       "solPen=(select count(*) from SOLICITUDES s where s.ID_paciente=pacientes.ID_paciente and s.ESTADO not in (7,9))" +
                                       " FROM pacientes " +
                                       " WHERE rut='" + context.Request["rut"].ToString() + "'");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<trabajador>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                                "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                                "<FONO_FIJO>" + dsQuery.Tables[0].Rows[cont]["FONO_FIJO"].ToString() + "</FONO_FIJO>" +
                                "<FONO_MOVIL>" + dsQuery.Tables[0].Rows[cont]["FONO_MOVIL"].ToString() + "</FONO_MOVIL>" +
                                "<DIRECCION>" + dsQuery.Tables[0].Rows[cont]["DIRECCION"].ToString() + "</DIRECCION>" +
                                "<EMAIL>" + dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString() + "</EMAIL>" +
                                "<ID_GENERO>" + dsQuery.Tables[0].Rows[cont]["ID_GENERO"].ToString() + "</ID_GENERO>" +
                                "<SOLPEN>" + dsQuery.Tables[0].Rows[cont]["SOLPEN"].ToString() + "</SOLPEN>";

                if (Convert.ToInt32(dsQuery.Tables[0].Rows[cont]["SOLPEN"].ToString()) > 0)
                {
                    DataSet dsQuerySol = fn.dsSql("select s.FECHA_SOLICITUD,tp.NOMBRE from SOLICITUDES s " +
                                                  " inner join TIPO_SOLICITUD tp on tp.ID_TIPO_SOLICITUD=s.ID_TIPO_SOLICITUD " +
                                                  " where s.ID_paciente='" + dsQuery.Tables[0].Rows[cont]["ID_paciente"].ToString() + "' and s.ESTADO not in (7,9)" +
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
            xml = xml + "</trabajador>";

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