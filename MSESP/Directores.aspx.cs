using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class Directores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static void Guardar(string nombre, string email, string region)
        {
            /* */
            funciones fn = new funciones();
            fn.dsSql("IF NOT EXISTS (select * from DIRECTORES where nombre='" + nombre + "') BEGIN " +
                     "insert into DIRECTORES (NOMBRE,ID_REGION,EMAIL,ESTADO) values(" +
                     "dbo.MayMinTexto('" + nombre + "'),'" + region + "','" + email + "',1); end " +
                     " ELSE begin UPDATE DIRECTORES SET NOMBRE=dbo.MayMinTexto('" + nombre + "'), ID_REGION='" + region + "', " +
                     "EMAIL='" + email + "' WHERE nombre='" + nombre + "' end ");
        }

        [WebMethod]
        public static void Eliminar(string id)
        {
            funciones fn = new funciones();
            fn.dsSql("update DIRECTORES set estado=0 where ID_DIRECTOR='" + id + "'");
        }
    }
}