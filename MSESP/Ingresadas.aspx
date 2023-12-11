﻿<%@ Page Title="Solicitudes Ingresadas" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Ingresadas.aspx.cs" Inherits="MSESP.Ingresadas" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent"> 
    <link href="Content/style.css" rel="stylesheet" type="text/css" />
    <script src="Scripts/js/comboTreePlugin.js" type="text/javascript"></script>
    <script src="Scripts/js/icontains.js" type="text/javascript"></script>
    <script type="text/javascript">
        var validator = "";
        var validatorAccion = "";
        var validatorAsignacion = "";
        var validatorFinal = "";
        var validatorSol = "";
        var validatorEstado = "";
        var validatorEstadoEpt = "";
        var validatorRecepionInforme = "";
        var validatorRechComite = "";
        var validatorEstadoCaso = "";
        var idSeg = "";
        var idActEpt = "";
        var idTipoRechazo = "";
        var codsol = "";
        var cargada = false;
        var cargadaAcc = false;
        var cargadaDoc = false;
        var cargadaFinal = false;
        var cargadaAgenda = false;
        var cargadaGrilla = false;

        var SampleJSONData = "";
        var selectedTitles = "";
        var selectedIds = "";
        var comboTree1 = "";
        var comboTree2 = "";

        var comboTree6 = "";

        var duplicarReg = "";
        var comboTree3 = "";
        var comboTree4 = "";
        var comboTree5 = "";

        var comboCarga = false;
        var comboCarga2 = false;

        var tipoSolAsig = "0";

        $(document).ready(function () {

            var array = ["2017-01-01", "2017-01-02", "2017-04-14", "2017-04-15", "2017-04-19", "2017-05-01", "2017-05-21", "2017-06-26", "2017-07-02",
           "2017-08-15", "2017-08-20", "2017-09-18", "2017-09-19", "2017-10-09", "2017-10-27", "2017-11-01", "2017-11-19", "2017-12-08", "2017-12-17", "2017-12-25"];
            $('#busFD').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
            $('#busFH').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });

            llena_tiposBus(0);
            llena_regionesBus(0);
            llena_comunasBus(0, 0);
            llena_agencias(0);
            llena_ano(0);

            llena_regionesProfBusc(0);
            llena_regionesProfBusc2(0);
            
            tabla();

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
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''
            };

            $.datepicker.setDefaults($.datepicker.regional['es']);

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

            $.datepicker.regional['es3'] = {
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

            $("#dialogRecepionInforme").dialog({
                title: "Seguimiento Informes",
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
                    'Guardar': function () {
                        if ($("#formRecepionInforme").valid()) {
                            var parametros = {
                                fecha: $('#RecepionInformeFecha').val(),
                                id_act: idActEpt,
                                tipo: $('#tipoRecepionFecha').val(),
                                usr: '<%=(string)(Session["IdUsuario"])%>',
                                id_sol: idSeg
                         };

                            /**/$.ajax({
                                url: 'Solicitud.aspx/recepcionInforme2',
                                type: 'POST',
                                data: JSON.stringify(parametros),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {
                                    $("#jQGridAsignaciones").trigger("reloadGrid");
                                    //validatorRecepionInforme.resetForm();
                                }
                            });
                            $(this).dialog('close');
                            $("#jQGridDemo").trigger("reloadGrid");
                     }
                    },
                    'Cerrar': function () {
                        //validatorRecepionInforme.resetForm();
                        $(this).dialog('close');
                        $("#jQGridDemo").trigger("reloadGrid");
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });

            $("#dialogRechComite").dialog({
                title: "Rechazo Comité",
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
                    'Guardar': function () {
                        if ($("#formRechComite").valid()) {
                            var parametros = {
                                rechazado: $('input[name=RechComite1]:checked').val(),
                                id_act: idActEpt,
                                tipo: idTipoRechazo,
                                usr: '<%=(string)(Session["IdUsuario"])%>'
                            };

                            $.ajax({
                                url: 'Solicitud.aspx/rechComite',
                                type: 'POST',
                                data: JSON.stringify(parametros),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {
                                    $("#jQGridAsignaciones").trigger("reloadGrid");
                                    validatorRechComite.resetForm();
                                }
                            });
                            $(this).dialog('close');
                        }
                    },
                    'Cerrar': function () {
                        validatorRechComite.resetForm();
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });

            $("#dialogEstFinaliza").dialog({
                title: "Cambiar Estado",
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
                    'Guardar': function () {
                        if ($("#formEstFinaliza").valid()) {
                            var parametros = {
                                tipo: $('#tipoEstFinaliza').val(),
                                obs: $('#obsEstFinaliza').val(),
                                fecha: $('#EstFechaFinaliza').val(),
                                id_sol: idSeg,
                                usr: '<%=(string)(Session["IdUsuario"])%>'
                            };

                            $.ajax({
                                url: 'Solicitud.aspx/cambiaEstado',
                                type: 'POST',
                                data: JSON.stringify(parametros),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {
                                    $("#jQGridDemo").trigger("reloadGrid");
                                     validatorEstadoCaso.resetForm();
                                }
                            });
                            $(this).dialog('close');
                        }
                    },
                    'Cerrar': function () {
                        validatorEstadoCaso.resetForm();
                        $(this).dialog('close');
                    }
                },
                   closeOnEscape: false,
                   open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
               });

            $("#dialogEstadoECT").dialog({
                title: "Cambiar Estado ECT",
                autoOpen: false,
                bgiframe: true,
                height: 220,
                width: 700,
                modal: true,
                overlay: {
                    backgroundColor: '#f00',
                    opacity: 0.5
                },
                buttons: {
                    'Guardar': function () {
                        if ($("#formEstadoECT").valid()) {
                            var parametros = {
                                id_estado: $('#tipoEstadoECT').val(),
                                id_sol: idSeg
                            };

                            $.ajax({
                                url: 'Solicitud.aspx/cambiaEstadoECT',
                                type: 'POST',
                                data: JSON.stringify(parametros),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {
                                    $("#jQGridDemo").trigger("reloadGrid");
                                    // validatorEstadoECT.resetForm();
                                }
                            });
                            $(this).dialog('close');
                        }
                    },
                    'Cerrar': function () {
                        // validatorEstadoECT.resetForm();
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });


            $("#dialog_delIns").dialog({
                bgiframe: true,
                autoOpen: false,
                height: 210,
                width: 400,
                modal: true,
                buttons: {
                    'Aceptar': function () {
                        var parametros = {
                            id: duplicarReg,
                            usr: '<%=(string)(Session["IdUsuario"])%>',
                            proy: '<%=(string)(Session["IDProyecto"])%>'
                        };

                        $.ajax({
                            url: 'Ingresadas.aspx/Duplicar',
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

            $("#dialog_delIns2").dialog({
                bgiframe: true,
                autoOpen: false,
                height: 210,
                width: 400,
                modal: true,
                buttons: {
                    'Aceptar': function () {
                        var parametros = {
                            id: duplicarReg,
                            usr: '<%=(string)(Session["IdUsuario"])%>',
                            proy: '<%=(string)(Session["IDProyecto"])%>'
                        };

                        $.ajax({
                            url: 'Ingresadas.aspx/Reabrir',
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

            $("#dialogEstadoEpt").dialog({
                title: "Cancelar Asignación",
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
                    'Guardar': function () {
                        if ($("#formEstadoEpt").valid()) {
                            var parametros = {
                                tipo: $('#tipoEstadoEpt').val(),
                                obs: $('#obsEstadoEpt').val(),
                                id_act: idActEpt,
                                usr: '<%=(string)(Session["IdUsuario"])%>'
                            };

                            $.ajax({
                                url: 'Solicitud.aspx/cancelaAsignacion',
                                type: 'POST',
                                data: JSON.stringify(parametros),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {
                                    $("#jQGridAsignaciones").trigger("reloadGrid");
                                    validatorEstadoEpt.resetForm();
                                }
                            });
                            $(this).dialog('close');
                        }
                    },
                    'Cerrar': function () {
                        validatorEstadoEpt.resetForm();
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });

            $("#dialogEnviar").dialog({
                title: "Enviar Notificación..",
                height: 220,
                width: 450,
                autoOpen: false,
                modal: true,
                buttons: [
                    {
                        id: "button-EnviarDE",
                        text: "Guardar",
                        click:
                            function () {
                                var parametros = {
                                    id_sol: $('#dEnviarID').val(),
                                    usr: '<%=(string)(Session["IdUsuario"])%>'
                                };

                                $.ajax({
                                    url: 'Solicitud.aspx/enviaNoti',
                                    type: 'POST',
                                    data: JSON.stringify(parametros),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function () {
                                        //$("#jQGridDemo").trigger("reloadGrid");
                                        //validatorEstado.resetForm();
                                        $(this).dialog('close');
                                    }
                                });
                                $(this).dialog('close');
                            }
                    },
                    {
                        id: "button-CerrarDE",
                        text: "Cerrar",
                        click:
                            function () {
                                $(this).dialog('close');
                            }
                    }
                ]
            });

            $("#dialogEstado").dialog({
                title: "Cambiar Estado Solicitud",
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
                    'Guardar': function () {
                         if ($("#formEstado").valid()) {
                            var parametros = {
                                tipo: $('#tipoEstado').val(),
                                obs: $('#obsEstado').val(),
                                fecha: "",
                                id_sol: idSeg,
                                usr: '<%=(string)(Session["IdUsuario"])%>'
                            };

                            $.ajax({
                                url: 'Solicitud.aspx/cambiaEstado',
                                type: 'POST',
                                data: JSON.stringify(parametros),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {
                                    $("#jQGridDemo").trigger("reloadGrid");
                                    validatorEstado.resetForm();
                                }
                            });
                            $(this).dialog('close');
                        }
                    },
                    'Cerrar': function () {
                        validatorEstado.resetForm();
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });

            $("#dialog_accion").dialog({
                title: "Registro de Acción",
                height: 420,
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
                                    data.append("accsolSegAccion", $('#actsolSegAccion').val());
                                    data.append("accsolLatAccion", $('#actsolLatAccion').val());

                                $.ajax({
                                    url: 'subeAccion.aspx',
                                    type: 'POST',
                                    contentType: false,
                                    processData: false,
                                    data: data,
                                    success: function () {
                                        $("#jQGridAcciones").trigger("reloadGrid");
                                        $("#jQGridDemo").trigger("reloadGrid");
                                        if ($('#accTipo').val() == '39') {
                                            actualizaSegLatAccion(idSeg);
                                        }
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

            $("#dialog_asignacion").dialog({
                title: "Registro de Asignación",
                height: 585,
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
                                        hora2: $('#asiHoraHasta').val(),
                                        asignacion: $('#asiCaso').val(),
                                        comuna: $('#asiComuna').val(),
                                        medio: $('#asiMed').val(),
                                        otros: $('#asiOtros').val()
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
                width: 1200,
                autoOpen: false,
                modal: true,
                close: function (event, ui) {
                    $('#busFD').datepicker("option", "maxDate", null);
                    $('#busFD').datepicker("option", "minDate", null);
                    $('#busFD').datepicker("option", "beforeShowDay", null);
                    $('#busFH').datepicker("option", "maxDate", null);
                    $('#busFH').datepicker("option", "minDate", null);
                    $('#busFH').datepicker("option", "beforeShowDay", null);
                },
                buttons: [
                {
                       //Guardar:
                       id: "button-GuardarLab",
                       text: "Guardar",
                       click:
                           function () {
                               if ($("#myForm").valid()) {
                                   //$('#sendMsn').html('Espere Mientras se Registra Solicitud.');
                                   //$("#sendConf").dialog('open');
                                   $("#actsolIDObs1").val(comboTree1.getSelectedItemsId());
                                   $("#actsolIDObs2").val(comboTree2.getSelectedItemsId());
                                   $("#actsolIDObs6").val(comboTree6.getSelectedItemsId());

                                   //alert($("#actsolIDObs1").val() + ' ' + $("#actsolIDObs2").val());

                                   $.ajax({
                                       type: "POST",
                                       url: "actualizaSolicitud.ashx",
                                       data: $('#myForm').serialize(),
                                       datatype: "xml",
                                       success: function (data) {
                                           //$('#result').html(data);
                                           $("#jQGridDemo").trigger("reloadGrid");
                                           validatorSol.resetForm();
                                       }
                                   });
                                   $(this).dialog('close');
                               }
                           }
                },
                {
                    //Guardar:
                    id: "button-GuardarLabComite",
                    text: "Registrar",
                    click:
                        function () {
                            /**/if ($("#myFormComite").valid()) {
                                $.ajax({
                                    type: "POST",
                                    url: "actualizaClasificacion.ashx",
                                    data: $('#myFormComite').serialize(),
                                    datatype: "xml",
                                    success: function (data) {
                                        //$('#result').html(data);
                                        validatorSol.resetForm();
                                    }
                                });
                                $(this).dialog('close');
                            }
                        }
                },
                   {
                       id: "button-CerrarLab",
                       text: "Cerrar",
                       click:
                           function () {
                               $(this).dialog('close');
                               $('#busFD').datepicker("option", "maxDate", null);
                               $('#busFD').datepicker("option", "minDate", null);
                               $('#busFD').datepicker("option", "beforeShowDay", null);
                               $('#busFH').datepicker("option", "maxDate", null);
                               $('#busFH').datepicker("option", "minDate", null);
                               $('#busFH').datepicker("option", "beforeShowDay", null);
                               validatorSol.resetForm();
                           }
                   }
                ]
            });

            $("#dialog").dialog({
                title: "Registro de Nueva Solicitud",
                height: 610,
                width: 1200,
                autoOpen: false,
                modal: true,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); },
                buttons: {
                    Guardar: function () {
                        //validarFrm();
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
                                        adhEmp: "12345",
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
                                        iddir: "1",
                                        idcaso: $('#MainContent_solCaso').val(),
                                        idseg: $('#MainContent_solSeg').val(),
                                        nseg: '1',//$('#MainContent_solNseg').val(),
                                        idlat: $('#MainContent_solLat').val(),
                                        dirEmp: $('#MainContent_solDirEmp').val(),
                                        obsCaso: $('#MainContent_solObsCaso').val(),
                                        codSol: $('#MainContent_codSolHidden').val(),
                                        idProf: $('#MainContent_solProf').val(),
                                        regpac: $('#MainContent_solRegPac').val(),
                                        compac: $('#MainContent_solComPac').val()
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
                    },
                    Cerrar: function () {
                        $(this).dialog('close');

                        validator.resetForm();
                    }
                }
            });
            //ventanaInicial();
        });

        function limpiarSegimiento() {
            $('#actsolID').val("0");
            llena_regionesPacAct(0);
            llena_comunasPacAct(0,0);
            llena_Profesionales_SugAct(0, 0, 0, 'actsolProf',0);
            llena_regionesAct(0);
            llena_comunasAct(0, 0);
            llena_regionesEmpAct(0);
            llena_comunasEmpAct(0, 0);
            $('#actsolDirEmp').val("");
            $('#actsolFecha').val("");
            $('#actsolHora').val("");
            $('#actsolObs').val("");
            $('#actsolSin').val("");
            $('#actSolConEmp').val("");
            $('#actSolConTel').val("");
            $('#actSolConEmail').val("");
            $('#actsolObsCaso').val("");
            $('#actsolEmp').val("");
            $('#actsolEmpNom').val("");
            $('#actsolRutPac').val("");
            $('#actsolNomPac').val("");
            $('#actsolTelFijo').val("");
            $('#actsolTelMovil').val("");
            $('#actsolDirPac').val("");
            $('#actsolEmailPac').val("");
            $('#lbsolicitante').html("");
            $('#actsolTipo').html("");
            $('#actsolForma').html("");
            llena_casos(0);
            for (var tr = 1; tr <= 12; tr++) {
                $('#trSegmento' + tr).hide();
                limpia_segLat('actsolSeg', 'actsolLat', tr);
                $('#Agregar' + tr).show();
                $('#Remove' + tr).show();
            }
            $('#tdLink').html("");
        }

        function Seguimiento(i, cod) {
                    limpiarSegimiento();
                    idSeg = i;
                    $('#modal_dialog').dialog('option', 'title', 'Solicitud N° ' + cod);

                    $.ajax({
                        type: "GET",
                        url: "datosSolicitud.ashx",
                        data: { id: i },
                        dataType: "xml",
                        success: function (xml) {
                            $('row', xml).each(function (i) {
                                $.datepicker.setDefaults($.datepicker.regional['es2']);
                                $('#tdActProf').html('Profesional Sugerido EPT: ');
                                $('#actsolID').val($(this).find('ID_SOLICITUD').text());
                                $('#IdactsolTipo').val($(this).find('ID_TIPO_SOLICITUD').text());
                                llena_regionesPacAct($(this).find('preg').text());
                                llena_comunasPacAct($(this).find('preg').text(), $(this).find('pcom').text());

                                if ($(this).find('ID_TIPO_SOLICITUD').text() != "2") {
                                    llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), $(this).find('ID_TIPO_SOLICITUD').text(), 'actsolProf',0);
                                }

                                /*$('#trActSegProf').hide();
                                if ($(this).find('ID_TIPO_SOLICITUD').text() == "2") {
                                    llena_Profesionales_SugAct($(this).find('IDPROFEVA').text(), $(this).find('ID_REGION_EPT').text(), 5, 'actsolProf',0);
                                    llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), 2, 'actsolProfEva', $(this).find('IDPROFEVA').text())
                                    $('#tdActProf').html('Prof. Sug. Eval. Clinico : ');
                                    $('#trActSegProf').show();
                                }*/

                                $('#trActSegProf').hide();
                                $('#tdActProfSugTxt').hide();
                                $('#tdActProfSugSel').hide();
                                if ($(this).find('ID_TIPO_SOLICITUD').text() == "2") {
                                    llena_Tipo_ServicioAct($(this).find('TIPOSERVICIO').text());
                                    $('#trActSegProf').show();

                                    if ($(this).find('TIPOSERVICIO').text() == "1") {
                                        llena_Profesionales_SugAct($(this).find('IDPROFEVA').text(), $(this).find('ID_REGION_EPT').text(), 5, 'actsolProf', 0);
                                        llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), 2, 'actsolProfEva', $(this).find('IDPROFEVA').text());
                                        $('#tdActProf').html('Prof. Sug. Eval. Clinico : ');
                                        $('#tdActProfSugTxt').show();
                                        $('#tdActProfSugSel').show();
                                    }
                                    else {
                                        //llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), 'actsolProf');
                                        llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text(), 2, 'actsolProf', 0);
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
                                $('#actsolHora').val($(this).find('HORA').text());

                                $('#actsolFecha').datepicker("option", "maxDate", null);
                                $('#actsolFecha').datepicker("option", "minDate", null);
                                $('#actsolFecha').datepicker("option", "beforeShowDay", null);
                                
                                if ('<%=(string)(Session["USRSuper"])%>' != "1")
                                { 
                                                    $('#actsolFecha').attr('disabled', 'disabled');
                                                    $('#actsolHora').attr('disabled', 'disabled');
                                }
                                
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
                                llena_Combos('actsolNomGrup', $(this).find('ID_GRUPO_CIUO').text(), 4, 0);
                                llena_Combos('actsolOcup', $(this).find('ID_SUBGRUPO_CIUO').text(), 5, $(this).find('ID_GRUPO_CIUO').text());
                                llena_Combos('actsolMacroAR', $(this).find('MACROAR1').text(), 3, 0);
                                llena_Criterios_Obs('actsolCriObsdemo', $(this).find('CRITERIO_OBS1').text(), 2, $(this).find('MACROAR1').text(), 1);
                                llena_Combos('actsolMacroAR2', $(this).find('MACROAR2').text(), 3, 0);
                                llena_Criterios_Obs('actsolCriObsdemo2', $(this).find('CRITERIO_OBS2').text(), 2, $(this).find('MACROAR2').text(), 2);
                                llena_Combos('actsolMacroAR6', $(this).find('MACROAR3').text(), 3, 0);
                                llena_Criterios_Obs('actsolCriObsdemo6', $(this).find('CRITERIO_OBS3').text(), 2, $(this).find('MACROAR3').text(), 6);
                                llena_Combos('actsolClaComi', $(this).find('ID_CLASIFICACION_COMITE').text(), 6, 0);
                                $('#actsolIDClaComi').val($(this).find('ID_SOLICITUD').text());
                                $('#button-GuardarLabComite').hide();
                                //$("#actsolNseg option[value=" + $(this).find('N_SEGMENTO').text() + "]").attr('selected', 'selected');
                                //$("#actsolSeg option[value=" + $(this).find('ID_SEGMENTO').text() + "]").attr('selected', 'selected');
                                //llena_segmentos($(this).find('ID_SEGMENTO').text());
                                //$("#actsolLat option[value=" + $(this).find('ID_LATERAL').text() + "]").attr('selected', 'selected');
                                //llena_lateridad($(this).find('ID_LATERAL').text());
                                //$("#actsolCaso option[value=" + $(this).find('ID_CASO').text() + "]").attr('selected', 'selected');
                                $('#actsolFecha').val($(this).find('FECHA').text());
                                for (var tr = 1; tr <= 12; tr++) {
                                    $('#trSegmento' + tr).hide();
                                    limpia_segLat('actsolSeg', 'actsolLat', tr);
                                    $('#Agregar' + tr).show();
                                    $('#Remove' + tr).show();
                                }

                                var arregloSegmentos = $(this).find('SEGN').text().split("###");

                                for (var i = 0; i < arregloSegmentos.length; i++) {
                                    if (arregloSegmentos[i] != "") {
                                        var arregloSegmentosDet = arregloSegmentos[i].split("##");

                                        for (var det = 0; det < arregloSegmentosDet.length; det++) {
                                            if (arregloSegmentosDet[det] != "") {
                                                if (det == 0) {
                                                    $('#trSegmento' + (i + 1)).show();
                                                    if(i>0){
                                                    MostrarSeg((i + 1), (i), 1);}
                                                }

                                                if (det == 1) {
                                                    llena_segmentosInicio('actsolSeg', (i + 1), arregloSegmentosDet[det])
                                                    //$('#tdsolSeg' + (i + 1)).html(arregloSegmentosDet[det]);
                                                }

                                                if (det == 2) {
                                                    llena_lateridadInicio('actsolLat', (i + 1), arregloSegmentosDet[det])
                                                    //$('#tdsolLat' + (i + 1)).html(arregloSegmentosDet[det]);
                                                }

                                                if (det == 3 && arregloSegmentosDet[det] == '1') {
                                                    $('#trSegmento' + (i + 1)).css("background-color", "#cedce2");
                                                }
                                            }
                                        }
                                    }
                                }

                                llena_casos($(this).find('ID_CASO').text());
                                //muestraSegmento($(this).find('ID_TIPO_SOLICITUD').text());

                                //$('#tdLink').html($(this).find('DOC').text().replace("*", "<a href=# onclick=verDoc('").replace("/", "');>Ver</a>"));

                                var arregloDeCadenas = $(this).find('DOC2').text().split("/");
                                var documentos = "";
                                for (var i = 0; i < arregloDeCadenas.length; i++) {
                                    if (arregloDeCadenas[i] != "") {
                                        documentos = documentos + "<b><a href='#' onclick=verDoc('" + arregloDeCadenas[i] + "'); style='color: red;'>Ver Doc. " + (i + 1) + "</a></b>&nbsp;&nbsp;";
                                    } 
                                }
                                $('#tdLink').html(documentos);

                                $("#tabs").tabs({
                                    active: 0/*,
                                    disabled: [2, 3]*/
                                });

                                validarFrmSol();
                            });
                        }
                    });

                    tablaAsignaciones(i);
                    tablaAcciones(i);
                    tablaDoc(i);
                    tablaFinal(i);
                    $('#actsolUsrMod').val('<%=(string)(Session["IdUsuario"])%>');
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
                                if (id_region == $(this).find('ID').text()) { 
                                    $("#asiReg").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                        $(this).find('NOMBRE').text() + '</option>');
                                    llena_comunas2(id_region, 0);
                                }
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
                            accTipo: "required",
                            accFecha: "required",
                            accDestinatario: "required",
                            accCorreo: {
                                required: true,
                                email: true
                            },
                            actsolSegAccion: "required",
                            actsolLatAccion: "required"
                        },
                        messages: {
                            accTipo: "&bull; Seleccione Tipo Acción.",
                            accFecha: "&bull; Ingrese Fecha Acción.",
                            accDestinatario: "&bull; Seleccione Interacción.",
                            accCorreo: {
                                required: "&bull; Ingrese Correo.",
                                email: "&bull; Email Erroneo."
                            },
                            actsolSegAccion: "&bull; Seleccione Segmento.",
                            actsolLatAccion: "&bull; Seleccione Lateridad.",
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
                                llena_TipoAccion($(this).find('ID').text());
                                muestraCorreo($(this).find('ID').text());
                                llenaTipoIte($(this).find('DES').text());
                                $('#accSubeDoc').hide();
                                $('#accVerDoc').hide();
                                if ($(this).find('DOCUMENTO').text() != "") {
                                    $('#accVerDoc').show();
                                    $('#docAcc').html("<a href=\"#\" onclick=\"verDoc('" + $(this).find('DOCUMENTO').text() + "');\">Ver</a>");
                                }

                                llena_segmentosInicio('actsolSegAccion', '', $(this).find('ID_SEGMENTO').text());
                                llena_lateridadInicio('actsolLatAccion', '', $(this).find('ID_LATERAL').text());
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

                function llena_TipoAsignacion(tipo, id_profesional) {
                    //alert($('#IdactsolTipo').val());
                    $("#asiTipo").html("");
                    $.ajax({
                        type: "GET",
                        url: "listarTipoActividadProfProg.ashx",
                        data: { t: "2", pf: id_profesional, tipoSol: $('#IdactsolTipo').val() },
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
                            asiCaso: "required",
                            asiMed: {
                                required: { depends: function (element) { if (($("#asiCaso").val() == 'Remoto') || ($("#asiCaso").val() == 'Mixto')) return true; else return false; } }
                            },
                            asiComuna: {
                                required: { depends: function (element) { if (($("#asiCaso").val() == 'Presencial') || ($("#asiCaso").val() == 'Mixto')) return true; else return false; } }
                            },
                            asiOtros: {
                                required: { depends: function (element) { if (($("#asiMed").val() == 'Otros')) return true; else return false; } }
                            },
                            asiProf: "required",
                            asiReg: "required",
                            asiHoraDis: "required",
                            asiHoraHasta: "required",
                            asiDir: "required"
                        },
                        messages: {
                            asiTipo: "&bull; Seleccione Tipo Actividad.",
                            asiFecha: "&bull; Ingrese Fecha Actividad.",
                            asiCaso: "&bull; Seleccione Asignación.",
                            asiMed: "&bull; Seleccione Medio.",
                            asiOtros: "Ingrese Otros.",
                            asiComuna: "&bull; Seleccione Comuna.",
                            asiProf: "&bull; Seleccione Profesional.",
                            asiReg: "&bull; Seleccione Región.",
                            asiHoraDis: "&bull; Seleccione.",
                            asiHoraHasta: "&bull; Seleccione.",
                            asiDir: "Ingrese Dirección."
                        }
                    });
                }

                function llena_Profesionales(id, id_region, hora, t_sol) {
                    $("#asiProf").html("");
                    $.ajax({
                        type: "GET",
                        url: "listarProfesionalesTipoSolicitud.ashx",
                        data: { t: t_sol, r: id_region, proy: '<%=(string)(Session["IDProyecto"])%>' },
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

                function llena_Profesionales_Sug(id, id_region) {
                    $("#MainContent_solProf").html("");
                    $.ajax({
                        type: "GET",
                        url: "listarProfesionales.ashx",
                        data: { t: "2", r: id_region },
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

                function llena_Profesionales_SugAct(id, id_region, tipo, pre, selprof1) {
                    $("#" + pre).html("");
                    $.ajax({
                        type: "GET",
                        url: "listarProfesionalesTipo.ashx",
                        data: { t: tipo, r: id_region, s: selprof1, proy: '<%=(string)(Session["IDProyecto"])%>' },
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
            tipoSolAsig = "";
                    $.ajax({
                        type: "GET",
                        url: "datosAsignacion.ashx",
                        data: { id: i },
                        dataType: "xml",
                        success: function (xml) {
                            $('row', xml).each(function (i) {
                                $('#asiFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                                $('#asiFecha').val($(this).find('FECHA').text());
                                llena_regionesAsig($(this).find('ID_REGION').text());

                                tipoSolAsig = $(this).find('ID_TIPO_SOLICITUD').text();

                                if (tipoSolAsig == "2") {
                                    tipoSolAsig = "2,5";
                                }

                                llena_Profesionales($(this).find('PROFESIONAL').text(), $(this).find('ID_REGION').text(), $(this).find('HORA').text(), tipoSolAsig);
                                llena_TipoAsignacion($(this).find('TIPO').text(), $(this).find('PROFESIONAL').text());
                                llena_hDisponibles($(this).find('HORA').text(), $(this).find('PROFESIONAL').text());
                                llena_hDisponibles2($(this).find('HORA2').text(), $(this).find('PROFESIONAL').text());
                                llena_Esp($(this).find('PROFESIONAL').text());
                                $('#asiDir').val($(this).find('DIR').text());
                                $("#asiTSol").val($(this).find('ID_TIPO_SOLICITUD').text());

                                llena_comunas2($(this).find('ID_REGION').text(), $(this).find('COMUNA').text());
                                $('#asiCaso').val($(this).find('ASIGNACION').text()).trigger('change');
                                $('#asiComuna').val($(this).find('COMUNA').text()).trigger('change');
                                $('#asiMed').val($(this).find('MEDIO').text());
                                $('#asiOtros').val($(this).find('OTROS').text());

                                $('#dialog_asignacion').dialog('open');
                                //$("#button-Guardar").hide();
                                if ($('#asiCaso').val() == 'Remoto') {
                                    $(".comuna").hide();
                                    $(".medio").show();

                                }
                                else if ($('#asiCaso').val() == 'Presencial') {
                                    $(".medio").hide();
                                    $(".comuna").show();

                                }
                                else if ($('#asiCaso').val() == 'Mixto') {
                                    $(".medio").show();
                                    $(".comuna").show();
                                }
                                else {
                                    $(".medio").hide();
                                    $(".comuna").hide();
                                }

                                if ($('#asiMed').val() == 'Otros') {
                                    $(".otros").show();
                                }
                                else {
                                    $(".otros").hide();

                                }
                            });
                        }
                    });
                }

                function tablaAsignaciones(id) {
                    sUrl = 'jqGridAsignaciones.ashx?id=' + id;

                    if (cargada) {
                        jQuery("#jQGridAsignaciones").jqGrid('setGridParam', { url: sUrl });
                        jQuery("#jQGridAsignaciones").trigger("reloadGrid");
                    } else {
                        cargada = true;
                        jQuery("#jQGridAsignaciones").jqGrid({
                            url: sUrl,
                            datatype: "xml",
                            colNames: ['Actividad', 'Fecha Asignación', 'Usuario', 'Profesional', 'Programación', '', '', 'F.Recepción', '', 'R.Interno', '', 'R.Comité', '', 'F.Corrección', ''],
                            colModel: [
                                        { name: 'TIPO', index: 'TIPO', width: 150, stype: 'text' },
                                        { name: 'F_Asig', index: 'F_Asig', width: 70, stype: 'text', align:'center' },
                                        { name: 'USR', index: 'USR', width: 150, stype: 'text' },
                                        { name: 'PROF', index: 'PROF', width: 150, stype: 'text' },
                                        { name: 'fecha', index: 'fecha', width: 60, stype: 'text', align: 'center' },
                                        { width: 15, stype: 'text' },
                                        { width: 15, stype: 'text' },
                                        { name: 'FECHA_RECEPCION', index: 'FECHA_RECEPCION', width: 58, stype: 'text' },
                                        { width: 15, stype: 'text' },
                                        { name: 'rechazoInterno', index: 'rechazoInterno', width: 52, stype: 'text' },
                                        { width: 15, stype: 'text' },
                                        { name: 'rechazo', index: 'rechazo', width: 52, stype: 'text' },
                                        { width: 15, stype: 'text' },
                                        { name: 'FECHA_CORRECION', index: 'FECHA_CORRECION', width: 58, stype: 'text' },
                                        { width: 18, stype: 'text' }
                            ],
                            rowNum: 50,
                            width: 1060,
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
                                $('#asiCaso').val("");
                                tipoSolAsig = "0";
                                $.ajax({
                                    type: "GET",
                                    url: "datosSolicitud.ashx",
                                    data: { id: idSeg },
                                    dataType: "xml",
                                    success: function (xml) {
                                        $('row', xml).each(function (i) {
                                            tipoSolAsig = $(this).find('ID_TIPO_SOLICITUD').text();

                                            if (tipoSolAsig == "2") {
                                                tipoSolAsig = "2,5";
                                            }
                                            //$('#MainContent_solEmpNom').val($(this).find('ID_REGION_EPT').text());
                                            llena_regionesAsig($(this).find('ID_REGION_EPT').text());
                                            llena_Profesionales(0, $(this).find('ID_REGION_EPT').text(), 0, tipoSolAsig);
                                            $("#asiTSol").val($(this).find('ID_TIPO_SOLICITUD').text());
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
                                $('#espProf').html("");
                                $('#dialog_asignacion').dialog('open');

                                $('.comuna').hide();
                                $('.medio').hide();
                                $(".otros").hide();

                                validarFrmAsignacion();
                            }
                        });
                    }
                }

                function tablaAcciones(id) {
                    sUrl = 'jqGridAcciones.ashx?id=' + id;

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
                                /*agregado*/
                                $('#trSegmentoAccion').hide();
                                $('#trdestino').show();
                                /*agregado*/
                                llenaTipoIte(0);
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

                function limpiarForm() {
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
                    MostrarSeg(2, 1, 2);
                }

                function validarFrm() {
                    validator = $("#form1").validate({
                        rules: {
                            ctl00$MainContent$solRutPac: {
                                required: true,
                                rut: true
                            },
                            ctl00$MainContent$solNomPac: "required",
                            ctl00$MainContent$solEmailPac: {
                                email: true
                            },
                            ctl00$MainContent$solDirPac: "required",
                            ctl00$MainContent$solEmp: {
                                required: true,
                                rut: true
                            },
                            ctl00$MainContent$solEmpNom: "required",
                            ctl00$MainContent$solTipo: "required",
                            ctl00$MainContent$solFecha: "required",
                            ctl00$MainContent$solHora: "required",
                            ctl00$MainContent$solSol: "required",
                            ctl00$MainContent$solCom: "required",
                            ctl00$MainContent$solReg: "required",
                            ctl00$MainContent$solSin: {
                                required: true,
                                number: true
                            },
                            ctl00$MainContent$SolConEmp: "required",
                            ctl00$MainContent$SolConTel: "required",
                            ctl00$MainContent$SolConEmail: {
                                email: true
                            },
                            ctl00$MainContent$solRegEmp: "required",
                            ctl00$MainContent$solComEmp: "required",
                            ctl00$MainContent$solCaso: "required",
                            ctl00$MainContent$solDirEmp: "required",
                            ctl00$MainContent$solObsCaso: "required",
                            ctl00$MainContent$solProf: "required"
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
                            ctl00$MainContent$solObsCaso: "&bull; Ingrese Observaciones del caso.",
                            ctl00$MainContent$solProf: "&bull; Seleccione Profesional."
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
    /*function muestraCorreo(e) {
        //alert(e);
        if (e == "1") {
            //$('#trdestino').show();
            $('#trcorreo').show();
        }
        else {
            //$('#trdestino').hide();
            $('#trcorreo').hide();
        }
    }*/

        function muestraCorreo(e) {
            $('#trcorreo').hide();
            if (e == "1") {
                $('#trcorreo').show();
            }

            $('#trSegmentoAccion').hide();
            $('#trdestino').show();
            llena_segmentosInicio('actsolSegAccion', '', 0);
            llena_lateridadInicio('actsolLatAccion', '', 0);
            if (e == "39") {
                $('#trSegmentoAccion').show();
                $('#trdestino').hide();
            }

            llenaTipoIte(0);
            $('#accDestinatario').removeAttr('disabled');
            if (e == "20") {
                llenaTipoIte(5);
                $('#accDestinatario').attr('disabled', 'disabled');
            }
        }

    function MostrarSeg(e, imgAgre, estMostrar) {
        if (estMostrar == "1") {
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
        if (e == "2") {
            $('#MainContent_trSegmento').hide();
            $('#trSegmento1').hide();
        }
        else {
            $('#MainContent_trSegmento').show();
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

        llena_regiones(0);
        llena_Profesionales_Sug(0, 0);
        llena_regionesEmp(0);
        llena_regionesPac(0);
        llena_comunas(0, 0);
        llena_comunasPac(0, 0);
        llena_comunasEmp(0, 0);
        $('#MainContent_solFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
        $('#MainContent_codSolHidden').val(f.getDate() + "" + (f.getMonth() + 1) + "" + f.getFullYear() + "" + hours + "" + minutes + "" + seconds);
        limpiarForm();
        $('#MainContent_trSegmento2').hide();
        $('#MainContent_trSegmento3').hide();
        $('#MainContent_trSegmento4').hide();
        $('#dialog').dialog('open');
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

        function tabla() {
            var var_t = "0";
            var var_ip = "0";
            var var_ipev = "0";
            sUrl = 'jqGridIngresos.ashx?r=0&c=0&s=0&t=0&ip=0&ipev=0&fi=&ff=&rp=&re=&os=&est=0&estep=0&nc=&di=&p=<%=(string)(Session["IDProyecto"])%>&usr=<%=(string)(Session["USRSuper"])%>';

        if (!cargadaGrilla) {
            jQuery("#jQGridDemo").jqGrid({
                url: sUrl,
                datatype: "xml",
                colNames: ['Nº', 'Tipo', 'Caso', 'Fecha Solicitud', 'Agencia', 'Rut Empresa', 'Empresa', 'Rut Paciente', 'Paciente', 'Dias', 'Estado Ev.Ps', '', 'Estado Ept', '', 'Mail Enviado', '', '', '', '', ''],
                colModel: [
                            { name: 'ID_SOLICITUD', index: 'ID_SOLICITUD', width: 62, stype: 'text' },
                            { name: 'TIPO', index: 'TIPO', width: 40, stype: 'text' },
                            { name: 'TIPO_CASO', index: 'TIPO_CASO', width: 30, stype: 'text' },
                            { name: 'FECHA_SOLICITUD', index: 'FECHA_SOLICITUD', width: 60, stype: 'text' },
                            { name: 'SOL', index: 'SOL', width: 65, stype: 'text' },
                            { name: 'RUT_E', index: 'RUT_E', width: 60, stype: 'text' },
                            { name: 'NOM_E', index: 'NOM_E', width: 100, stype: 'text' },
                            { name: 'TRAB_RUT', index: 'TRAB_RUT', width: 60, stype: 'text' },
                            { name: 'TRAB_NOM', index: 'TRAB_NOM', width: 100, stype: 'text' },
                            { name: 'ORDEN_SINIESTRO', index: 'ORDEN_SINIESTRO', width: 30, stype: 'text' },
                            { name: 'EST', index: 'EST', width: 50, stype: 'text' },
                            { width: 20, stype: 'text' },
                            { name: 'ESTEpt', index: 'ESTEpt', width: 50, stype: 'text' },
                            { width: 20, stype: 'text' },
                            { name: 'EST', index: 'EST', width: 50, stype: 'text' },
                            { width: 20, stype: 'text' },
                            { width: 20, stype: 'text' },
                            { name: 'ENEMAIL', index: 'ENEMAIL', width: 18, stype: 'text' },
                            { width: 20, stype: 'text' },
                            { width: 20, stype: 'text' }
                ],
                rowNum: 500,
                rownumbers: true,
                autowidth: true,
                height: 175,
                mtype: 'GET',
                loadonce: false,
                rowList: [500, 800, 1000],
                pager: '#jQGridDemoPager',
                sortname: 'cod',
                viewrecords: true,
                sortorder: 'desc',
                caption: "Listado de Solicitudes",
                gridComplete: function () {
                    var rows = $("#jQGridDemo").getDataIDs();
                    for (var i = 0; i < rows.length; i++) {
                        var status = $("#jQGridDemo").getCell(rows[i], "ESTEpt");
                        if (status == "Finalizado" || status == "Anulado" || status == "Cancelado") {
                            $("#jQGridDemo").jqGrid('setRowData', rows[i], false, { /**/color: 'Black', weightfont: 'bold', background: '#fae275' });
                        }

                        if (status == "Fecha de Prog. Vencida EPT") {
                            $("#jQGridDemo").jqGrid('setRowData', rows[i], false, { color: 'Red', weightfont: 'bold'});
                        }
                    }
                }
            });

            if ('<%=(string)(Session["IDProyecto"])%>' != '2') {
                jQuery("#jQGridDemo").jqGrid('hideCol', 'ENEMAIL');
            }

            if ('<%=(string)(Session["IDProyecto"])%>' == '2') {
                jQuery("#jQGridDemo").jqGrid('hideCol', 'TIPO_CASO');
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
                caption: "Exportar Excel ",
                title: "Exportar Excel",
                buttonicon: 'ui-icon-plus',
                onClickButton: function () {

                    var comunaId = "0";

                    comunaId = $('#busCom').val();

                    /**/if (comboTree3) {
                        var_t = comboTree3.getSelectedItemsId().toString() == "false" ? "0" : comboTree3.getSelectedItemsId().toString()
                    }

                    if (comboTree4) {
                        var_ip = comboTree4.getSelectedItemsId().toString() == "false" ? "0" : comboTree4.getSelectedItemsId().toString()
                    }

                    if (comboTree5) {
                        var_ipev = comboTree5.getSelectedItemsId().toString() == "false" ? "0" : comboTree5.getSelectedItemsId().toString()
                    }

                    sUrl = 'excel.aspx?r=' + $('#busReg').val() +
                           '&c=' + comunaId + '&s=' + $('#bussol').val() +
                        '&t=' + var_t + '&m=' + $('#busMes').val() +
                           '&a=' + $('#busAno').val() + '&rp=' + $('#busPac').val() +
                           '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() +
                           '&est=' + $('#busEst').val() + '&di=' + $('#busDI').val() +
                           '&fi=' + $('#busFD').val() + '&ff=' + $('#busFH').val() + '&nc=' + $('#busNC').val() +
                           '&tp=<%=(string)(Session["TpUsuario"])%>&tu=<%=(string)(Session["IdUsuario"])%>&p=<%=(string)(Session["IDProyecto"])%>&tc=0&tpexcel=1';

                                window.open(sUrl, 'Solicitudes EPT')
                            }
            });

            cargadaGrilla = true;
            jQuery("#jQGridDemo").jqGrid('setGridParam', { url: sUrl }).trigger("reloadGrid");
        }
        else {
            /*sUrl = 'jqGridIngresos.ashx?r=' + $('#busReg').val() +
           '&c=' + comunaId + '&s=' + $('#bussol').val() +
           '&t=' + $('#bustipo').val() + '&fi=' + $('#busFD').val() +
           '&ff=' + $('#busFH').val() + '&rp=' + $('#busPac').val() +
           '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() +
           '&est=' + $('#busEst').val() + '&di=' + $('#busDI').val();
            r=0&c=0&s=0&t=0&fi=&ff=&rp=&re=&os=&est=0&di=*/


            if (comboTree3) {
                var_t = comboTree3.getSelectedItemsId().toString() == "false" ? "0" : comboTree3.getSelectedItemsId().toString()
            }
            
            if (comboTree4) {
                var_ip = comboTree4.getSelectedItemsId().toString() == "false" ? "0" : comboTree4.getSelectedItemsId().toString()
            }
            //alert(var_ip);
            if (comboTree5) {
                var_ipev = comboTree5.getSelectedItemsId().toString() == "false" ? "0" : comboTree5.getSelectedItemsId().toString()
            }

            jQuery("#jQGridDemo").jqGrid('setGridParam', {
                url: 'jqGridIngresos.ashx?r=' + $('#busReg').val() +
               '&c=' + $('#busCom').val() + '&s=' + $('#bussol').val() +
                    '&t=' + var_t + '&fi=' + $('#busFD').val() +
               '&ip=' + var_ip +
               '&ipev=' + var_ipev +
               '&a=' + $('#busAno').val() +
               '&ff=' + $('#busFH').val() + '&rp=' + $('#busPac').val() +
               '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() + '&nc=' + $('#busNC').val() +
               '&est=' + $('#busEst').val() + '&estep=' + $('#busEstEP').val() + '&di=' + $('#busDI').val() + '&p=<%=(string)(Session["IDProyecto"])%>&usr=<%=(string)(Session["USRSuper"])%>'
            }).trigger("reloadGrid");
        //jQuery("#jQGridDemo").trigger("reloadGrid");
        } 
    }

    function llena_regionesBus(id_region) {
        $("#busReg").html("");
        $.ajax({
            type: "GET",
            url: "listaRegiones.ashx",
            data: { id: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#busReg").append("<option value='0'>Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_region == $(this).find('ID').text())
                        $("#busReg").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#busReg").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }



    function llena_comunasBus(id_region, id_comuna) {
        $("#busCom").html("");
        $.ajax({
            type: "GET",
            url: "listarComunas.ashx",
            data: { r: id_region },
            dataType: "xml",
            success: function (xml) {
                $("#busCom").append("<option value='0'>Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id_comuna == $(this).find('ID').text())
                        $("#busCom").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#busCom").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
        tabla();
    }

    function llena_agencias(id) {
        $("#bussol").html("");
        $.ajax({
            type: "GET",
            url: "listaAgencias.ashx",
            data: { id: id, proy: '<%=(string)(Session["IDProyecto"])%>' },
            dataType: "xml",
            success: function (xml) {
                $("#bussol").append("<option value='0'>Seleccione</option>");
                $('row', xml).each(function (i) {
                    if (id == $(this).find('ID').text())
                        $("#bussol").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                    else
                        $("#bussol").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                $(this).find('NOMBRE').text() + '</option>');
                });
            }
        });
    }

    function validarFrmSol() {
        validatorSol = $("#myForm").validate({
            rules: {
                actsolRutPac: {
                    required: true,
                    rut: true
                },
                actsolNomPac: "required",
                actsolEmailPac: {
                    email: true
                },
                actsolDirPac: "required",
                actsolEmp: {
                    required: true,
                    rut: true
                },
                actsolGeneroPac: "required",
                actsolEmpNom: "required",
                actsolTipo: "required",
                actsolFecha: "required",
                actsolHora: "required",
                actsolactsol: "required",
                actsolCom: "required",
                actsolReg: "required",
                actsolSin: {
                    required: true,
                    number: true
                },
                actsolConEmp: "required",
                actsolConTel: "required",
                actsolConEmail: {
                    email: true
                },
                actsolRegEmp: "required",
                actsolComEmp: "required",
                actsolCaso: "required",
                actsolDirEmp: "required",
                actsolSeg1: "required",
                actsolLat1: "required",
                actsolSeg2: "required",
                actsolLat2: "required",
                actsolSeg3: "required",
                actsolLat3: "required",
                actsolSeg4: "required",
                actsolLat4: "required",
                actsolSeg5: "required",
                actsolLat5: "required",
                actsolSeg6: "required",
                actsolLat6: "required",
                actsolSeg7: "required",
                actsolLat7: "required",
                actsolSeg8: "required",
                actsolLat8: "required",
                actsolSeg9: "required",
                actsolLat9: "required",
                actsolSeg10: "required",
                actsolLat10: "required",
                actsolSeg11: "required",
                actsolLat11: "required",
                actsolSeg12: "required",
                actsolLat12: "required"
            },
            messages: {
                actsolRutPac: {
                    required: "&bull; Ingrese Rut.",
                    rut: "&bull; Rut Erroneo."
                },
                actsolNomPac: "&bull; Ingrese Nombre.",
                actsolEmailPac: {
                    email: "&bull; Email Erroneo."
                },
                actsolDirPac: "&bull; Ingrese Dirección.",
                actsolEmp: {
                    required: "&bull; Ingrese Rut.",
                    rut: "&bull; Rut Erroneo."
                },
                actsolGeneroPac: "&bull; Seleccione Género.",
                actsolEmpNom: "&bull; Ingrese Razón social de la Empresa.",
                actsolTipo: "&bull; Seleccione Tipo.",
                actsolFecha: "&bull; Ingrese Fecha.",
                actsolHora: "&bull; Ingrese Hora.",
                actsolactsol: "&bull; Seleccione actsolicitante.",
                actsolCom: "&bull; Seleccione Comuna actsolicitud.",
                actsolReg: "&bull; Seleccione Región actsolicitud.",
                actsolSin: {
                    required: "&bull; Ingrese Orden de Siniestro.",
                    number: "&bull; Ingrese actsolo Números."
                },
                actsolConEmp: "&bull; Ingrese Contacto.",
                actsolConTel: "&bull; Ingrese Telefono.",
                actsolConEmail: {
                    email: "&bull; Email de Empresa Erroneo."
                },
                actsolRegEmp: "&bull; Seleccione Región de la Empresa.",
                actsolComEmp: "&bull; Seleccione Comuna de la Empresa.",
                actsolCaso: "&bull; Seleccione Caso.",
                actsolDirEmp: "&bull; Ingrese Dirección de la Empresa.",
                actsolSeg1: "&bull; Seleccione",
                actsolLat1: "&bull; Seleccione",
                actsolSeg2: "&bull; Seleccione",
                actsolLat2: "&bull; Seleccione",
                actsolSeg3: "&bull; Seleccione",
                actsolLat3: "&bull; Seleccione",
                actsolSeg4: "&bull; Seleccione",
                actsolLat4: "&bull; Seleccione",
                actsolSeg5: "&bull; Seleccione",
                actsolLat5: "&bull; Seleccione",
                actsolSeg6: "&bull; Seleccione",
                actsolLat6: "&bull; Seleccione",
                actsolSeg7: "&bull; Seleccione",
                actsolLat7: "&bull; Seleccione",
                actsolSeg8: "&bull; Seleccione",
                actsolLat8: "&bull; Seleccione",
                actsolSeg9: "&bull; Seleccione",
                actsolLat9: "&bull; Seleccione",
                actsolSeg10: "&bull; Seleccione",
                actsolLat10: "&bull; Seleccione",
                actsolSeg11: "&bull; Seleccione",
                actsolLat11: "&bull; Seleccione",
                actsolSeg12: "&bull; Seleccione",
                actsolLat12: "&bull; Seleccione"
            }
        });
    }

    function llena_Esp(id)
    {
        $('#espProf').html("");
        $.ajax({
            type: "GET",
            url: "datosProfSel.ashx",
            data: { id: id },
            dataType: "xml",
            success: function (xml) {
                $('row', xml).each(function (i) {
                    $('#espProf').html("<b>Profesión : </b>" + $(this).find('PROFESION').text() + "</BR>" +
                                       "<b>Email : </b>" + $(this).find('EMAIL').text() + "</BR>" +
                                       "<b>Teléfono : </b>" + $(this).find('FONO').text() + "</BR>" +
                                       "<b>Proveedor : </b>" + $(this).find('PROV').text() + "</BR>" +
                                       "<b>Zonal : </b>" + $(this).find('ZONAL').text() + "</BR>" +
                                       "<b>Agencia : </b>" + $(this).find('AGENCIA').text() + "</BR>" +
                                       "<b>Atención : </b>" + $(this).find('ATENCION').text() + "</BR>" +
                                       "<b>Consideraciones : </b>" + $(this).find('CONSIDERACIONES').text());
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

    function MostrarSeg(e, imgAgre, estMostrar) {
        if (estMostrar == "1") {
            $('#trSegmento' + e).show();
            $('#Agregar' + imgAgre).hide();
            $('#Remove' + imgAgre).hide();
        }
        else {
            $('#trSegmento' + e).hide();
            $('#Agregar' + imgAgre).show();
            $('#Remove' + imgAgre).show();
        }
    }

    function llena_segLat(controlSeg, controlLat, ncontrol, id) {
        llena_segmentosInicio(controlSeg, ncontrol, id);
        llena_lateridadInicio(controlLat, ncontrol, id);
    }

    function limpia_segLat(controlSeg, controlLat, ncontrol) {
        $("#" + controlSeg + ncontrol).html("");
        $("#" + controlLat + ncontrol).html("");
    }

    function cambiaEstadoSol(id, e) {
        idSeg = id;
        $('#obsEstado').val("");
        $("#tipoEstado").html("");

        if (e == '0') {
            $("#tipoEstado").append("<option value=\"\">Seleccione</option>");
            $("#tipoEstado").append("<option value=\"17\">Anular Solicitud Completa</option>");
            $("#tipoEstado").append("<option value=\"18\">Cancelar Solicitud Completa</option>");
        }
        else {
            $("#tipoEstado").append("<option value=\"\">Seleccione</option>");
            $("#tipoEstado").append("<option value=\"24\" selected=\"selected\">Reabrir Caso</option>");
        }

        validarFrmEstado();
        $('#dialogEstado').dialog('open');
    }

    function cancelaEptSol(id) {
        idActEpt = id;
        $('#obsEstadoEpt').val("");
        validarFrmEstadoEpt();
        $('#dialogEstadoEpt').dialog('open');
    }

    function validarFrmEstado() {
        validatorEstado = $("#formEstado").validate({
            rules: {
                tipoEstado: "required",
                obsEstado: "required"
            },
            messages: {
                tipoEstado: "&bull; Seleccione Estado a Cambiar.",
                obsEstado: "&bull; Ingrese Observaciones."
            }
        });
    }

    function validarFrmEstadoEpt() {
        validatorEstadoEpt = $("#formEstadoEpt").validate({
            rules: {
                tipoEstadoEpt: "required",
                obsEstadoEpt: "required"
            },
            messages: {
                tipoEstadoEpt: "&bull; Seleccione Motivo de la Cancelación.",
                obsEstadoEpt: "&bull; Ingrese Observaciones."
            }
        });
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

    function muestraCargaDoc(id) {
        if ($("#IdactsolTipo").val() == "2") {
            $("#tdActProfSugTxt").show();
            $("#tdActProfSugSel").show();
            $('#tdActProf').html('Prof. Sug. Eval. Clinico : ');

            if (id == "2") {
                $('#actsolProf').html("");
                $('#actsolProfEva').html("");
                $("#tdActProfSugTxt").hide();
                $("#tdActProfSugSel").hide();
                $('#tdActProf').html('Profesional Sugerido EPT: ');
                llena_Profesionales_SugAct(0, $('#actsolReg').val(), 2, 'actsolProf', 0);
            }
            else if (id == "1") {
                $('#actsolProf').html("");
                $('#actsolProfEva').html("");
                $('#tdActProf').html('Prof. Sug. Eval. Clinico : ');
                llena_Profesionales_SugAct(0, $('#actsolReg').val(), 5, 'actsolProf', 0);
                llena_Profesionales_SugAct(0, $('#actsolReg').val(), 2, 'actsolProfEva', 0);

            }
        }
    }

    function finalizarCaso(id, tipo) {
        idSeg = id;
        $('#obsEstFinaliza').val("");
        $("#tipoEstFinaliza").html("");

        $("#tipoEstFinaliza").append("<option value=\"\">Seleccione</option>");

        if (tipo == '25') {
            $('#txtEstFinaliza').html("Que desea realizar con la Evaluación Psicológica Seleccionada?.");
            $("#tipoEstFinaliza").append("<option value=\"40\">Anular Evaluación Psicológica</option>");
            $("#tipoEstFinaliza").append("<option value=\"42\">Cancelar Evaluación Psicológica</option>");
            $("#tipoEstFinaliza").append("<option value=\"25\">Finalizar Evaluación Psicológica</option>");
            $('#fecha_recepcion').val('1');
            $('#fecha_recepcion').css("display", "none");
            $('.txtFechaRecepcion').html("");
        } else {
            $('#txtEstFinaliza').html("Que desea realizar con el EPT de la Solicitud Seleccionada?.");
            $("#tipoEstFinaliza").append("<option value=\"41\">Anular EPT</option>");
            $("#tipoEstFinaliza").append("<option value=\"43\">Cancelar EPT</option>");
            $("#tipoEstFinaliza").append("<option value=\"26\">Finalizar EPT</option>");
            $('.txtFechaRecepcion').html("Fecha Recepción :");
            $('#fecha_recepcion').val('');
            $('#fecha_recepcion').css("display", "");
        }

        //$("#tipoEstFinaliza").val(tipo);

        $('#EstFechaFinaliza').val("");
        $('#EstFechaFinaliza').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
        getFecha(id);
        validarEstadoCaso();
        $('#dialogEstFinaliza').dialog('open');
    }

    function validarEstadoCaso() {
        validatorEstadoCaso = $("#formEstFinaliza").validate({
            rules: {
                tipoEstFinaliza: "required",
                EstFechaFinaliza: "required",
                fecha_recepcion: "required"
            },
            messages: {
                tipoEstFinaliza: "&bull; Seleccione.",
                EstFechaFinaliza: "&bull; Seleccione.",
                fecha_recepcion: "&bull; Debe ingresar la fecha de recepción del informe para poder cerrar la solicitud."
            }
        });
    }

    function enviaNotiSol(id) {
        //$("#tdEnviarCarga").hide();
        //$("#tdTxtEnviar").show();
        $("#dEnviarID").val(id);
        $("#dialogEnviar").dialog('open');
    }

    function recepcionInforme(id, tipo) {
        idActEpt = id;
        //$('#obsEstadoEpt').val("");
        //validarFrmRecepionInforme();
        $('#RecepionInformeFecha').val("");
        $.datepicker.setDefaults($.datepicker.regional['es3']);
        $('#RecepionInformeFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
        $('#tipoRecepionFecha').val(tipo);

        if (tipo == '1') {
            $('#txtRecepionInformeFecha').html('Fecha Recepción Informe : ');
        }
        else {
            $('#txtRecepionInformeFecha').html('Fecha Corrección Informe : ');
        }

        $('#dialogRecepionInforme').dialog('open');
    }

    function rechComite(id, tipo) {
        idActEpt = id;
        idTipoRechazo = tipo;
        if (tipo==1)
        {
            $('#dialogRechComite').dialog('option', 'title', 'Rechazo Interno');
            $('#tablaRechTipo').html('Rechazado Interno : ');
        }else{
            $('#dialogRechComite').dialog('option', 'title', 'Rechazo Comité');
            $('#tablaRechTipo').html('Rechazado por Comité : ');
        }
        validarFrmRechComite();
        $('input:radio[name=RechComite1]')[0].checked = false;
        $('input:radio[name=RechComite1]')[1].checked = false;
        $('#dialogRechComite').dialog('open');
    }

    function validarFrmRecepionInforme() {
        validatorRecepionInforme = $("#formRecepionInforme").validate({
            rules: {
                RecepionInformeFecha: "required"
            },
            messages: {
                RecepionInformeFecha: "&bull; Ingrese Fecha."
            }
        });
    }

    function validarFrmRechComite() {
        validatorRechComite = $("#formRechComite").validate({
            rules: {
                RechComite1: "required"
            },
            messages: {
                RechComite1: "&bull; Seleccione."
            }
        });
    }

    function actualizaSegLatAccion(ID) {
        $.ajax({
            type: "GET",
            url: "datosSolicitud.ashx",
            data: { id: ID },
            dataType: "xml",
            success: function (xml) {
                $('row', xml).each(function (i) {
                    for (var tr = 1; tr <= 12; tr++) {
                        $('#trSegmento' + tr).hide();
                        limpia_segLat('actsolSeg', 'actsolLat', tr);
                        $('#Agregar' + tr).show();
                        $('#Remove' + tr).show();
                    }

                    var arregloSegmentos = $(this).find('SEGN').text().split("###");

                    for (var i = 0; i < arregloSegmentos.length; i++) {
                        if (arregloSegmentos[i] != "") {
                            var arregloSegmentosDet = arregloSegmentos[i].split("##");

                            for (var det = 0; det < arregloSegmentosDet.length; det++) {
                                if (arregloSegmentosDet[det] != "") {
                                    if (det == 0) {
                                        $('#trSegmento' + (i + 1)).show();
                                        $('#trSegmento' + (i + 1)).css("background-color", "#fcfdfd");
                                        if (i > 0) {
                                            MostrarSeg((i + 1), (i), 1);
                                        }
                                    }

                                    if (det == 1) {
                                        llena_segmentosInicio('actsolSeg', (i + 1), arregloSegmentosDet[det])
                                    }

                                    if (det == 2) {
                                        llena_lateridadInicio('actsolLat', (i + 1), arregloSegmentosDet[det])
                                    }

                                    if (det == 3 && arregloSegmentosDet[det] == '1') {
                                        $('#trSegmento' + (i + 1)).css("background-color", "#cedce2");
                                    }
                                }
                            }
                        }
                    }

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

    //function llena_Criterios_Obs(control, id, query, filtro, column) {
    //    var txt = "";
    //    var txt2 = "";
    //    var txtID = id.split(",");
    //    $("#demotd" + column).html("");
    //    $("#demotd" + column).append("<input type=\"text\" name=" + control + " id=" + control + " placeholder=\"Seleccione\"/>");
    //    $.ajax({
    //        type: "GET",
    //        url: "listaCombos.ashx",
    //        data: { query: query, filtro: filtro },
    //        dataType: "xml",
    //        success: function (xml) {
    //            SampleJSONData = '[';
    //            $('row', xml).each(function (i) {
    //                txt = txt + $(this).find('ID').text() + "##" + $(this).find('NOMBRE').text() + "###";
    //                SampleJSONData = SampleJSONData + '{' +
    //                                    '"id": ' + $(this).find('ID').text() + ',' +
    //                                    '"title": "' + $(this).find('NOMBRE').text() + '"},';
    //            });

    //            SampleJSONData = SampleJSONData + ']';
    //            SampleJSONData = SampleJSONData.replace("},]", "}]");

    //            if (column == "1") {
    //                comboTree1 = $("#" + control).comboTree({
    //                    source: JSON.parse(SampleJSONData),
    //                    isMultiple: true
    //                });

    //                txt = txt.split("###");
    //                for (var contTxt = 0; contTxt < txt.length; contTxt++) {
    //                    txt2 = txt[contTxt].split("##");
    //                    for (var i = 0; i < txtID.length; i++) {
    //                        if (txtID[i] == txt2[0]) {
    //                            $("#chk-" + txt2[0]).attr('checked', true);
    //                            comboTree1.multiItemClick('<span data-id="' + txt2[0] +
    //                            '" class="comboTreeItemTitle comboTreeItemHover"><input type="checkbox" id="chk-' + column + '-' + txt2[0] +
    //                            '">' + txt2[1] + '</span>');
    //                        }
    //                    }
    //                }
    //            }
    //            else {
    //                comboTree2 = $("#" + control).comboTree({
    //                    source: JSON.parse(SampleJSONData),
    //                    isMultiple: true
    //                });

    //                txt = txt.split("###");
    //                for (var contTxt = 0; contTxt < txt.length; contTxt++) {
    //                    txt2 = txt[contTxt].split("##");
    //                    for (var i = 0; i < txtID.length; i++) {
    //                        if (txtID[i] == txt2[0]) {
    //                            $("#chk-" + txt2[0]).attr('checked', true);
    //                            comboTree2.multiItemClick('<span data-id="' + txt2[0] +
    //                            '" class="comboTreeItemTitle comboTreeItemHover"><input type="checkbox" id="chk-' + column + '-' + txt2[0] +
    //                            '">' + txt2[1] + '</span>');
    //                        }
    //                    }
    //                }

    //            }
    //        }
    //    });
    //}

        function llena_Criterios_Obs(control, id, query, filtro, column) {
            //alert(control + " " + id + " " + query + " " + filtro + " " + column);
            var txt = "";
            var txt2 = "";
            var txtID = id.split(",");
            $("#demotd" + column).html("");
            $("#demotd" + column).append("<input type=\"text\" name=" + control + " id=" + control + " placeholder=\"Seleccione\"/>");
            $.ajax({
                type: "GET",
                url: "listaCombos.ashx",
                data: { query: query, filtro: filtro },
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

                    if (column == "1") {
                        comboTree1 = $("#" + control).comboTree({
                            source: JSON.parse(SampleJSONData),
                            isMultiple: true
                        });

                        txt = txt.split("###");
                        for (var contTxt = 0; contTxt < txt.length; contTxt++) {
                            txt2 = txt[contTxt].split("##");
                            for (var i = 0; i < txtID.length; i++) {
                                if (txtID[i] == txt2[0]) {
                                    $("#chk-" + txt2[0]).attr('checked', true);
                                    comboTree1.multiItemClick('<span data-id="' + txt2[0] +
                                        '" class="comboTreeItemTitle comboTreeItemHover"><input type="checkbox" id="chk-' + column + '-' + txt2[0] +
                                        '">' + txt2[1] + '</span>');
                                }
                            }
                        }
                    }
                    else if (column == "2") {
                        comboTree2 = $("#" + control).comboTree({
                            source: JSON.parse(SampleJSONData),
                            isMultiple: true
                        });

                        txt = txt.split("###");
                        for (var contTxt = 0; contTxt < txt.length; contTxt++) {
                            txt2 = txt[contTxt].split("##");
                            for (var i = 0; i < txtID.length; i++) {
                                if (txtID[i] == txt2[0]) {
                                    $("#chk-" + txt2[0]).attr('checked', true);
                                    comboTree2.multiItemClick('<span data-id="' + txt2[0] +
                                        '" class="comboTreeItemTitle comboTreeItemHover"><input type="checkbox" id="chk-' + column + '-' + txt2[0] +
                                        '">' + txt2[1] + '</span>');
                                }
                            }
                        }
                    }
                    else {
                        comboTree6 = $("#" + control).comboTree({
                            source: JSON.parse(SampleJSONData),
                            isMultiple: true
                        });

                        txt = txt.split("###");
                        for (var contTxt = 0; contTxt < txt.length; contTxt++) {
                            txt2 = txt[contTxt].split("##");
                            for (var i = 0; i < txtID.length; i++) {
                                if (txtID[i] == txt2[0]) {
                                    $("#chk-" + txt2[0]).attr('checked', true);
                                    comboTree6.multiItemClick('<span data-id="' + txt2[0] +
                                        '" class="comboTreeItemTitle comboTreeItemHover"><input type="checkbox" id="chk-' + column + '-' + txt2[0] +
                                        '">' + txt2[1] + '</span>');
                                }
                            }
                        }
                    }
                }
            });
        }

    /*function validaObs(column) {
        if (column == 1) {
            if ($("#actsolMacroAR").val() == $("#actsolMacroAR2").val()) {
                llena_Combos('actsolMacroAR2', 0, 3, 0);
                llena_Criterios_Obs('actsolCriObsdemo2', '0', 2, 0, 2);
            }
        }

        if (column == 2) {
            if ($("#actsolMacroAR").val() == $("#actsolMacroAR2").val()) {
                llena_Combos('actsolMacroAR', 0, 3, 0);
                llena_Criterios_Obs('actsolCriObsdemo', '0', 2, 0, 1);
            }
        }
    }*/
    function validaObs(column) {
            if (column == 1) {
                if ($("#actsolMacroAR").val() == $("#actsolMacroAR2").val()) {
                    llena_Combos('actsolMacroAR2', 0, 3, 0);
                    llena_Criterios_Obs('actsolCriObsdemo2', '0', 2, 0, 2);
                }

                if ($("#actsolMacroAR").val() == $("#actsolMacroAR6").val()) {
                    llena_Combos('actsolMacroAR2', 0, 3, 0);
                    llena_Criterios_Obs('actsolCriObsdemo2', '0', 2, 0, 6);
                }
            }

            if (column == 2) {
                if ($("#actsolMacroAR2").val() == $("#actsolMacroAR").val()) {
                    llena_Combos('actsolMacroAR', 0, 3, 0);
                    llena_Criterios_Obs('actsolCriObsdemo', '0', 2, 0, 1);
                }

                if ($("#actsolMacroAR2").val() == $("#actsolMacroAR6").val()) {
                    llena_Combos('actsolMacroAR2', 0, 3, 0);
                    llena_Criterios_Obs('actsolCriObsdemo2', '0', 2, 0, 6);
                }
            }

            if (column == 6) {
                if ($("#actsolMacroAR6").val() == $("#actsolMacroAR").val()) {
                    llena_Combos('actsolMacroAR', 0, 3, 0);
                    llena_Criterios_Obs('actsolCriObsdemo', '0', 2, 0, 1);
                }

                if ($("#actsolMacroAR6").val() == $("#actsolMacroAR2").val()) {
                    llena_Combos('actsolMacroAR2', 0, 3, 0);
                    llena_Criterios_Obs('actsolCriObsdemo2', '0', 2, 0, 2);
                }
            }
        }

        function llena_ano(id) {
            var dt = new Date();
            var anioActual = dt.getFullYear();
            //console.log(anioActual);
            $("#busAno").append('<option value="" selected="selected" >Seleccione</option>');
            $("#busAno").append('<option value="' + anioActual + '"> ' + anioActual + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 1) + '"> ' + (anioActual - 1) + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 2) + '"> ' + (anioActual - 2) + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 3) + '"> ' + (anioActual - 3) + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 4) + '"> ' + (anioActual - 4) + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 5) + '"> ' + (anioActual - 5) + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 6) + '"> ' + (anioActual - 6) + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 7) + '"> ' + (anioActual - 7) + ' </option>');
            $("#busAno").append('<option value="' + (anioActual - 8) + '"> ' + (anioActual - 8) + ' </option>');
        }

        function llena_tiposBus(id) {

            SampleJSONData = '[';

            /*SampleJSONData = SampleJSONData + '{' +
                '"id": 4,' +
                '"title": "EPT Disfonía"},';*/

            SampleJSONData = SampleJSONData + '{' +
                '"id": 1,' +
                '"title": "EPT ME"},';

            SampleJSONData = SampleJSONData + '{' +
                '"id": 2,' +
                '"title": "EPT SM"},';

            SampleJSONData = SampleJSONData + '{' +
                '"id": 3,' +
                '"title": "EP Dermat"},';

            SampleJSONData = SampleJSONData + ']';
            SampleJSONData = SampleJSONData.replace("},]", "}]");

            comboTree3 = $("#busprofAEPT2").comboTree({
                source: JSON.parse(SampleJSONData),
                isMultiple: true
            });
        }

        function llena_regionesProfBusc(id_region) {
            var var_Ept = "0";

            if (comboTree3) {
                var_Ept = comboTree3.getSelectedItemsId().toString() == "false" ? "0" : comboTree3.getSelectedItemsId().toString()
            }

            $.ajax({
                type: "GET",
                url: "listarProfesionalesTipoSolicitud.ashx",
                data: { t: var_Ept, proy: '<%=(string)(Session["IDProyecto"])%>', r:"" },
                dataType: "xml",
                success: function (xml) {
                    if (comboCarga == true) {
                        comboTree5.destroy();
                    }

                    SampleJSONData = '[';
                    $('row', xml).each(function (i) {
                        SampleJSONData = SampleJSONData + '{' +
                            '"id": ' + $(this).find('ID').text() + ',' +
                            '"title": "' + $(this).find('NOMBRE').text() + '"},';
                    });

                    SampleJSONData = SampleJSONData + ']';
                    SampleJSONData = SampleJSONData.replace("},]", "}]");

                    comboTree5 = $("#busprofAEPT").comboTree({
                        source: JSON.parse(SampleJSONData),
                        isMultiple: true
                    });

                    comboCarga = true;
                }
            });
        }

        function llena_regionesProfBusc2(id_region) {
            var var_Ev_Psico = "0";

            if (comboTree3) {
                var_Ev_Psico = comboTree3.getSelectedItemsId().toString() == "false" ? "0" : comboTree3.getSelectedItemsId().toString()
            }

            if (var_Ev_Psico.replace("1", "").replace("3", "").replace(",", "") == "2") {
                var_Ev_Psico = "5";
            }
            else {
                var_Ev_Psico = "0";
            }

            $.ajax({
                type: "GET",
                url: "listarProfesionalesTipoSolicitud.ashx",
                data: { t: var_Ev_Psico, proy: '<%=(string)(Session["IDProyecto"])%>',r:"" },
                dataType: "xml",
                success: function (xml) {
                    if (comboCarga2 == true) {
                        comboTree4.destroy();
                    }

                    SampleJSONData = '[';
                    $('row', xml).each(function (i) {
                        SampleJSONData = SampleJSONData + '{' +
                            '"id": ' + $(this).find('ID').text() + ',' +
                            '"title": "' + $(this).find('NOMBRE').text() + '"},';
                    });

                    SampleJSONData = SampleJSONData + ']';
                    SampleJSONData = SampleJSONData.replace("},]", "}]");

                    comboTree4 = $("#busprofAEC").comboTree({
                        source: JSON.parse(SampleJSONData),
                        isMultiple: true
                    });

                    comboCarga2 = true;
                }
            });
        }

        function duplicar(i) {
            duplicarReg = i;
            $('#dialog_delIns').dialog('open');
        }

        function reabrir(i) {
            duplicarReg = i;
            $('#dialog_delIns2').dialog('open');
        }

        function cambiaEstadoECT(id) {
            idSeg = id;

            $("#tipoEstadoECT").html("");

            $("#tipoEstadoECT").append("<option value=\"\">Seleccione</option>");
            $("#tipoEstadoECT").append("<option value=\"1\">SI</option>");
            $("#tipoEstadoECT").append("<option value=\"2\">NO</option>");
            $("#tipoEstadoECT").append("<option value=\"3\">Fuera de Plazo</option>");

            // validarFrmEstado();
            $('#dialogEstadoECT').dialog('open');
        }

        function getFecha(i) {
            idSeg = i;
            $.ajax({
                type: "GET",
                url: "datosFechaRecepcion.ashx",
                data: { id_solicitud: i },
                dataType: "xml",
                success: function (xml) {
                    $('row', xml).each(function (i) {
                        $('#fecha_recepcion').val($(this).find('FECHA').text());
                    }
                    )
                }
            });
        }

        function llena_campos(id) {
            $(".otros").hide();
            $("#asiOtros").val("");
            $("#asiMed").val("");
            $("#asiComuna").val('');
            if (id == 'Remoto') {
                $(".comuna").hide();
                $(".medio").show();

            }
            else if (id == 'Presencial') {
                $(".medio").hide();
                $(".comuna").show();

            }
            else if (id == 'Mixto') {
                $(".medio").show();
                $(".comuna").show();
            }
            else {
                $(".medio").hide();
                $(".comuna").hide();
            }
        }

        function llena_campos2(id) {
            if (id == 'Otros') {
                $(".otros").show();

            }
            else {
                $(".otros").hide();

            }
        }

        function llena_comunas2(id_region, id_comuna) {
            $("#asiComuna").html("");
            $.ajax({
                type: "GET",
                url: "listarComunas.ashx",
                data: { r: id_region },
                dataType: "xml",
                success: function (xml) {
                    $("#asiComuna").append("<option value=''>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id_comuna == $(this).find('ID').text())
                            $("#asiComuna").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#asiComuna").append('<option value="' + $(this).find('ID').text() + '" >' +
                                $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });

        }
    </script>

<div id="modal_dialog">
    <div id="tabs" style="height:auto">
	    <ul>
		    <li><a href="#tabs-1" onclick="$('#button-GuardarLab').show();$('#button-GuardarLabComite').hide();">Solicitud</a></li>
            <%if ((string)(Session["TpUsuario"]) == "1")
            { 
            %>
		    <li><a href="#tabs-2" onclick="$('#button-GuardarLab').hide();$('#button-GuardarLabComite').hide();">Acciones</a></li>
		    <li><a href="#tabs-3" onclick="$('#button-GuardarLab').hide();$('#button-GuardarLabComite').hide();">Asignaciones</a></li>
		    <li><a href="#tabs-4" onclick="$('#button-GuardarLab').hide();$('#button-GuardarLabComite').hide();">Actividades</a></li>
		    <li><a href="#tabs-5" onclick="$('#button-GuardarLab').hide();$('#button-GuardarLabComite').hide();">Documentación Final</a></li>
		    <li><a href="#tabs-6" onclick="$('#button-GuardarLab').hide();$('#button-GuardarLabComite').show();">Clasificación</a></li>
            <%
            }
            %>
	    </ul>
	    <div id="tabs-1" style="font-size: 10px;">
        <form id="myForm">
        <table id="tablActSol" style="width:1130px;">
            <tr>
                <td colspan="6"><strong>Datos Solicitud</strong>&nbsp;&nbsp;<span><font color="red">(Información del Tipo y lugar a realizar la EPT)</font></span><HR></td>
            </tr>
	        <tr>
		        <td style="width:180px;">Tipo : </td>
                <td style="width:280px;"><input name="actsolIDObs1" type="hidden" id="actsolIDObs1"/><input name="actsolIDObs2" type="hidden" id="actsolIDObs2"/><input name="actsolIDObs6" type="hidden" id="actsolIDObs6" /><input name="actsolUsrMod" type="hidden" id="actsolUsrMod"/><input name="actsolID" type="hidden" id="actsolID"/><input name="IdactsolTipo" type="hidden" id="IdactsolTipo"/><label id="actsolTipo" name="actsolTipo" onchange="muestraSegmento(this.value);"></label></td>
                <td style="width:200px;">Fecha : </td>
                <td style="width:280px;"><input name="actsolFecha" type="text" maxlength="50" id="actsolFecha" style="width:40%;" /></td>
                <td style="width:180px;">Hora : </td>
                <td style="width:280px;"><input name="actsolHora" type="text" maxlength="11" id="actsolHora" onblur="validaHoraAct(this.value);" style="width:30%;" /></td>
	        </tr>
            <tr>
		        <td>Solicitante : </td>
                <td><label id="lbsolicitante" name="lbsolicitante"></label></td>
                <td>Región EPT : </td>
                <td><select name="actsolReg" id="actsolReg" onchange="llena_comunasAct(this.value,0);llena_Profesionales_SugAct(0,this.value, $('#IdactsolTipo').val(), 'actsolProf',0);llena_Profesionales_SugAct(0,this.value, 5,'actsolProfEva',0);muestraCargaDoc(0);llena_Tipo_ServicioAct(1);" style="width:100%;"></select></td>
                <td>Comuna EPT : </td>
                <td><select name="actsolCom" id="actsolCom" style="width:80%;"></select></td>
	        </tr>
            <tr>
		        <td>Forma Ingreso : </td>
                <td name="actsolForma" id="actsolForma"></td>
                <td>Observaciones : </td>
                <td colspan="4"><input name="actsolObs" type="text" maxlength="100" id="actsolObs" style="width:100%;"/></td>
	        </tr>
            <tr>
		        <td>Nombre del Grupo : </td>
                <td><select name="actsolNomGrup" id="actsolNomGrup" onchange="llena_Combos('actsolOcup', 0, 5, this.value);" style="width:100%;"></select></td>
                <td>Ocupación : </td>
		        <td><select name="actsolOcup" id="actsolOcup" style="width:100%;"></select></td>
	        </tr>
            <tr>
                <td colspan="6"><strong>Datos Paciente</strong> <HR></td>
            </tr>
            <tr>
		        <td>Rut Paciente : </td>
                <td><input name="actsolRutPac" type="text" maxlength="10" id="actsolRutPac" style="width:40%;" onblur="datostrabajador(this.value);" /></td>
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
                <td><select name="actsolRegPac" id="actsolRegPac" onchange="llena_comunasPacAct(this.value,0);" style="width:100%;">
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
                <td><input name="actsolEmp" type="text" maxlength="10" id="actsolEmp" style="width:100%;" onblur="datosEmpresa(this.value);" /></td>
                <td>Nombre Empresa : </td>
                <td><input name="actsolEmpNom" type="text" maxlength="50" id="actsolEmpNom" /></td>
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
                <td><select name="actsolProf" id="actsolProf" onchange="llena_Profesionales_SugAct(0, $('#actsolReg').val(), 2,'actsolProfEva', this.value);"></select></td>
                <td>Observaciones : </td>
                <td><input name="actsolObsCaso" type="text" maxlength="100" id="actsolObsCaso" /></td>
            </tr>
            <tr id="trActSegProf">
		        <td>Tipo de Servicio:</td>
                <td><select name="actsolTipoServicio" id="actsolTipoServicio" onchange="muestraCargaDoc(this.value);"></select></td>
                <td id="tdActProfSugTxt">Profesional Sugerido EPT: </td>
                <td id="tdActProfSugSel"><select name="actsolProfEva" id="actsolProfEva"></select></td>
            </tr>
            <tr>
		        <td>M. Agente Riesgo 1:</td>
                <td><select name="actsolMacroAR" id="actsolMacroAR" onchange="llena_Criterios_Obs('actsolCriObsdemo', '0', 2, this.value, 1); validaObs(1);" style="width:100%;"></select></td>
                <td>Criterios Observación 1:</td>
         		<td id="demotd1" colspan="3"><input type="text" name="actsolCriObsdemo" id="actsolCriObsdemo" placeholder="Seleccione"/></td>
	        </tr>
            <tr>
		        <td>M. Agente Riesgo 2:</td>
                <td><select name="actsolMacroAR2" id="actsolMacroAR2" onchange="llena_Criterios_Obs('actsolCriObsdemo2', '0', 2, this.value, 2); validaObs(2);" style="width:100%;"></select></td>
                <td>Criterios Observación 2:</td>
         		<td id="demotd2" colspan="3"><input type="text" name="actsolCriObsdemo2" id="actsolCriObsdemo2" placeholder="Seleccione"/></td>
	        </tr>
            <tr>
                            <td>M. Agente Riesgo 3:</td>
                            <td>
                                <select name="actsolMacroAR6" id="actsolMacroAR6" onchange="llena_Criterios_Obs('actsolCriObsdemo6', '0', 2, this.value, 6); validaObs(6);" style="width: 100%;"></select></td>
                            <td>Criterios Observación 3:</td>
                            <td id="demotd6" colspan="3">
                                <input type="text" name="actsolCriObsdemo6" id="actsolCriObsdemo6" placeholder="Seleccione" /></td>
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
                <td><select name="actsolSeg<%=nseg%>" id="actsolSeg<%=nseg%>" style="width:90%;"></select></td>
                <td>Lateralidad : </td>
                <td><select name="actsolLat<%=nseg%>" id="actsolLat<%=nseg%>"></select>
                &nbsp;&nbsp;<%if(nseg<12){%><img id="Agregar<%=nseg%>" onclick="MostrarSeg(<%=(nseg+1)%>,<%=nseg%>,1); llena_segLat('actsolSeg','actsolLat', <%=(nseg+1)%>, 0);" src="images/AgregarS.png"><%}%>
                &nbsp;&nbsp;<%if(nseg>1){%><img id="Remove<%=nseg%>" onclick="MostrarSeg(<%=nseg%>,<%=(nseg-1)%>,2); limpia_segLat('actsolSeg','actsolLat', <%=nseg%>);" src="images/removeS.png"><%}%></td>
	        </tr>
            <% }%>            
        </table>   
        </form>   

	    </div>
        <%if ((string)(Session["TpUsuario"]) == "1")
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
        <div id="tabs-6" style="font-size: 10px;">
        <form id="myFormComite">
        <table id="tablActSolComite" style="width:500px;">
            <tr>
                <td colspan="6"><strong>Datos Finales</strong><HR></td>
            </tr>    
            <tr>
                <td style="width:150px;">Clasificación Comité : <input name="actsolIDClaComi" type="hidden" id="actsolIDClaComi"/></td>
                <td style="width:350px;"><select name="actsolClaComi" id="actsolClaComi" style="width:80%;"></select></td>
	        </tr>       
        </table>   
        </form>
        </div>
        <%
            }
        %>
    </div>
</div>

<div id="dialog">
    <form id="form1" runat="server" style="font-size: 10px;">
        <asp:Table ID="Table1" runat="server" Width="1160px" style="padding: 0px; border-spacing: 0px;">
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Datos Solicitud</strong>&nbsp;&nbsp;<span><font color="red">(Información del Tipo y lugar a realizar la EPT)</font></span> <HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell Width="170">Solicitante : </asp:TableCell>
                <asp:TableCell Width="280"><asp:DropDownList runat="server" ID="solSol"></asp:DropDownList></asp:TableCell>
                <asp:TableCell Width="160">Fecha : </asp:TableCell>
                <asp:TableCell Width="280"><asp:TextBox runat="server" ID="solFecha" MaxLength="50" Width="40%"></asp:TextBox></asp:TableCell>
                <asp:TableCell Width="165">Hora : </asp:TableCell>
                <asp:TableCell Width="280"><asp:TextBox runat="server" ID="solHora" MaxLength="11"  Width="20%" onblur="validaHora(this.value);"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Tipo : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solTipo" onchange="muestraSegmento(this.value);">
                </asp:DropDownList><asp:TextBox runat="server" ID="codSolHidden" MaxLength="50" Width="40%" Visible="True" EnableViewState="False" Enabled="False" BackColor="White" BorderColor="White" BorderStyle="None" ForeColor="White">
                </asp:TextBox></asp:TableCell>
                <asp:TableCell>Región EPT : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solReg" Width="100%" onchange="llena_comunas(this.value,0);llena_Profesionales_Sug(0,this.value);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Comuna EPT : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solCom" Width="100%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Forma Ingreso : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solForma"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Observaciones : </asp:TableCell>
                <asp:TableCell ColumnSpan="4"><asp:TextBox runat="server" ID="solObs" MaxLength="300" Width="100%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Datos Paciente</strong><HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Rut Paciente : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solRutPac" MaxLength="10" Width="50%" placeholder="Rut Ej: 16313889-8" onblur="datostrabajador(this.value);"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Nombre Paciente : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solNomPac" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Orden Siniestro : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solSin" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Teléfono Fijo : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solTelFijo" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Teléfono Móvil : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solTelMovil" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Email : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solEmailPac" MaxLength="50"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Dirección : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solDirPac" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Región : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solRegPac" Width="100%" onchange="llena_comunasPac(this.value,0);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Comuna : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solComPac" Width="100%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Datos Empresa</strong><HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Rut Empresa : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solEmp" MaxLength="10" Width="50%" onblur="datosEmpresa(this.value);" placeholder="Rut Ej: 16313889-8"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Nombre Empresa : </asp:TableCell>
                <asp:TableCell ColumnSpan="4"><asp:TextBox runat="server" ID="solEmpNom" MaxLength="50" Width="37%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Dirección : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solDirEmp" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Región : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solRegEmp" Width="100%" onchange="llena_comunasEmp(this.value,0);"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Comuna : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solComEmp" Width="100%"></asp:DropDownList></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Contacto : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="SolConEmp" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Contacto Teléfono: </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="SolConTel" MaxLength="50"></asp:TextBox></asp:TableCell>
                <asp:TableCell>Contacto Email : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="SolConEmail" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell ColumnSpan="6"><strong>Posible Enfermedad Profesional</strong><HR></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Tipo de Caso : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solCaso"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Profesional Sugerido : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solProf" Width="100%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Observaciones : </asp:TableCell>
                <asp:TableCell><asp:TextBox runat="server" ID="solObsCaso" MaxLength="50" Width="100%"></asp:TextBox></asp:TableCell>
            </asp:TableRow>
            <asp:TableRow>
                <asp:TableCell>Adjuntar Documentos : </asp:TableCell>
                <asp:TableCell>
                    <asp:FileUpload ID="solArch" runat="server" Width="80%" class="multi" accept="png|jpg|pdf" />
                </asp:TableCell>
            </asp:TableRow>
            <asp:TableRow ID="trSegmento" >                
                <asp:TableCell>Nº Segmento : </asp:TableCell>
                <asp:TableCell>1<!--<asp:DropDownList runat="server" ID="solNseg"></asp:DropDownList>--></asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat"></asp:DropDownList>&nbsp;&nbsp;<asp:Image id="Agregar1" runat="server" ImageUrl="images/Agregar.png" onclick="MostrarSeg(2,1,1);"></asp:Image></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento2" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>2</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg2" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat2"></asp:DropDownList>&nbsp;&nbsp;<asp:Image id="Agregar2" runat="server" ImageUrl="images/Agregar.png" onclick="MostrarSeg(3,2,1);" />&nbsp;<asp:Image id="Remove2" runat="server" ImageUrl="images/remove.png" onclick="MostrarSeg(2,1,2);"/></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento3" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>3</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg3" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat3"></asp:DropDownList>&nbsp;&nbsp;<asp:Image id="Agregar3" runat="server" ImageUrl="images/Agregar.png" onclick="MostrarSeg(4,3,1);" />&nbsp;<asp:Image id="Remove3" runat="server" ImageUrl="images/remove.png" onclick="MostrarSeg(3,2,2);"/></asp:TableCell>
            </asp:TableRow>  
            <asp:TableRow ID="trSegmento4" >                
                <asp:TableCell></asp:TableCell>
                <asp:TableCell>4</asp:TableCell>
                <asp:TableCell>Segmento : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solSeg4" Width="90%"></asp:DropDownList></asp:TableCell>
                <asp:TableCell>Lateralidad : </asp:TableCell>
                <asp:TableCell><asp:DropDownList runat="server" ID="solLat4"></asp:DropDownList>&nbsp;&nbsp;&nbsp;<asp:Image id="Remove4" runat="server" ImageUrl="images/remove.png" onclick="MostrarSeg(4,3,2);"/></asp:TableCell>
            </asp:TableRow>  
        </asp:Table>
    </form> 
</div>

<div id="dialogEstado">
    <form id="formEstado" style="font-size: 11px; width: 500px">
         <table id="tablaEstado">
            <tr>
                <td style="width:120px;">Estado : </td>
                <td style="width:380px;"><select name="tipoEstado" id="tipoEstado" style="width:50%;">
                                            <option value="">Seleccione</option>
                                            <option value="17">Anular Solicitud</option>
                                            <option value="18">Cancelar Solicitud</option>
                                         </select></td>
            </tr>
            <tr>
                <td>Observaciones : </td>
                <td><textarea id="obsEstado" name="obsEstado" cols="30" rows="6"></textarea></td>
            </tr>
        </table>
    </form> 
</div>

<div id="dialogEnviar">
    <form id="formEnviar" style="font-size: 11px; width: 400px">
         <table id="tablaEnviar">
            <tr id="tdTxtEnviar" name="tdTxtEnviar">
                <td style="width:300px;">Esta Seguro de Enviar Notificación?<input name="dEnviarID" type="hidden" id="dEnviarID" /></td>
            </tr>
            <!--<tr id="tdEnviarCarga" name="tdEnviarCarga">
                <td style="width:500px;" ><center><img id="loading" src="images/loading_cbm.gif" style="display:none;"/></center></td>
            </tr>-->
        </table>
    </form> 
</div>

<div id="dialogEstFinaliza">
    <form id="formEstFinaliza" style="font-size: 11px; width: 540px">
         <table id="tablaEstFinaliza">
            <tr>
                <td colspan="2" id="txtEstFinaliza" name="txtEstFinaliza"></td>
            </tr>
            <tr>
                <td>Acción : <!--<input name="tipoEstFinaliza" type="hidden" id="tipoEstFinaliza" />--></td>
                <td><select name="tipoEstFinaliza" id="tipoEstFinaliza" style="width:50%;"></select></td>
            </tr>
            <tr>
                <td>Fecha Acción : </td>
                <td><input name="EstFechaFinaliza" type="text" maxlength="50" id="EstFechaFinaliza" style="width:20%;" /></td>
            </tr>
            <tr>
                <td style="width:180px;">Observaciones : <!--<input name="tipoEstFinaliza" type="hidden" id="tipoEstFinaliza" />--></td>
                <td style="width:360px;"><textarea id="obsEstFinaliza" name="obsEstFinaliza" cols="50" rows="6"></textarea></td>
            </tr>
            <tr>
                    <td class="txtFechaRecepcion">Fecha Recepción : </td>
                    <td>
                        <input name="fecha_recepcion" type="text" readonly id="fecha_recepcion" style="width: 25%;" />
                    </td>
            </tr>
        </table>
    </form> 
</div>

<div id="dialogEstadoEpt">
    <form id="formEstadoEpt" style="font-size: 11px; width: 500px">
         <table id="tablaEstadoEpt">
            <tr>
                <td style="width:120px;">Motivo : </td>
                <td style="width:380px;"><select name="tipoEstadoEpt" id="tipoEstadoEpt" style="width:50%;">
                                            <option value="">Seleccione</option>
                                            <option value="21">Por Solicitud de la Empresa</option>
                                            <option value="22">Por Solicitud del Eptista</option>
                                            <option value="23">Otro</option>
                                         </select></td>
            </tr>
            <tr>
                <td>Observaciones : </td>
                <td><textarea id="obsEstadoEpt" name="obsEstadoEpt" cols="30" rows="6"></textarea></td>
            </tr>
        </table>
    </form> 
</div>

<div id="dialog_asignacion">
    <form id="formAsignacion" style="font-size: 11px; width: 850px">
         <table id="tablaAsignacion">
            <tr>
                <td>Región : </td>
                <td><select name="asiReg" id="asiReg" style="width:80%;" onchange="llena_Profesionales(0,this.value,0,$('#asiTSol').val()); llena_comunas2(this.value,0);" ></select>
                    <input type="hidden" name="asiTSol" id="asiTSol"/>
                </td>
            </tr>
             <tr>
                    <td>Asignación : </td>
                    <td>
                        <select name="asiCaso" id="asiCaso" style="width: 50%;" onchange="llena_campos(this.value);">
                            <option value="">Seleccione</option>
                            <option value="Remoto">Remoto</option>
                            <option value="Presencial">Presencial</option>
                            <option value="Mixto">Mixto</option>

                        </select></td>
                </tr>
                <tr class="comuna">
                    <td>Comuna : </td>
                    <td>
                        <select name="asiComuna" id="asiComuna" style="width: 50%;"></select></td>
                </tr>
                <tr class="medio">
                    <td>Medio : </td>
                    <td>
                        <select name="asiMed" id="asiMed" style="width: 50%;" onchange="llena_campos2(this.value);">
                            <option value="">Seleccione</option>
                            <option value="Teams">Teams</option>
                            <option value="Zoom">Zoom</option>
                            <option value="GoogleMeets">Google Meets</option>
                            <option value="Skype">Skype</option>
                            <option value="LlamadaTel">Llamada Telefonica</option>
                            <option value="Otros">Otros</option>
                        </select></td>
                </tr>
                <tr class="otros">
                    <td>Otros : </td>
                    <td>
                        <input name="asiOtros" type="text" maxlength="50" id="asiOtros" style="width: 50%;" /></td>
                </tr>
            <tr>
                <td style="width:180px;">Fecha Programación : </td>
                <td style="width:230px;"><input name="asiFecha" type="text" maxlength="50" id="asiFecha" style="width:25%;" onchange="tablaAgenda($('#asiProf').val(), $('#asiFecha').val());llena_hDisponibles(0, $('#asiProf').val());llena_hDisponibles2(0, $('#asiProf').val());"/></td>
                <td style="width:440px;"></td>
            </tr>
            <tr>                
                <td>Profesional : </td>
                <td><select name="asiProf" id="asiProf" style="width:100%;" onchange="tablaAgenda(this.value, $('#asiFecha').val());llena_hDisponibles(0, this.value);llena_hDisponibles2(0, $('#asiProf').val());llena_TipoAsignacion(0, this.value);llena_Esp(this.value);"></select></td>
            </tr>
            <tr>
                <td>Tipo Actividad : </td>
                <td><select name="asiTipo" id="asiTipo" style="width:100%;"></select></td>
            </tr>
            <tr>                
                <td>Agenda : </td>
                <td><table id="jQGridAgenda"></table>
                    <div id="jQGridAgendaPager"></div>
                </td>
                <td><label id="espProf"></label></td>
            </tr>
            <tr>                
                <td>Horas : </td>
                <td colspan="2">Inicio : <select name="asiHoraDis" id="asiHoraDis" style="width:20%;"></select>
                    Hasta : <select name="asiHoraHasta" id="asiHoraHasta" style="width:20%;"></select>
                </td>
            </tr>
            <tr>
                <td>Observaciones : </td>
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
            <tr style="display:none" id="trSegmentoAccion">
                <td>Segmento : </td><td><select name="actsolSegAccion" id="actsolSegAccion" style="width:40%;"></select>
                &nbsp;&nbsp;Lateralidad :&nbsp;&nbsp;<select name="actsolLatAccion" id="actsolLatAccion" style="width:20%;"></select></td>
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

<div id="grillaBig"> 
    <h1>
        <%: Page.Title %>
    </h1>
<table id=""  style="font-size: 10.5px;">
        <tr>
            <td>Región EPT : </td>
            <td colspan="3"><select name="busReg" id="busReg" onchange="llena_comunasBus(this.value,0);" style="width:100%; font-size:11px"></select></td>
            <td colspan="3">Comuna EPT :&nbsp;&nbsp;
            <select name="busCom" id="busCom" style="width:60%; font-size:11px" onchange="tabla();"></select></td>
            <td colspan="4">Agencia :&nbsp;&nbsp;
            <select name="bussol" id="bussol" style="width:34%; font-size:11px" onchange="tabla();"></select>&nbsp;&nbsp;
            Nº Caso :&nbsp;&nbsp;
            <input id="busNC" name="busNC" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" style="width:18%; font-size:11px"/></td>
        </tr>
        <tr>
            <td style="width:110px">Tipo Solicitud : </td>
            <td style="width:150px"><!--<select name="bustipo" id="bustipo" style="width:90%; font-size:11px" onchange="tabla();">
                    <option value="0">Seleccione</option>-->
                    <!--<option value="4">EPT Disfonía</option>-->
                    <!--<option value="1">EPT ME</option>
                    <option value="2">EPT SM</option>
                    <option value="3">EP Dermat</option></select>-->
                <input type="text" name="busprofAEPT2" id="busprofAEPT2" style="font-size:11px" onchange="llena_regionesProfBusc(comboTree3.getSelectedItemsId().toString());llena_regionesProfBusc2(comboTree3.getSelectedItemsId().toString());tabla();" placeholder="Seleccione"/>
            </td>
            <td style="width:10px"></td>
            <td style="width:160px">Desde:&nbsp;&nbsp;&nbsp;&nbsp;<input id="busFD" name="busFD" type="text" tabindex="1" maxlength="10" size="10" onchange="tabla();"/></td>
            <td style="width:150px">Hasta:&nbsp;&nbsp;&nbsp;&nbsp;<input id="busFH" name="busFH" type="text" tabindex="1" maxlength="10" size="10" onchange="tabla();"/></td>
            <td style="width:10px"></td>
            <td style="width:130px">Año:&nbsp;&nbsp;&nbsp;&nbsp;<select id="busAno" name="busAno" style="width:60%; font-size:11px" onchange="tabla();"></select></td>
            <td style="width:5px"></td>
            <td style="width:5px"></td>
            <td style="width:110px">Dias Ingreso : </td>
            <td style="width:185px"><input id="busDI" name="busDI" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" style="width:25%; font-size:11px"/></td>
        </tr>
        <tr>
		    <td colspan="1">Profesional EV.PS.:</td><td colspan="3"><input type="text" name="busprofAEC" id="busprofAEC" style="font-size:11px" onchange="tabla();" placeholder="Seleccione" autocomplete="off"/></td>
		    <td colspan="1">Profesional Asignado EPT : </td><td colspan="5"><input type="text" name="busprofAEPT" id="busprofAEPT" style="font-size:11px" onchange="tabla();" placeholder="Seleccione" autocomplete="off"/></td>
	    </tr>
        <tr>
            <td colspan="2">Paciente (Ingrese Rut o Nombre): &nbsp;&nbsp;<input id="busPac" name="busPac" type="text" tabindex="1" maxlength="20" size="20" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%; font-size:11px"/></td>
            <td colspan="3">Empresa (Ingrese Rut o Razón Social): &nbsp;&nbsp;<input id="busEmp" name="busEmp" type="text" tabindex="1" maxlength="20" size="20" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%; font-size:11px"/></td>
            <td colspan="2">Orden Siniestro : &nbsp;&nbsp;<input id="busOS" name="busOS" type="text" tabindex="1" maxlength="10" size="18" onkeyup="tabla();" style="font-size:11px"/></td>
            <td colspan="4">Estado EV.PS.: &nbsp;&nbsp;<select name="busEstEP" id="busEstEP" style="width:70%; font-size:11px" onchange="tabla();">
                    <option value="0">Seleccione</option>
                    <!--<option value="5">Agendado</option>-->
                    <option value="4">Agendado Clinico</option>
                    <option value="9">Anulado</option>
                    <option value="12">En Auditoria Revisión EV.PS.</option>
                    <option value="3">En Espera Respuesta</option>
                    <option value="1">En Gestión</option>
                    <option value="13">En Revisión</option>
                    <!--<option value="8">Fecha de Prog. Vencida EPT</option>-->
                    <option value="11">Fecha de Prog. Vencida EV.PS.</option>
                    <option value="7">Finalizado</option>
                    <option value="2">Por Agendar</option>
                    <option value="10">Reagendado</option>
	            </select><br />Estado EPT : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select name="busEst" id="busEst" style="width:70%; font-size:11px" onchange="tabla();">
                    <option value="0">Seleccione</option>
                    <option value="5">Agendado</option>
                    <!--<option value="4">Agendado Clinico</option>-->
                    <option value="9">Anulado</option>
                    <option value="6">En Auditoria Revisión EPT</option>
                    <option value="3">En Espera Respuesta</option>
                    <option value="1">En Gestión</option>
                    <option value="13">En Revisión</option>
                    <option value="8">Fecha de Prog. Vencida EPT</option>
                    <!--<option value="11">Fecha de Prog. Vencida EV.PS.</option>-->
                    <option value="7">Finalizado</option>
                    <option value="2">Por Agendar</option>
                    <option value="10">Reagendado</option>
	            </select></td>
        </tr>
    </table>

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
     <p align="center" id="msnResult"></p>
</div>

<div id="dialogRecepionInforme">
    <form id="formRecepionInforme" style="font-size: 11px; width: 500px">
         <table id="tablaRecepionInforme">
            <tr>
                <td style="width:200px;" id="txtRecepionInformeFecha" name="txtRecepionInformeFecha">Fecha Recepción Informe : </td>
                <td style="width:300px;"><input name="tipoRecepionFecha" type="hidden" id="tipoRecepionFecha" />
                                         <input name="RecepionInformeFecha" type="text" maxlength="50" id="RecepionInformeFecha" style="width:40%;" /></td>
            </tr>
            <!--<tr>
                <td>Observaciones : </td>
                <td><textarea id="obsEstadoEpt" name="obsEstadoEpt" cols="30" rows="6"></textarea></td>
            </tr>-->
        </table>
    </form> 
</div>

<div id="dialogRechComite">
    <form id="formRechComite" style="font-size: 11px; width: 500px">
         <table id="tablaRechComite">
            <tr>
                <td style="width:200px;" id="tablaRechTipo" name="tablaRechTipo">Rechazado por Comité : </td>
                <td style="width:300px;"><input name="RechComite1" id="RechComite1" value="0" type="radio" />Si<input name="RechComite1" id="RechComite1" value="1" type="radio" />No</td>
            </tr>
            <!--<tr>
                <td>Observaciones : </td>
                <td><textarea id="obsEstadoEpt" name="obsEstadoEpt" cols="30" rows="6"></textarea></td>
            </tr>-->
        </table>
    </form> 
</div>
    <div id="dialog_delIns" title="Duplicar y Abrir Caso">
        <p>¿Confirma duplicar y abrir el caso seleccionado?.</p>
    </div>

    <div id="dialog_delIns2" title="Reaperturar Evaluación Psicologica">
        <p>¿Desea reaperturar la evaluación psicologica?.</p>
    </div>

        <div id="dialogEstadoECT">
        <form id="formEstadoECT" style="font-size: 11px; width: 500px">
            <table id="tablaEstadoECT">
                <tr>
                    <td style="width: 120px;">Estado ECT : </td>
                    <td style="width: 380px;">
                        <select name="tipoEstadoECT" id="tipoEstadoECT" style="width: 50%;">
                            <option value="">Seleccione</option>
                            <option value="1">SI</option>
                            <option value="2">NO</option>
                            <option value="3">Fuera de Plazo</option>
                        </select></td>
                </tr>

            </table>
        </form>
    </div>
</asp:Content>