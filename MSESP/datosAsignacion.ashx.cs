using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosAsignacion
    /// </summary>
    public class datosAsignacion : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select A.ID_ACTIVIDAD,A.ID_SOLICITUD,USR=A.ID_USUARIO,PROF=A.ID_PROFESIONAL,A.ID_REGION," +
                                        "fecha=CONVERT(VARCHAR(10),A.FECHA_PROGRAMACION, 105),TIPO=A.ID_TIPO_ACTIVIDAD,A.DIRECCION,A.HORA1,A.HORA2,s.ID_TIPO_SOLICITUD, a.ASIGNACION, a.COMUNA, a.MEDIO, a.OTROS from ACTIVIDADES a " +
                                        " inner join SOLICITUDES s on s.ID_SOLICITUD=A.ID_SOLICITUD " +
                                        " where A.ID_ACTIVIDAD=" + context.Request["id"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                  "<asignacion>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<PROFESIONAL>" + dsQuery.Tables[0].Rows[cont]["PROF"].ToString() + "</PROFESIONAL>" +
                            "<FECHA>" + dsQuery.Tables[0].Rows[cont]["FECHA"].ToString() + "</FECHA>" +
                            "<TIPO>" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "</TIPO>" +
                            "<ID_REGION>" + dsQuery.Tables[0].Rows[cont]["ID_REGION"].ToString() + "</ID_REGION>" +
                            "<DIR>" + dsQuery.Tables[0].Rows[cont]["DIRECCION"].ToString() + "</DIR>" +
                            "<HORA>" + dsQuery.Tables[0].Rows[cont]["HORA1"].ToString() + "</HORA>" +
                            "<HORA2>" + dsQuery.Tables[0].Rows[cont]["HORA2"].ToString() + "</HORA2>" +
                            "<ID_TIPO_SOLICITUD>" + dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() + "</ID_TIPO_SOLICITUD>" +
                            "<ASIGNACION>" + dsQuery.Tables[0].Rows[cont]["ASIGNACION"].ToString() + "</ASIGNACION>" +
                            "<COMUNA>" + dsQuery.Tables[0].Rows[cont]["COMUNA"].ToString() + "</COMUNA>" +
                            "<MEDIO>" + dsQuery.Tables[0].Rows[cont]["MEDIO"].ToString() + "</MEDIO>" +
                            "<OTROS>" + dsQuery.Tables[0].Rows[cont]["OTROS"].ToString() + "</OTROS>" +
                            "</row>";
            }
            xml = xml + "</asignacion>";

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