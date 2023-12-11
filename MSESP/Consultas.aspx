<%@ Page Title="Consultas" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Consultas.aspx.cs" Inherits="MSESP.Consultas" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent"> 
    <script type="text/javascript">
        var validatorAccion = "";
        var validatorAsignacion = "";
        var idSeg = "";
        var codsol = "";
        var cargada = false;
        var cargadaAcc = false;
        var cargadaDoc = false;
        var check = '0';
        $(document).ready(function () {
            $('#tpActivos').removeAttr('checked');
            $('#busFD').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
            $('#busFH').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
            llena_regiones(0);
            llena_comunas(0, 0);
            llena_agencias(0);
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

            $("#tpActivos").on("click", function () {
                if ($("#tpActivos").is(":checked")) {
                    check = '1';
                } else {
                    check = '0';
                }
                tabla();
            });

            $("#dialog_accion").dialog({
                title: "Registro de Acción",
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
                                validarFrmAccion();
                                if ($("#formAccion").valid()) {
                                    var parametros = {
                                        tipo: $('#accTipo').val(),
                                        fecha: $('#accFecha').val(),
                                        obs: $('#accObs').val(),
                                        id_sol: idSeg,
                                        usr: '<%=(string)(Session["IdUsuario"])%>'
                                };

                                $.ajax({
                                    url: 'Solicitud.aspx/GuardarAccion',
                                    type: 'POST',
                                    data: JSON.stringify(parametros),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
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

            $("#dialog_asignacion").dialog({
                title: "Registro de Asignación",
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
                                validarFrmAsignacion();
                                if ($("#formAsignacion").valid()) {
                                    var parametros = {
                                        tipo: $('#asiTipo').val(),
                                        fecha: $('#asiFecha').val(),
                                        prof: $('#asiProf').val(),
                                        id_sol: idSeg,
                                        usr: '<%=(string)(Session["IdUsuario"])%>'
                                    };

                                    $.ajax({
                                        url: 'Solicitud.aspx/GuardarAsignacion',
                                        type: 'POST',
                                        data: JSON.stringify(parametros),
                                        contentType: "application/json; charset=utf-8",
                                        dataType: "json",
                                        success: function () {
                                            $("#jQGridAsignaciones").trigger("reloadGrid");
                                            //tablaDoc(idSeg);
                                            validatorAsignacion.resetForm();
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
                title: "Registro de ",
                height: 580,
                width: 1100,
                autoOpen: false,
                modal: true,
                buttons: {
                    Guardar: function () {
                        // validarFrm();
                        if ($("#form1").valid()) {
                            $('#sendMsn').html('Espere Mientras se Registra Solicitud.');
                            $("#sendConf").dialog('open');
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
                                nseg: $('#MainContent_solNseg').val(),
                                idlat: $('#MainContent_solLat').val(),
                                dirEmp: $('#MainContent_solDirEmp').val(),
                                obsCaso: $('#MainContent_solObsCaso').val()
                            };
                            //data: $('form1').serialize(),
                            $.ajax({
                                url: 'Solicitud.aspx/Guardar',
                                type: 'POST',
                                data: JSON.stringify(parametros),           // los parámetros en formato JSON
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function () {                      // función que se va a ejecutar si el pedido resulta exitoso
                                    //$('#lblMensaje').text('La información ha sido guardada exitosamente.');
                                    //alert('La información ha sido guardada exitosamente.');
                                    $("#sendConf").dialog('close');
                                    $('#sendMsn').html('');
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

                function Seguimiento(i, cod) {
                    idSeg = i;
                    $('#modal_dialog').dialog('option', 'title', 'Solicitud N° ' + cod);

                    $.ajax({
                        type: "GET",
                        url: "datosSolicitud.ashx",
                        data: { id: i },
                        dataType: "xml",
                        success: function (xml) {
                            $('row', xml).each(function (i) {
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
                                $('#actsolHora').val($(this).find('HORA').text());
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
                                //$("#actsolNseg option[value=" + $(this).find('N_SEGMENTO').text() + "]").attr('selected', 'selected');
                                //$("#actsolSeg option[value=" + $(this).find('ID_SEGMENTO').text() + "]").attr('selected', 'selected');
                                //$("#actsolLat option[value=" + $(this).find('ID_LATERAL').text() + "]").attr('selected', 'selected');
                                //$("#actsolCaso option[value=" + $(this).find('ID_CASO').text() + "]").attr('selected', 'selected');

                                //llena_segmentos($(this).find('ID_SEGMENTO').text());
                                //$("#actsolLat option[value=" + $(this).find('ID_LATERAL').text() + "]").attr('selected', 'selected');
                                //llena_lateridad($(this).find('ID_LATERAL').text());
                                //$("#actsolCaso option[value=" + $(this).find('ID_CASO').text() + "]").attr('selected', 'selected');

                                for (var tr = 1; tr <= 12; tr++) {
                                    $('#trSegmento' + tr).hide();
                                }

                                var arregloSegmentos = $(this).find('SEGDATOS').text().split("###");

                                for (var i = 0; i < arregloSegmentos.length; i++) {
                                    if (arregloSegmentos[i] != "") {
                                        var arregloSegmentosDet = arregloSegmentos[i].split("##");

                                        for (var det = 0; det < arregloSegmentosDet.length; det++) {
                                            if (arregloSegmentosDet[det] != "") {
                                                if (det == 0) {
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
                                //$('#actsolTipo').find("option[index='" + "1" + "']").attr("selected", "selected");
                                //validarFrm();
                            });
                        }
                    });

                    //tablaAsignaciones(i);
                    //tablaAcciones(i);
                    //tablaDoc(i);
                    log(i);
                    $('#modal_dialog').dialog('open');
                }

                function verDoc(doc) {
                    $("#ifPagina").attr('src', "Documentos/" + doc);
                    if (!$('#Doc').dialog('isOpen'))
                        $('#Doc').dialog('open');
                    //alert(doc);
                }

                function muestraSegmento(e) {
                    if (e == "2") {
                        $('#MainContent_trSegmento').hide();
                        $('#trSegmento').hide();
                    }
                    else {
                        $('#MainContent_trSegmento').show();
                        $('#trSegmento').show();
                    }
                }

                function log(i) {
                    $.ajax({
                        type: "GET",
                        url: "datosLog.ashx",
                        data: { id: i },
                        dataType: "xml",
                        success: function (xml) {
                            $('row', xml).each(function (i) {
                                $("#tablaLog").html("");
                                var arregloDeCadenas = $(this).find('LOG').text().split("--FIN--");

                                for (var i = 0; i < arregloDeCadenas.length; i++) {
                                    var tds = $("#tablaLog tr:first td").length;
                                    var trs = $("#tablaLog tr").length;
                                    var nuevaFila = "<tr>";

                                    //for (var c = 0; c < tds; c++) {
                                    nuevaFila += "<td>" + arregloDeCadenas[i].replace('#link', ' - <a href="#" onclick="verDoc(\'').replace('link#', '\');"  style="color: red; font-weight: bold;">Ver Documento</a>') + "</td>";
                                    //}

                                    //nuevaFila += "<td>" + arregloDeCadenas[i];
                                    nuevaFila += "</tr>";
                                    $("#tablaLog").append(nuevaFila);
                                }
                            });
                        }
                    });
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

                function llena_comunas(id_region, id_comuna) {
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

                function validarFrmAccion() {
                    validatorAccion = $("#formAccion").validate({
                        rules: {
                            accTipo: "required",
                            accFecha: "required"
                        },
                        messages: {
                            accTipo: "&bull; Seleccione Tipo Acción.",
                            accFecha: "&bull; Ingrese Fecha Acción."
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
                                llena_TipoAccion($(this).find('ID').text());
                                $('#dialog_accion').dialog('open');
                                $("#button-Guardar").hide();
                            });
                        }
                    });
                }

                function llena_TipoAsignacion(tipo) {
                    $("#asiTipo").html("");
                    $.ajax({
                        type: "GET",
                        url: "listarTipoActividad.ashx",
                        data: { t: "2" },
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
                            asiProf: "required"
                        },
                        messages: {
                            asiTipo: "&bull; Seleccione Tipo Actividad.",
                            asiFecha: "&bull; Ingrese Fecha Actividad.",
                            asiProf: "&bull; Seleccione Profesional."
                        }
                    });
                }

                function llena_Profesionales(id) {
                    $("#asiProf").html("");
                    $.ajax({
                        type: "GET",
                        url: "listarProfesionales.ashx",
                        data: { t: "2" },
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
                                llena_TipoAsignacion($(this).find('TIPO').text());
                                llena_Profesionales($(this).find('PROFESIONAL').text());
                                $('#dialog_asignacion').dialog('open');
                                //$("#button-Guardar").hide();
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
                                llena_TipoAsignacion(0);
                                llena_Profesionales(0);
                                //$('#accObs').val(""),
                                $('#asiFecha').val(""),
                                $('#asiFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                                $('#dialog_asignacion').dialog('open');
                                //$("#button-Guardar").show();dialog_asignacion
                                // $("#button-Guardar").show();
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
                            colNames: ['Acción', 'Usuario', 'Fecha Realización', ''],
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
                                $('#accObs').val(""),
                                $('#accFecha').val(""),
                                $('#accFecha').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
                                $('#dialog_accion').dialog('open');
                                $("#button-Guardar").show();
                                validarFrmAccion();
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
                            colNames: ['Tipo de Documento', 'Profesional', 'Programación', ''],
                            colModel: [
                                        { name: 'TIPO', index: 'TIPO', width: 300, stype: 'text' },
                                        { name: 'PROF', index: 'PROF', width: 80, stype: 'text' },
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
                            caption: "Listado de Documentos",
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

                function tabla()
                {
                    var comunaId = "0";

                    comunaId = $('#busCom').val();

                    sUrl = 'jqGridConsultas.ashx?r=' + $('#busReg').val() +
                           '&c=' + comunaId + '&s=' + $('#bussol').val() +
                           '&t=' + $('#bustipo').val() + '&m=' + $('#busMes').val() +
                           '&a=' + $('#busAno').val() + '&rp=' + $('#busPac').val() +
                           '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() +
                           '&est=' + $('#busEst').val() + '&estep=' + $('#busEstEP').val() + '&di=' + $('#busDI').val() +
                           '&fi=' + $('#busFD').val() + '&ff=' + $('#busFH').val() + '&nc=' + $('#busNC').val() +
                           '&tp=<%=(string)(Session["TpUsuario"])%>&tu=<%=(string)(Session["IdUsuario"])%>&p=<%=(string)(Session["IDProyecto"])%>&tc=' + check;

                    if (cargadaDoc) {
                        jQuery("#jQGridDemo").jqGrid('setGridParam', { url: sUrl });
                        jQuery("#jQGridDemo").trigger("reloadGrid");
                    } else {
                        cargadaDoc = true;

                        jQuery("#jQGridDemo").jqGrid({
                            url: 'jqGridConsultas.ashx?r=0&c=null&s=0&t=0&m=0&a=0&rp=&fi=&ff=&re=&est=&estep=&di=&os=&nc=&tp=<%=(string)(Session["TpUsuario"])%>&tu=<%=(string)(Session["IdUsuario"])%>&p=<%=(string)(Session["IDProyecto"])%>&tc=0',
                            datatype: "xml",
                            colNames: ['Nº', 'Tipo', 'Caso', 'Fecha Solicitud', 'Solicitante', 'Agencia', 'Rut Empresa', 'Empresa', 'Rut Paciente', 'Paciente', 'Orden Siniestro', 'Est. EPS', 'Est. EPT', 'Fecha Acción', 'Acción', ''],
                            colModel: [
                                        { name: 'ID_SOLICITUD', index: 'ID_SOLICITUD', width: 70, stype: 'text' },
                                        { name: 'TIPO', index: 'TIPO', width: 50, stype: 'text' },
                                        { name: 'TIPO_CASO', index: 'TIPO_CASO', width: 30, stype: 'text' },
                                        { name: 'FECHA_SOLICITUD', index: 'FECHA_SOLICITUD', width: 60, stype: 'text' },
                                        { name: 'SOL', index: 'SOL', width: 100, stype: 'text' },
                                        { name: 'Agencia', index: 'Agencia', width: 60, stype: 'text' },
                                        { name: 'RUT_E', index: 'RUT_E', width: 70, stype: 'text' },
                                        { name: 'NOM_E', index: 'NOM_E', width: 100, stype: 'text' },
                                        { name: 'TRAB_RUT', index: 'TRAB_RUT', width: 70, stype: 'text' },
                                        { name: 'TRAB_NOM', index: 'TRAB_NOM', width: 100, stype: 'text' },
                                { name: 'ORDEN_SINIESTRO', index: 'ORDEN_SINIESTRO', width: 60, stype: 'text' },
                                { name: 'ESTEP', index: 'ESTEP', width: 50, stype: 'text' },
                                        { name: 'EST', index: 'EST', width: 50, stype: 'text' },
                                        { name: 'FACC', index: 'FACC', width: 50, stype: 'text' },
                                        { name: 'ACC', index: 'ACC', width: 50, stype: 'text' },
                                        { width: 20, stype: 'text' }
                            ],
                            rowNum: 100,
                            autowidth: true,
                            height: 200,
                            mtype: 'GET',
                            loadonce: false,
                            rowList: [100, 300, 500],
                            pager: '#jQGridDemoPager',
                            sortname: 'cod',
                            viewrecords: true,
                            sortorder: 'desc',
                            caption: "Listado de Solicitudes",
                            gridComplete: function () {
                                var rows = $("#jQGridDemo").getDataIDs();
                                for (var i = 0; i < rows.length; i++) {
                                    var status = $("#jQGridDemo").getCell(rows[i], "EST");
                                    if (status == "Finalizado" || status == "Anulado" || status == "Cancelado") {
                                        $("#jQGridDemo").jqGrid('setRowData', rows[i], false, { /**/color: 'Black', weightfont: 'bold', background: '#fae275' });
                                    }

                                    if (status == "Fecha de Programación Vencida") {
                                        $("#jQGridDemo").jqGrid('setRowData', rows[i], false, { color: 'Red', weightfont: 'bold'/*, background: '#fae275'*/ });
                                    }
                                }
                            }
                        });

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

                                sUrl = 'excel.aspx?r=' + $('#busReg').val() +
                                       '&c=' + comunaId + '&s=' + $('#bussol').val() +
                                       '&t=' + $('#bustipo').val() + '&m=' + $('#busMes').val() +
                                       '&a=' + $('#busAno').val() + '&rp=' + $('#busPac').val() +
                                       '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() +
                                       '&est=' + $('#busEst').val() + '&estep=' + $('#busEstEP').val() + '&di=' + $('#busDI').val() +
                                       '&fi=' + $('#busFD').val() + '&ff=' + $('#busFH').val() + '&nc=' + $('#busNC').val() +
                                       '&tp=<%=(string)(Session["TpUsuario"])%>&tu=<%=(string)(Session["IdUsuario"])%>&p=<%=(string)(Session["IDProyecto"])%>&tc=' + check + '&tpexcel=2';

                                window.open(sUrl, 'Solicitudes EPT')
                            }
                        });
                    }
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
    </script>

<div id="modal_dialog">
    <div id="tabs" style="height:950px">
	    <ul>
		    <li><a href="#tabs-1">Solicitud</a></li>
            <li><a href="#tabs-6">Historial</a></li>
	    </ul>
        <div id="tabs-6" style="font-size: 11px;">
             <table id="tablaLog" style="width:1000px;">

             </table>
        </div>
	    <div id="tabs-1" style="font-size: 11px;">
        <table id="tablActSol" style="width:1110px;">
            <tr>
                <td colspan="6"><strong>Datos Solicitud</strong> <HR></td>
            </tr>
	        <tr>
		        <td style="width:180px;">Tipo : </td>
                <td style="width:280px;"><label id="actsolTipo" name="actsolTipo"></label></td>
                <td style="width:220px;">Fecha : </td>
                <td style="width:235px;"><input name="actsolFecha" type="text" maxlength="50" id="actsolFecha" style="width:40%;" /></td>
                <td style="width:170px;">Hora : </td>
                <td style="width:280px;"><input name="actsolHora" type="text" maxlength="11" id="actsolHora" onblur="validaHoraAct(this.value);" style="width:30%;" /></td>
	        </tr>
            <tr>
		        <td>Solicitante : </td>
                <td><label id="lbsolicitante" name="lbsolicitante"></label></td>
                <td>Región EPT : </td>
                <td><select name="actsolReg" id="actsolReg" onchange="llena_comunasAct(this.value,0);" style="width:100%;"></select></td>
                <td>Comuna EPT : </td>
                <td><select name="actsolCom" id="actsolCom" style="width:80%;"></select></td>
	        </tr>
            <tr>
		        <td>Forma Ingreso : </td>
                <td name="actsolForma" id="actsolForma"></td>
                <td>Observaciones : </td>
                <td colspan="4"><input name="actsolObs" type="text" maxlength="30" style="width:90%;" id="actsolObs" /></td>
	        </tr>
            <tr>
                <td colspan="6"><strong>Datos Paciente</strong> <HR></td>
            </tr>
            <tr>
		        <td>Rut Paciente : </td>
                <td><input name="actsolRutPac" type="text" maxlength="10" id="actsolRutPac" style="width:40%;" /></td>
                <td>Nombre Paciente : </td>
                <td><input name="actsolNomPac" type="text" maxlength="50" id="actsolNomPac" style="width:100%;"  /></td>
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
                <td>Observaciones : </td>
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

    </div>
</div>

<div id="grillaBig"> 
    <h1>
        <%: Page.Title %>
    </h1>
   <table id=""  style="font-size: 10.5px;">
        <tr>
            <td>Región EPT : </td>
            <td colspan="3"><select name="busReg" id="busReg" onchange="llena_comunas(this.value,0);" style="width:100%; font-size:11px"></select></td>
            <td colspan="3">Comuna EPT : &nbsp;&nbsp;
            <select name="busCom" id="busCom" style="width:55%; font-size:11px" onchange="tabla();"></select></td>
            <td colspan="4">Agencia :&nbsp;&nbsp;
            <select name="bussol" id="bussol" style="width:34%; font-size:11px" onchange="tabla();"></select>&nbsp;&nbsp;
            Nº Caso :&nbsp;&nbsp;
            <input id="busNC" name="busNC" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" style="width:18%; font-size:11px"/></td>
        </tr>
        <tr>
            <td style="width:130px">Tipo Solicitud : </td>
            <td style="width:170px"><select name="bustipo" id="bustipo" style="width:90%; font-size:11px" onchange="tabla();">
                    <option value="0">Seleccione</option>
                    <!--<option value="4">EPT Disfonía</option>-->
                    <option value="1">EPT ME</option>
                    <option value="2">EPT SM</option>
                    <option value="3">EP Dermat</option></select>
            </td>
            <td style="width:10px"></td>
            <td style="width:120px">Fecha Desde : </td>
            <td style="width:115px"><input id="busFD" name="busFD" type="text" tabindex="1" maxlength="10" size="10" onchange="tabla();"/></td>
            <td style="width:10px"></td>
            <td style="width:135px">Fecha Hasta : </td>
            <td style="width:10px"><input id="busFH" name="busFH" type="text" tabindex="1" maxlength="10" size="10" onchange="tabla();"/></td>
            <td style="width:10px"></td>
            <td style="width:110px">Dias Ingreso : </td>
            <td style="width:170px"><input id="busDI" name="busDI" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" style="width:25%; font-size:11px"/>&nbsp;&nbsp;&nbsp;
                <input type="checkbox" name="tpActivos" id="tpActivos" value="1"/>Activos</td>
        </tr>
        <tr>
            <td>Rut Paciente : </td>
            <td colspan="2"><input id="busPac" name="busPac" type="text" tabindex="1" maxlength="20" size="20" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%; font-size:11px"/></td>
            <td>Rut Empresa : </td>
            <td colspan="2"><input id="busEmp" name="busEmp" type="text" tabindex="1" maxlength="20" size="20" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%; font-size:11px"/></td>
            <td colspan="2">Orden Siniestro : <input id="busOS" name="busOS" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();"/></td>
            <td colspan="4">Estado EPS: &nbsp;&nbsp;<select name="busEstEP" id="busEstEP" style="width:70%; font-size:11px" onchange="tabla();">
                              <option value="0">Seleccione</option><!--<option value="5">Agendado</option>-->
                              <option value="4">Agendado Clinico</option>
                              <option value="9">Anulado</option>
                              <option value="12">En Auditoria Revisión EV.PS.</option>
                              <option value="13">En Revisión</option>
                              <option value="3">En Espera Respuesta</option>
                              <option value="1">En Gestión</option><!--<option value="8">Fecha de Prog. Vencida EPT</option>-->
                              <option value="11">Fecha de Prog. Vencida EV.PS.</option>
                              <option value="7">Finalizado</option>
                              <option value="2">Por Agendar</option>
                              <option value="10">Reagendado</option>
                      </select>
                Estado EPT: &nbsp;&nbsp;<select name="busEst" id="busEst" style="width:70%; font-size:11px" onchange="tabla();">
                    <option value="">Seleccione</option>
                    <option value="5">Agendado</option>
                    <option value="9">Anulado</option>
                    <option value="6">En Auditoria Revisión EPT</option>
                    <option value="13">En Revisión</option>
                    <option value="3">En Espera Respuesta</option>
                    <option value="1">En Gestión</option>
                    <option value="8">Fecha de Programación Vencida</option>
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

<div id="sendConf" title="Enviando">
     <p align="center"><label id="sendMsn" name="sendMsn"></label><br/><br/><img src="Images/loadfbk.gif"/></p>
</div>
</asp:Content>

