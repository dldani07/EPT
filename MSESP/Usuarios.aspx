<%@ Page Title="Usuarios" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="MSESP.Usuarios" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">   

    <script type="text/javascript">
        var validator = "";
        $(document).ready(function () {
            jQuery("#jQGridDemo").jqGrid({
                url: 'jqGridUsuarios.ashx?p=<%=(string)(Session["IDProyecto"])%>',
                datatype: "xml",
                colNames: ['Rut', 'Usuario', 'Email', 'Telefono', 'Tipo', '', ''],
                colModel: [
                            { name: 'RUT', index: 'RUT', width: 50, stype: 'text' },
                            { name: 'NOMBRE', index: 'NOMBRE', width: 150, stype: 'text' },
                            { name: 'EMAIL', index: 'EMAIL', width: 150, stype: 'text' },
                            { name: 'FONO', index: 'FONO', width: 100, stype: 'text' },
                            { name: 'TIPO', index: 'TIPO', width: 100, stype: 'text' },
                            { width: 13, stype: 'text' },
                            { width: 13, stype: 'text' }
                ],
                rowNum: 50,
                rownumbers: true,
                width: 960,
                height: 300,
                mtype: 'GET',
                loadonce: false,
                rowList: [50, 100, 200],
                pager: '#jQGridDemoPager',
                sortname: 'NOMBRE',
                viewrecords: true,
                sortorder: 'asc',
                caption: "Listado de <%: Page.Title %>"
            });

            $('#jQGridDemo').jqGrid('navGrid', '#jQGridDemoPager',
            {
                edit: false,
                add: false,
                del: false,
                search: false,
                searchtext: "Search",
                addtext: "Add",
                edittext: "Edit",
                deltext: "Delete"
            });

            jQuery("#jQGridDemo").jqGrid('navButtonAdd', "#jQGridDemoPager", {
                caption: "Agregar&nbsp;&nbsp;",
                title: "Agregar Nuevo Registro",
                buttonicon: 'ui-icon-plus',
                onClickButton: function () {
                    $('#MainContent_txtRut').val("");
                    $('#MainContent_txtNombre').val("");
                    $('#MainContent_txtFono').val("");
                    $('#MainContent_txtEmail').val("");
                    $('#MainContent_txtClave').val("");
                    $("#MainContent_trAgencia").hide();
                    //$('#txtAgencia option:selected').remove();
                    llena_agencias(0);
                    llena_tipoUsuarios(0);
                    //validator.resetForm();
                    $('#modal_dialog').dialog('open');
                    validarFrm();
                }
            });

            jQuery("#jQGridDemo").jqGrid('navButtonAdd', "#jQGridDemoPager", {
                caption: "Exportar a Excel&nbsp;&nbsp;",
                title: "Exportar a Excel",
                buttonicon: 'ui-icon-script',
                onClickButton: function () {
                    sUrl = 'ReportesXLS.aspx?t=3&fi=&ft=&p=<%=(string)(Session["IDProyecto"])%>';
                    window.open(sUrl, 'Reportabilidad');
                }
            });

            $("#modal_dialog").dialog({
             title: "Registro de <%: Page.Title %>",
             height: 400,
             width: 850,
             autoOpen: false,
             modal: true,
             buttons: {
                 Guardar: function () {
                     validarFrm();
                     if ($("#form1").valid()) {
                         var parametros = {
                             rut: $('#MainContent_txtRut').val(),
                             nombre: $('#MainContent_txtNombre').val(),
                             fono: $('#MainContent_txtFono').val(),
                             email: $('#MainContent_txtEmail').val(),
                             tipo: $('#MainContent_UsuarioTipo').val(),
                             clave: $('#MainContent_txtClave').val(),
                             agencia: $('#MainContent_txtAgencia').val(),
                             proy: '<%=(string)(Session["IDProyecto"])%>'
                         };
                         //data: $('form1').serialize(),
                         $.ajax({
                             url: 'Usuarios.aspx/Guardar',
                             type: 'POST',
                             data: JSON.stringify(parametros),           // los parámetros en formato JSON
                             contentType: "application/json; charset=utf-8",
                             dataType: "json",
                             success: function () {                      // función que se va a ejecutar si el pedido resulta exitoso
                                 //$('#lblMensaje').text('La información ha sido guardada exitosamente.');
                                 //alert('La información ha sido guardada exitosamente.');
                                 $("#jQGridDemo").trigger("reloadGrid");
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
    });

    function validarFrm() {
        validator = $("#form1").validate({
            rules: {
                ctl00$MainContent$UsuarioTipo: "required",
                ctl00$MainContent$txtAgencia: "required",
                ctl00$MainContent$txtRut: {
                    required: true,
                    rut: true
                },
                ctl00$MainContent$txtNombre: "required",
                ctl00$MainContent$txtFono: "required",
                ctl00$MainContent$txtEmail: {
                                            required: true,
                                            email: true
                },
                ctl00$MainContent$txtClave: "required"
            },
            messages: {
                ctl00$MainContent$UsuarioTipo: "&bull; Seleccione Tipo de Usuario.",
                ctl00$MainContent$txtAgencia: "&bull; Seleccione Agencia.",
                ctl00$MainContent$txtRut: {
                    required: "&bull; Ingrese Rut de Usuario.",
                    rut: "&bull; Rut de Usuario Erroneo."
                },
                ctl00$MainContent$txtNombre: "&bull; Ingrese Nombre de Usuario.",
                ctl00$MainContent$txtFono: "&bull; Ingrese Telefono de Usuario.",
                ctl00$MainContent$txtEmail: {
                                            required: "&bull; Ingrese Email de Usuario.",
                                            email: "&bull; Email de Usuario erroneo."
                },
                ctl00$MainContent$txtClave: "&bull; Ingrese Contraseña de Usuario."
            }
        });
    }

    function eliminar(i) {
        //alert(i);
        var parametros = {
            id: i,
            proy: '<%=(string)(Session["IDProyecto"])%>'
        };

        $.ajax({
            url: 'Usuarios.aspx/Eliminar',
            type: 'POST',
            data: JSON.stringify(parametros),           // los parámetros en formato JSON
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {                      // función que se va a ejecutar si el pedido resulta exitoso
                //$('#lblMensaje').text('La información ha sido guardada exitosamente.');
                //alert('La información ha sido guardada exitosamente.');
                $("#jQGridDemo").trigger("reloadGrid");
            }
        });
    }

    function actualizar(i) {
        $.ajax({
            type: "GET",
            url: "datosUsuarios.ashx", 
            data: { id: i, proy: '<%=(string)(Session["IDProyecto"])%>' }, 
            dataType: "xml", 
            success: function (xml) { 
                $('row',xml).each(function(i) { 
                    $('#MainContent_txtRut').val($(this).find('RUT').text());
                    $('#MainContent_txtNombre').val($(this).find('NOMBRE').text());
                    $('#MainContent_txtFono').val($(this).find('FONO').text());
                    $('#MainContent_txtEmail').val($(this).find('EMAIL').text());
                    $('#MainContent_txtClave').val($(this).find('PASSWORD').text());
                    muestraAgencia($(this).find('ID_TIPO_USUARIO').text());
                    llena_tipoUsuarios($(this).find('ID_TIPO_USUARIO').text());
                    llena_agencias($(this).find('AGENCIA').text());
                    $('#modal_dialog').dialog('open');
                    validarFrm();
                });
            }
        });
    }

    function muestraAgencia(e) {
        if (e == "3") {
            $("#MainContent_trAgencia").show();
        } else {
            $("#MainContent_trAgencia").hide();
        }
    }

    function llena_agencias(id) {
        $("#MainContent_txtAgencia").html("");
        $.ajax({
            type: "GET",
            url: "listaAgencias.ashx",
            data: { id: id, proy: '<%=(string)(Session["IDProyecto"])%>' },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_txtAgencia").append("<option value=''>Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id == $(this).find('ID').text())
                        $("#MainContent_txtAgencia").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_txtAgencia").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_tipoUsuarios(id) {
        $("#MainContent_UsuarioTipo").html("");
        $.ajax({
            type: "GET",
            url: "listaTipoUsuarios.ashx",
            data: { id: id },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_UsuarioTipo").append("<option value=''>Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id == $(this).find('ID').text())
                        $("#MainContent_UsuarioTipo").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_UsuarioTipo").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    </script>
<div id="modal_dialog">
    <form id="form1" runat="server" class="cmxform" style="font-size: 11px;">
        <asp:Table ID="Table1" runat="server">
            <asp:TableRow>
                <asp:TableCell>Tipo Usuario : </asp:TableCell>
                <asp:TableCell><asp:DropDownList ID="UsuarioTipo" runat="server" onchange="muestraAgencia(this.value);"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell Width="120">Rut : </asp:TableCell>
                <asp:TableCell Width="600"><asp:TextBox runat="server" ID="txtRut" Width="30%" MaxLength="11"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Nombre : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtNombre" Width="100%" MaxLength="50"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
          <asp:TableRow ID="trAgencia">
                <asp:TableCell>Agencia : </asp:TableCell>
                <asp:TableCell><asp:DropDownList ID="txtAgencia" runat="server" Width="60%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Telefono : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtFono" Width="60%" MaxLength="30"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Email : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtEmail" Width="60%" MaxLength="50"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Contraseña : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtClave" Width="50%" MaxLength="20" type="password"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
        </asp:Table>
    </form> 
</div>
    <div id="grilla"> 
    <h1>
        <%: Page.Title %>
    </h1>
    <table id="jQGridDemo">
    </table>
    <div id="jQGridDemoPager">
    </div>
    </div>
</asp:Content>
