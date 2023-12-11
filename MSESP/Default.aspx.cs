using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.Services;

namespace MSESP
{
    public partial class _Default : Page
    {
        string tpSelec;
        protected void Page_Load(object sender, EventArgs e)
        {
            /*string txt;
            txt = GetCustomers();
            UserName.Text = txt.ToString();*/
            //llenaCombo("1");
            //this.UserName.Text = indee;
            TipoUsuario.Items.Clear();
            cargaTipoUsuario();
        }

        public void cargaTipoUsuario()
        {
            ListItem oItem;
            oItem = new ListItem("Usuario MAS+C", "1");
            TipoUsuario.Items.Add(oItem);
            //oItem = new ListItem("Usuario C.C.O", "2");
            //TipoUsuario.Items.Add(oItem);
            oItem = new ListItem("Usuario Cliente", "3");
            TipoUsuario.Items.Add(oItem);
            oItem = new ListItem("Profesional EPT", "4");
            TipoUsuario.Items.Add(oItem);
            //oItem = new ListItem("Administración Mutual", "5");
            //TipoUsuario.Items.Add(oItem);
            this.TipoUsuario.ClearSelection();
        }

        public static string GetCustomers()
        {
            funciones fn = new funciones();
            DataSet dsTrab = fn.dsSql("SELECT top 5 * FROM TIPO_SOLICITUD");
            
            System.IO.StringWriter writer = new System.IO.StringWriter();
            dsTrab.Tables[0].WriteXml(writer, XmlWriteMode.WriteSchema, false);
            return writer.ToString();
        }

        public void llenaCombo(string id)
        {
            funciones fn = new funciones();
            DataSet dsTrab = fn.dsSql("SELECT top 5 * FROM TIPO_SOLICITUD");

            /*ListItem oItem;
            oItem = new ListItem("Seleccione", "0");
            TipoUsuario.Items.Add(oItem);*/

            TipoUsuario.DataSource = dsTrab.Tables[0].DefaultView;
            TipoUsuario.DataValueField = "ID_TIPO_SOLICITUD";
            TipoUsuario.DataTextField = "NOMBRE";
            TipoUsuario.DataBind();

            TipoUsuario.SelectedValue = id;
        }

