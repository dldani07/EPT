<%@ Page Title="Profesionales" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Profesionales.aspx.cs" Inherits="MSESP.Profesionales" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">   
    <link href="Content/style.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/js/comboTreePlugin.js" type="text/javascript"></script>
    <script src="Scripts/js/icontains.js" type="text/javascript"></script>
    <script type="text/javascript">
        var validator = "";
        var vCheckDE = "";
        var vCheckME = "";
        var vCheckSM = "";
        var vCheckPC = "";
        var vCheckDF = "";

        var vCheckManLun = "";
        var vCheckManMar = "";
        var vCheckManMie = "";
        var vCheckManJue = "";
        var vCheckManVie = "";
        var vCheckManSab = "";
        var vCheckManDom = "";

        var vCheckTarLun = "";
        var vCheckTarMar = "";
        var vCheckTarMie = "";
        var vCheckTarJue = "";
        var vCheckTarVie = "";
        var vCheckTarSab = "";
        var vCheckTarDom = "";

        var originalContent = "";
        var eliminaProf = "";
        var cargadaGrilla = false;

        var selectedIds = "";
        var comboTree1 = "";

        $(document).ready(function () {
            $.validator.setDefaults({
                submitHandler: function () {
                    alert("submitted!");
                }
            });

            llena_agencias(0);
            llenar_estados('');
            llena_organizaciones('');
            tabla();
            
            $("#dialog_delIns").dialog({
                bgiframe: true,
                autoOpen: false,
                height: 210,
                width: 400,
                modal: true,
                buttons: {
                    'Aceptar': function () {
                        var parametros = {
                            id: eliminaProf,
                            usr: '<%=(string)(Session["IdUsuario"])%>',
                            proy: '<%=(string)(Session["IDProyecto"])%>'
                        };

                        $.ajax({
                            url: 'Profesionales.aspx/Eliminar',
                            type: 'POST',
                            data: JSON.stringify(parametros),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function () {
                                $("#jQGridDemo").trigger("reloadGrid");
                            }
                        });

                        $(this).dialog('close');
                    },
                    Cancelar: function () {
                        $(this).dialog('close');
                    }
                }
            });

            $("#modal_dialog").dialog({
                title: "Registro de <%: Page.Title %>",
                height: 560,
                width: 1000,
                autoOpen: false,
                modal: true,
                buttons: {
                    Guardar: function () {
                        validarFrm();
                        if ($("#form1").valid()) {
                            vCheckDE = "";
                            vCheckME = "";
                            vCheckSM = "";
                            vCheckPC = "";
                            vCheckDF = "";
                            vCheckManLun = "";
                            vCheckManMar = "";
                            vCheckManMie = "";
                            vCheckManJue = "";
                            vCheckManVie = "";
                            vCheckManSab = "";
                            vCheckManDom = "";
                            vCheckTarLun = "";
                            vCheckTarMar = "";
                            vCheckTarMie = "";
                            vCheckTarJue = "";
                            vCheckTarVie = "";
                            vCheckTarSab = "";
                            vCheckTarDom = "";

                            if ($("#MainContent_CheckDE").is(':checked'))
                            {
                                vCheckDE = '1';
                            }

                            if ($("#MainContent_CheckME").is(':checked')) {
                                vCheckME = '1';
                            }

                            if ($("#MainContent_CheckSM").is(':checked')) {
                                vCheckSM = '1';
                            }

                            if ($("#MainContent_CheckPC").is(':checked')) {
                                vCheckPC = '1';
                            }

                            if ($("#MainContent_CheckDF").is(':checked')) {
                                vCheckDF = '1';
                            }

                            if ($('#MainContent_cbTarLun').is(':checked')) {
                                vCheckTarLun = '1';
                            }

                            if ($('#MainContent_cbTarMar').is(':checked')) {
                                vCheckTarMar = '1';
                            }

                            if ($('#MainContent_cbTarMie').is(':checked')) {
                                vCheckTarMie = '1';
                            }

                            if ($('#MainContent_cbTarJue').is(':checked')) {
                                vCheckTarJue = '1';
                            }

                            if ($('#MainContent_cbTarVie').is(':checked')) {
                                vCheckTarVie = '1';
                            }

                            if ($('#MainContent_cbTarSab').is(':checked')) {
                                vCheckTarSab = '1';
                            }

                            if ($('#MainContent_cbTarDom').is(':checked')) {
                                vCheckTarDom = '1';
                            }

                            if ($('#MainContent_cbManLun').is(':checked')) {
                                vCheckManLun = '1';
                            }

                            if ($('#MainContent_cbManMar').is(':checked')) {
                                vCheckManMar = '1';
                            }

                            if ($('#MainContent_cbManMie').is(':checked')) {
                                vCheckManMie = '1';
                            }

                            if ($('#MainContent_cbManJue').is(':checked')) {
                                vCheckManJue = '1';
                            }

                            if ($('#MainContent_cbManVie').is(':checked')) {
                                vCheckManVie = '1';
                            }

                            if ($('#MainContent_cbManSab').is(':checked')) {
                                vCheckManSab = '1';
                            }

                            if ($('#MainContent_cbManDom').is(':checked')) {
                                vCheckManDom = '1';
                            }

                            var parametros = {
                                rut: $('#MainContent_txtRut').val(),
                                nombre: $('#MainContent_txtRazon').val(),
                                proveedor: comboTree1.getSelectedItemsId(),
                                clave: $('#MainContent_txtClave').val(),
                                CheckDE: vCheckDE,
                                CheckME: vCheckME,
                                CheckSM: vCheckSM,
                                CheckPC: vCheckPC,
                                CheckManLun: vCheckManLun,
                                CheckManMar: vCheckManMar,
                                CheckManMie: vCheckManMie,
                                CheckManJue: vCheckManJue,
                                CheckManVie: vCheckManVie,
                                CheckManSab: vCheckManSab,
                                CheckManDom: vCheckManDom,
                                CheckTarLun: vCheckTarLun,
                                CheckTarMar: vCheckTarMar,
                                CheckTarMie: vCheckTarMie,
                                CheckTarJue: vCheckTarJue,
                                CheckTarVie: vCheckTarVie,
                                CheckTarSab: vCheckTarSab,
                                CheckTarDom: vCheckTarDom,
                                vrbTar: $('#MainContent_rbTar').val(),
                                vcmbTarFin: $('#MainContent_cmbTarFin').val(),
                                vcmbTarIni: $('#MainContent_cmbTarIni').val(),
                                vrbMan: $('#MainContent_rbMan').val(),
                                vcmbManFin: $('#MainContent_cmbManFin').val(),
                                vcmbManIni: $('#MainContent_cmbManIni').val(),
                                vsolAgencia: $('#MainContent_solAgencia').val(),
                                vsolZonal: $('#MainContent_solZonal').val(),
                                vtxtProf: $('#MainContent_txtProf').val(),
                                vtxtEmail: $('#MainContent_txtEmail').val(),
                                vxtFono: $('#MainContent_txtFono').val(),
                                vsolAte: $('#MainContent_solAte').val(),
                                vsolDispComent: $('#MainContent_solDispComent').val(),
                                vtxtDir: $('#MainContent_txtDir').val(),
                                vsolVeh: $('#MainContent_solVeh').val(),
                                CheckDF: vCheckDF,
                                proy: '<%=(string)(Session["IDProyecto"])%>',
                                estado: $('#MainContent_solEstado').val(),
                                organizacion: $('#MainContent_solOrganizacion').val()
                            };
                            //data: $('form1').serialize(),
                            $.ajax({
                                url: 'Profesionales.aspx/Guardar',
                                type: 'POST',
                                data: JSON.stringify(parametros), 
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {
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
                },
                open: function (event, ui) {
                    originalContent = $("#modal_dialog").html();
                },
                close: function (event, ui) {
                //$("#modal_dialog").html(originalContent);
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
                    ctl00$MainContent$solZonal: "required",
                    ctl00$MainContent$solAgencia: "required",
                    ctl00$MainContent$txtClave: "required",
                    ctl00$MainContent$txtFono: "required",
                    ctl00$MainContent$txtProf: "required",
                    ctl00$MainContent$solEstado: "required",
                    ctl00$MainContent$solOrganizacion: "required",
                    ctl00$MainContent$txtEmail: {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    ctl00$MainContent$txtRut: {
                        required: "&bull; Ingrese Rut.",
                        rut: "&bull; Rut de Profesional Erroneo."
                    },
                    ctl00$MainContent$txtRazon: "&bull; Ingrese Nombre de Profesional.",
                    ctl00$MainContent$solRegEmp: "&bull; Seleccione Proveedor.",
                    ctl00$MainContent$solZonal: "&bull; Seleccione Zonal.",
                    ctl00$MainContent$solAgencia: "&bull; Seleccione Agencia.",
                    ctl00$MainContent$txtClave: "&bull; Ingrese Clave.",
                    ctl00$MainContent$txtFono: "&bull; Ingrese Teléfono de Profesional.",
                    ctl00$MainContent$txtProf: "&bull; Ingrese Profesion.",
                    ctl00$MainContent$solEstado: "&bull; Seleccione Estado.",
                    ctl00$MainContent$solOrganizacion: "&bull; Seleccione Organizacion.",
                    ctl00$MainContent$txtEmail: {
                        required: "&bull; Ingrese Email.",
                        email: "&bull; Email Erroneo."
                    }
                }
            });
        }

        function eliminar(i) {
            eliminaProf = i;
            $('#dialog_delIns').dialog('open');

            /*var parametros = {
                id: i
            };

            $.ajax({
                url: 'Profesionales.aspx/Eliminar',
                type: 'POST',
                data: JSON.stringify(parametros),  
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {
                    $("#jQGridDemo").trigger("reloadGrid");
                }
            });*/
        }

        function actcheck(pre) {
            $('#MainContent_cb' + pre + 'Lun').attr('checked', false);
            $('#MainContent_cb' + pre + 'Mar').attr('checked', false);
            $('#MainContent_cb' + pre + 'Mie').attr('checked', false);
            $('#MainContent_cb' + pre + 'Jue').attr('checked', false);
            $('#MainContent_cb' + pre + 'Vie').attr('checked', false);
            $('#MainContent_cb' + pre + 'Sab').attr('checked', false);
            $('#MainContent_cb' + pre + 'Dom').attr('checked', false);
        }

        function actJornada(pre, estado) {
            //$('#MainContent_rb' + pre + '_' + estado).attr('checked', 'checked');
            if (estado == 0) {
                $('#MainContent_cb' + pre + 'Lun').attr('disabled', 'disabled');
                $('#MainContent_cb' + pre + 'Mar').attr('disabled', 'disabled');
                $('#MainContent_cb' + pre + 'Mie').attr('disabled', 'disabled');
                $('#MainContent_cb' + pre + 'Jue').attr('disabled', 'disabled');
                $('#MainContent_cb' + pre + 'Vie').attr('disabled', 'disabled');
                $('#MainContent_cb' + pre + 'Sab').attr('disabled', 'disabled');
                $('#MainContent_cb' + pre + 'Dom').attr('disabled', 'disabled');

                $('#MainContent_cmb' + pre + 'Ini').attr('disabled', 'disabled');
                $('#MainContent_cmb' + pre + 'Fin').attr('disabled', 'disabled');
            }
            else {
                $('#MainContent_cb' + pre + 'Lun').removeAttr('disabled');
                $('#MainContent_cb' + pre + 'Mar').removeAttr('disabled');
                $('#MainContent_cb' + pre + 'Mie').removeAttr('disabled');
                $('#MainContent_cb' + pre + 'Jue').removeAttr('disabled');
                $('#MainContent_cb' + pre + 'Vie').removeAttr('disabled');
                $('#MainContent_cb' + pre + 'Sab').removeAttr('disabled');
                $('#MainContent_cb' + pre + 'Dom').removeAttr('disabled');

                $('#MainContent_cmb' + pre + 'Ini').removeAttr('disabled');
                $('#MainContent_cmb' + pre + 'Fin').removeAttr('disabled');
            }
        }

        function actualizar(i) {
            $("#MainContent_CheckME").attr('checked', false);
            $("#MainContent_CheckSM").attr('checked', false);
            $("#MainContent_CheckPC").attr('checked', false);
            $("#MainContent_CheckDE").attr('checked', false);
            $("#MainContent_CheckDF").attr('checked', false);
            $('#MainContent_rbMan_0').attr('checked', false);
            $('#MainContent_rbMan_1').attr('checked', false);

            $('#MainContent_rbTar_0').attr('checked', false);
            $('#MainContent_rbTar_1').attr('checked', false);

            actcheck('Man');
            actcheck('Tar');
            actJornada('Man', 0);
            actJornada('Tar', 0);

            originalContent = $("#modal_dialog").html();
            $("#modal_dialog").html(originalContent);

            $.ajax({
                type: "GET",
                url: "datosProfesionales.ashx", 
                data: { id: i }, 
                dataType: "xml", 
                success: function (xml) { 
                    $('row', xml).each(function (i) {
                        $('#MainContent_txtRut').val($(this).find('RUT').text());
                        $('#MainContent_txtRazon').val($(this).find('NOMBRE').text());
                        llena_regionesEmp($(this).find('REGION').text());
                        $('#MainContent_txtClave').val($(this).find('CLAVE').text());
                        //$("#MainContent_solZonal option[value=" + $(this).find('ZONAL').text() + "]").attr('selected', 'selected');
                        llenaZonal($(this).find('ZONAL').text());
                        $("#MainContent_solAgencia option[value=" + $(this).find('AGENCIA').text() + "]").attr('selected', 'selected');
                        $('#MainContent_txtProf').val($(this).find('PROFESION').text());
                        $('#MainContent_txtEmail').val($(this).find('EMAIL').text());
                        $('#MainContent_txtFono').val($(this).find('FONO').text());
                        $('#MainContent_solAte').val($(this).find('ATENCION').text());
                        $('#MainContent_solDispComent').val($(this).find('CONSIDERACIONES').text());
                        $('#MainContent_txtDir').val($(this).find('DIRECCION').text());

                        if ($(this).find('jornManana').text()!="") {
                            actJornada('Man', 1);
                            $('#MainContent_rbMan_1').attr('checked', true);
                        }
                        else {
                            $('#MainContent_rbMan_0').attr('checked', true);
                        }
                        
                        if ($(this).find('jornTarde').text() != "") {
                            actJornada('Tar', 1);
                            $('#MainContent_rbTar_1').attr('checked', true);
                        } else {
                            $('#MainContent_rbTar_0').attr('checked', true);
                        }

                        var arregloDeCadenas = $(this).find('REALIZA').text().split("/");

                        for (var i = 0; i < arregloDeCadenas.length; i++) {
                            if (arregloDeCadenas[i] == "5") {
                                $("#MainContent_CheckME").attr('checked', true);
                            } 

                            if (arregloDeCadenas[i] == "12") {
                                $("#MainContent_CheckSM").attr('checked', true);
                            } 

                            if (arregloDeCadenas[i] == "4") {
                                $("#MainContent_CheckPC").attr('checked', true);
                            } 

                            if (arregloDeCadenas[i] == "13") {
                                $("#MainContent_CheckDE").attr('checked', true);
                            }

                            if (arregloDeCadenas[i] == "19") {
                                $("#MainContent_CheckDF").attr('checked', true);
                            }
                        }

                        var arregloJM = $(this).find('jornManana').text().split(",");

                        for (var i = 0; i < arregloJM.length; i++) {
                            if (arregloJM[i] == "Lunes") {
                                $('#MainContent_cbManLun').attr('checked', true);
                            }

                            if (arregloJM[i] == "Martes") {
                                $('#MainContent_cbManMar').attr('checked', true);
                            }

                            if (arregloJM[i] == "Miércoles") {
                                $('#MainContent_cbManMie').attr('checked', true);
                            }

                            if (arregloJM[i] == "Jueves") {
                                $('#MainContent_cbManJue').attr('checked', true);
                            }

                            if (arregloJM[i] == "Viernes") {
                                $('#MainContent_cbManVie').attr('checked', true);
                            }

                            if (arregloJM[i] == "Sábado") {
                                $('#MainContent_cbManSab').attr('checked', true);
                            }

                            if (arregloJM[i] == "Domingo") {
                                $('#MainContent_cbManDom').attr('checked', true);
                            }

                        }

                        var arregloJT = $(this).find('jornTarde').text().split(",");

                        for (var i = 0; i < arregloJT.length; i++) {
                            if (arregloJT[i] == "Lunes") {
                                $('#MainContent_cbTarLun').attr('checked', true);
                            }

                            if (arregloJT[i] == "Martes") {
                                $('#MainContent_cbTarMar').attr('checked', true);
                            }

                            if (arregloJT[i] == "Miércoles") {
                                $('#MainContent_cbTarMie').attr('checked', true);
                            }

                            if (arregloJT[i] == "Jueves") {
                                $('#MainContent_cbTarJue').attr('checked', true);
                            }

                            if (arregloJT[i] == "Viernes") {
                                $('#MainContent_cbTarVie').attr('checked', true);
                            }

                            if (arregloJT[i] == "Sábado") {
                                $('#MainContent_cbTarSab').attr('checked', true);
                            }

                            if (arregloJT[i] == "Domingo") {
                                $('#MainContent_cbTarDom').attr('checked', true);
                            }

                        }

                        actHora('cmbManIni', 0, $(this).find('manHoraIni').text());
                        actHora('cmbManFin', 0, $(this).find('manHoraFin').text());

                        actHora('cmbTarIni', 1, $(this).find('tarHoraIni').text());
                        actHora('cmbTarFin', 1, $(this).find('tarHoraFin').text());

                        llena_agencias2($(this).find('AGENCIA').text());
                        llena_Vehiculos($(this).find('VEHICULO').text());
                        llena_organizaciones($(this).find('ID_ORGANIZACION').text());
                        llenar_estados($(this).find('ESTADO2').text());
                        $('#modal_dialog').dialog('open');
                        validarFrm();
                    });
                }
            });
        }

        /*function llena_regionesEmp(id_region) {
            $("#MainContent_solRegEmp").html("");
            $.ajax({
                type: "GET",
                url: "listaProveedores.ashx",
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
        }*/

        function llena_regionesEmp(id_region) {
            var txt = "";
            var txt2 = "";

            $.ajax({
                type: "GET",
                url: "listaProveedores.ashx",
                data: { id: id_region },
                dataType: "xml",
                success: function (xml) {

                    SampleJSONData = '[';
                    $('row', xml).each(function (i) {
                        txt = txt + $(this).find('ID').text() + "##" + $(this).find('NOMBRE').text() + "###";
                        SampleJSONData = SampleJSONData + '{' +
                            '"id": ' + $(this).find('ID').text() + ',' +
                            '"title": "' + $(this).find('NOMBRE').text() + '"},';
                    });

                    SampleJSONData = SampleJSONData + ']';
                    SampleJSONData = SampleJSONData.replace("},]", "}]");

                    comboTree1 = $("#MainContent_solRegEmp").comboTree({
                        source: JSON.parse(SampleJSONData),
                        isMultiple: true
                    });
                    var regiones = id_region.split("##");
                    txt = txt.split("###");
                    console.log(regiones);
                    console.log(txt);

                    for (var contTxt = 0; contTxt < txt.length; contTxt++) {
                        txt2 = txt[contTxt].split("##");
                        console.log(txt2);
                        for (var i = 0; i < regiones.length; i++) {
                            if (regiones[i] == txt2[0]) {
                                $("#chk-" + txt2[0]).attr('checked', true);
                                comboTree1.multiItemClick('<span data-id="' + txt2[0] +
                                    '" class="comboTreeItemTitle comboTreeItemHover"><input type="checkbox" id="chk-' + txt2[0] +
                                    '">' + txt2[1] + '</span>');
                            }
                        }
                    }

                }
            });

        }

        function llena_agencias(id) {
            $("#MainContent_solAgencia").html("");
            $.ajax({
                type: "GET",
                url: "listaAgencias.ashx",
                data: { id: id, proy: '<%=(string)(Session["IDProyecto"])%>' },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_solAgencia").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#MainContent_solAgencia").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#MainContent_solAgencia").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_Vehiculos(id) {
            $("#MainContent_solVeh").html("");
            $.ajax({
                type: "GET",
                url: "listaVehiculos.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_solVeh").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#MainContent_solVeh").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#MainContent_solVeh").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function actHora(pre, jornada, hora) {
            $("#MainContent_" + pre).html("");
            //$("#MainContent_" + pre).append("<option value=\"0\">Seleccione</option>");
            $.ajax({
                type: "GET",
                url: "listaHorasProf.ashx",
                data: { jornada: jornada },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_" + pre).append("<option value=\"0\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (hora == $(this).find('ID').text())
                            $("#MainContent_" + pre).append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('HORA').text() + '</option>');
                        else
                            $("#MainContent_" + pre).append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('HORA').text() + '</option>');
                    });
                }
            });
        }

        function llenaZonal(id) {
            $("#MainContent_solZonal").html("");
            //$("#MainContent_" + pre).append("<option value=\"0\">Seleccione</option>");
            $.ajax({
                type: "GET",
                url: "listaZonal.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_solZonal").append("<option value=\"0\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#MainContent_solZonal").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#MainContent_solZonal").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_agencias(id) {
            $("#busAgencia").html("");
            $.ajax({
                type: "GET",
                url: "listaAgencias.ashx",
                data: { id: id, proy: '1' },
                dataType: "xml",
                success: function (xml) {
                    $("#busAgencia").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#busAgencia").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#busAgencia").append('<option value="' + $(this).find('ID').text() + '" >' +
                                $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llenar_estados(id) {
            $("#MainContent_solEstado").html("");
            $("#MainContent_solEstado").append("<option value=\"\">Seleccione</option>");

            if (id == 'A') {
                $("#MainContent_solEstado").append("<option value=\"A\" selected>Activo</option>");
            }
            else {
                $("#MainContent_solEstado").append("<option value=\"A\">Activo</option>");
            }
            if (id == 'I') {
                $("#MainContent_solEstado").append("<option value=\"I\" selected>Inactivo</option>");
            }
            else {
                $("#MainContent_solEstado").append("<option value=\"I\">Inactivo</option>");
            }
        }

        function llena_organizaciones(id) {
            $("#MainContent_solOrganizacion").html("");
            $.ajax({
                type: "GET",
                url: "listaOrganizaciones.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_solOrganizacion").append("<option value=''>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#MainContent_solOrganizacion").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#MainContent_solOrganizacion").append('<option value="' + $(this).find('ID').text() + '" >' +
                                $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function tabla() {
            sUrl = 'jqGridProfesionales.ashx?a=0&pro=&p=<%=(string)(Session["IDProyecto"])%>';
            //  console.log('ok');

            if (!cargadaGrilla) {
                jQuery("#jQGridDemo").jqGrid({
                    url: sUrl,
                    datatype: "xml",
                    colNames: ['Rut', 'Nombre', 'Proveedor', 'Profesión', 'Agencia', 'Organización', 'Teléfono', 'E-Mail', 'Estado', '', ''],
                    colModel: [
                        { name: 'RUT', index: 'RUT', width: 30, stype: 'text' },
                        { name: 'NOMBRE', index: 'NOMBRE', width: 150, stype: 'text' },
                        { name: 'prov', index: 'prov', width: 100, stype: 'text' },
                        { name: 'PROFESION', index: 'PROFESION', width: 80, stype: 'text' },
                        { name: 'AGENCIA', index: 'AGENCIA', width: 80, stype: 'text' },
                        { name: 'ORGANIZACION', index: 'ORGANIZACION', width: 80, stype: 'text' },
                        { name: 'TELEFONO', index: 'TELEFONO', width: 100, stype: 'text' },
                        { name: 'EMAIL', index: 'EMAIL', width: 120, stype: 'text' },
                        { name: 'ESTADO', index: 'ESTADO', width: 80, stype: 'text' },
                        { width: 16, stype: 'text' },
                        { width: 16, stype: 'text' }

                    ],
                    rowNum: 50,
                    rownumbers: true,
                    autowidth: true,
                    height: 250,
                    mtype: 'GET',
                    loadonce: false,
                    rowList: [50, 100, 200],
                    pager: '#jQGridDemoPager',
                    sortname: 'NOMBRE',
                    viewrecords: true,
                    sortorder: 'asc',
                    caption: "Listado de Profesionales"
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
                        originalContent = $("#modal_dialog").html();
                        $("#modal_dialog").html(originalContent);

                        $('#MainContent_txtRut').val("");
                        $('#MainContent_txtRazon').val("");
                        $('#MainContent_txtClave').val("");
                        $('#MainContent_txtEmail').val("");
                        $('#MainContent_txtFono').val("");
                        $('#MainContent_txtProf').val("");
                        $('#MainContent_solDispComent').val("");
                        $('#MainContent_solAte').val("");
                        $("#MainContent_CheckDE").attr('checked', false);
                        $("#MainContent_CheckME").attr('checked', false);
                        $("#MainContent_CheckSM").attr('checked', false);
                        $("#MainContent_CheckPC").attr('checked', false);
                        $("#MainContent_CheckDF").attr('checked', false);

                        $('#MainContent_rbMan_0').attr('checked', true);
                        $('#MainContent_rbMan_1').attr('checked', false);

                        $('#MainContent_rbTar_0').attr('checked', true);
                        $('#MainContent_rbTar_1').attr('checked', false);

                        actHora('cmbManIni', 0, 0);
                        actHora('cmbManFin', 0, 0);

                        actHora('cmbTarIni', 1, 0);
                        actHora('cmbTarFin', 1, 0);

                        llenaZonal(0);
                        llena_regionesEmp(0);
                        actcheck('Man');
                        actcheck('Tar');
                        actJornada('Man', 0);
                        actJornada('Tar', 0);
                        llena_agencias2(0);
                        llena_Vehiculos(0);
                        llena_organizaciones('');
                        llenar_estados('');
                        validarFrm();
                        $('#modal_dialog').dialog('open');
                    }
                });

                jQuery("#jQGridDemo").jqGrid('navButtonAdd', "#jQGridDemoPager", {
                    caption: "Exportar a Excel&nbsp;&nbsp;",
                    title: "Exportar a Excel",
                    buttonicon: 'ui-icon-script',
                    onClickButton: function () {
                        sUrl = 'ReportesXLS.aspx?t=4&fi=&ft=&p=<%=(string)(Session["IDProyecto"])%>';
                    window.open(sUrl, 'Reportabilidad');
                }
            });
                cargadaGrilla = true;
            }
            else {
                jQuery("#jQGridDemo").jqGrid('setGridParam', {
                    url: 'jqGridProfesionales.ashx?a=' + $('#busAgencia').val() +
                        '&pro=' + $('#busProfesion').val() + '&p=<%=(string)(Session["IDProyecto"])%>'
                }).trigger("reloadGrid");

            }
        }

        function llena_agencias2(id) {
            $("#MainContent_solAgencia").html("");
            //console.log('ok' + id);
            $.ajax({
                type: "GET",
                url: "listaAgencias.ashx",
                data: { id: id, proy: '1' },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_solAgencia").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#MainContent_solAgencia").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#MainContent_solAgencia").append('<option value="' + $(this).find('ID').text() + '" >' +
                                $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }
    </script>
<div id="modal_dialog">
    <form id="form1" runat="server" class="cmxform" style="font-size: 11px;">
        <asp:Table ID="Table1" runat="server" style="padding: 0px; border-spacing: 0px;" Width="960px">
            <asp:TableRow>
                <asp:TableCell Width="100">Rut : </asp:TableCell>
                <asp:TableCell Width="300"><asp:TextBox runat="server" ID="txtRut" Width="50%" MaxLength="11"></asp:TextBox></asp:TableCell>
                <asp:TableCell Width="120">Nombre : </asp:TableCell>
                <asp:TableCell Width="280"><asp:TextBox runat="server" ID="txtRazon" Width="100%" MaxLength="50"></asp:TextBox></asp:TableCell>
                <asp:TableCell Width="100">Profesión : </asp:TableCell>
                <asp:TableCell Width="280"><asp:TextBox runat="server" ID="txtProf" Width="100%" MaxLength="50"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Email : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtEmail" Width="100%" MaxLength="80"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Teléfono : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtFono" Width="100%" MaxLength="80"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Contraseña : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtClave" Width="50%" MaxLength="20" type="password"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Proveedor : </asp:TableCell>
                <asp:TableCell><input type="text" runat="server" name="solRegEmp" id="solRegEmp" placeholder="Seleccione" /></asp:TableCell>
                <asp:TableCell>Zonal : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solZonal" Width="100%" onchange="llena_comunasEmp(this.value,0);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Agencia : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solAgencia" Width="100%" onchange="llena_comunasEmp(this.value,0);"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Dirección Consulta : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="txtDir" Width="100%" MaxLength="80"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Tipo Vehiculo : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solVeh" Width="100%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Organización : </asp:TableCell>
                    <asp:TableCell>
                        <asp:DropDownList runat="server" ID="solOrganizacion" Width="100%" AutoPostBack="false"></asp:DropDownList>
                    </asp:TableCell>
                </asp:TableRow>
                <asp:TableRow>
                    <asp:TableCell>Estado : </asp:TableCell>
                     <asp:TableCell>
                        <asp:DropDownList runat="server" ID="solEstado" Width="100%" AutoPostBack="false"></asp:DropDownList>
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
            <asp:Table ID="Table3" runat="server" style="padding: 0px; border-spacing: 0px;" Width="860px">
            <asp:TableRow>
                                            <asp:TableCell Width="130">EPT que Realiza : </asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="CheckDE" runat="server" />EPT Dermatología</asp:TableCell>  
                                            <asp:TableCell><asp:CheckBox ID="CheckDF" runat="server" />EPT Disfonía</asp:TableCell>                                         
                                            <asp:TableCell><asp:CheckBox ID="CheckME" runat="server" />EPT ME</asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="CheckSM" runat="server" />EPT SM</asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="CheckPC" runat="server" />Psicología Clínica</asp:TableCell>
            </asp:TableRow>
            </asp:Table>
            <asp:Table ID="Table2" runat="server" style="padding: 0px; border-spacing: 0px;">
             <asp:TableRow>
                 
                                            <asp:TableCell>Jornada</asp:TableCell>
                                            <asp:TableCell>Habilitar</asp:TableCell>
                                            <asp:TableCell>Lun</asp:TableCell>
                                            <asp:TableCell>Mar</asp:TableCell>
                                            <asp:TableCell>Mie</asp:TableCell>
                                            <asp:TableCell>Jue</asp:TableCell>
                                            <asp:TableCell>Vie</asp:TableCell>
                                            <asp:TableCell>Sab</asp:TableCell>
                                            <asp:TableCell>Dom</asp:TableCell>    
                                            <asp:TableCell>Hora Inicio</asp:TableCell> 
                                            <asp:TableCell>Hora Fin</asp:TableCell> 
                                                   
              </asp:TableRow>
              <asp:TableRow>
                                            <asp:TableCell>Mañana : </asp:TableCell>
                                            <asp:TableCell>
                                                <asp:RadioButtonList ID="rbMan" runat="server"><asp:ListItem Value="0" ID="rbMan_0" Text="No" onclick="actJornada('Man',this.value);actcheck('Man');"></asp:ListItem><asp:ListItem Value="1" ID="rbMan_1" Text="Si" onclick="actJornada('Man',this.value);"></asp:ListItem></asp:RadioButtonList>
                                            </asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbManLun" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbManMar" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbManMie" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbManJue" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbManVie" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbManSab" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbManDom" runat="server" /></asp:TableCell>                                            
                                            <asp:TableCell>
                                                <asp:DropDownList ID="cmbManIni" runat="server">
                                                    <asp:ListItem Text="Seleccione" Value="0" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Text="06:00" Value="06:00"></asp:ListItem>
                                                    <asp:ListItem Text="07:00" Value="07:00"></asp:ListItem>
                                                    <asp:ListItem Text="08:00" Value="08:00"></asp:ListItem>
                                                    <asp:ListItem Text="09:00" Value="09:00"></asp:ListItem>
                                                    <asp:ListItem Text="10:00" Value="10:00"></asp:ListItem>
                                                    <asp:ListItem Text="11:00" Value="11:00"></asp:ListItem>
                                                    <asp:ListItem Text="12:00" Value="12:00"></asp:ListItem>
                                                    <asp:ListItem Text="13:00" Value="13:00"></asp:ListItem>                                         
                                                </asp:DropDownList>
                                            </asp:TableCell>
                                            <asp:TableCell>
                                                <asp:DropDownList ID="cmbManFin" runat="server">
                                                    <asp:ListItem Text="Seleccione" Value="0" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Text="06:00" Value="06:00"></asp:ListItem>
                                                    <asp:ListItem Text="07:00" Value="07:00"></asp:ListItem>
                                                    <asp:ListItem Text="08:00" Value="08:00"></asp:ListItem>
                                                    <asp:ListItem Text="09:00" Value="09:00"></asp:ListItem>
                                                    <asp:ListItem Text="10:00" Value="10:00"></asp:ListItem>
                                                    <asp:ListItem Text="11:00" Value="11:00"></asp:ListItem>
                                                    <asp:ListItem Text="12:00" Value="12:00"></asp:ListItem>
                                                    <asp:ListItem Text="13:00" Value="13:00"></asp:ListItem>                                          
                                                </asp:DropDownList>
                                            </asp:TableCell>                                            
                                        </asp:TableRow>
                                        <asp:TableRow>
                                            <asp:TableCell>Tarde : </asp:TableCell>
                                            <asp:TableCell>
                                                <asp:RadioButtonList ID="rbTar" runat="server"><asp:ListItem Value="0" ID="rbTar_0" Text="No" onclick="actJornada('Tar',this.value);actcheck('Tar');"></asp:ListItem>
                                                    <asp:ListItem Value="1" ID="rbTar_1" Text="Si" OnClick="actJornada('Tar',this.value);"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbTarLun" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbTarMar" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbTarMie" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbTarJue" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbTarVie" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbTarSab" runat="server" /></asp:TableCell>
                                            <asp:TableCell><asp:CheckBox ID="cbTarDom" runat="server" /></asp:TableCell>  
                                            <asp:TableCell>
                                                <asp:DropDownList ID="cmbTarIni" runat="server">
                                                    <asp:ListItem Text="Seleccione" Value="0" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Text="14:00" Value="14:00"></asp:ListItem>
                                                    <asp:ListItem Text="15:00" Value="15:00"></asp:ListItem>
                                                    <asp:ListItem Text="16:00" Value="16:00"></asp:ListItem>
                                                    <asp:ListItem Text="17:00" Value="17:00"></asp:ListItem>
                                                    <asp:ListItem Text="18:00" Value="18:00"></asp:ListItem>
                                                    <asp:ListItem Text="19:00" Value="19:00"></asp:ListItem>
                                                    <asp:ListItem Text="20:00" Value="20:00"></asp:ListItem>
                                                    <asp:ListItem Text="21:00" Value="21:00"></asp:ListItem> 
                                                    <asp:ListItem Text="22:00" Value="22:00"></asp:ListItem>
                                                </asp:DropDownList></asp:TableCell>
                                            <asp:TableCell>
                                                <asp:DropDownList ID="cmbTarFin" runat="server">
                                                    <asp:ListItem Text="Seleccione" Value="0" Selected="True"></asp:ListItem>          
                                                    <asp:ListItem Text="14:00" Value="14:00"></asp:ListItem>
                                                    <asp:ListItem Text="15:00" Value="15:00"></asp:ListItem>
                                                    <asp:ListItem Text="16:00" Value="16:00"></asp:ListItem>
                                                    <asp:ListItem Text="17:00" Value="17:00"></asp:ListItem>
                                                    <asp:ListItem Text="18:00" Value="18:00"></asp:ListItem>
                                                    <asp:ListItem Text="19:00" Value="19:00"></asp:ListItem>
                                                    <asp:ListItem Text="20:00" Value="20:00"></asp:ListItem>
                                                    <asp:ListItem Text="21:00" Value="21:00"></asp:ListItem> 
                                                    <asp:ListItem Text="22:00" Value="22:00"></asp:ListItem>      
                                                </asp:DropDownList>
                                            </asp:TableCell>                                           
                                        </asp:TableRow>
                                        </asp:Table>
                                        <asp:Table ID="Table4" runat="server" style="padding: 0px; border-spacing: 0px;">
                                        <asp:TableRow>
                                            <asp:TableCell Width="150">Ciudades de atención : </asp:TableCell>
                                            <asp:TableCell><asp:TextBox ID="solAte" runat="server" Width="100%"></asp:TextBox></asp:TableCell>
                                            <asp:TableCell Width="120">Consideraciones : </asp:TableCell>
                                            <asp:TableCell Width="300"><asp:TextBox ID="solDispComent" runat="server" Width="100%"></asp:TextBox></asp:TableCell>
                                        </asp:TableRow>
        </asp:Table>
    </form> 
</div>
    <div id="grillaBig"> 
    <h1>
        <%:Page.Title%>
    </h1>
    <table id="" style="font-size: 10.5px;">
            <tr>
                <td>Buscar: </td>
                <td colspan="2">
                    <input id="busProfesion" name="busProfesion" type="text" tabindex="1" maxlength="50" size="200" onkeyup="tabla();" style="width: 25%; font-size: 11px"></td>

            </tr>
            <tr>
                <td>Agencia: </td>
                <td colspan="2">
                    <select name="busAgencia" id="busAgencia" style="width: 60%; font-size: 11px" onchange="tabla();">
                        <option value="0">Seleccione</option>
                    </select></td>
            </tr>
    </table>
    <table id="jQGridDemo">
    </table>
    <div id="jQGridDemoPager">
    </div>
    </div>
<div id="dialog_delIns" title="Eliminar Profesional">
	<p>Esta seguro de eliminar al Profesional?.</p>
</div>
</asp:Content>




