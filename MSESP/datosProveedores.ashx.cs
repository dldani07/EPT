using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosProveedores
    /// </summary>
    public class datosProveedores : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select p.ID_PROVEEDOR,p.RUT,p.NOMBRE,P.ID_REGION,P.ID_COMUNA from PROVEEDORES p " +
                                       " where p.ID_PROVEEDOR=" + context.Request["id"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<empresa>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "<REGION>" + dsQuery.Tables[0].Rows[cont]["ID_REGION"].ToString() + "</REGION>" +
                            "<COMUNA>" + dsQuery.Tables[0].Rows[cont]["ID_COMUNA"].ToString() + "</COMUNA>" +
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