using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaZonal
    /// </summary>
    public class listaZonal : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select zp.ID_ZONAL,zp.ZONAL from ZONAL_PROFESIONAL zp where zp.ESTADO=1 order BY zp.ZONAL");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<zonal>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_ZONAL"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["ZONAL"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</zonal>";

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