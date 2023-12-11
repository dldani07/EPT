<%@ Page Title="Proveedores" Language="C#" MasterPageFile="~/SiteMES.Master" CodeBehind="Proveedores.aspx.cs" Inherits="MSESP.Proveedores" %>

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
                url: 'jqGridProveedor.ashx',
                datatype: "xml",
                colNames: ['Rut', 'Razón Social', 'Región', 'Comuna', '', ''],
                colModel: [
                            { name: 'RUT', index: 'RUT', width: 30, stype: 'text' },
                            { name: 'NOMBRE', index: 'NOMBRE', width: 150, stype: 'text' },
                            { name: 'REG', index: 'REG', width: 100, stype: 'text' },
                            { name: 'COM', index: 'COM', width: 100, stype: 'text' },
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
                caption: "Listado de <%:Page.Title%>"
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
                    $('#MainContent_txtRazon').val("");
                    llena_regionesEmp(0);
                    llena_comunasEmp(0, 0);
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
                             region: $('#MainContent_solRegEmp').val(),
                             comuna: $('#MainContent_solComEmp').val()
                         };
                         //data: $('form1').serialize(),
                         $.ajax({
                             url: 'Proveedores.aspx/Guardar',
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
                ctl00$MainContent$txtRazon: "required",
                ctl00$MainContent$solRegEmp: "required",
                ctl00$MainContent$solComEmp: "required"
            },
            messages: {
                ctl00$MainContent$txtRut: {
                    required: "&bull; Ingrese Rut de Empresa.",
                    rut: "&bull; Rut de Empresa Erroneo."
                },
                ctl00$MainContent$txtRazon: "&bull; Ingrese Razón Social de Empresa.",
                ctl00$MainContent$solRegEmp: "&bull; Seleccine Región.",
                ctl00$MainContent$solComEmp: "&bull; Seleccione Comuna."
            }
        });
    }

    function eliminar(i) {
        //alert(i);
        var parametros = {
            id: i
        };

        $.ajax({
            url: 'Proveedores.aspx/Eliminar',
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
            url: "datosProveedores.ashx", //Direccion del servicio web segido de /Nombre del metodo a llamar
            data: { id: i }, //Esto se utiliza si deseamos pasar algun paramentro al metodo del servicio web ejm: {'indentificacion':'1234'}
            dataType: "xml", //Esto quiere decir que los datos nos llegaran como un objeto json
            success: function (xml) { //Aca se recibe la respuesta del metodo llamado
                $('row', xml).each(function (i) {
                    $('#MainContent_txtRut').val($(this).find('RUT').text());
                    $('#MainContent_txtRazon').val($(this).find('NOMBRE').text());
                    llena_regionesEmp($(this).find('REGION').text());
                    llena_comunasEmp($(this).find('REGION').text(), $(this).find('COMUNA').text());
                    $('#modal_dialog').dialog('open');
                    validarFrm();
                });
            }
        });
    }

    function llena_regionesEmp(id_region) {
        $("#MainContent_solRegEmp").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx",
            data: { id: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_solRegEmp").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_region == $(this).find('ID').text())
                        $("#MainContent_solRegEmp").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_solRegEmp").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_comunasEmp(id_region, id_comuna) {
        $("#MainContent_solComEmp").html("");
        $.ajax({
            type: "GET",
            url: "listarComunas.ashx",
            data: { r: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_solComEmp").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_comuna == $(this).find('ID').text())
                        $("#MainContent_solComEmp").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_solComEmp").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
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
                <asp:TableCell>Razón Social : </asp:TableCell><asp:TableCell>
                <asp:TextBox runat="server" ID="txtRazon" Width="50%" MaxLength="50"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Región : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solRegEmp" Width="60%" onchange="llena_comunasEmp(this.value,0);"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>                
                <asp:TableCell>Comuna : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solComEmp" Width="60%"></asp:DropDownList></asp:TableCell>
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



