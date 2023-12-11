<%@ Page Title="Solicitudes" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Solicitud.aspx.cs" Inherits="MSESP.Solicitud" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent"> 
    <script type="text/javascript">
        var validator = "";
        var validatorAccion = "";
        var validatorAsignacion = "";
        var validatorFinal = "";
        var idSeg = "";
        var codsol = "";
        var cargada = false;
        var cargadaAcc = false;
        var cargadaDoc = false;
        var cargadaFinal = false;
        var cargadaAgenda = false;
        
        $().ready(function () {

            /*$(document).everyTime(3000, function () {

                alert("timeout");

            });*/

            var array = ["2017-01-01", "2017-01-02", "2017-04-14", "2017-04-15", "2017-04-19", "2017-05-01", "2017-05-21", "2017-06-26", "2017-07-02",
            "2017-08-15", "2017-08-20", "2017-09-18", "2017-09-19", "2017-10-09", "2017-10-27", "2017-11-01", "2017-11-19", "2017-12-08", "2017-12-17", "2017-12-25"];

            $.datepicker.regional['es2'] = {
                closeText: 'Cerrar',
                prevText: '< Ant',
                nextText: 'Sig >',
                currentText: 'Hoy',
                monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
                dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mié', 'Juv', 'Vie', 'Sáb'],
                dayNamesMin: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá'],
                weekHeader: 'Sm',
                dateFormat: 'dd/mm/yy',
                minDate: -30, maxDate: "+0D", 
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: '',
                beforeShowDay: function(date){
                    var string = jQuery.datepicker.formatDate('yy-mm-dd', date);
                    return [ array.indexOf(string) == -1 ]}
            };

            $.datepicker.regional['es'] = {
                closeText: 'Cerrar',
                prevText: '< Ant',
                nextText: 'Sig >',
                currentText: 'Hoy',
                monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
                dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mié', 'Juv', 'Vie', 'Sáb'],
                dayNamesMin: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá'],
                weekHeader: 'Sm',
                dateFormat: 'dd/mm/yy',
                minDate: -0, maxDate: "+60D",
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: '',
                beforeShowDay: function (date) {
                    var string = jQuery.datepicker.formatDate('yy-mm-dd', date);
                    return [array.indexOf(string) == -1]
                }
            };

            

            $('#MainContent_solHora').mask('Hn:Nn', {
                translation: {
                    'H': {
                        pattern: /[0-2]/, optional: true
                    },
                    'n': {
                        pattern: /[0-9]/, optional: true
                    },
                    'N': {
                        pattern: /[0-5]/, optional: true
                    }
                }
            });

            $('#actsolHora').mask('Hn:Nn', {
                translation: {
                    'H': {
                        pattern: /[0-2]/, optional: true
                    },
                    'n': {
                        pattern: /[0-9]/, optional: true
                    },
                    'N': {
                        pattern: /[0-5]/, optional: true
                    }
                }
            });

        
        $("#tabs").tabs();

        jQuery("#jQGridDemo").jqGrid({
            url: 'jqGridSolicitudes.ashx?t=<%=(string)(Session["TpUsuario"])%>&u=<%=(string)(Session["IdUsuario"])%>&p=<%=(string)(Session["IDProyecto"])%>',
            datatype: "xml",
            colNames: ['Nº', 'Tipo', 'Fecha', 'Solicitante', 'Rut Empresa', 'Empresa', 'Rut Paciente', 'Paciente', 'Orden Siniestro', 'Estado', ''],
            colModel: [
                        { name: 'ID_SOLICITUD', index: 'ID_SOLICITUD', width: 62, stype: 'text' },
                        { name: 'TIPO', index: 'TIPO', width: 40, stype: 'text' },
                        { name: 'FECHA_SOLICITUD', index: 'FECHA_SOLICITUD', width: 60, stype: 'text' },
                        { name: 'SOL', index: 'SOL', width: 100, stype: 'text' },
                        { name: 'RUT_E', index: 'RUT_E', width: 70, stype: 'text' },
                        { name: 'NOM_E', index: 'NOM_E', width: 100, stype: 'text' },
                        { name: 'TRAB_RUT', index: 'TRAB_RUT', width: 70, stype: 'text' },
                        { name: 'TRAB_NOM', index: 'TRAB_NOM', width: 100, stype: 'text' },
                        { name: 'ORDEN_SINIESTRO', index: 'ORDEN_SINIESTRO', width: 50, stype: 'text' },
                        { name: 'EST', index: 'EST', width: 50, stype: 'text' },
                        { width: 20, stype: 'text' }
            ],
            rowNum: 50,
            rownumbers: true,
            width: 960,
            height: 300,
            mtype: 'GET',
            loadonce: false,
            rowList: [50, 100, 200],
            pager: '#jQGridDemoPager',
            sortname: 'cod',
            viewrecords: true,
            sortorder: 'desc',
            caption: "Listado de <%: Page.Title %>"
        });

            if ('<%=(string)(Session["IDProyecto"])%>' == '2') {
                jQuery("#jQGridDemo").jqGrid('hideCol', 'EST');
            }

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
                caption: "Nueva Solicitud&nbsp;&nbsp;",
                title: "Agregar Nuevo Registro",
                buttonicon: 'ui-icon-plus',
                onClickButton: function () {
                    var f = new Date();
                    var msecPerMinute = 1000 * 60;
                    var msecPerHour = msecPerMinute * 60;
                    var msecPerDay = msecPerHour * 24;
                    var date = new Date();
                    var dateMsec = date.getTime();
                    date.setMonth(0);
                    date.setDate(1);
                    date.setHours(0, 0, 0, 0);
                    var interval = dateMsec - date.getTime();
                    var days = Math.floor(interval / msecPerDay);
                    interval = interval - (days * msecPerDay);
                    var hours = Math.floor(interval / msecPerHour);
                    interval = interval - (hours * msecPerHour);
                    var minutes = Math.floor(interval / msecPerMinute);
                    interval = interval - (minutes * msecPerMinute);
                    var seconds = Math.floor(interval / 1000);

                    if ('<%=(string)(Session["IDProyecto"])%>' == '2') {
                        llena_regiones(13);
                        llena_comunas(13, 295);
                        llena_regionesEmp(13);
                        llena_comunasEmp(13, 0);
                        llena_regionesPac(13);
                        llena_comunasPac(13, 0);
                        muestraCargaDoc(0);
                        llena_Tipo_Servicio(1);

                        $('#MainContent_tdsolFormObser').hide();
                        $('#MainContent_tdsolRegepttxt').hide();
                        $('#MainContent_tdsolRegeptsel').hide();
                        $('#MainContent_tdsolComepttxt').hide();
                        $('#MainContent_tdsolComeptsel').hide();

                        $('#spDirEmp').html("");
                        $('#spConEmp').html("");
                        $('#spConTel').html("");
                        $('#cabPant').html("");

                        $('#sptelMovil').html("(*)");

                        $('#MainContent_ProfSug1Prof').hide();
                        $('#MainContent_ProfSug1').hide();
                        $('#MainContent_tdProfSugTxt').hide();
                        $('#MainContent_tdProfSugSel').hide();
                        $('#MainContent_tdTipoCasotxt').hide();
                        $('#MainContent_tdTipoCasosel').hide();
                    }
                    else {
                        llena_regiones(0);
                        llena_comunas(0, 0);
                        llena_regionesEmp(0);
                        llena_comunasEmp(0, 0);
                        llena_regionesPac(0);
                        llena_comunasPac(0, 0);

                        $('#MainContent_tdsolFormObser').show();
                        $('#MainContent_tdsolRegepttxt').show();
                        $('#MainContent_tdsolRegeptsel').show();
                        $('#MainContent_tdsolComepttxt').show();
                        $('#MainContent_tdsolComeptsel').show();

                        $('#spDirEmp').html("(*)");
                        $('#spConEmp').html("(*)");
                        $('#spConTel').html("(*)");
                        $('#cabPant').html("(Información del Tipo y lugar a realizar la EPT)");

                        $('#sptelMovil').html("");

                        $('#MainContent_ProfSug1Prof').show();
                        $('#MainContent_ProfSug1').show();
                        $('#MainContent_tdProfSugTxt').show();
                        $('#MainContent_tdProfSugSel').show();
                        $('#MainContent_tdTipoCasotxt').show();
                        $('#MainContent_tdTipoCasosel').show();
                    }

                    llena_Combos('MainContent_solGeneroPac', 0, 1, 0);
                    $('#MainContent_foIngresolb').hide();
                    $('#MainContent_foIngresoVal').hide();

                    llena_Pregunta_Factores(0);
                    filaFacRiesgos(0);

                    //llena_regiones(0);
                    //llena_regionesEmp(0);
                    //llena_comunas(0, 0);
                    //llena_comunasEmp(0, 0);
                    //llena_regionesPac(0);
                    //llena_comunasPac(0, 0);

                    $.datepicker.setDefaults($.datepicker.regional['es2']);

                    $('#MainContent_solFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                    $('#MainContent_codSolHidden').val(f.getDate() + "" + (f.getMonth() + 1) + "" + f.getFullYear() + "" + hours + "" + minutes + "" + seconds);
                    limpiarForm();
                    //MostrarSeg(2, 1, 2);
                    //$('#MainContent_Agregar1').show();
                    $('#MainContent_trSegmento1').show();
                    llena_segLat('MainContent_solSeg', 'MainContent_solLat', 1, 0);
                    for (var seg = 2; seg <= 12; seg++) {
                        //$('#MainContent_trSegmento' + seg).hide();
                        MostrarSeg(seg, seg - 1, 2);
                        limpia_segLat('MainContent_solSeg', 'MainContent_solLat', seg);
                    }
                    
                    $('#button-GuardarSol').show();
                    //$('#dialog').dialog('open');

                    $.ajax({
                        type: "GET",
                        url: "validaFechaHora.ashx",
                        data: { orden: '' },
                        dataType: "xml",
                        success: function (xml) {
                            $('row', xml).each(function (i) {
                                if ($(this).find('REGISTRA').text() == '1')
                                {
                                    $('#dialog').dialog('open');
                                }
                                else
                                {
                                    $("#msnResult").html('<b>Señor(a) ' + '<%=(string)(Session["nomUsuario"])%>' + '</b>, le recordamos que el horario de ingreso de solicitudes al Sistema se extiende entre las 8:30 y las 18:00 horas, de Lunes a Viernes, salvo festivos, de manera que le solicitamos ingresar los casos que requiera dentro de dicho horarios.');
                                    $("#resultadoIngreso").dialog('open');
                                }
                            });
                        }
                    });

                    validarFrm();
                }
            });

            $("#DocRev").dialog({
                autoOpen: false,
                bgiframe: true,
                height: 500,
                width: 900,
                modal: true,
                overlay: {
                    backgroundColor: '#000',
                    opacity: 0.5
                },
                buttons: {
                    'Aprobar': function () {
                        guardarRevision("4");
                        $(this).dialog('close');
                    },
                    'Rechazar': function () {
                        guardarRevision("3");
                        $(this).dialog('close');
                    },
                    'Cerrar': function () {
                        $(this).dialog('close');
                    }
                },
                title: 'Documento'
            });

            $("#Doc").dialog({
                autoOpen: false,
                bgiframe: true,
                height: 500,
                width: 900,
                modal: true,
                overlay: {
                    backgroundColor: '#000',
                    opacity: 0.5
                },
                buttons: {
                    'Aceptar': function () {
                        $(this).dialog('close');
                    }
                },
                title: 'Documento'
            });

            $("#dialog_accion").dialog({
                title: "Registro de Acción",
                height: 420,
                width: 880,
                autoOpen: false,
                modal: true,
                buttons:[
                    {
                    //Guardar:
                    id: "button-Guardar",
                    text: "Guardar",
                    click:
                        function () {
                            validarFrmAccion();
                            if ($("#formAccion").valid()) {
                                var data = new FormData();
                                var archivos = $("#AccArch");

                                for (var i = 0; i < archivos[0].files.length; i++)
                                    data.append("arch[" + i + "]", archivos[0].files[i])

                                data.append("tipo", $('#accTipo').val());
                                data.append("fecha", $('#accFecha').val());
                                data.append("obs", $('#accObs').val());
                                data.append("id_sol", idSeg);
                                data.append("usr", '<%=(string)(Session["IdUsuario"])%>');
                                data.append("accDestinatario", $('#accDestinatario').val());
                                data.append("accCorreo", $('#accCorreo').val());

                                $.ajax({
                                    url: 'subeAccion.aspx',
                                    type: 'POST',
                                    contentType: false,
                                    processData: false,
                                    data: data,
                                    success: function () {
                                        $("#jQGridAcciones").trigger("reloadGrid");
                                        validatorAccion.resetForm();
                                    }
                                });
                                $(this).dialog('close');
                            }
                        }
                    },
                    {//Cerrar: 
                        id: "button-Cerrar",
                        text: "Cerrar",
                        click:
                            function () {
                            $(this).dialog('close');
                            validatorAccion.resetForm();
                            }
                    }
                ]
            });

            $("#dialog_Final").dialog({
                title: "Registro de Documento",
                height: 400,
                width: 880,
                autoOpen: false,
                modal: true,
                buttons: [
                    {
                        //Guardar:
                        id: "button-Guardar",
                        text: "Guardar",
                        click:
                            function () {
                                validarFrmFinal();
                                if ($("#formFinal").valid()) {

                                    var data = new FormData();
                                    var archivos = $("#fileUpload");

                                    for (var i = 0; i < archivos[0].files.length; i++)
                                        data.append("arch[" + i + "]", archivos[0].files[i])

                                    data.append("obs", $("#accObsFinal").val());
                                    data.append("tipo", $("#accTipoFinal").val());
                                    data.append("usr", '<%=(string)(Session["IdUsuario"])%>');
                                    data.append("id_sol", idSeg);
                                    data.append("fecha", $("#accFechaFinal").val());
                                    
                                    
                                    $.ajax({
                                        type: "POST",
                                        url: "Solicitud2.aspx",
                                        contentType: false,
                                        processData: false,
                                        data: data,
                                        success: function () {
                                            $("#jQGridFinal").trigger("reloadGrid");
                                            validatorFinal.resetForm();
                                        }
                                    });
                                    $(this).dialog('close');
                               }
                        }
                    },
                    {//Cerrar: 
                        id: "button-Cerrar",
                        text: "Cerrar",
                        click:
                            function () {
                                $(this).dialog('close');
                                validatorFinal.resetForm();
                            }
                    }
                ]
            });
            

            $("#solPend").dialog({
                title: "EPT Pendientes",
                autoOpen: false,
                bgiframe: true,
                height: 350,
                width: 700,
                modal: true,
                overlay: {
                    backgroundColor: '#f00',
                    opacity: 0.5
                },
                buttons: {
                    'Si': function () {
                        $(this).dialog('close');
                    },
                    'No': function () {
                        $('#dialog').dialog('close');
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });


            $("#sendConf").dialog({
                autoOpen: false,
                bgiframe: true,
                height: 150,
                width: 350,
                modal: true,
                overlay: {
                    backgroundColor: '#f00',
                    opacity: 0.5
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });

            $("#resultadoIngreso").dialog({
                autoOpen: false,
                bgiframe: true,
                height: 250,
                width: 450,
                modal: true,
                overlay: {
                    backgroundColor: '#f00',
                    opacity: 0.5
                },
                buttons: {
                    'Aceptar': function () {
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });

            $("#resultadoOS").dialog({
                autoOpen: false,
                bgiframe: true,
                height: 200,
                width: 450,
                modal: true,
                overlay: {
                    backgroundColor: '#f00',
                    opacity: 0.5
                },
                buttons: {
                    'Aceptar': function () {
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });

            $("#resultadoFactores").dialog({
                autoOpen: false,
                bgiframe: true,
                height: 550,
                width: 1150,
                modal: true,
                overlay: {
                    backgroundColor: '#f00',
                    opacity: 0.5
                },
                buttons: {
                    'Aceptar': function () {
                        $(this).dialog('close');

                        $("#MainContent_MacAgenHidden").val("0");
                        $("#MainContent_countMacAgen").val("0");
                        var NoptionBD = 37;
                        var listadoFR = "n";

                        for (var NFR = 1; NFR <= 18; NFR++) {
                            if ($('#FR_' + NFR).is(':checked')) {
                                listadoFR = listadoFR + ',' + NoptionBD;
                            }
                            NoptionBD = NoptionBD + 1;
                        }

                        if ($('#MainContent_solTipo').val() == '2' && listadoFR != 'n') {
                            $("#MainContent_MacAgenHidden").val(listadoFR.replace('n,', '').replace('n', ''));

                            var MacroSegSel = $("#MainContent_MacAgenHidden").val().split(",");

                            $("#MainContent_countMacAgen").val(MacroSegSel.length);
                        }
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            }); 

            $("#dialog_asignacion").dialog({
                title: "Registro de Asignación",
                height: 650,
                width: 980,
                autoOpen: false,
                modal: true,
                buttons: [
                    {
                        //Guardar:
                        id: "button-Guardar",
                        text: "Guardar",
                        click:
                            function () {
                                validarFrmAsignacion();
                                if ($("#formAsignacion").valid()) {
                                    var parametros = {
                                        tipo: $('#asiTipo').val(),
                                        fecha: $('#asiFecha').val(),
                                        prof: $('#asiProf').val(),
                                        id_sol: idSeg,
                                        usr: '<%=(string)(Session["IdUsuario"])%>',
                                        region: $('#asiReg').val(),
                                        hora: $('#asiHoraDis').val(),
                                        dir: $('#asiDir').val(),
                                        hora2: $('#asiHoraHasta').val()
                                };

                                $.ajax({
                                    url: 'Solicitud.aspx/GuardarAsignacion',
                                    type: 'POST',
                                    data: JSON.stringify(parametros),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function () {
                                        $("#jQGridAsignaciones").trigger("reloadGrid");
                                        validatorAsignacion.resetForm();
                                        tablaDoc(idSeg);
                                    }
                                });
                                $(this).dialog('close');
                            }
                        }
                    },
                    {//Cerrar: 
                        id: "button-Cerrar",
                        text: "Cerrar",
                        click:
                            function () {
                                $(this).dialog('close');
                                validatorAsignacion.resetForm();
                            }
                    }
                ]
            });

            $("#modal_dialog").dialog({
                title: "Seguimiento Solicitudes",
                height: 600,
                width: 1180,
                autoOpen: false,
                modal: true,
                buttons: {
                    Cerrar: function () {
                        $(this).dialog('close');
                    }
                }
            });

            $("#dialog").dialog({
                title: "Registro de Nueva Solicitud",
                height: 610,
                width: 1200,
                autoOpen: false,
                modal: true,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); },
                buttons: [
                   {
                       //Guardar:
                       id: "button-GuardarSol",
                       text: "Guardar",
                       click:
                           function () {
                               $("#MainContent_MacAgenHidden").val("0");

                               var NoptionBD = 37;
                               var listadoFR = "n";

                               for (var NFR = 1; NFR <= 18; NFR++) {
                                   if ($('#FR_' + NFR).is(':checked')) {
                                       listadoFR = listadoFR + ',' + NoptionBD;
                                   }
                                   NoptionBD = NoptionBD + 1;
                               }

                               /*$("#MainContent_MacAgenHidden").val(listadoFR.replace('n,', '').replace('n', ''));
                               var MacroSegSel = $("#MainContent_MacAgenHidden").val().split(",");

                               $("#MainContent_countMacAgen").val(MacroSegSel.length);*/
                               if ($('#MainContent_solTipo').val() == '2' && listadoFR != 'n') {
                                   $("#MainContent_MacAgenHidden").val(listadoFR.replace('n,', '').replace('n', ''));

                                   var MacroSegSel = $("#MainContent_MacAgenHidden").val().split(",");

                                   $("#MainContent_countMacAgen").val(MacroSegSel.length);
                               }

                               if ($("#form1").valid()) {
                                   $('#sendMsn').html('Espere Mientras se Registra Solicitud.');
                                   $("#sendConf").dialog('open');

                                   var data = new FormData();
                                   var d = $("#form1");
                                   for (var i = 0; i < (d.find('input[type=file]').length) ; i++) {
                                       data.append((d.find('input[type="file"]').eq(i).attr("id")), ((d.find('input[type="file"]:eq(' + i + ')')[0]).files[0]));
                                   }
                                   data.append("codSol", $('#MainContent_codSolHidden').val());

                                   $.ajax({
                                       type: "POST",
                                       url: "Solicitud.aspx",
                                       contentType: false,
                                       processData: false,
                                       data: data,
                                       success: function () {
                                           var parametros = {
                                               rut: $('#MainContent_solRutPac').val(),
                                               nombre: $('#MainContent_solNomPac').val(),
                                               fono: $('#MainContent_solTelFijo').val(),
                                               movil: $('#MainContent_solTelMovil').val(),
                                               email: $('#MainContent_solEmailPac').val(),
                                               dirp: $('#MainContent_solDirPac').val(),
                                               rutEmp: $('#MainContent_solEmp').val(),
                                               nombreEmp: $('#MainContent_solEmpNom').val(),
                                               tipoSol: $('#MainContent_solTipo').val(),
                                               f_sol: $('#MainContent_solFecha').val(),
                                               h_sol: $('#MainContent_solHora').val(),
                                               u_sol: $('#MainContent_solSol').val(),
                                               com_sol: $('#MainContent_solCom').val(),
                                               reg_sol: $('#MainContent_solReg').val(),
                                               obs_sol: $('#MainContent_solObs').val(),
                                               o_sol: $('#MainContent_solSin').val(),
                                               conEmp: $('#MainContent_SolConEmp').val(),
                                               conFono: $('#MainContent_SolConTel').val(),
                                               conEmail: $('#MainContent_SolConEmail').val(),
                                               idregemp: $('#MainContent_solRegEmp').val(),
                                               idcomemp: $('#MainContent_solComEmp').val(),
                                               idcaso: $('#MainContent_solCaso').val(),
                                               idseg1: $('#MainContent_solSeg1').val(),
                                               idlat1: $('#MainContent_solLat1').val(),
                                               dirEmp: $('#MainContent_solDirEmp').val(),
                                               obsCaso: $('#MainContent_solObsCaso').val(),
                                               codSol: $('#MainContent_codSolHidden').val(),
                                               idProf: $('#MainContent_solProf').val(),
                                               regpac: $('#MainContent_solRegPac').val(),
                                               compac: $('#MainContent_solComPac').val(),
                                               idseg2: $('#MainContent_solSeg2').val(),
                                               idlat2: $('#MainContent_solLat2').val(),
                                               idseg3: $('#MainContent_solSeg3').val(),
                                               idlat3: $('#MainContent_solLat3').val(),
                                               idseg4: $('#MainContent_solSeg4').val(),
                                               idlat4: $('#MainContent_solLat4').val(),
                                               idseg5: $('#MainContent_solSeg5').val(),
                                               idlat5: $('#MainContent_solLat5').val(),
                                               idseg6: $('#MainContent_solSeg6').val(),
                                               idlat6: $('#MainContent_solLat6').val(),
                                               idseg7: $('#MainContent_solSeg7').val(),
                                               idlat7: $('#MainContent_solLat7').val(),
                                               idseg8: $('#MainContent_solSeg8').val(),
                                               idlat8: $('#MainContent_solLat8').val(),
                                               idseg9: $('#MainContent_solSeg9').val(),
                                               idlat9: $('#MainContent_solLat9').val(),
                                               idseg10: $('#MainContent_solSeg10').val(),
                                               idlat10: $('#MainContent_solLat10').val(),
                                               idseg11: $('#MainContent_solSeg11').val(),
                                               idlat11: $('#MainContent_solLat11').val(),
                                               idseg12: $('#MainContent_solSeg12').val(),
                                               idlat12: $('#MainContent_solLat12').val(),
                                               forma_sol: "2",
                                               usrSol: '<%=(string)(Session["IdUsuario"])%>',
                                               idProfEC: $('#MainContent_solProfEva').val(),
                                               idtipoUser: '<%=(string)(Session["TpUsuario"])%>',
                                               tServicio: $('#MainContent_solTipoServicio').val(),
                                               proy: '<%=(string)(Session["IDProyecto"])%>',
                                               idgenero: $('#MainContent_solGeneroPac').val(),
                                               detCriterio: $("#MainContent_MacAgenHidden").val()
                                           };

                                           $.ajax({
                                               url: 'Solicitud.aspx/Guardar',
                                               type: 'POST',
                                               data: JSON.stringify(parametros),
                                               contentType: "application/json; charset=utf-8",
                                               dataType: "json",
                                               success: function (datos) {
                                                   $("#sendConf").dialog('close');
                                                   $('#sendMsn').html('');
                                                   $("#jQGridDemo").trigger("reloadGrid");
                                                   validator.resetForm();

                                                   for (var clave in datos) {
                                                       if (datos.hasOwnProperty(clave)) {
                                                           $("#msnResult").html('Se ha ingresado exitosamente el Caso Nº ' + datos[clave].replace('{"dato": "', '').replace('"}', ''));
                                                       }
                                                   }

                                                   $("#resultadoIngreso").dialog('open');
                                               }
                                           });
                                       }
                                   });
                                   $(this).dialog('close');
                               }
                           }
                   },                    
                   {//Cerrar: 
                        id: "button-CerrarSol",
                        text: "Cerrar",
                        click:
                        function () {
                            $(this).dialog('close');
                            validator.resetForm();
                        }
                    }
            ]
            });
            ventanaInicial();

        /*$(document).everyTime(50, function (i) { alert("timeout"); }, 0);*/

            /*setInterval(function () {
                //this code runs every second 
                alert("timeout");
            }, 10);*/
        });

        function Seguimiento(i,cod) {
            idSeg = i;
            $('#modal_dialog').dialog('option', 'title', 'Solicitud N° ' + cod);

            $.ajax({
                type: "GET",
                url: "datosSolicitud.ashx", 
                data: { id: i },
                dataType: "xml", 
                success: function (xml) {
                    $('row', xml).each(function (i) {
                        $.datepicker.setDefaults($.datepicker.regional['es']);
                        $('#tdActProf').html('Profesional Sugerido EPT: ');
                        llena_regionesPacAct($(this).find('preg').text());
                        llena_comunasPacAct($(this).find('preg').text(), $(this).find('pcom').text());

                        if ($(this).find('ID_TIPO_SOLICITUD').text() != "2") {
                            llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), 'actsolProf');
                        }

                        $('#trActSegProf').hide();
                        $('#tdActProfSugTxt').hide();
                        $('#tdActProfSugSel').hide();
                        if ($(this).find('ID_TIPO_SOLICITUD').text() == "2") {
                            llena_Tipo_ServicioAct($(this).find('TIPOSERVICIO').text());
                            $('#trActSegProf').show();

                            if ($(this).find('TIPOSERVICIO').text() == "1") {
                                llena_Profesionales_SugAct($(this).find('IDPROFEVA').text(), $(this).find('ID_REGION_EPT').text(), 'actsolProf');
                                llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), 'actsolProfEva');
                                $('#tdActProf').html('Prof. Sug. Eval. Clinico : ');
                                $('#tdActProfSugTxt').show();
                                $('#tdActProfSugSel').show();
                            }
                            else {
                                llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), 'actsolProf');
                                $('#tdActProf').html('Profesional Sugerido EPT: ');
                                $('#tdActProfSugTxt').hide();
                                $('#tdActProfSugSel').hide();
                            }
                        }

                        llena_regionesAct($(this).find('ID_REGION_EPT').text());
                        llena_comunasAct($(this).find('ID_REGION_EPT').text(), $(this).find('ID_COMUNA_EPT').text());
                        llena_regionesEmpAct($(this).find('ID_REGION_EMPRESA').text());
                        llena_comunasEmpAct($(this).find('ID_REGION_EMPRESA').text(), $(this).find('ID_COMUNA_EMPRESA').text());/**/
                        $('#actsolDirEmp').val($(this).find('DIRECCION_EMPRESA').text());
                        $('#actsolFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                        $('#actsolFecha').val($(this).find('FECHA').text());
                        $('#actsolFecha').attr('disabled', 'disabled');
                        $('#actsolHora').val($(this).find('HORA').text());
                        $('#actsolHora').attr('disabled', 'disabled');
                        $('#actsolObs').val($(this).find('OBSERVACIONES').text());
                        $('#actsolSin').val($(this).find('ORDEN_SINIESTRO').text());
                        $('#actSolConEmp').val($(this).find('CONTACTO_NOMBRE').text());
                        $('#actSolConTel').val($(this).find('CONTACTO_FONO').text());
                        $('#actSolConEmail').val($(this).find('CONTACTO_EMAIL').text());
                        $('#actsolObsCaso').val($(this).find('OBSERVACION_CASO').text());
                        $('#actsolEmp').val($(this).find('RUT').text());
                        $('#actsolEmpNom').val($(this).find('NOMBRE').text());
                        $('#actsolRutPac').val($(this).find('trab_rut').text());
                        $('#actsolNomPac').val($(this).find('trab_nom').text());
                        $('#actsolTelFijo').val($(this).find('FONO_FIJO').text());
                        $('#actsolTelMovil').val($(this).find('FONO_MOVIL').text());
                        $('#actsolDirPac').val($(this).find('DIRECCION').text());
                        $('#actsolEmailPac').val($(this).find('EMAIL').text());
                        $('#lbsolicitante').html($(this).find('SOLICITANTE').text());
                        $('#actsolTipo').html($(this).find('TIPO').text());
                        $('#actsolForma').html($(this).find('FORMA').text());
                        llena_Combos('actsolGeneroPac', $(this).find('ID_GENERO').text(), 1, 0);
                        //llena_segmentos($(this).find('ID_SEGMENTO').text());
                        //llena_lateridad($(this).find('ID_LATERAL').text());

                        for (var tr = 1; tr <= 12; tr++) {
                            $('#trSegmento'+tr).hide();
                        }

                        var arregloSegmentos = $(this).find('SEGDATOS').text().split("###");
                        
                        for (var i = 0; i < arregloSegmentos.length; i++) {
                            if (arregloSegmentos[i] != "") {
                                var arregloSegmentosDet = arregloSegmentos[i].split("##");

                                for (var det = 0; det < arregloSegmentosDet.length; det++) {
                                    if (arregloSegmentosDet[det] != "") {
                                        if (det==0) {
                                            $('#trSegmento' + (i + 1)).show();
                                        }

                                        if (det == 1) {
                                            $('#tdsolSeg' + (i + 1)).html(arregloSegmentosDet[det]);
                                        }

                                        if (det == 2) {
                                            $('#tdsolLat' + (i + 1)).html(arregloSegmentosDet[det]);
                                        }
                                    }
                                }
                            }
                        }

                        llena_casos($(this).find('ID_CASO').text());

                        //muestraSegmento($(this).find('ID_TIPO_SOLICITUD').text());
                        $('#tablActSol').find('input, textarea, button, select').attr('disabled', 'disabled');

                        var arregloDeCadenas = $(this).find('DOC2').text().split("/");
                        var documentos = "";
                        for (var i = 0; i < arregloDeCadenas.length; i++) {
                            if (arregloDeCadenas[i] != "") {
                                documentos = documentos + "<b><a href='#' onclick=verDoc('" + arregloDeCadenas[i] + "'); style='color: red;'>Ver Doc. " + (i + 1) + "</a></b>&nbsp;&nbsp;";
                            }
                        }
                        $('#tdLink').html(documentos);
                        //validarFrm();
                    });
                }
            });

            tablaAsignaciones(i);
            tablaAcciones(i);
            tablaDoc(i);
            tablaFinal(i);
            $('#modal_dialog').dialog('open');
        }

        function verDoc(doc) {
            $("#ifPagina").attr('src', "Documentos/" + doc);
            if (!$('#Doc').dialog('isOpen'))
                $('#Doc').dialog('open');
            //alert(doc);
        }

        function verDocRev(idact, doc, idactdet) {
            //alert(idact + ' ' + doc + ' ' + idactdet)
            $("#revActId").val(idact);
            $("#revActDetId").val(idactdet);

            $("#ifPagina2").attr('src', "Documentos/" + doc);
            if (!$('#DocRev').dialog('isOpen'))
                $('#DocRev').dialog('open');
        }

        function validaHora(valor) {
        if (valor.indexOf("_") == -1) {
            var hora = valor.split(":")[0];
            if (parseInt(hora) > 23) {
                $("#MainContent_solHora").val("");
            }
        }
    }

    function validaHoraAct(valor) {
        if (valor.indexOf("_") == -1) {
            var hora = valor.split(":")[0];
            if (parseInt(hora) > 23) {
                $("#actsolHora").val("");
            }
        }
    }

    function llena_regiones(id_region) {
        $("#MainContent_solReg").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx", 
            data: { id: id_region }, 
            dataType: "xml", 
            success: function (xml) { 
                $("#MainContent_solReg").append("<option value=\"\">Seleccione</option>");
					    $('row', xml).each(function (i) {
					        if (id_region == $(this).find('ID').text())
					            $("#MainContent_solReg").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
																		$(this).find('NOMBRE').text() + '</option>');
					        else
					            $("#MainContent_solReg").append('<option value="' + $(this).find('ID').text() + '" >' +
																		$(this).find('NOMBRE').text() + '</option>');
                    });
                }
                });
    }

    function llena_regionesAsig(id_region) {
        $("#asiReg").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx",
            data: { id: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#asiReg").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_region == $(this).find('ID').text())
                        $("#asiReg").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#asiReg").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_regionesAct(id_region) {
        $("#actsolReg").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx",
            data: { id: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#actsolReg").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_region == $(this).find('ID').text())
                        $("#actsolReg").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#actsolReg").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
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

    function llena_regionesEmpAct(id_region) {
        $("#actsolRegEmp").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx",
            data: { id: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#actsolRegEmp").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_region == $(this).find('ID').text())
                        $("#actsolRegEmp").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#actsolRegEmp").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_regionesPac(id_region) {
        $("#MainContent_solRegPac").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx",
            data: { id: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_solRegPac").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_region == $(this).find('ID').text())
                        $("#MainContent_solRegPac").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_solRegPac").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_regionesPacAct(id_region) {
        $("#actsolRegPac").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx",
            data: { id: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#actsolRegPac").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_region == $(this).find('ID').text())
                        $("#actsolRegPac").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#actsolRegPac").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_comunas(id_region, id_comuna) {
        $("#MainContent_solCom").html("");
                    $.ajax({
                        type: "GET",
                        url: "listarComunas.ashx",
                        data: { r: id_region },
                        dataType: "xml",
                        success: function (xml) {
                            $("#MainContent_solCom").append("<option value=\"\">Seleccione</option>");
                            $('row', xml).each(function (i) {
                                if (id_comuna == $(this).find('ID').text())
                                    $("#MainContent_solCom").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                            $(this).find('NOMBRE').text() + '</option>');
                                else
                                    $("#MainContent_solCom").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                            $(this).find('NOMBRE').text() + '</option>');
                            });
                        }
					});
    }

    function llena_comunasPac(id_region, id_comuna) {
        $("#MainContent_solComPac").html("");
        $.ajax({
            type: "GET",
            url: "listarComunas.ashx",
            data: { r: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_solComPac").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_comuna == $(this).find('ID').text())
                        $("#MainContent_solComPac").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_solComPac").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_comunasPacAct(id_region, id_comuna) {
        $("#actsolComPac").html("");
        $.ajax({
            type: "GET",
            url: "listarComunas.ashx",
            data: { r: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#actsolComPac").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_comuna == $(this).find('ID').text())
                        $("#actsolComPac").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#actsolComPac").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_comunasAct(id_region, id_comuna) {
        $("#actsolCom").html("");
        $.ajax({
            type: "GET",
            url: "listarComunas.ashx",
            data: { r: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#actsolCom").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_comuna == $(this).find('ID').text())
                        $("#actsolCom").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#actsolCom").append('<option value="' + $(this).find('ID').text() + '" >' +
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

    function llena_comunasEmpAct(id_region, id_comuna) {
        $("#actsolComEmp").html("");
        $.ajax({
            type: "GET",
            url: "listarComunas.ashx",
            data: { r: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#actsolComEmp").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_comuna == $(this).find('ID').text())
                        $("#actsolComEmp").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#actsolComEmp").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_TipoAccion(tipo) {
        $("#accTipo").html("");
        $.ajax({
            type: "GET",
            url: "listarTipoActividad.ashx",
            data: { t: "1" },
            dataType: "xml",
            success: function (xml) {
                $("#accTipo").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (tipo == $(this).find('ID').text())
                        $("#accTipo").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#accTipo").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_TipoFinal(tipo) {
        $("#accTipoFinal").html("");
        $.ajax({
            type: "GET",
            url: "listarTipoActividad.ashx",
            data: { t: "3" },
            dataType: "xml",
            success: function (xml) {
                $("#accTipoFinal").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (tipo == $(this).find('ID').text())
                        $("#accTipoFinal").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#accTipoFinal").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function validarFrmAccion() {
        validatorAccion = $("#formAccion").validate({
            rules: {
                accTipo : "required",
                accFecha: "required",
                accDestinatario: "required",
                accCorreo: {
                    required: true,
                    email: true
                },
            },
            messages: {
                accTipo: "&bull; Seleccione Tipo Acción.",
                accFecha: "&bull; Ingrese Fecha Acción.",
                accDestinatario: "&bull; Seleccione Interacción.",
                accCorreo: {
                    required: "&bull; Ingrese Correo.",
                    email: "&bull; Email Erroneo."
                },
            }
        });
    }

    function validarFrmFinal() {
        validatorFinal = $("#formFinal").validate({
            rules: {
                accTipoFinal: "required",
                accFechaFinal: "required",
                fileUpload: "required"
            },
            messages: {
                accTipoFinal: "&bull; Seleccione Tipo de Documento.",
                accFechaFinal: "&bull; Ingrese Fecha del Documento.",
                fileUpload: "&bull; Seleccione Archivo."
            }
        });
    }

    function verAccion(i) {
        $.ajax({
            type: "GET",
            url: "datosAccion.ashx", 
            data: { id: i },
            dataType: "xml", 
            success: function (xml) { 
                $('row', xml).each(function (i) {
                    $('#accFecha').val($(this).find('FECHA').text());
                    $('#accObs').val($(this).find('OBS').text());
                    $('#accCorreo').val($(this).find('CORREO').text());
                    llenaTipoIte($(this).find('DES').text());
                    llena_TipoAccion($(this).find('ID').text());
                    muestraCorreo($(this).find('ID').text());
                    $('#accSubeDoc').hide();
                    $('#accVerDoc').hide();
                    if ($(this).find('DOCUMENTO').text()!="") {
                        $('#accVerDoc').show();
                        $('#docAcc').html("<a href=\"#\" onclick=\"verDoc('" + $(this).find('DOCUMENTO').text() + "');\">Ver</a>");
                    }

                    $('#dialog_accion').dialog('open');
                    $("#button-Guardar").hide(); 
                });
            }
        });
    }

    function llenaTipoIte(id_tipo) {
        $("#accDestinatario").html("");
        $("#accDestinatario").append("<option value=\"\">Seleccione</option>");
        if (id_tipo == 1) {
            $("#accDestinatario").append("<option value=\"1\" selected=\"selected\">Paciente</option>");
            $("#accDestinatario").append("<option value=\"2\">Empresa</option>");
            $("#accDestinatario").append("<option value=\"3\">Profesional</option>");
            $("#accDestinatario").append("<option value=\"4\">Otros</option>");
        } else if (id_tipo == 2) {
            $("#accDestinatario").append("<option value=\"1\">Paciente</option>");
            $("#accDestinatario").append("<option value=\"2\" selected=\"selected\">Empresa</option>");
            $("#accDestinatario").append("<option value=\"3\">Profesional</option>");
            $("#accDestinatario").append("<option value=\"4\">Otros</option>");
        } else if (id_tipo == 3) {
            $("#accDestinatario").append("<option value=\"1\">Paciente</option>");
            $("#accDestinatario").append("<option value=\"2\">Empresa</option>");
            $("#accDestinatario").append("<option value=\"3\" selected=\"selected\">Profesional</option>");
            $("#accDestinatario").append("<option value=\"4\">Otros</option>");
        } else if (id_tipo == 4) {
            $("#accDestinatario").append("<option value=\"1\">Paciente</option>");
            $("#accDestinatario").append("<option value=\"2\">Empresa</option>");
            $("#accDestinatario").append("<option value=\"3\">Profesional</option>");
            $("#accDestinatario").append("<option value=\"4\" selected=\"selected\">Otros</option>");
        } else {
            $("#accDestinatario").append("<option value=\"1\">Paciente</option>");
            $("#accDestinatario").append("<option value=\"2\">Empresa</option>");
            $("#accDestinatario").append("<option value=\"3\">Profesional</option>");
            $("#accDestinatario").append("<option value=\"4\">Otros</option>");
        }
    }

    function llena_TipoAsignacion(tipo,id_profesional) {
        $("#asiTipo").html("");
        $.ajax({
            type: "GET",
            url: "listarTipoActividadProf.ashx",
            data: { t: "2", pf: id_profesional },
            dataType: "xml",
            success: function (xml) {
                $("#asiTipo").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (tipo == $(this).find('ID').text())
                        $("#asiTipo").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#asiTipo").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function validarFrmAsignacion() {
        validatorAsignacion = $("#formAsignacion").validate({
            rules: {
                asiTipo: "required",
                asiFecha: "required",
                asiProf: "required",
                asiReg: "required",
                asiHoraDis: "required",
                asiHoraHasta: "required",
                asiDir: "required"
            },
            messages: {
                asiTipo: "&bull; Seleccione Tipo Actividad.",
                asiFecha: "&bull; Ingrese Fecha Actividad.",
                asiProf: "&bull; Seleccione Profesional.",
                asiReg: "&bull; Seleccione Región.",
                asiHoraDis: "&bull; Seleccione Horario.",
                asiHoraHasta: "&bull; Seleccione Horario.",
                asiDir: "&bull; Ingrese Observaciones."
            }
        });
    }

    function llena_Profesionales(id, id_region, hora) {
        $("#asiProf").html("");
        $.ajax({
            type: "GET",
            url: "listarProfesionales.ashx",
            data: { t: "2", r: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#asiProf").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id == $(this).find('ID').text())
                        $("#asiProf").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#asiProf").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
        
        tablaAgenda(id, $('#asiFecha').val());
        //llena_hDisponibles(hora, id);
        //llena_hDisponibles(hora, id);
    }

    function llena_Profesionales_Sug(id, id_region, tipo) {
        var vtipo = tipo;
        if (tipo=='2') {
            vtipo = '5';
        }

        $("#MainContent_solProf").html("");
        $.ajax({
            type: "GET",
            url: "listarProfesionalesTipo.ashx",
            data: { t: vtipo, r: id_region, s: '0', proy: '<%=(string)(Session["IDProyecto"])%>' },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_solProf").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id == $(this).find('ID').text())
                        $("#MainContent_solProf").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_solProf").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function llena_Profesionales_SugEva(id, id_region, tipo, selprof1) {
        $("#MainContent_solProfEva").html("");
        if ($("#MainContent_solTipo").val()=='2') { 
        $.ajax({
            type: "GET",
            url: "listarProfesionalesTipo.ashx",
            data: { t: tipo, r: id_region, s: selprof1, proy: '<%=(string)(Session["IDProyecto"])%>' },
            dataType: "xml",
            success: function (xml) {
                $("#MainContent_solProfEva").append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id == $(this).find('ID').text())
                        $("#MainContent_solProfEva").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#MainContent_solProfEva").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
        }
    }

    function llena_Profesionales_SugAct(id, id_region, pre) {
        $("#" + pre).html("");
        $.ajax({
            type: "GET",
            url: "listarProfesionales.ashx",
            data: { t: "2", r: id_region, proy: '<%=(string)(Session["IDProyecto"])%>' },
            dataType: "xml",
            success: function (xml) {
                $("#" + pre).append("<option value=\"\">Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id == $(this).find('ID').text())
                        $("#" + pre).append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#" + pre).append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }


    function verAsignacion(i) {
        $.ajax({
            type: "GET",
            url: "datosAsignacion.ashx",
            data: { id: i },
            dataType: "xml",
            success: function (xml) {
                $('row', xml).each(function (i) {
                    $('#asiFecha').val($(this).find('FECHA').text());
                    
                    llena_regionesAsig($(this).find('ID_REGION').text());
                    llena_Profesionales($(this).find('PROFESIONAL').text(), $(this).find('ID_REGION').text(), $(this).find('HORA').text());
                    llena_TipoAsignacion($(this).find('TIPO').text(), $(this).find('PROFESIONAL').text());
                    llena_hDisponibles($(this).find('HORA').text(), $(this).find('PROFESIONAL').text());
                    llena_hDisponibles2($(this).find('HORA2').text(), $(this).find('PROFESIONAL').text());

                    $('#asiDir').val($(this).find('DIR').text());
                    $('#dialog_asignacion').dialog('open');
                    //$("#button-Guardar").hide();
                });
            }
        });
    }

    function tablaAsignaciones(id)
    {
        sUrl='jqGridAsignaciones.ashx?id=' + id;
     
        if (cargada) {
            jQuery("#jQGridAsignaciones").jqGrid('setGridParam', { url: sUrl });
            jQuery("#jQGridAsignaciones").trigger("reloadGrid");
        } else {
            cargada = true;
            jQuery("#jQGridAsignaciones").jqGrid({
                url: sUrl,
                datatype: "xml",
                colNames: ['Actividad', 'Usuario', 'Profesional', 'Programación', ''],
                colModel: [
                            { name: 'TIPO', index: 'TIPO', width: 150, stype: 'text' },
                            { name: 'USR', index: 'USR', width: 150, stype: 'text' },
                            { name: 'PROF', index: 'PROF', width: 150, stype: 'text' },
                            { name: 'fecha', index: 'fecha', width: 40, stype: 'text' },
                            { name: 'ID_ACTIVIDAD', index: 'ID_ACTIVIDAD', width: 13, stype: 'text' }
                ],
                rowNum: 50,
                width: 960,
                height: 300,
                mtype: 'GET',
                loadonce: false,
                rowList: [50, 100, 200],
                pager: '#jQGridAsignacionesPager',
                sortname: 'ID_ACTIVIDAD',
                viewrecords: false,
                sortorder: 'desc',
                caption: "Listado de Asignaciones",
                editurl: 'jqGridAsignaciones.ashx'
            });

            $('#jQGridAsignaciones').jqGrid('navGrid', '#jQGridAsignacionesPager',
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

            jQuery("#jQGridAsignaciones").jqGrid('navButtonAdd', "#jQGridAsignacionesPager", {
                caption: "Agregar&nbsp;&nbsp;",
                title: "Agregar Nuevo Registro",
                buttonicon: 'ui-icon-plus',
                onClickButton: function () {
                    $('#asiDir').val("");
                    $('#asiFecha').val("");
                    $('#asiFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                    
                    $.ajax({
                        type: "GET",
                        url: "datosSolicitud.ashx",
                        data: { id: id },
                        dataType: "xml",
                        success: function (xml) {
                            $('row', xml).each(function (i) {
                                //$('#MainContent_solEmpNom').val($(this).find('ID_REGION_EPT').text());
                                llena_regionesAsig($(this).find('ID_REGION_EPT').text());
                                llena_Profesionales(0,$(this).find('ID_REGION_EPT').text(),0);
                            });
                        }
                    });
                    $("#asiTipo").html("");
                    $("#asiTipo").append("<option value=\"\">Seleccione</option>");

                    $("#asiHoraHasta").html("");
                    $("#asiHoraHasta").append("<option value=\"\">Seleccione</option>");

                    $("#asiHoraDis").html("");
                    $("#asiHoraDis").append("<option value=\"\">Seleccione</option>");

                    //llena_Profesionales(0, 0, 0);
                    //llena_TipoAsignacion(0,0);

                    $('#dialog_asignacion').dialog('open');

                    validarFrmAsignacion();
                }
            });
        }
    }

    function tablaAcciones(id)
    {
        sUrl='jqGridAcciones.ashx?id=' + id;
     
        if (cargadaAcc) {
            jQuery("#jQGridAcciones").jqGrid('setGridParam', { url: sUrl });
            jQuery("#jQGridAcciones").trigger("reloadGrid");
        } else {
            cargadaAcc = true;
            jQuery("#jQGridAcciones").jqGrid({
                url: 'jqGridAcciones.ashx?id=' + id,
                datatype: "xml",
                colNames: ['Acción', 'Interacción', 'Usuario', 'Fecha Realización', ''],
                colModel: [
                            { name: 'Accion', index: 'Accion', width: 150, stype: 'text' },
                            { name: 'interaccion', index: 'interaccion', width: 150, stype: 'text' },
                            { name: 'usuario', index: 'usuario', width: 150, stype: 'text' },
                            { name: 'Fecha_Real', index: 'Fecha_Real', width: 40, stype: 'text' },
                            { name: 'TIPO', index: 'TIPO', width: 13, stype: 'text' }
                ],
                rowNum: 50,
                width: 960,
                height: 300,
                mtype: 'GET',
                loadonce: false,
                rowList: [50, 100, 200],
                pager: '#jQGridAccionesPager',
                sortname: 'Fecha_Real',
                viewrecords: false,
                sortorder: 'desc',
                caption: "Listado de Acciones",
                editurl: 'jqGridAcciones.ashx'
            });

            $('#jQGridAcciones').jqGrid('navGrid', '#jQGridAccionesPager',
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

            jQuery("#jQGridAcciones").jqGrid('navButtonAdd', "#jQGridAccionesPager", {
                caption: "Agregar&nbsp;&nbsp;",
                title: "Agregar Nuevo Registro",
                buttonicon: 'ui-icon-plus',
                onClickButton: function () {
                    llena_TipoAccion(0);
                    //$('#accDestinatario').val("Seleccione"),
                    $('#accCorreo').val("");
                    $('#accObs').val("");
                    $('#accFecha').val("");
                    $('#accFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                    $('#accSubeDoc').show();
                    $('#AccArch').val("");
                    $('#accVerDoc').hide();
                    $('#dialog_accion').dialog('open');
                    $("#button-Guardar").show();
                    validarFrmAccion();
                }
            });
        }
    }

    function tablaFinal(id) {
        sUrl = 'jqGridFinal.ashx?id=' + id;

        if (cargadaFinal) {
            jQuery("#jQGridFinal").jqGrid('setGridParam', { url: sUrl });
            jQuery("#jQGridFinal").trigger("reloadGrid");
        } else {
            cargadaFinal = true;
            jQuery("#jQGridFinal").jqGrid({
                url: 'jqGridFinal.ashx?id=' + id,
                datatype: "xml",
                colNames: ['Documento', 'Usuario', 'Fecha Subida', ''],
                colModel: [
                            { name: 'Accion', index: 'Accion', width: 150, stype: 'text' },
                            { name: 'usuario', index: 'usuario', width: 150, stype: 'text' },
                            { name: 'Fecha_Real', index: 'Fecha_Real', width: 40, stype: 'text' },
                            { name: 'TIPO', index: 'TIPO', width: 13, stype: 'text' }
                ],
                rowNum: 50,
                width: 960,
                height: 300,
                mtype: 'GET',
                loadonce: false,
                rowList: [50, 100, 200],
                pager: '#jQGridFinalPager',
                sortname: 'Fecha_Real',
                viewrecords: false,
                sortorder: 'desc',
                caption: "Listado de Documentos",
                editurl: 'jqGridFinal.ashx'
            });

            $('#jQGridFinal').jqGrid('navGrid', '#jQGridFinalPager',
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

            jQuery("#jQGridFinal").jqGrid('navButtonAdd', "#jQGridFinalPager", {
                caption: "Agregar&nbsp;&nbsp;",
                title: "Agregar Nuevo Registro",
                buttonicon: 'ui-icon-plus',
                onClickButton: function () {
                    /**/llena_TipoFinal(0);
                    $('#accObsFinal').val(""),
                    $('#accFechaFinal').val(""),
                    $('#accFechaFinal').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                    $('#dialog_Final').dialog('open');
                    //$("#button-Guardar").show();
                    validarFrmFinal();
                }
            });
        }
    }


    function tablaDoc(id) {
        sUrl = 'jqGridDoc.ashx?id=' + id;

        if (cargadaDoc) {
            jQuery("#jQGridDoc").jqGrid('setGridParam', { url: sUrl });
            jQuery("#jQGridDoc").trigger("reloadGrid");
        } else {
            cargadaDoc = true;
            jQuery("#jQGridDoc").jqGrid({
                url: sUrl,
                datatype: "xml",
                colNames: ['Tipo de Documento', 'Profesional', 'Programación', 'Estado', ''],
                colModel: [
                            { name: 'TIPO', index: 'TIPO', width: 300, stype: 'text' },
                            { name: 'PROF', index: 'PROF', width: 80, stype: 'text' },
                            { name: 'fecha', index: 'fecha', width: 80, stype: 'text' },
                            { name: 'fecha', index: 'fecha', width: 80, stype: 'text' },
                            { name: 'TIPO', index: 'TIPO', width: 13, stype: 'text' }
                ],
                rowNum: 50,
                width: 960,
                height: 300,
                mtype: 'GET',
                loadonce: false,
                rowList: [50, 100, 200],
                pager: '#jQGridDocPager',
                sortname: 'ID_ACTIVIDAD',
                viewrecords: false,
                sortorder: 'desc',
                caption: "Listado de Actividades",
                editurl: 'jqGridDoc.ashx'
            });

            $('#jQGridDoc').jqGrid('navGrid', '#jQGridDocPager',
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
        }
    }

    function limpiarForm(){
        $('#MainContent_solRutPac').val("");
        //$('#MainContent_solRutPac').defaultValue('Rut Ej: 16313889-8');
        $('#MainContent_solNomPac').val("");
        $('#MainContent_solTelFijo').val("");
        $('#MainContent_solTelMovil').val("");
        $('#MainContent_solEmailPac').val("");
        $('#MainContent_solDirPac').val("");
        $('#MainContent_solEmp').val("");
        //$('#MainContent_solEmp').defaultValue('Rut Ej: 16313889-8');
        $('#MainContent_solEmpNom').val("");
        $('#MainContent_solTipo').val("");
        //$('#MainContent_solFecha').val("");
        //$('#MainContent_solHora').val("");
        $('#MainContent_solCom').val("");
        $('#MainContent_solReg').val("");
        $('#MainContent_solObs').val("");
        $('#MainContent_solSin').val("");
        $('#MainContent_SolConEmp').val("");
        $('#MainContent_SolConTel').val("");
        $('#MainContent_SolConEmail').val("");
        $('#MainContent_solRegEmp').val("");
        $('#MainContent_solComEmp').val("");
        $('#MainContent_solArch').val("");
        $('#MainContent_solArch_wrap_list').html("");
        $('#MainContent_solDirEmp').val("");
        $('#MainContent_solObsCaso').val("");
        $('#MainContent_Agregar1').show();
        llena_Profesionales_Sug(0, 0, 0);
        llena_casos_Sol(0);
        $('#MainContent_trSegProf').hide();

        if ('<%=(string)(Session["TpUsuario"])%>' != '3') {
            $('#MainContent_solFecha').val("");
            $('#MainContent_solHora').val("");
            $('#MainContent_solForma').val("");
            $('#MainContent_solSol').val("0");
        }

        //MostrarSeg(2, 1, 2);
    }



    function validarFrm() {
        validator = $("#form1").validate({
            rules: {
                ctl00$MainContent$solRutPac: {
                    required: true,
                    rut: true
                },
                ctl00$MainContent$solNomPac : "required",
                ctl00$MainContent$solEmailPac: {
                    email: true
                },
                ctl00$MainContent$solDirPac: "required",
                ctl00$MainContent$solGeneroPac: "required",
                ctl00$MainContent$solEmp: {
                    required: true,
                    rut: true
                },
                ctl00$MainContent$solEmpNom : "required",
                ctl00$MainContent$solTipo : "required",
                ctl00$MainContent$solFecha : "required",
                ctl00$MainContent$solHora : "required",
                ctl00$MainContent$solSol: "required",
                ctl00$MainContent$solCom : "required",
                ctl00$MainContent$solReg: "required",
                ctl00$MainContent$solTelMovil: {
                    required: { depends: function (element) { if ('<%=(string)(Session["IDProyecto"])%>' == '2') return true; else return false; } }
                },
                ctl00$MainContent$solSin: {
                    required: true,
                    number: true
                },
                ctl00$MainContent$SolConEmp: {
                    required: { depends: function (element) { if ('<%=(string)(Session["IDProyecto"])%>' == '1') return true; else return false; } }
                },
                ctl00$MainContent$SolConTel: {
                    required: { depends: function (element) { if ('<%=(string)(Session["IDProyecto"])%>' == '1') return true; else return false; } }
                },
                ctl00$MainContent$SolConEmail: {
                    email: true
                },
                ctl00$MainContent$solRegEmp : "required",
                ctl00$MainContent$solComEmp : "required",
                ctl00$MainContent$solCaso : "required",
                ctl00$MainContent$solDirEmp: {
                    required: { depends: function (element) { if ('<%=(string)(Session["IDProyecto"])%>' == '1') return true; else return false; } }
                },
                ctl00$MainContent$FileDocMotConsulta: {
                    required: true
                },
                ctl00$MainContent$FileDocListaTestigos: {
                    required: true
                },
                ctl00$MainContent$solSeg1: "required",
                ctl00$MainContent$solLat1: "required",
                ctl00$MainContent$solSeg2: "required",
                ctl00$MainContent$solLat2: "required",
                ctl00$MainContent$solSeg3: "required",
                ctl00$MainContent$solLat3: "required",
                ctl00$MainContent$solSeg4: "required",
                ctl00$MainContent$solLat4: "required",
                ctl00$MainContent$solSeg5: "required",
                ctl00$MainContent$solLat5: "required",
                ctl00$MainContent$solSeg6: "required",
                ctl00$MainContent$solLat6: "required",
                ctl00$MainContent$solSeg7: "required",
                ctl00$MainContent$solLat7: "required",
                ctl00$MainContent$solSeg8: "required",
                ctl00$MainContent$solLat8: "required",
                ctl00$MainContent$solSeg9: "required",
                ctl00$MainContent$solLat9: "required",
                ctl00$MainContent$solSeg10: "required",
                ctl00$MainContent$solLat10: "required",
                ctl00$MainContent$solSeg11: "required",
                ctl00$MainContent$solLat11: "required",
                ctl00$MainContent$solSeg12: "required",
                ctl00$MainContent$solLat12: "required",
                ctl00$MainContent$countMacAgen: {
                    required: true,
                    max: 3
                }
            },
            messages: {
                ctl00$MainContent$solRutPac: {
                    required: "&bull; Ingrese Rut.",
                    rut: "&bull; Rut Erroneo."
                },
                ctl00$MainContent$solNomPac: "&bull; Ingrese Nombre.",
                ctl00$MainContent$solEmailPac: {
                    email: "&bull; Email Erroneo."
                },
                ctl00$MainContent$solDirPac: "&bull; Ingrese Dirección.",
                ctl00$MainContent$solGeneroPac: "&bull; Seleccione Género",
                ctl00$MainContent$solEmp: {
                    required: "&bull; Ingrese Rut.",
                    rut: "&bull; Rut Erroneo."
                },
                ctl00$MainContent$solEmpNom: "&bull; Ingrese Razón social de la Empresa.",
                ctl00$MainContent$solTipo: "&bull; Seleccione Tipo.",
                ctl00$MainContent$solFecha: "&bull; Ingrese Fecha.",
                ctl00$MainContent$solHora: "&bull; Ingrese Hora.",
                ctl00$MainContent$solSol: "&bull; Seleccione Solicitante.",
                ctl00$MainContent$solCom: "&bull; Seleccione Comuna Solicitud.",
                ctl00$MainContent$solReg: "&bull; Seleccione Región Solicitud.",
                ctl00$MainContent$solTelMovil: "&bull; Ingrese Móvil",
                ctl00$MainContent$solSin: {
                    required: "&bull; Ingrese Orden de Siniestro.",
                    number: "&bull; Ingrese Solo Números."
                },
                ctl00$MainContent$SolConEmp: "&bull; Ingrese Contacto.",
                ctl00$MainContent$SolConTel: "&bull; Ingrese Telefono.",
                ctl00$MainContent$SolConEmail: {
                    email: "&bull; Email de Empresa Erroneo."
                },
                ctl00$MainContent$solRegEmp: "&bull; Seleccione Región de la Empresa.",
                ctl00$MainContent$solComEmp: "&bull; Seleccione Comuna de la Empresa.",
                ctl00$MainContent$solCaso: "&bull; Seleccione Caso.",
                ctl00$MainContent$solDirEmp: "&bull; Ingrese Dirección de la Empresa.",
                ctl00$MainContent$FileDocMotConsulta: {
                    required: "&bull; Seleccione Documento."
                },
                ctl00$MainContent$FileDocListaTestigos: {
                    required: "&bull; Seleccione Documento."
                },
                ctl00$MainContent$solSeg1: "&bull; Seleccione",
                ctl00$MainContent$solLat1: "&bull; Seleccione",
                ctl00$MainContent$solSeg2: "&bull; Seleccione",
                ctl00$MainContent$solLat2: "&bull; Seleccione",
                ctl00$MainContent$solSeg3: "&bull; Seleccione",
                ctl00$MainContent$solLat3: "&bull; Seleccione",
                ctl00$MainContent$solSeg4: "&bull; Seleccione",
                ctl00$MainContent$solLat4: "&bull; Seleccione",
                ctl00$MainContent$solSeg5: "&bull; Seleccione",
                ctl00$MainContent$solLat5: "&bull; Seleccione",
                ctl00$MainContent$solSeg6: "&bull; Seleccione",
                ctl00$MainContent$solLat6: "&bull; Seleccione",
                ctl00$MainContent$solSeg7: "&bull; Seleccione",
                ctl00$MainContent$solLat7: "&bull; Seleccione",
                ctl00$MainContent$solSeg8: "&bull; Seleccione",
                ctl00$MainContent$solLat8: "&bull; Seleccione",
                ctl00$MainContent$solSeg9: "&bull; Seleccione",
                ctl00$MainContent$solLat9: "&bull; Seleccione",
                ctl00$MainContent$solSeg10: "&bull; Seleccione",
                ctl00$MainContent$solLat10: "&bull; Seleccione",
                ctl00$MainContent$solSeg11: "&bull; Seleccione",
                ctl00$MainContent$solLat11: "&bull; Seleccione",
                ctl00$MainContent$solSeg12: "&bull; Seleccione",
                ctl00$MainContent$solLat12: "&bull; Seleccione",
                ctl00$MainContent$countMacAgen: {
                    required: "&bull; Seleccione",
                    max: "&bull; Seleccione Máximo 3"
                }
            }
        });
    }

    function guardarRevision(e) {
        var parametros = {
            id_act: $("#revActId").val(),
            det_act: $("#revActDetId").val(),
            obs: $('#revObs').val(),
            usr: '<%=(string)(Session["IdUsuario"])%>',
            est: e
        };

        $.ajax({
            url: 'Solicitud.aspx/Revision',
            type: 'POST',
            data: JSON.stringify(parametros), 
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function () {
                $("#jQGridDoc").trigger("reloadGrid");
                $('#revObs').val("");
            }
        });
    }
        function muestraCorreo(e) {
            //alert(e);
            if(e=="1")
            {
                //$('#trdestino').show();
                $('#trcorreo').show();
            }
            else
            {
                //$('#trdestino').hide();
                $('#trcorreo').hide();
            }
        }

        function llena_segLat(controlSeg, controlLat, ncontrol, id) {
            llena_segmentosInicio(controlSeg, ncontrol, id);
            llena_lateridadInicio(controlLat, ncontrol, id);
        }

        function limpia_segLat(controlSeg, controlLat, ncontrol) 
        {
            $("#" + controlSeg + ncontrol).html("");
            $("#" + controlLat + ncontrol).html("");
        }

        function llena_segmentosInicio(control, ncontrol, id) {
            //alert(control + ' ' + ncontrol + ' ' + id);
            $("#" + control + ncontrol).html("");
            $.ajax({
                type: "GET",
                url: "listaSegmentos.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#" + control + ncontrol).append("<option value=\"\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#" + control + ncontrol).append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#" + control + ncontrol).append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_lateridadInicio(control, ncontrol, id) {
            //alert(id);
            $("#" + control + ncontrol).html("");
            $.ajax({
                type: "GET",
                url: "listaLateridad.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#" + control + ncontrol).append("<option value=\"\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#" + control + ncontrol).append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#" + control + ncontrol).append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function MostrarSeg(e,imgAgre, estMostrar) {
            if (estMostrar=="1") {
                    $('#MainContent_trSegmento' + e).show();
                    $('#MainContent_Agregar' + imgAgre).hide();
                    $('#MainContent_Remove' + imgAgre).hide();
            }
            else {
                    $('#MainContent_trSegmento' + e).hide();
                    $('#MainContent_Agregar' + imgAgre).show();
                    $('#MainContent_Remove' + imgAgre).show();
            }
        }

        function muestraSegmento(e) {
            $('#MainContent_trSegProf').hide();
            $('#MainContent_ProfSug1').html('Profesional Sugerido EPT: ');
            muestraCargaDoc(0);
            llena_Tipo_Servicio(1);

            if (e == "2" || e == "3" || e == "4") {
                for (var seg = 1; seg <= 12; seg++) {
                    MostrarSeg(seg, seg - 1, 2);
                    limpia_segLat('MainContent_solSeg', 'MainContent_solLat', seg);
                }

                $('#trSegmento1').hide();
                if (e == "2")
                {
                    if ('<%=(string)(Session["IDProyecto"])%>' != '2') {
                        $('#MainContent_trSegProf').show();
                    }
                    llena_Profesionales_SugEva(0, $('#MainContent_solReg').val(), 2, 0);
                    $('#MainContent_ProfSug1').html('Prof. Sug. Eval. Clinico : '); 
                }
            }
            else {
                $('#MainContent_trSegmento1').show();
                llena_segLat('MainContent_solSeg', 'MainContent_solLat', 1, 0);
                $('#trSegmento1').show();
            }
        }
        
        function ventanaInicial() {
            var f = new Date();
            var msecPerMinute = 1000 * 60;
            var msecPerHour = msecPerMinute * 60;
            var msecPerDay = msecPerHour * 24;
            var date = new Date();
            var dateMsec = date.getTime();
            date.setMonth(0);
            date.setDate(1);
            date.setHours(0, 0, 0, 0);
            var interval = dateMsec - date.getTime();
            var days = Math.floor(interval / msecPerDay);
            interval = interval - (days * msecPerDay);
            var hours = Math.floor(interval / msecPerHour);
            interval = interval - (hours * msecPerHour);
            var minutes = Math.floor(interval / msecPerMinute);
            interval = interval - (minutes * msecPerMinute);
            var seconds = Math.floor(interval / 1000);

            if ('<%=(string)(Session["IDProyecto"])%>' == '2') {
                llena_regiones(13);
                llena_comunas(13, 295);
                llena_regionesEmp(13);
                llena_comunasEmp(13, 0);
                llena_regionesPac(13);
                llena_comunasPac(13, 0);
                muestraCargaDoc(0);
                llena_Tipo_Servicio(1);

                $('#MainContent_tdsolFormObser').hide();
                $('#MainContent_tdsolRegepttxt').hide();
                $('#MainContent_tdsolRegeptsel').hide();
                $('#MainContent_tdsolComepttxt').hide();
                $('#MainContent_tdsolComeptsel').hide();

                $('#spDirEmp').html("");
                $('#spConEmp').html("");
                $('#spConTel').html("");
                $('#cabPant').html("");

                $('#sptelMovil').html("(*)");

                $('#MainContent_ProfSug1Prof').hide();
                $('#MainContent_ProfSug1').hide();
                $('#MainContent_tdProfSugTxt').hide();
                $('#MainContent_tdProfSugSel').hide();
                $('#MainContent_tdTipoCasotxt').hide();
                $('#MainContent_tdTipoCasosel').hide();
            }
            else {
                llena_regiones(0);
                llena_comunas(0, 0);
                llena_regionesEmp(0);
                llena_comunasEmp(0, 0);
                llena_regionesPac(0);
                llena_comunasPac(0, 0);

                $('#MainContent_tdsolFormObser').show();
                $('#MainContent_tdsolRegepttxt').show();
                $('#MainContent_tdsolRegeptsel').show();
                $('#MainContent_tdsolComepttxt').show();
                $('#MainContent_tdsolComeptsel').show();

                $('#spDirEmp').html("(*)");
                $('#spConEmp').html("(*)");
                $('#spConTel').html("(*)");
                $('#cabPant').html("(Información del Tipo y lugar a realizar la EPT)");

                $('#sptelMovil').html("");

                $('#MainContent_ProfSug1Prof').show();
                $('#MainContent_ProfSug1').show();
                $('#MainContent_tdProfSugTxt').show();
                $('#MainContent_tdProfSugSel').show();
                $('#MainContent_tdTipoCasotxt').show();
                $('#MainContent_tdTipoCasosel').show();
            }

            llena_Combos('MainContent_solGeneroPac', 0, 1, 0);
            $('#MainContent_foIngresolb').hide();
            $('#MainContent_foIngresoVal').hide();

            llena_Pregunta_Factores(0);
            filaFacRiesgos(0);
            //llena_regiones(0);
            //llena_Profesionales_Sug(0, 0);
            //llena_regionesEmp(0);
            //llena_regionesPac(0);
            //llena_comunas(0, 0);
            //llena_comunasPac(0, 0);
            //llena_comunasEmp(0, 0);
            $.datepicker.setDefaults($.datepicker.regional['es2']);
            $('#MainContent_solFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
            $('#MainContent_codSolHidden').val(f.getDate() + "" + (f.getMonth() + 1) + "" + f.getFullYear() + "" + hours + "" + minutes + "" + seconds);
            limpiarForm();
            $('#MainContent_trSegmento1').show();
            llena_segLat('MainContent_solSeg', 'MainContent_solLat', 1, 0);
            for (var seg = 2; seg <= 12; seg++) {
                //$('#MainContent_trSegmento' + seg).hide();
                MostrarSeg(seg, seg - 1, 2);
                limpia_segLat('MainContent_solSeg', 'MainContent_solLat', seg);
            }

            $('#button-GuardarSol').show();

            $.ajax({
                type: "GET",
                url: "validaFechaHora.ashx",
                data: { orden: '' },
                dataType: "xml",
                success: function (xml) {
                    $('row', xml).each(function (i) {
                        if ($(this).find('REGISTRA').text() == '1')
                        {
                            $('#dialog').dialog('open');
                        }
                        else
                        {
                            $("#msnResult").html('<b>Señor(a) ' + '<%=(string)(Session["nomUsuario"])%>' + '</b>, le recordamos que el horario de ingreso de solicitudes al Sistema se extiende entre las 8:30 y las 18:00 horas, de Lunes a Viernes, salvo festivos, de manera que le solicitamos ingresar los casos que requiera dentro de dicho horarios.');
                            $("#resultadoIngreso").dialog('open');
                        }
                    });
                }
            });

            validarFrm();
        }

        function datosEmpresa(rut) {
           // alert(rut);
            $.ajax({
                type: "GET",
                url: "datosEmpresa.ashx",
                data: { rut: rut },
                dataType: "xml",
                success: function (xml) {
                    $('row', xml).each(function (i) {
                        $('#MainContent_solEmpNom').val($(this).find('NOMBRE').text());

                        /*if ($(this).find('SOLPEN').text() != '0') {
                            $("#tablaLog").html("");
                            var arregloDeCadenas = $(this).find('DETSOLPEN').text().split("--FIN--");

                            for (var i = 0; i < arregloDeCadenas.length; i++) {
                                var tds = $("#tablaLog tr:first td").length;
                                var trs = $("#tablaLog tr").length;
                                var nuevaFila = "<tr>";

                                //for (var c = 0; c < tds; c++) {
                                nuevaFila += "<td>" + arregloDeCadenas[i] + "</td>";
                                //}

                                //nuevaFila += "<td>" + arregloDeCadenas[i];
                                nuevaFila += "</tr>";
                                $("#tablaLog").append(nuevaFila);
                            }
                            $('#solPend').dialog('open');
                        }*/
                    });
                }
            });
        }

        function verificaOrden(orden) {
            $.ajax({
                type: "GET",
                url: "datosOrden.ashx",
                data: { orden: orden, proy: '<%=(string)(Session["IDProyecto"])%>' },
                dataType: "xml",
                success: function (xml) {
                    $('row', xml).each(function (i) {
                        if ($(this).find('TOTAL').text()!='0') {
                            $('#resultadoOS').dialog('open');
                            $('#button-GuardarSol').hide();
                        }
                        else {
                            $('#button-GuardarSol').show();
                        }
                    });
                }
            });
        }


        function datostrabajador(rut) {
            // alert(rut);
            $.ajax({
                type: "GET",
                url: "datosTrabajador.ashx",
                data: { rut: rut },
                dataType: "xml",
                success: function (xml) {
                    $('row', xml).each(function (i) {
                        $('#MainContent_solNomPac').val($(this).find('NOMBRE').text());
                        $('#MainContent_solTelFijo').val($(this).find('FONO_FIJO').text());
                        $('#MainContent_solTelMovil').val($(this).find('FONO_MOVIL').text());
                        $('#MainContent_solEmailPac').val($(this).find('EMAIL').text());
                        $('#MainContent_solDirPac').val($(this).find('DIRECCION').text());
                        llena_Combos('MainContent_solGeneroPac', $(this).find('ID_GENERO').text(), 1, 0);

                        if ($(this).find('SOLPEN').text() != '0') {
                          $("#tablaLog").html("");
                          var arregloDeCadenas = $(this).find('DETSOLPEN').text().split("--FIN--");

                          for (var i = 0; i < arregloDeCadenas.length; i++) {
                              var tds = $("#tablaLog tr:first td").length;
                              var trs = $("#tablaLog tr").length;
                              var nuevaFila = "<tr>";

                              //for (var c = 0; c < tds; c++) {
                              nuevaFila += "<td>" + arregloDeCadenas[i] + "</td>";
                              //}

                              //nuevaFila += "<td>" + arregloDeCadenas[i];
                              nuevaFila += "</tr>";
                              $("#tablaLog").append(nuevaFila);
                          }
                          $('#solPend').dialog('open');
                      }
                    });
                }
            });
        }

        function tablaAgenda(prof, fecha) {
            sUrl = 'jqGridAgenda.ashx?f=' + fecha + '&p=' + prof;

            if (cargadaAgenda) {
                jQuery("#jQGridAgenda").jqGrid('setGridParam', { url: sUrl });
                jQuery("#jQGridAgenda").trigger("reloadGrid");
            } else {
                cargadaAgenda = true;
                jQuery("#jQGridAgenda").jqGrid({
                    url: sUrl,
                    datatype: "xml",
                    colNames: ['Horario', 'Estado'],
                    colModel: [
                                { name: 'hora', index: 'hora', width: 13, stype: 'text' },
                                { name: 'status', index: 'status', width: 13, stype: 'text' }
                    ],
                    rowNum: 50,
                    width: 300,
                    height: 200,
                    mtype: 'GET',
                    loadonce: false,
                    rowList: [50, 100, 200],
                    pager: '#jQGridAgendaPager',
                    sortname: 'ID_ACTIVIDAD',
                    viewrecords: false,
                    sortorder: 'desc',
                    caption: "Agenda",
                    onSelectRow: function (id) {
                        var rowId = jQuery("#jQGridAgenda").jqGrid('getGridParam', 'selrow');
                        var rowData = jQuery("#jQGridAgenda").getRowData(rowId);
                        var colData = rowData['hora'].replace('<b>', '').replace('</b>', '');
                        
                        llena_hDisponibles(colData, $("#asiProf").val());
                        llena_hDisponibles2(colData, $("#asiProf").val());
                     }
                });

                $('#jQGridAgenda').jqGrid('navGrid', '#jQGridAgendaPager',
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
            }
            //llena_hDisponibles('00:01', prof);
        }

        function llena_hDisponibles(id_hora, prof) {
            $("#asiHoraDis").html("");
            $.ajax({
                type: "GET",
                url: "listaHoras.ashx",
                data: { p: prof, f: $("#asiFecha").val(), h: id_hora },
                dataType: "xml",
                success: function (xml) {
                    $("#asiHoraDis").append("<option value=\"\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id_hora == $(this).find('hora').text())
                            $("#asiHoraDis").append('<option value="' + $(this).find('hora').text() + '" selected="selected">' +
                                                                    $(this).find('hora').text() + '</option>');
                        else
                            $("#asiHoraDis").append('<option value="' + $(this).find('hora').text() + '" >' +
                                                                    $(this).find('hora').text() + '</option>');
                    });
                }
            });
        }

        function llena_hDisponibles2(id_hora, prof) {
            $("#asiHoraHasta").html("");
            $.ajax({
                type: "GET",
                url: "listaHoras.ashx",
                data: { p: prof, f: $("#asiFecha").val(), h: id_hora },
                dataType: "xml",
                success: function (xml) {
                    $("#asiHoraHasta").append("<option value=\"\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id_hora == $(this).find('hora').text())
                            $("#asiHoraHasta").append('<option value="' + $(this).find('hora').text() + '" selected="selected">' +
                                                                    $(this).find('hora').text() + '</option>');
                        else
                            $("#asiHoraHasta").append('<option value="' + $(this).find('hora').text() + '" >' +
                                                                    $(this).find('hora').text() + '</option>');
                    });
                }
            });
        }

        function llena_segmentos(id) {
            //alert(id);
            $("#actsolSeg").html("");
            $.ajax({
                type: "GET",
                url: "listaSegmentos.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#actsolSeg").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#actsolSeg").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#actsolSeg").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_lateridad(id) {
            //alert(id);
            $("#actsolLat").html("");
            $.ajax({
                type: "GET",
                url: "listaLateridad.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#actsolLat").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#actsolLat").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#actsolLat").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_casos(id) {
            //alert(id);
            $("#actsolCaso").html("");
            $.ajax({
                type: "GET",
                url: "listaCasos.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#actsolCaso").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#actsolCaso").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#actsolCaso").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_casos_Sol(id) {
            //alert(id);
            $("#MainContent_solCaso").html("");
            $.ajax({
                type: "GET",
                url: "listaCasos.ashx",
                data: { id: id },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_solCaso").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#MainContent_solCaso").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#MainContent_solCaso").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_Tipo_Servicio(id_tipo) {
            $("#MainContent_solTipoServicio").html("");
            //$("#MainContent_solTipoServicio").append("<option value=\"\">Seleccione</option>");
            if (id_tipo == 1) {
                $("#MainContent_solTipoServicio").append("<option value=\"1\" selected=\"selected\">Evaluación y EPT</option>");
                $("#MainContent_solTipoServicio").append("<option value=\"2\">Sólo EPT</option>");
            } else if (id_tipo == 2) {
                $("#MainContent_solTipoServicio").append("<option value=\"1\">Evaluación y EPT</option>");
                $("#MainContent_solTipoServicio").append("<option value=\"2\" selected=\"selected\">Sólo EPT</option>");
            } else {
                $("#MainContent_solTipoServicio").append("<option value=\"1\">Evaluación y EPT</option>");
                $("#MainContent_solTipoServicio").append("<option value=\"2\">Sólo EPT</option>");
            }
        }

        function muestraCargaDoc(id) {
            if ('<%=(string)(Session["IDProyecto"])%>' == '2' && $("#MainContent_solTipo").val() == "2") {
                $("#MainContent_trAdDoc").hide();
            }
            else {
                $("#MainContent_trAdDoc").show();
            }

            $('#MainContent_ProfSug1').html('Prof. Sug. Eval. Clinico : ');
            if ($("#MainContent_solTipo").val() == "2") {
                if ('<%=(string)(Session["IDProyecto"])%>' != '2') {
                        $("#MainContent_tdProfSugTxt").show();
                        $("#MainContent_tdProfSugSel").show();
                }
                $("#MainContent_tdDocConsultaTxt").hide();
                $("#MainContent_tdDocConsultaSel").hide();
                $("#MainContent_tdDocListaTestigosTxt").hide();
                $("#MainContent_tdDocListaTestigosSel").hide();

                $('#MainContent_FileDocListaTestigos').val("");
                $('#MainContent_FileDocMotConsulta').val("");

                if (id == "2") {
                    $('#MainContent_solProf').html("");
                    $('#MainContent_solProfEva').html("");
                    $("#MainContent_tdProfSugTxt").hide();
                    $("#MainContent_tdProfSugSel").hide();
                    $("#MainContent_tdDocConsultaTxt").show();
                    $("#MainContent_tdDocConsultaSel").show();
                    $("#MainContent_tdDocListaTestigosTxt").show();
                    $("#MainContent_tdDocListaTestigosSel").show();
                    $("#MainContent_trAdDoc").hide();
                    $('#MainContent_ProfSug1').html('Profesional Sugerido EPT: ');
                    llena_Profesionales_SugServicio(0, $('#MainContent_solReg').val());
                }
                else if (id == "1") {
                    $('#MainContent_solProf').html("");
                    $('#MainContent_solProfEva').html("");
                    $('#MainContent_ProfSug1').html('Prof. Sug. Eval. Clinico : ');
                    llena_Profesionales_Sug(0, $('#MainContent_solReg').val(), 2);
                    llena_Profesionales_SugEva(0, $('#MainContent_solReg').val(), 2, 0);
                }
            }
            else {
                $('#MainContent_ProfSug1').html('Profesional Sugerido EPT: ');
            }
        }

        function llena_Tipo_ServicioAct(id_tipo) {
            $("#actsolTipoServicio").html("");
            //$("#MainContent_solTipoServicio").append("<option value=\"\">Seleccione</option>");
            if (id_tipo == 1) {
                $("#actsolTipoServicio").append("<option value=\"1\" selected=\"selected\">Evaluación y EPT</option>");
                $("#actsolTipoServicio").append("<option value=\"2\">Sólo EPT</option>");
            } else if (id_tipo == 2) {
                $("#actsolTipoServicio").append("<option value=\"1\">Evaluación y EPT</option>");
                $("#actsolTipoServicio").append("<option value=\"2\" selected=\"selected\">Sólo EPT</option>");
            } else {
                $("#actsolTipoServicio").append("<option value=\"1\">Evaluación y EPT</option>");
                $("#actsolTipoServicio").append("<option value=\"2\">Sólo EPT</option>");
            }
        }

        function llena_Profesionales_SugServicio(id, id_region) {
            $("#MainContent_solProf").html("");
            $.ajax({
                type: "GET",
                url: "listarProfesionalesTipo.ashx",
                data: { t: '2', r: id_region, s: '0', proy: '<%=(string)(Session["IDProyecto"])%>' },
                dataType: "xml",
                success: function (xml) {
                    $("#MainContent_solProf").append("<option value=\"\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#MainContent_solProf").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#MainContent_solProf").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_Combos(control, id, query, filtro) {
            $("#" + control).html("");
            $.ajax({
                type: "GET",
                url: "ListaCombos.ashx",
                data: { query: query, filtro: filtro },
                dataType: "xml",
                success: function (xml) {
                    $("#" + control).append("<option value=\"\">Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#" + control).append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#" + control).append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }

        function llena_Pregunta_Factores(id_Pfactor) {
            muestraCriterios(0);
            $("#MainContent_solPregFactores").html("");
            if (id_Pfactor == 1) {
                $("#MainContent_solPregFactores").append("<option value=\"0\">Seleccione</option>");
                $("#MainContent_solPregFactores").append("<option value=\"1\" selected=\"selected\">Si</option>");
                $("#MainContent_solPregFactores").append("<option value=\"2\">No</option>");
            } else if (id_Pfactor == 2) {
                $("#MainContent_solPregFactores").append("<option value=\"0\">Seleccione</option>");
                $("#MainContent_solPregFactores").append("<option value=\"1\">Si</option>");
                $("#MainContent_solPregFactores").append("<option value=\"2\" selected=\"selected\">No</option>");
            } else {
                $("#MainContent_solPregFactores").append("<option value=\"0\">Seleccione</option>");
                $("#MainContent_solPregFactores").append("<option value=\"1\">Si</option>");
                $("#MainContent_solPregFactores").append("<option value=\"2\">No</option>");
            }
        }

        function muestraCriterios(id) {
            $("#MainContent_tdLbCriterios").hide();
            $("#MainContent_tdLbCriterios2").hide();
            $("#MainContent_countMacAgen").val("0");

            for (var NFR = 1; NFR <= 18; NFR++) {
                $('#FR_' + NFR).attr('checked', false);
            }

            if (id == "1") {
                $("#MainContent_tdLbCriterios").show();
                $("#MainContent_tdLbCriterios2").show();
            }
        }

        function filaFacRiesgos(id) {
            $("#MainContent_trFacRiesgos").hide();
            llena_Pregunta_Factores(0);

            if (id == "2") {
                $("#MainContent_trFacRiesgos").show();
            }
        }
    </script>

<div id="modal_dialog">
    <div id="tabs" style="height:890px">
	    <ul>
		    <li><a href="#tabs-1">Solicitud</a></li>
            <%if ((string)(Session["TpUsuario"]) == "0")
            { 
            %>
		    <li><a href="#tabs-2">Acciones</a></li>
		    <li><a href="#tabs-3">Asignaciones</a></li>
		    <li><a href="#tabs-4">Actividades</a></li>
		    <li><a href="#tabs-5">Documentación Final</a></li>
            <%
            }
            %>
	    </ul>
	    <div id="tabs-1" style="font-size: 10px;">
        <table id="tablActSol" style="width:1110px;">
            <tr>
                <td colspan="6"><strong>Datos Solicitud</strong>&nbsp;&nbsp;<span><font color="red">(Información del Tipo y lugar a realizar la EPT)</font></span><HR></td>
            </tr>
	        <tr>
		        <td style="width:180px;">Solicitante : </td>
                <td style="width:280px;"><label id="lbsolicitante" name="lbsolicitante"></label></td>
                <td style="width:200px;">Fecha : </td>
                <td style="width:280px;"><input name="actsolFecha" type="text" maxlength="50" id="actsolFecha" style="width:40%;" /></td>
                <td style="width:180px;">Hora : </td>
                <td style="width:280px;"><input name="actsolHora" type="text" maxlength="11" id="actsolHora" onblur="validaHoraAct(this.value);" style="width:30%;" /></td>
	        </tr>
            <tr>
		        <td>Tipo : </td>
                <td><label id="actsolTipo" name="actsolTipo" onchange="muestraSegmento(this.value);"></label></td>
                <td>Región EPT : </td>
                <td><select name="actsolReg" id="actsolReg" onchange="llena_comunasAct(this.value,0);" style="width:100%;"></select></td>
                <td>Comuna EPT : </td>
                <td><select name="actsolCom" id="actsolCom" style="width:80%;"></select></td>
	        </tr>
            <tr>
		        <td>Forma Ingreso : </td>
                <td name="actsolForma" id="actsolForma"></td>
                <td>Observaciones : </td>
                <td colspan="4"><input name="actsolObs" type="text" maxlength="30" id="actsolObs" style="width:90%;"/></td>
	        </tr>
            <tr>
                <td colspan="6"><strong>Datos Paciente</strong> <HR></td>
            </tr>
            <tr>
		        <td>Rut Paciente : </td>
                <td><input name="actsolRutPac" type="text" maxlength="10" id="actsolRutPac" style="width:40%;" /></td>
                <td>Nombre Paciente : </td>
                <td><input name="actsolNomPac" type="text" maxlength="50" id="actsolNomPac" style="width:100%;"/></td>
                <td>Orden Siniestro : </td>
                <td><input name="actsolSin" type="text" maxlength="50" id="actsolSin" /></td>
	        </tr>
            <tr>
		        <td>Teléfono Fijo : </td>
                <td><input name="actsolTelFijo" type="text" maxlength="50" id="actsolTelFijo" /></td>
                <td>Teléfono Móvil : </td>
                <td><input name="actsolTelMovil" type="text" maxlength="50" id="actsolTelMovil" /></td>
		        <td>Email : </td>
                <td><input name="actsolEmailPac" type="text" maxlength="50" id="actsolEmailPac" /></td>
	        </tr>
            <tr>
                <td>Región : </td>
                <td><select name="actsolRegPac" id="actsolRegPac" onchange="llena_comunasActPac(this.value,0);" style="width:100%;">
		        </select></td>
                <td>Comuna : </td>
                <td><select name="actsolComPac" id="actsolComPac" style="width:100%;"></select></td>
                <td>Dirección : </td>
                <td><input name="actsolDirPac" type="text" maxlength="50" id="actsolDirPac" /></td>
	        </tr>
            <tr>
                <td>Género : </td>
                <td><select name="actsolGeneroPac" id="actsolGeneroPac" style="width:100%;"></select></td>
	        </tr>
            <tr>
                <td colspan="6"><strong>Datos Empresa</strong> <HR></td>
            </tr>
            <tr>
		        <td>Rut Empresa : </td>
                <td><input name="actsolEmp" type="text" maxlength="10" id="actsolEmp" style="width:40%;" /></td>
                <td>Nombre Empresa : </td>
                <td><input name="actsolEmpNom" type="text" maxlength="50" id="actsolEmpNom" style="width:100%;" /></td>
	        </tr>
            <tr>
		        <td>Región : </td>
                <td><select name="actsolRegEmp" id="actsolRegEmp" onchange="llena_comunasEmpAct(this.value,0);" style="width:100%;">
		        </select></td>
                <td>Comuna : </td>
                <td><select name="actsolComEmp" id="actsolComEmp" style="width:100%;"></select></td>
                <td>Dirección : </td>
                <td><input name="actsolDirEmp" type="text" maxlength="50" id="actsolDirEmp" /></td>
	        </tr>
            <tr>
		        <td>Contacto : </td><td><input name="actSolConEmp" type="text" maxlength="50" id="actSolConEmp" /></td>
                <td>Contacto Telefono: </td>
                <td><input name="actSolConTel" type="text" maxlength="50" id="actSolConTel" /></td>
                <td>Contacto Email : </td>
                <td><input name="actSolConEmail" type="text" maxlength="50" id="actSolConEmail" /></td>
	        </tr>
            <tr>
                <td colspan="6"><strong>Posible Enfermedad Profesional</strong> <HR></td>
            </tr>
            <tr>
		        <td>Tipo de Caso : </td>
                <td><select name="actsolCaso" id="actsolCaso">
			        <!--<option value="">Seleccione</option>
			        <option value="1">STP</option>
			        <option value="2">CTP</option>--></select></td>
                <td id="tdActProf">Profesional Sugerido EPT: </td>
                <td><select name="actsolProf" id="actsolProf"></select></td>
                <td>Observación : </td>
                <td><input name="actsolObsCaso" type="text" maxlength="50" id="actsolObsCaso" /></td>
            </tr>
            <tr id="trActSegProf">
		        <td>Tipo de Servicio:</td>
                <td><select name="actsolTipoServicio" id="actsolTipoServicio"></select></td>
                <td id="tdActProfSugTxt">Profesional Sugerido EPT: </td>
                <td id="tdActProfSugSel"><select name="actsolProfEva" id="actsolProfEva"></select></td>
            </tr>
            <tr>
                <td>Documentos</td>
                <td name="tdLink" id="tdLink"></td>
	        </tr>
            <% for (int nseg = 1; nseg <= 12; nseg++){ %>  
            <tr id="trSegmento<%=nseg%>">
		        <td>Nº Segmento : </td>
                <td><%=nseg%></td>
                <td>Segmento : </td>
                <td id="tdsolSeg<%=nseg%>"><!--<select name="actsolSeg" id="actsolSeg" style="width:90%;"></select>--></td>
                <td>Lateralidad : </td>
                <td id="tdsolLat<%=nseg%>"><!--<select name="actsolLat" id="actsolLat"></select>--></td>
	        </tr>
            <% }%>
        </table>   

	    </div>
        <%if ((string)(Session["TpUsuario"]) == "0")
            { 
        %>
	    <div id="tabs-2">
            <div id="grillaAcciones"> 
                <table id="jQGridAcciones">
                </table>
                <div id="jQGridAccionesPager">
                </div>
            </div>
	    </div>
	    <div id="tabs-3">
            <div id="grillaAsignaciones"> 
                <table id="jQGridAsignaciones">
                </table>
                <div id="jQGridAsignacionesPager">
                </div>
            </div>
	    </div>
        <div id="tabs-4">
            <div id="grillaDoc"> 
                <table id="jQGridDoc">
                </table>
                <div id="jQGridDocPager">
                </div>
            </div>
        </div>
        <div id="tabs-5">            
            <div id="grillaFinal"> 
                <table id="jQGridFinal">
                </table>
                <div id="jQGridFinalPager">
                </div>
            </div></div>
        <%
            }
        %>
    </div>
</div>

<div id="dialog">
     <form id="form1" runat="server" style="font-size: 10px;">
        <asp:Table ID="Table1" runat="server" Width="1160px" style="padding: 0px; border-spacing: 0px;">
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Datos Solicitud</strong>&nbsp;&nbsp;<span id="cabPant"><font color="red">(Información del Tipo y lugar a realizar la EPT)</font></span> <HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell Width="190">Solicitante : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell Width="260"><asp:DropDownList runat="server" ID="solSol"></asp:DropDownList></asp:TableCell>
                <asp:TableCell Width="170">Fecha : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell Width="270"><asp:TextBox runat="server" ID="solFecha" MaxLength="50" Width="40%"></asp:TextBox></asp:TableCell>
                <asp:TableCell Width="165">Hora : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell Width="280"><asp:TextBox runat="server" ID="solHora" MaxLength="11"  Width="20%" onblur="validaHora(this.value);"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Tipo : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solTipo" onchange="muestraSegmento(this.value);llena_Profesionales_Sug(0,$('#MainContent_solReg').val(),this.value);filaFacRiesgos(this.value);">
                </asp:DropDownList><asp:TextBox runat="server" ID="codSolHidden" MaxLength="50" Width="40%" Visible="True" EnableViewState="False" Enabled="False" BackColor="White" BorderColor="White" BorderStyle="None" ForeColor="White">
                </asp:TextBox></asp:TableCell>
                <asp:TableCell ID="tdsolRegepttxt">Región EPT : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell ID="tdsolRegeptsel"><asp:DropDownList runat="server" ID="solReg" Width="100%" onchange="llena_comunas(this.value,0);llena_Profesionales_Sug(0,this.value,$('#MainContent_solTipo').val());llena_Profesionales_SugEva(0, $('#MainContent_solReg').val(), 2, 0);muestraCargaDoc(0);llena_Tipo_Servicio(1);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell ID="tdsolComepttxt">Comuna EPT : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell ID="tdsolComeptsel"><asp:DropDownList runat="server" ID="solCom" Width="100%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow ID="tdsolFormObser">
                <asp:TableCell ID="foIngresolb">Forma Ingreso : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell ID="foIngresoVal"><asp:DropDownList runat="server" ID="solForma"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Observaciones : </asp:TableCell>
                <asp:TableCell ColumnSpan="4"><asp:TextBox runat="server" ID="solObs" MaxLength="300" Width="100%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Datos Paciente</strong><HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Rut Paciente : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solRutPac" MaxLength="10" Width="50%" placeholder="Rut Ej: 16313889-8" onblur="datostrabajador(this.value);"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Nombre Paciente : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solNomPac" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Orden Siniestro : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solSin" MaxLength="50" Width="100%" onblur="verificaOrden(this.value);"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Teléfono Fijo : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solTelFijo" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Teléfono Móvil : <span id="sptelMovil" style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solTelMovil" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Email : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solEmailPac" MaxLength="50"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Dirección : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solDirPac" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Región : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solRegPac" Width="100%" onchange="llena_comunasPac(this.value,0);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Comuna : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solComPac" Width="100%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Género : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solGeneroPac" Width="50%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Datos Empresa</strong><HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Rut Empresa : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solEmp" MaxLength="10" Width="50%" onblur="datosEmpresa(this.value);" placeholder="Rut Ej: 16313889-8"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Nombre Empresa : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell ColumnSpan="4"><asp:TextBox runat="server" ID="solEmpNom" MaxLength="100" Width="37%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Dirección : <span id="spDirEmp" style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solDirEmp" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Región : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solRegEmp" Width="100%" onchange="llena_comunasEmp(this.value,0);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Comuna : <span style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solComEmp" Width="100%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Contacto : <span id="spConEmp" style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="SolConEmp" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Contacto Teléfono: <span id="spConTel" style="color: red;">(*)</span></asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="SolConTel" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Contacto Email : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="SolConEmail" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Posible Enfermedad Profesional</strong><HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ID="tdTipoCasotxt">Tipo de Caso : </asp:TableCell>
                <asp:TableCell ID="tdTipoCasosel"><asp:DropDownList runat="server" ID="solCaso"></asp:DropDownList></asp:TableCell>
                <asp:TableCell ID="ProfSug1">Profesional Sugerido EPT: </asp:TableCell>
                <asp:TableCell ID="ProfSug1Prof"><asp:DropDownList runat="server" ID="solProf" Width="100%" onchange="llena_Profesionales_SugEva(0, $('#MainContent_solReg').val(), 2, this.value);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Observaciones : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solObsCaso" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow ID="trSegProf">
                <asp:TableCell>Tipo de Servicio:</asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solTipoServicio" Width="70%" onchange="muestraCargaDoc(this.value);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell ID="tdProfSugTxt">Profesional Sugerido EPT: </asp:TableCell>
                <asp:TableCell ID="tdProfSugSel"><asp:DropDownList runat="server" ID="solProfEva" Width="100%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell ID="tdDocConsultaTxt">Doc. Motivo de Consulta: </asp:TableCell>
                <asp:TableCell ID="tdDocConsultaSel"><asp:FileUpload ID="FileDocMotConsulta" runat="server" Width="90%" accept="png|jpg|pdf"/></asp:TableCell>
                <asp:TableCell ID="tdDocListaTestigosTxt">Doc. Lista de Testigos: </asp:TableCell>
                <asp:TableCell ID="tdDocListaTestigosSel"><asp:FileUpload ID="FileDocListaTestigos" runat="server" Width="95%" accept="png|jpg|pdf"/></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow ID="trFacRiesgos">
                            <asp:TableCell>¿Tiene Factores de Riesgos Laborales?</asp:TableCell>
                            <asp:TableCell><asp:DropDownList runat="server" ID="solPregFactores" Width="35%" onchange="muestraCriterios(this.value);"></asp:DropDownList></asp:TableCell>
                            <asp:TableCell ID="tdLbCriterios">Factores Riesgos Seleccionados: </asp:TableCell>
                            <asp:TableCell ID="tdLbCriterios2">
                                           <asp:TextBox runat="server" ID="countMacAgen" Width="10%" ReadOnly="TRUE"></asp:TextBox>
                                           <asp:Image ToolTip="Al pinchar acá Ud. puede agregar Factores de Riesgos." ID="AgregarFactores" runat="server" ImageUrl="images/AgregarS.png" onclick="$('#resultadoFactores').dialog('open');"></asp:Image>
                                           <asp:TextBox runat="server" ID="MacAgenHidden" Width="5%" Visible="True" EnableViewState="False" Enabled="False" BackColor="White" BorderColor="White" BorderStyle="None" ForeColor="White"></asp:TextBox> 
                            </asp:TableCell>
             </asp:TableRow>
            <asp:TableRow ID="trAdDoc">
                <asp:TableCell>Adjuntar Documentos : </asp:TableCell>
                <asp:TableCell>
                    <asp:FileUpload ID="solArch" runat="server" Width="80%" class="multi" accept="png|jpg|pdf|xls|xlsx" />
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow ID="trSegmento1" >                
                <asp:TableCell>Nº Segmento : </asp:TableCell>
                <asp:TableCell>1<!--<asp:DropDownList runat="server" ID="solNseg"></asp:DropDownList>--></asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg1" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat1"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar1" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(2,1,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 2, 0);"></asp:Image></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento2" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>2</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg2" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat2"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar2" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(3,2,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 3, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove2" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(2,1,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 2);"/></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento3" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>3</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg3" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat3"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar3" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(4,3,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 4, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove3" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(3,2,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 3);"/></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento4" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>4</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg4" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat4"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar4" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(5,4,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 5, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove4" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(4,3,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 4);"/></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento5" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>5</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg5" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat5"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar5" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(6,5,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 6, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove5" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(5,4,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 5);"/></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento6" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>6</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg6" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat6"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar6" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(7,6,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 7, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove6" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(6,5,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 6);"/></asp:TableCell>
            </asp:TableRow> 
            <asp:TableRow ID="trSegmento7" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>7</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg7" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat7"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar7" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(8,7,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 8, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove7" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(7,6,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 7);"/></asp:TableCell>
            </asp:TableRow>    
            <asp:TableRow ID="trSegmento8" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>8</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg8" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat8"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar8" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(9,8,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 9, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove8" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(8,7,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 8);"/></asp:TableCell>
            </asp:TableRow>   
            <asp:TableRow ID="trSegmento9" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>9</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg9" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat9"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar9" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(10,9,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 10, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove9" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(9,8,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 9);"/></asp:TableCell>
            </asp:TableRow>       
            <asp:TableRow ID="trSegmento10" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>10</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg10" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat10"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar10" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(11,10,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 11, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove10" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(10,9,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 10);"/></asp:TableCell>
            </asp:TableRow> 
            <asp:TableRow ID="trSegmento11" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>11</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg11" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat11"></asp:DropDownList>&nbsp;&nbsp;<asp:Image ToolTip="Al pinchar acá Ud. puede agregar más lateralidad." id="Agregar11" runat="server" ImageUrl="images/AgregarS.png" onclick="MostrarSeg(12,11,1); llena_segLat('MainContent_solSeg','MainContent_solLat', 12, 0);" />&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove11" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(11,10,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 11);"/></asp:TableCell>
            </asp:TableRow>                                                        
            <asp:TableRow ID="trSegmento12" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>12</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg12" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat12"></asp:DropDownList>&nbsp;&nbsp;&nbsp;<asp:Image ToolTip="Eliminar lateralidad." id="Remove12" runat="server" ImageUrl="images/removeS.png" onclick="MostrarSeg(12,11,2); limpia_segLat('MainContent_solSeg','MainContent_solLat', 12);"/></asp:TableCell>
            </asp:TableRow>  

        </asp:Table>
    </form> 
</div>

<div id="dialog_asignacion">
    <form id="formAsignacion" style="font-size: 11px;">
         <table id="tablaAsignacion">
            <tr>
                <td>Región : </td>
                <td><select name="asiReg" id="asiReg" style="width:50%;" onchange="llena_Profesionales(0,this.value,0);" ></select></td>
            </tr>
            <tr>
                <td style="width:160px;">Fecha Programación : </td>
                <td><input name="asiFecha" type="text" maxlength="50" id="asiFecha" style="width:25%;" onchange="tablaAgenda($('#asiProf').val(), $('#asiFecha').val());llena_hDisponibles(0, $('#asiProf').val());llena_hDisponibles2(0, $('#asiProf').val());"/></td>
            </tr>
            <tr>                
                <td>Profesional : </td>
                <td><select name="asiProf" id="asiProf" style="width:50%;" onchange="tablaAgenda(this.value, $('#asiFecha').val());llena_hDisponibles(0, this.value);llena_hDisponibles2(0, $('#asiProf').val());llena_TipoAsignacion(0, this.value);"></select></td>
            </tr>
            <tr>
                <td>Tipo Actividad : </td>
                <td><select name="asiTipo" id="asiTipo" style="width:50%;"></select></td>
            </tr>
            <tr>                
                <td>Agenda : </td>
                <td><table id="jQGridAgenda"></table>
                    <div id="jQGridAgendaPager"></div>
                </td>
            </tr>
            <tr>                
                <td>Horas : </td>
                <td>Inicio : <select name="asiHoraDis" id="asiHoraDis" style="width:20%;"></select>
                    Hasta : <select name="asiHoraHasta" id="asiHoraHasta" style="width:20%;"></select>
                </td>
            </tr>
            <tr>
                <td>Dirección : </td>
                <td><input name="asiDir" type="text" maxlength="50" id="asiDir" style="width:50%;"/></td>
            </tr>
        </table>
    </form> 
</div>

<div id="dialog_accion">
    <form id="formAccion" style="font-size: 11px;">
         <table id="tablaAccion">
            <tr>
                <td>Tipo : </td>
                <td><select name="accTipo" id="accTipo" style="width:50%;" onchange="muestraCorreo(this.value)"></select></td>
            </tr>
            <tr id="trdestino">
                <td style="width:100px;">Interacción : </td>
                <td><select name="accDestinatario" id="accDestinatario" style="width:50%;">
                    <option value="0">Seleccione</option>
                                <option value="1">Paciente</option>
                                <option value="2">Empresa</option>
                                <option value="3">Profesional</option>
                                <option value="4">Otros</option>
                    </select></td>
            </tr>
            <tr style="display:none" id="trcorreo">
                <td style="width:100px;">Correo : </td>
                <td><input name="accCorreo" type="text" maxlength="50" id="accCorreo" style="width:50%;" /></td>
            </tr>
            <tr>
                <td style="width:100px;">Fecha : </td>
                <td><input name="accFecha" type="text" maxlength="50" id="accFecha" style="width:18%;" /></td>
            </tr>
            <tr>                
                <td>Observación : </td>
                <td><textarea id="accObs" name="accObs" cols="30" rows="6"></textarea></td>
            </tr>
            <tr id="accSubeDoc">                
                <td>Documento : </td>
                <td><input id="AccArch" name="AccArch" type="file" /></td>
            </tr>
            <tr id="accVerDoc">                
                <td>Documento : </td>
                <td id="docAcc"></td>
            </tr>
        </table>
    </form> 
</div>

<div id="dialog_Final">
    <form id="formFinal" style="font-size: 11px;">
         <table id="tablaFinal">
            <tr>
                <td>Tipo : </td>
                <td><select name="accTipoFinal" id="accTipoFinal" style="width:50%;"></select></td>
            </tr>
            <tr>
                <td style="width:100px;">Fecha : </td>
                <td><input name="accFechaFinal" type="text" maxlength="50" id="accFechaFinal" style="width:18%;" /></td>
            </tr>
            <tr>                
                <td>Observación : </td>
                <td><textarea id="accObsFinal" name="accObsFinal" cols="30" rows="6"></textarea></td>
            </tr>
            <tr>                
                <td>Documento : </td>
                <td><input id="fileUpload" name="fileUpload" type="file" /></td>
            </tr>
        </table>
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

<div id="Doc" title="Pagina">
	<iframe style="width:100%;height:100%" id="ifPagina"></iframe>
</div>

<div id="DocRev" title="Pagina">
	<iframe style="width:100%;height:70%" id="ifPagina2"></iframe>
    <form id="formRev" style="font-size: 11px;">
         <table id="tablaRev">
            <tr>                
                <td style="width:110px;">Observación : 
                                        <input id="revActId" name="revActId" type="hidden">
                                        <input id="revActDetId" name="revActDetId" type="hidden">
                </td>
                <td><textarea id="revObs" name="revObs" cols="50" rows="6"></textarea></td>
            </tr>
        </table>
    </form> 
</div>

<div id="solPend" style="font-size: 11px;">
             <label id="lbmensajeLog"><b>Estimado Usuario, el paciente ingresado se encuentra con los siguientes Casos pendientes, Desea Continuar?</b></label>
             <table id="tablaLog">

             </table>
</div>

<div id="sendConf" title="Enviando">
     <p align="center"><label id="sendMsn" name="sendMsn"></label></br></br><img src="Images/loadfbk.gif"/></p>
</div>

<div id="resultadoIngreso" title="Registro de Solicitud">
     <p id="msnResult"></p>
</div>

<div id="resultadoOS" title="Orden de Siniestro" style="font-size: 11px;">
      <label id="lbmensajeOS"><b>Estimado Usuario:</b> La Orden de Siniestro Ingresada ya se encuentra Registrada.</label>
</div>

<div id="resultadoFactores" title="Registro de Factores de Riesgos">
        <font size="1">
        	<table ID="tablaFacRiesgos">           
	        <tr>
                    <td style="width:200px;">
                        <input type="checkbox" ID="FR_1" />1. Sobrecarga
                    </td>
                    <td style="width:200px;">
                        <input type="checkbox" ID="FR_7" />7. Limitación o imposibilidad de regular por el/la trabajador/a la cantidad de trabajo diario, el ritmo de trabajo, las pausas, y la libertad para alternarlos
                    </td>
                    <td style="width:200px;">
                        <input type="checkbox" ID="FR_13" />13. Conflictos interpersonales recurrentes
                    </td>
                </tr>
            <tr>
                    <td>
                        <input type="checkbox" ID="FR_2" />2. Subcarga
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_8" />8. Limitación o imposibilidad de tomar decisiones por el/la trabajador/a relacionadas con el ejercicio de su trabajo
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_14" />14. Condiciones organizacionales hostiles o bien cultura organizacional estresante
                    </td>
                </tr>
            <tr>
                    <td>
                        <input type="checkbox" ID="FR_3" />3. Ausencia de descansos
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_9" />9. Limitación o imposibilidad de regular permisos o vacaciones por el/la trabajador/a.
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_15" />15. Funcionalidad de la jefatura
                    </td>
                </tr>
            <tr>
                    <td>
                        <input type="checkbox" ID="FR_4" />4. Tareas excesivamente rutinarias
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_10" />10. Carencia de utilización de habilidades del trabajador; ausencia de mecanismos para contribuir a mejoras en la producción.
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_16" />16. Hostilidad de la jefatura
                    </td>
                </tr>
            <tr>
                    <td>
                        <input type="checkbox" ID="FR_5" />5. Exigencias psicológicas del trabajo
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_11" />11. Ausencia de ayuda e información necesarias para que el/la trabajador/a realice las tareas asignadas o para adaptarse a los cambios organizacionales o tecnológicos, o para afrontar hostilidad de usuarios
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_17" />17. Existencia de conductas de asedio sexual
                    </td>
                </tr>
            <tr>
                    <td>
                        <input type="checkbox" ID="FR_6" />6. Ambigüedad o conflicto de roles
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_12" />12. Ausencia de capacitación tecnológica periódica
                    </td>
                    <td>
                        <input type="checkbox" ID="FR_18" />18. Condiciones físicas o ergonómicas deficientes
                    </td>
             </tr>
	</table>  </font>
</div>
</asp:Content>

