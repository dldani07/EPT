using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de listaZonasUsuarios
    /// </summary>
    public class listaZonasUsuarios : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select U.ID_USUARIO,up.ID_PROYECTO,p.LOGO,PROY=p.NOMBRE,up.SUPER_USUARIO from USUARIOS u " +
                                            " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                            " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                            " inner join PROYECTO p on p.ID_PROYECTO=up.ID_PROYECTO " +
                                            " where u.ID_USUARIO='" + context.Request["id"].ToString() + "' AND UP.ESTADO=1 ");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<proyectos>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                                "<IDU>" + dsQuery.Tables[0].Rows[cont]["ID_USUARIO"].ToString() + "</IDU>" +
                                "<IDP>" + dsQuery.Tables[0].Rows[cont]["ID_PROYECTO"].ToString() + "</IDP>" +
                                "<LOGO>" + dsQuery.Tables[0].Rows[cont]["LOGO"].ToString() + "</LOGO>" +
                                "<PROY>" + dsQuery.Tables[0].Rows[cont]["PROY"].ToString() + "</PROY>" +
                                "<SUPER>" + dsQuery.Tables[0].Rows[cont]["SUPER_USUARIO"].ToString() + "</SUPER>" +
                            "</row>";
            }
            xml = xml + "</proyectos>";

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