<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/SiteInicio.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MSESP._Default" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <script src='https://www.google.com/recaptcha/api.js'></script>
<script type="text/javascript">
    var validator = "";
    $(document).ready(function () {

        //mensaje();

        $("#recupera").dialog({
                title: "Recuperar Contraseña",
                height: 250,
                width: 600,
                autoOpen: false,
                modal: true,
                buttons: {
                    Recuperar: function () {
                        validarFrm();
                        if ($("#form1").valid()) {
                            /**/var parametros = {
                                rut: $('#repRut').val(),
                                email: $('#repCorreo').val(),
                            };
                            $.ajax({
                                url: 'Default.aspx/Recuperar',
                                type: 'POST',
                                data: JSON.stringify(parametros), 
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () { 
                                    validator.resetForm();
                                }
                            });
                            $(this).dialog('close');
                        }
                    },
                    Cerrar: function () {
                        $(this).dialog('close');
                        validator.resetForm();
                    }
                }
        });

        $("#contigencia").dialog({
            title: "Informativo",
            height: 450,
            width: 600,
            autoOpen: false,
            modal: true,
            buttons: {
                Cerrar: function () {
                    $(this).dialog('close');
                }
            }
        });
    });

    function mensaje() {
        //alert('Estimados Usuarios: Les informamos que nos encontramos en una contingencia, por lo cual durante esta jornada el ingreso a la plataforma deberá realizarse con el Rut y la contraseña, favor en caso de problemas contactarse con Soporte TI al Teléfono +56 9 33520388.'); 
        //$('#contigencia').dialog('open');
    }

    function recuperarclave() {
        $('#recupera').dialog('open');
        //$('#contigencia').dialog('open');
        $('#repRut').val("");
        $('#repCorreo').val("");
        validarFrm();
    }

    function validarFrm() {
        validator = $("#form1").validate({
            rules: {
                repRut: {
                    required: true,
                    rut: true
                },
                repCorreo: {
                    required: true,
                    email: true
                }
            },
            messages: {
                repRut: {
                    required: "&bull; Ingrese Rut de Usuario.",
                    rut: "&bull; Rut de Usuario Erroneo."
                },
                repCorreo: {
                    required: "&bull; Ingrese Email de Usuario.",
                    email: "&bull; Email de Usuario erroneo."
                }
            }
        });
    }

    function cambiaPlaceFolder(id)
    {
        $("#MainContent_UserName").attr('placeholder', 'Rut Ej: 16313889-8');
        if (id == 3) {
            $("#MainContent_UserName").attr('placeholder', 'Ingrese su E-mail');
        }
    }

    //mensaje();
</script>

    <div id="billboard" style="width: 80%; align-content:center;"> 
        
           <article style="line-height: 2.42857143;">
            <h1>Bienvenido a nuestro<br/><span> Portal</span></h1>
            <form runat="server" style="width:100%" id="frmLogin" method="post" action="Default.aspx">
                    

                        <div style="height: 50px;">
                            <asp:DropDownList ID="TipoUsuario" runat="server" Height="35px" Width="100%" onchange="cambiaPlaceFolder(this.value);" ></asp:DropDownList>
                        </div>
                
                        <div style="height: 50px;">
                            <asp:TextBox runat="server" class="form-control" id="UserName" placeholder="Rut Ej: 16313889-8" maxlength="50" type="text" ></asp:TextBox>
                        </div>
         
                        <div style="height: 50px;">  
                            <asp:TextBox runat="server" id="Password" maxlength="20" class="form-control" placeholder="Clave" type="password" ></asp:TextBox>  
                        </div>

                        <div class="g-recaptcha" data-sitekey="6LcBdzAUAAAAANpFv0t24PcuYRo8qigpimLA3wB4" style="height: 90px; display: none"></div>
  
                        <div style="height: 50px;">  
                            <asp:Button ID="BtnIngresar" CssClass="btn" runat="server" Text="Ingresar" OnClick="BtnIngresar_Click" />
                        </div>

                        <div style="height: 50px; display: none">
                            <asp:TextBox runat="server" class="form-control" id="EmailAd" placeholder="Ingrese su Correo Electrónico" maxlength="50" type="text" ></asp:TextBox>
                        </div>

                        <div style="height: 50px; display: none">  
                            <asp:Button ID="BtnIngresarAD" CssClass="btn" runat="server" Text="Iniciar Sesión" OnClick="BtnIngresarAD_Click" Visible="False"/>
                        </div>

                        <div style="height: 30px;">  
                            <asp:HyperLink ID="recuperar" runat="server" href="#" onclick="recuperarclave();" >¿Olvidaste o se bloqueó tu clave?</asp:HyperLink>
                        </div>
                              
                        <div style="height: 50px;"> 
                            <asp:Label ID="LbMensaje" runat="server" Font-Bold="True" Font-Italic="True" ForeColor="Red"><%if (Request["e"] == "404") { %><%="La Información Ingresada no es Válida. Inténtelo Nuevamente"%><% }%></asp:Label>
                        </div>
            </form>
        </article>
    </div>

<div id="recupera"> 
    <form id="form1" style="font-size: 11px;">
         <table id="tablaFinal" style="width:300px">
            <tr>
                <td style="width:70px">Rut : </td>
                <td style="width:230px"><input name="repRut" type="text" maxlength="50" id="repRut" style="width:100%"/></td>
            </tr>
            <tr>
                <td>Correo : </td>
                <td><input name="repCorreo" type="text" maxlength="50" id="repCorreo" style="width:100%"/></td>
            </tr>
        </table>
    </form> 
</div>

<div id="contigencia"> 
    Estimados Usuarios: Les informamos que nos encontramos en una contingencia, por lo cual durante esta jornada el ingreso a la plataforma deberá realizarse con el Rut y la contraseña, favor en caso de problemas contactarse con Soporte TI al Teléfono +56 9 33520388.
</div>
</asp:Content>