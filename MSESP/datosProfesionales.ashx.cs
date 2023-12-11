using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosProfesionales
    /// </summary>
    public class datosProfesionales : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT pf.ID_PROFESIONAL,PF.RUT,PF.NOMBRE,ID_PROVEEDOR=dbo.fun_prof_prov_id(pf.ID_PROFESIONAL),PF.PASSWORD, estado2=(case when PF.ESTADO2='A' THEN 'A' ELSE 'I' END)," +
                                       "PF.REALIZA,vAGENCIA=isnull(PF.AGENCIA,0),vZONAL=isnull(PF.ZONAL,0),PF.PROFESION,PF.EMAIL,PF.FONO,PF.ATENCION,PF.CONSIDERACIONES," +
                                       "PF.jornManana,PF.manHoraIni,PF.manHoraFin,PF.jornTarde,PF.tarHoraIni,PF.tarHoraFin,VEHICULO=ISNULL(PF.ID_VEHICULO,0),PF.DIRECCION, PF.ID_ORGANIZACION  " +
                                       " FROM PROFESIONALES PF " +
                                       " WHERE PF.ID_PROFESIONAL=" + context.Request["id"].ToString());
            
            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<empresa>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "<REGION>" + dsQuery.Tables[0].Rows[cont]["ID_PROVEEDOR"].ToString() + "</REGION>" +
                            "<CLAVE>" + dsQuery.Tables[0].Rows[cont]["PASSWORD"].ToString() + "</CLAVE>" +
                            "<AGENCIA>" + dsQuery.Tables[0].Rows[cont]["vAGENCIA"].ToString() + "</AGENCIA>" +
                            "<ZONAL>" + dsQuery.Tables[0].Rows[cont]["vZONAL"].ToString() + "</ZONAL>" +
                            "<PROFESION>" + dsQuery.Tables[0].Rows[cont]["PROFESION"].ToString() + "</PROFESION>" +
                            "<EMAIL>" + dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString() + "</EMAIL>" +
                            "<FONO>" + dsQuery.Tables[0].Rows[cont]["FONO"].ToString() + "</FONO>" +
                            "<ATENCION>" + dsQuery.Tables[0].Rows[cont]["ATENCION"].ToString() + "</ATENCION>" +
                            "<CONSIDERACIONES>" + dsQuery.Tables[0].Rows[cont]["CONSIDERACIONES"].ToString() + "</CONSIDERACIONES>" +
                            "<jornManana>" + dsQuery.Tables[0].Rows[cont]["jornManana"].ToString() + "</jornManana>" +
                            "<manHoraIni>" + dsQuery.Tables[0].Rows[cont]["manHoraIni"].ToString() + "</manHoraIni>" +
                            "<manHoraFin>" + dsQuery.Tables[0].Rows[cont]["manHoraFin"].ToString() + "</manHoraFin>" +
                            "<jornTarde>" + dsQuery.Tables[0].Rows[cont]["jornTarde"].ToString() + "</jornTarde>" +
                            "<tarHoraIni>" + dsQuery.Tables[0].Rows[cont]["tarHoraIni"].ToString() + "</tarHoraIni>" +
                            "<tarHoraFin>" + dsQuery.Tables[0].Rows[cont]["tarHoraFin"].ToString() + "</tarHoraFin>" +
                            "<REALIZA>" + dsQuery.Tables[0].Rows[cont]["REALIZA"].ToString() + "</REALIZA>" +
                            "<DIRECCION>" + dsQuery.Tables[0].Rows[cont]["DIRECCION"].ToString() + "</DIRECCION>" +
                            "<VEHICULO>" + dsQuery.Tables[0].Rows[cont]["VEHICULO"].ToString() + "</VEHICULO>" +
                            "<ESTADO2>" + dsQuery.Tables[0].Rows[cont]["ESTADO2"].ToString() + "</ESTADO2>" +
                            "<ID_ORGANIZACION>" + dsQuery.Tables[0].Rows[cont]["ID_ORGANIZACION"].ToString() + "</ID_ORGANIZACION>" +
                            "</row>";
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