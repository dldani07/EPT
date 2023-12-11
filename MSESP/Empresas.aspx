<%@ Page Title="Empresas" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Empresas.aspx.cs" Inherits="MSESP.Empresas" %>
 
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">   

    <script type="text/javascript">
        var validator = "";
        $(document).ready(function () {
            $.validator.setDefaults({
                submitHandler: function () {
                    alert("submitted!");
                }
        });

        jQuery("#jQGridDemo").jqGrid({
            url: 'jqGridEmpresas.ashx',
            datatype: "xml",
            colNames: ['Rut', 'Razón Social', 'Adherente', '', ''],
            colModel: [
                        { name: 'RUT', index: 'RUT', width: 30, stype: 'text' },
   		                { name: 'NOMBRE', index: 'NOMBRE', width: 220, stype: 'text' },
   		                { name: 'N_ADHERENTE', index: 'N_ADHERENTE', width: 80, stype: 'text', align: 'center' },
                        { width: 13, stype: 'text'},
                        { width: 13, stype: 'text'}

            ],
            rowNum: 500,
            width: 960,
            height: 300,
            mtype: 'GET',
            loadonce: false,
            rowList: [500, 1000, 1500],
            pager: '#jQGridDemoPager',
            sortname: 'NOMBRE',
            viewrecords: true,
            sortorder: 'asc',
            caption: "Listado de Empresas",
            editurl: 'jqGridEmpresas.ashx'
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
                       deltext:"Delete"
        });

        jQuery("#jQGridDemo").jqGrid('navButtonAdd', "#jQGridDemoPager", {
            caption: "Agregar&nbsp;&nbsp;",
            title: "Agregar Nuevo Registro",
            buttonicon: 'ui-icon-plus',
            onClickButton: function () {
                $('#MainContent_txtRut').val("");
                $('#MainContent_txtRazon').val("");
                $('#MainContent_txtAdh').val("");
                validarFrm();
                $('#modal_dialog').dialog('open');
            }
        });
        
         $("#modal_dialog").dialog({
                title: "Registro de <%: Page.Title %>",
                height: 520,
                width: 1000,
                autoOpen: false,
                modal: true,
                buttons: {
                    Guardar: function () {
                        validarFrm();
                        if ($("#form1").valid()) {
                            var parametros = {
                                rut: $('#MainContent_txtRut').val(),
                                nombre: $('#MainContent_txtRazon').val(),
                                adh: $('#MainContent_txtAdh').val()
                            };
                            //data: $('form1').serialize(),
                            $.ajax({
                                url: 'Empresas.aspx/Guardar',
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
                    ctl00$MainContent$txtRut: {
                        required: true,
                        rut: true
                    },
                    ctl00$MainContent$txtAdh: "required",
                    ctl00$MainContent$txtRazon: "required"
                },
                messages: {
                    ctl00$MainContent$txtRut: {
                        required: "&bull; Ingrese Rut de Empresa.",
                        rut: "&bull; Rut de Empresa Erroneo."
                    },
                    ctl00$MainContent$txtAdh: "&bull; Ingrese Adherente de Empresa.",
                    ctl00$MainContent$txtRazon: "&bull; Ingrese Razón Social de Empresa."
                }
            });
        }

        function eliminar(i) {
            //alert(i);
            var parametros = {
                id: i
            };

            $.ajax({
                url: 'Empresas.aspx/Eliminar',
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
                url: "datosEmpresas.ashx", //Direccion del servicio web segido de /Nombre del metodo a llamar
                data: { id: i }, //Esto se utiliza si deseamos pasar algun paramentro al metodo del servicio web ejm: {'indentificacion':'1234'}
                dataType: "xml", //Esto quiere decir que los datos nos llegaran como un objeto json
                success: function (xml) { //Aca se recibe la respuesta del metodo llamado
                    $('row', xml).each(function (i) {
                        $('#MainContent_txtRut').val($(this).find('RUT').text());
                        $('#MainContent_txtRazon').val($(this).find('NOMBRE').text());
                        $('#MainContent_txtAdh').val($(this).find('ADH').text());
                        $('#modal_dialog').dialog('open');
                        validarFrm();
                    });
                }
            });
        }

    </script>
<div id="modal_dialog">
    <form id="form1" runat="server" class="cmxform">
        <asp:Table ID="Table1" runat="server">
            <asp:TableRow>
                <asp:TableCell Width="120">Rut : </asp:TableCell>
                <asp:TableCell Width="600"><asp:TextBox runat="server" ID="txtRut" Width="30%" MaxLength="11"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>N° Adherente : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtAdh" Width="30%" MaxLength="11"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Razón Social : </asp:TableCell><asp:TableCell>
                <asp:TextBox runat="server" ID="txtRazon" Width="50%" MaxLength="50"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
        </asp:Table>
    </form> 
</div>
    <div id="grilla"> 
    <h1>
        <%:Page.Title%>
    </h1>
    <table id="jQGridDemo">
    </table>
    <div id="jQGridDemoPager">
    </div>
    </div>
</asp:Content>



