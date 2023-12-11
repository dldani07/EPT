using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaVehiculos
    /// </summary>
    public class listaVehiculos : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select tv.ID_VEHICULO,tv.VEHICULO from TIPO_VEHICULOS tv where tv.ESTADO=1 order by tv.VEHICULO");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<vehiculos>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_VEHICULO"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["VEHICULO"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</vehiculos>";

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