using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosAccion
    /// </summary>
    public class datosAccion : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select a.ID_TIPO_ACTIVIDAD,fecha=CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105)," +
                                       " ad.OBSERVACIONES,DES=isnull(ad.DESTINATARIO,0),ad.CORREO,ad.DOCUMENTO,ad.ID_SEGMENTO,ad.ID_LATERAL from ACCION_DETALLE ad " +
                                       " inner join acciones a on a.ID_ACCION=ad.ID_ACCION " +
                                       " where ad.ID_ACCION_DETALLE=" + context.Request["id"].ToString());

            
            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                  "<accion>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_TIPO_ACTIVIDAD"].ToString() + "</ID>" +
                            "<FECHA>" + dsQuery.Tables[0].Rows[cont]["FECHA"].ToString() + "</FECHA>" +
                            "<OBS>" + dsQuery.Tables[0].Rows[cont]["OBSERVACIONES"].ToString() + "</OBS>" +
                            "<DES>" + dsQuery.Tables[0].Rows[cont]["DES"].ToString() + "</DES>" +
                            "<CORREO>" + dsQuery.Tables[0].Rows[cont]["CORREO"].ToString() + "</CORREO>" +
                            "<DOCUMENTO>" + dsQuery.Tables[0].Rows[cont]["DOCUMENTO"].ToString() + "</DOCUMENTO>" +
                            "<ID_SEGMENTO>" + dsQuery.Tables[0].Rows[cont]["ID_SEGMENTO"].ToString() + "</ID_SEGMENTO>" +
                            "<ID_LATERAL>" + dsQuery.Tables[0].Rows[cont]["ID_LATERAL"].ToString() + "</ID_LATERAL>" +
                            "</row>";
            }
            xml = xml + "</accion>";

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