using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Services;
using System.Xml;

namespace MSESP
{
    public partial class Empresas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        [WebMethod]   
        public static void Guardar(string rut, string nombre, string adh)
        {
           /* */funciones fn = new funciones();
           fn.dsSql("IF NOT EXISTS (select * from empresas where RUT='" + rut + "') BEGIN " + 
                    "insert into empresas (RUT,NOMBRE,ESTADO,MANDANTE,N_ADHERENTE) values(" +
                    "'" + rut + "','" + nombre + "',1,0,'" + adh + "')" +
            	    " select ID=ID_EMPRESA from empresas where RUT='" + rut + "' end " +
                    " ELSE begin UPDATE empresas SET NOMBRE=dbo.MayMinTexto('" + nombre + "'), N_ADHERENTE='" + adh + "' " +
                    " WHERE RUT='" + rut + "'" +	  
	                " select ID=ID_EMPRESA from empresas where RUT='" + rut + "' end ");
        }

        [WebMethod]
        public static void Eliminar(string id)
        {
            funciones fn = new funciones();
            fn.dsSql("update EMPRESAS set estado=0 where ID_EMPRESA='" + id + "'");
        }

        [WebMethod]
        public void cargaDatos(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select U.ID_USUARIO,U.RUT,U.NOMBRE,u.EMAIL,u.FONO,tp.TIPO,u.ID_TIPO_USUARIO from USUARIOS u " +
                                       " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                       " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                       " where U.ESTADO=1 and U.ID_USUARIO=" + context.Request["id"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<usuario>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row>" +
                            "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                            "</row>";
            }
            xml = xml + "</usuario>";

            context.Response.Write(xml);
            //return xml;
        }

        [WebMethod] 
        public static string lista()
        {
            /*String rawXml =
            @"<root>
                <person firstname=""Riley"" lastname=""Scott"" />
                <person firstname=""Thomas"" lastname=""Scott"" />
            </root>";
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(rawXml);*/

            funciones fn = new funciones();
            DataSet dsTrab = fn.dsSql("SELECT * FROM EMPRESAS");
            return "";
            //return JsonConvert.SerializeObject(dsTrab.Tables[0]);
        }
    }
}