        protected void BtnIngresarAD_Click(object sender, EventArgs e)
        {
            string AuthorizationEndpoint = "https://login.microsoftonline.com/57952562-bae2-4b79-8ad4-e375a3dced97/oauth2/v2.0/authorize";
            string ResponseType = "code";
            string ClientId = "024eb5b2-5006-49a4-8f49-e165d75992ba";
            string RedirectUri = "https://localhost:44337/auth/login-callback";
            //string RedirectUri = "https://test.solicitudept.cl/auth/login-callback";
            //string RedirectUri = "https://www.solicitudept.cl/auth/login-callback";
            string Scope = "https://graph.microsoft.com/User.Read";
            string State = "This is my state value";

            string URL = $"{AuthorizationEndpoint}?" +
                $"response_type={ResponseType}&" +
                $"client_id={ClientId}&" +
                $"redirect_uri={RedirectUri}&" +
                $"scope={Scope}&state={State}";

            Response.Redirect(URL);
        }
        protected void BtnIngresar_Click(object sender, EventArgs e)
        {
            //indee = TipoUsuario.SelectedItem.ToString();
            tpSelec = Request["ctl00$MainContent$TipoUsuario"];
            funciones fn = new funciones();
            string queryInicio = "";

            Session["TpUsuario"] = "";
            Session["IdUsuario"] = "";


            if (tpSelec == "1" || tpSelec == "2")
            {
                              queryInicio = "select U.ID_USUARIO,U.RUT,U.NOMBRE from USUARIOS u " +
                                            " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                            " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                            " where u.RUT='" + this.UserName.Text.Trim() + "'"+
                                            " and u.[PASSWORD]='" + this.Password.Text.Trim() + "'" +
                                            " AND U.ESTADO=1 and u.ID_TIPO_USUARIO in (1,2)";

            }

            if (tpSelec == "3")
            {
                queryInicio = "select U.ID_USUARIO,U.RUT,U.NOMBRE from USUARIOS u " +
                                            " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                            " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                            " where u.EMAIL='" + this.UserName.Text.Trim() + "'" +
                                            " and u.[PASSWORD]='" + this.Password.Text.Trim() + "'" +
                                            " AND U.ESTADO=1 and u.ID_TIPO_USUARIO in (3)";
            }

            if (tpSelec == "4")
            {
                queryInicio = "SELECT ID_USUARIO=pf.ID_PROFESIONAL,PF.RUT,PF.NOMBRE FROM PROFESIONALES PF " +
                              " where PF.RUT='" + this.UserName.Text.Trim() + "'" +
                              " and PF.[PASSWORD]='" + this.Password.Text.Trim() + "'" +
                              " AND PF.ESTADO=1";
            }

            if (tpSelec == "5")
            {
                queryInicio = "SELECT ID_USUARIO=E.ID_EMPRESA,E.RUT,E.NOMBRE FROM EMPRESAS E " +
                              " where E.RUT='" + this.UserName.Text.Trim() + "'" +
                              " and E.[PASSWORD]='" + this.Password.Text.Trim() + "'" +
                              " AND E.ESTADO=1 AND E.MANDANTE=1";
            }

            DataSet dsInicio = fn.dsSql(queryInicio);

            if (dsInicio.Tables[0].Rows.Count > 0)
            {

                Session["TpUsuario"] = tpSelec;
                Session["IdUsuario"] = dsInicio.Tables[0].Rows[0]["ID_USUARIO"].ToString();
                if (dsInicio.Tables[0].Rows[0]["NOMBRE"].ToString().Length > 24)
                {
                    Session["nomUsuario"] = dsInicio.Tables[0].Rows[0]["NOMBRE"].ToString().Substring(0, 24);
                }
                else
                {
                    Session["nomUsuario"] = dsInicio.Tables[0].Rows[0]["NOMBRE"].ToString();
                }
                fn.dsSql("exec dbo.ACTUALIZA_ESTADO_SOLICITUD_AGENDADO");

                //Response.Redirect("Inicio.aspx");
                //Response.Redirect("Acceso.aspx");
                var encodedResponse = Request.Form["g-Recaptcha-Response"];
                var isCaptchaValid = ReCaptcha.Validate(encodedResponse);

                if (!isCaptchaValid)
                {
                    //Response.Redirect("Default.aspx?e=404");
                    Response.Redirect("Acceso.aspx");
                }
                else
                {
                    Response.Redirect("Acceso.aspx");
                }
            }
            else
            {
                //this.LbMensaje.Text = "mensajeee";
                //this.ValueHiddenField.ToString();
                Response.Redirect("Default.aspx?e=404");
            }
        }

        [WebMethod]
        public static void Recuperar(string rut, string email)
        {
            funciones fn = new funciones();
            Random rnd = new Random();
            string tabla = "";
            int nro = rnd.Next(10000, 99999);

            DataSet dsQuery = fn.dsSql("SELECT NOMBRE FROM Usuarios " +
                                       " WHERE rut='" + rut + "' and EMAIL='" + email + "'");

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                fn.dsSql("update usuarios set PASSWORD='" + nro.ToString() + "' where rut='" + rut + "' and EMAIL='" + email + "'");

                tabla = tabla + "<tr>" +
                                "    <td colpan=\"2\"></td>" +
                                "</tr>" +
                                "<tr><td style=\"width:100px;\">Rut : </td>" +
                                "    <td style=\"width:300px;\">" + rut + "</td>" +
                                "</tr>" +
                                "<tr><td>Email : </td>" +
                                "    <td>" + email + "</td>" +
                                "</tr>" +
                                "<tr><td>Clave : </td>" +
                                "    <td>" + nro.ToString() + "</td>" +
                                "</tr>";

                fn.enviaCorreo("Estimado " + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + " : ", email, tabla, "", "Recuperar Contraseña", "Se procedido a Cambiar su contraseña:");
            }
        }

        /*protected void TipoUsuario_SelectedIndexChanged(object sender, EventArgs e)
        {
            string message = TipoUsuario.SelectedItem.Text + " - " + TipoUsuario.SelectedItem.Value;
            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + message + "');", true);
        }*/
    }
}