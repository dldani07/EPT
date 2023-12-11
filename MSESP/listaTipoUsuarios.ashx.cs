using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaTipoUsuarios
    /// </summary>
    public class listaTipoUsuarios : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("SELECT ID_TIPO_USUARIO,TIPO FROM TIPO_USUARIOS where ID_TIPO_USUARIO in (1,3)");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<tusuarios>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<ID>" + dsQuery.Tables[0].Rows[cont]["ID_TIPO_USUARIO"].ToString() + "</ID>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "</NOMBRE>" +
                            "</row>";
            }
            xml = xml + "</tusuarios>";

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