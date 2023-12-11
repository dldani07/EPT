using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using Newtonsoft.Json;
using System.Net;
using System.Text;
using System.Data;

namespace MSESP
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string code = "";
            string state = "";

            if (Request.QueryString["code"] != null && Request.QueryString["code"] != string.Empty)
            {
                code = Request.QueryString["code"];
            }

            if (Request.QueryString["state"] != null && Request.QueryString["state"] != string.Empty)
            {
                state = Request.QueryString["state"];
            }

            const string GrantType = "authorization_code";
            string ResponseType = "code";
            string ClientId = "024eb5b2-5006-49a4-8f49-e165d75992ba";
            //string RedirectUri = "https://localhost:44337/auth/login-callback";
            //string RedirectUri = "https://test.solicitudept.cl/auth/login-callback";
            string RedirectUri = "https://www.solicitudept.cl/auth/login-callback";
            string Scope = "openid%20profile%20email%20user.read&sso_reload=true";
            string State = "This is my state value";
            string ApiEndpoint = "https://graph.microsoft.com/V1.0/me";
            string ClientSecret = "8Dw8Q~rsJ2L.8epKXlhhfPu23gyT0RjnR1JvlcwE";
            string TokenEndpoint = "https://login.microsoftonline.com/57952562-bae2-4b79-8ad4-e375a3dced97/oauth2/v2.0/token";

            /*string URLConexion = "https://login.microsoftonline.com/{tenant}/oauth2/v2.0/authorize?" +
                                 "client_id=024eb5b2-5006-49a4-8f49-e165d75992ba" +
                                 "&response_type = code" +
                                 "&redirect_uri = https://localhost:44337/auth/login-callback" +
                                 "&response_mode = query " +
                                 "&scope = https://graph.microsoft.com" +
                                 "&state = 12345" +
                                 "&code_challenge = 8Dw8Q~rsJ2L.8epKXlhhfPu23gyT0RjnR1JvlcwE" +
                                 "&code_challenge_method = S256";*/


            if (state.Equals("This is my state value"))
            {

                var postData = "grant_type=" + Uri.EscapeDataString(GrantType);
                postData += "&code=" + Uri.EscapeDataString(code);
                postData += "&redirect_uri=" + Uri.EscapeDataString(RedirectUri);
                postData += "&client_id=" + Uri.EscapeDataString(ClientId);
                postData += "&client_secret=" + Uri.EscapeDataString(ClientSecret);
                postData += "&scope=" + Uri.EscapeDataString(Scope);

                

                var data = Encoding.ASCII.GetBytes(postData);

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(TokenEndpoint);
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;

                using (var stream = request.GetRequestStream())
                {
                    stream.Write(data, 0, data.Length);
                    //MessageBox.Show();
                }

                try
                {
                    using (WebResponse response = request.GetResponse())
                    {
                        using (Stream strReader = response.GetResponseStream())
                        {
                            if (strReader == null) return;
                            using (StreamReader objReader = new StreamReader(strReader))
                            {
                                string responseBody = objReader.ReadToEnd();

                                //ResponseToken ResponseToken = new ResponseToken();
                              
                                ResponseToken responseToken = JsonConvert.DeserializeObject<ResponseToken>(responseBody);
                                HttpWebRequest apiRequest = (HttpWebRequest)WebRequest.Create(ApiEndpoint);
                                apiRequest.Headers["Authorization"] = "Bearer " + responseToken.access_token;

                                try
                                {
                                    using (WebResponse apiResponse = apiRequest.GetResponse())
                                    {
                                        using (Stream apiStrReader = apiResponse.GetResponseStream())
                                        {
                                            if (apiStrReader == null) return;
                                            using (StreamReader apiObjReader = new StreamReader(apiStrReader))
                                            {
                                                string apiResponseBody = apiObjReader.ReadToEnd();
                                                ResponseApi responseApi = JsonConvert.DeserializeObject<ResponseApi>(apiResponseBody);

                                                
                                                //indee = TipoUsuario.SelectedItem.ToString();
                                                //string tpSelec = "1";
                                                funciones fn = new funciones();
                                                string queryInicio = "";

                                                Session["TpUsuario"] = "";
                                                Session["IdUsuario"] = "";


                                                //if (tpSelec == "1" || tpSelec == "2")
                                               // {
                                                    queryInicio = "select TOP 1 U.ID_USUARIO,U.RUT,U.NOMBRE,tp.ID_TIPO_USUARIO from USUARIOS u " +
                                            " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                            " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                            " where u.EMAIL='" + responseApi.mail.ToString() + "'" +
                                            " AND UP.ESTADO=1 and u.ID_TIPO_USUARIO in (1,3)";
                                               // }

                                                DataSet dsInicio = fn.dsSql(queryInicio);
                                                if (dsInicio.Tables[0].Rows.Count > 0)
                                                {
                                                    Session["TpUsuario"] = dsInicio.Tables[0].Rows[0]["ID_TIPO_USUARIO"].ToString();
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
                                                    //var encodedResponse = Request.Form["g-Recaptcha-Response"];
                                                    //var isCaptchaValid = ReCaptcha.Validate(encodedResponse);

                                                    /*if (!isCaptchaValid)
                                                    {
                                                        //Response.Redirect("Default.aspx?e=404");
                                                        Response.Redirect("/Acceso.aspx");
                                                    }
                                                    else
                                                    {*/
                                                        Response.Redirect("/Acceso.aspx");
                                                    //}
                                                }
                                                else
                                                {
                                                    //this.LbMensaje.Text = "mensajeee";
                                                    //this.ValueHiddenField.ToString();
                                                    Response.Redirect("/Default.aspx?e=404");
                                                }

                                            }
                                        }
                                    }
                                }
                                catch (WebException ex)
                                {
                                    Response.Redirect("/Default.aspx?e=404");
                                }
                            }
                        }
                    }
                }
                catch (WebException ex)
                {
                    Response.Redirect("/Default.aspx?e=404");
                }
            }
        }
    }
}