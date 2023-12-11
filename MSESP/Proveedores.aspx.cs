using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class Proveedores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static void Guardar(string rut, string nombre, string region, string comuna)
        {
            /* */
            funciones fn = new funciones();
            fn.dsSql("IF NOT EXISTS (select * from PROVEEDORES where RUT='" + rut + "') BEGIN " +
                     "insert into PROVEEDORES (RUT,NOMBRE,ID_REGION,ID_COMUNA,ESTADO) values(" +
                     "'" + rut + "','" + nombre + "','" + region + "','" + comuna + "',1); end " +
                     " ELSE begin UPDATE PROVEEDORES SET NOMBRE=dbo.MayMinTexto('" + nombre + "'), ID_REGION='" + region + "'," +
                     " ID_COMUNA='" + comuna + "' WHERE RUT='" + rut + "' end ");
        }

        [WebMethod]
        public static void Eliminar(string id)
        {
            funciones fn = new funciones();
            fn.dsSql("update PROVEEDORES set estado=0 where ID_PROVEEDOR='" + id + "'");
        }
    }
}