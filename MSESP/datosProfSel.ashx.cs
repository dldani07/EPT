using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosProfSel
    /// </summary>
    public class datosProfSel : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT prov=P.NOMBRE," +
                                        "vAGENCIA=ISNULL((select a.AGENCIA from agencias a " +
                                        " where a.ID_AGENCIA=PF.AGENCIA),'Sin Asignar')," +
                                        "vZONAL=(CASE PF.ZONAL when 1 then 'Centro' " +
                                        " when 2 then 'Norte' when 3 then 'Punta Arenas' " +
                                        " when 4 then 'RM' when 5 then 'RM / Centro' " +
                                        " when 6 then 'Sur' else 'Sin Asignar' end)," +
                                        " PF.PROFESION,PF.ATENCION,PF.CONSIDERACIONES,pf.EMAIL,pf.FONO " +
                                        " FROM PROFESIONALES PF  " +
                                        " inner join PROVEEDORES p on p.ID_PROVEEDOR=PF.ID_PROVEEDOR " +
                                        " WHERE PF.ID_PROFESIONAL=" + context.Request["id"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<empresa>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<PROV>" + dsQuery.Tables[0].Rows[cont]["prov"].ToString() + "</PROV>" +
                            "<AGENCIA>" + dsQuery.Tables[0].Rows[cont]["vAGENCIA"].ToString() + "</AGENCIA>" +
                            "<ZONAL>" + dsQuery.Tables[0].Rows[cont]["vZONAL"].ToString() + "</ZONAL>" +
                            "<PROFESION>" + dsQuery.Tables[0].Rows[cont]["PROFESION"].ToString() + "</PROFESION>" +
                            "<ATENCION>" + dsQuery.Tables[0].Rows[cont]["ATENCION"].ToString() + "</ATENCION>" +
                            "<CONSIDERACIONES>" + dsQuery.Tables[0].Rows[cont]["CONSIDERACIONES"].ToString() + "</CONSIDERACIONES>" +
                            "<EMAIL>" + dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString() + "</EMAIL>" +
                            "<FONO>" + dsQuery.Tables[0].Rows[cont]["FONO"].ToString() + "</FONO>" +
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