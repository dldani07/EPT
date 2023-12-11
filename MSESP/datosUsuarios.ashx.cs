using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosUsuarios
    /// </summary>
    public class datosUsuarios : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";

            //this.
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select U.ID_USUARIO,U.RUT,NOMBRE=dbo.MayMinTexto(U.NOMBRE),u.EMAIL,u.FONO,tp.TIPO,u.ID_TIPO_USUARIO,u.PASSWORD,AGENCIA=isnull(u.ID_AGENCIA,0) from USUARIOS u " +
                                       " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                       " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                       " where U.ESTADO=1 and U.ID_USUARIO=" + context.Request["id"].ToString() +
                                       " and up.ID_PROYECTO=" + context.Request["proy"].ToString().Trim());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<usuario>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                            "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                            "<EMAIL>" + dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString() + "</EMAIL>" +
                            "<FONO>" + dsQuery.Tables[0].Rows[cont]["FONO"].ToString() + "</FONO>" +
                            "<ID_TIPO_USUARIO>" + dsQuery.Tables[0].Rows[cont]["ID_TIPO_USUARIO"].ToString() + "</ID_TIPO_USUARIO>" +
                            "<PASSWORD>" + dsQuery.Tables[0].Rows[cont]["PASSWORD"].ToString() + "</PASSWORD>" +
                            "<AGENCIA>" + dsQuery.Tables[0].Rows[cont]["AGENCIA"].ToString() + "</AGENCIA>" +
                            "</row>";
            }
            xml = xml + "</usuario>";

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