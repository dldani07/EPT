using System;
using System.Web;

using System.Data;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class Usuarios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //UsuarioTipo.Items.Clear();
            //llenaComboUsuarios("1");

            //txtAgencia.Items.Clear();
            //llenaAgencias("1");
        }

        public void llenaAgencias(string id)
        {
            funciones fn = new funciones();
            DataSet dsTrab = fn.dsSql("/*select ID_AGENCIA='',AGENCIA='Seleccione' union all */" +
                                      "select a.ID_AGENCIA,a.AGENCIA from agencias a where a.ESTADO=1 order by a.AGENCIA");

            txtAgencia.DataSource = dsTrab.Tables[0].DefaultView;
            txtAgencia.DataValueField = "ID_AGENCIA";
            txtAgencia.DataTextField = "AGENCIA";
            txtAgencia.DataBind();

            //this.txtAgencia.ClearSelection();
            
        }

        public void llenaComboUsuarios(string id)
        {
            funciones fn = new funciones();
            DataSet dsTrab = fn.dsSql("SELECT ID_TIPO_USUARIO,TIPO FROM TIPO_USUARIOS where ID_TIPO_USUARIO in (1,3)");

            /*ListItem oItem;
            oItem = new ListItem("Seleccione", "0");
            TipoUsuario.Items.Add(oItem);*/

            UsuarioTipo.DataSource = dsTrab.Tables[0].DefaultView;
            UsuarioTipo.DataValueField = "ID_TIPO_USUARIO";
            UsuarioTipo.DataTextField = "TIPO";
            UsuarioTipo.DataBind();

            //this.UsuarioTipo.ClearSelection();
            //UsuarioTipo.SelectedValue = id;
        }

        public void limpia()
        {
           // MSESP.Usuarios fn = new MSESP.Usuarios();

           // fn.UsuarioTipo.Items.Clear();
            //DropDownList.Equals 

           /* foreach (Control oControls in form1.Controls)
            {

                if (oControls is DropDownList)
                {
                    ((DropDownList)oControls).ClearSelection();
                    //oControls.t = ""; // Eliminar el texto del TextBox
                }
            }*/

        }

        [WebMethod]
        public static void SeleccionItems(string u, string a)
        {
            //MSESP.Usuarios.limpia();
            MSESP.Usuarios fn = new MSESP.Usuarios();

            //fn.UsuarioTipo.SelectedValue = "22";

            fn.limpia();
            //fn.txtAgencia.SelectedValue = a;
        }

        [WebMethod]
        public static void Guardar(string rut, string nombre, string fono, string email, string tipo, string clave, string agencia, string proy)
        {
            string insUsuario = "", strUsr = "", addUsrPro = "", strSQLUsr = "";
            funciones fn = new funciones();

            insUsuario = "IF NOT EXISTS (select * from USUARIOS where RUT='" + rut + "') BEGIN " +
                  "insert into usuarios (RUT,NOMBRE,FONO,EMAIL,ESTADO,ID_TIPO_USUARIO,PASSWORD,ID_AGENCIA) values('" + rut + "'," +
                  "dbo.MayMinTexto('" + nombre + "'),'" + fono + "',LOWER('" + email + "'),1,'" + tipo + "','" + clave + "','" + agencia + "') " +
                  " select ID=ID_USUARIO from USUARIOS where RUT='" + rut + "' end " +
                  " ELSE begin UPDATE USUARIOS SET NOMBRE=dbo.MayMinTexto('" + nombre + "'), FONO='" + fono + "', " +
                  "EMAIL=LOWER('" + email + "'), ESTADO=1, ID_TIPO_USUARIO='" + tipo + "'," +
                  "PASSWORD='" + clave + "', ID_AGENCIA='" + agencia + "' WHERE RUT='" + rut + "'" +
                  " select ID=ID_USUARIO from USUARIOS where RUT='" + rut + "' END ";

            strUsr = "Set Nocount on ";
            strUsr = strUsr + insUsuario;
            strUsr = strUsr + " set nocount off";


            DataSet rsUsuario = fn.dsSql(strUsr);

            addUsrPro = "IF NOT EXISTS (select * from USUARIO_PROYECTO UP where UP.ID_USUARIO='" + rsUsuario.Tables[0].Rows[0]["ID"].ToString() + "'" +
                      " and UP.ID_PROYECTO=" + proy + ") BEGIN " +
                      " insert into USUARIO_PROYECTO (ID_USUARIO,ID_PROYECTO,FECHA_CREACION,ESTADO) values('" + rsUsuario.Tables[0].Rows[0]["ID"].ToString() + "'," + proy + ",getdate(),1); end " +
                      " ELSE begin UPDATE USUARIO_PROYECTO SET ESTADO=1 where ID_USUARIO='" + rsUsuario.Tables[0].Rows[0]["ID"].ToString() + "' AND ID_PROYECTO=" + proy + " END";

            strSQLUsr = "Set Nocount on ";
            strSQLUsr = strSQLUsr + addUsrPro;
            strSQLUsr = strSQLUsr + " set nocount off";

            fn.dsSql(strSQLUsr);/**/
        }
        
        [WebMethod]
        public static void Eliminar(string id, string proy)
        {
            funciones fn = new funciones();
            //fn.dsSql("update usuarios set estado=0 where id_usuario='" + id + "'");
            fn.dsSql("update USUARIO_PROYECTO set estado=0 where ID_PROYECTO=" + proy + " and ID_USUARIO='" + id + "'");
        }

        [WebMethod]
        public void cargaDatos(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select U.ID_USUARIO,U.RUT,U.NOMBRE,u.EMAIL,u.FONO,tp.TIPO,u.ID_TIPO_USUARIO from USUARIOS u " +
                                       " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                       " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                       " where U.ESTADO=1 and U.ID_USUARIO=" +  context.Request["id"].ToString());

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
    }
}