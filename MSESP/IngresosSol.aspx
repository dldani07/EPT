<%@ Page Title="Solicitudes Ingresadas" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="IngresosSol.aspx.cs" Inherits="MSESP.IngresosSol" %>

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

        $(document).ready(function () {
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
                dateFormat: 'dd/mm/yy', //minDate: -30, maxDate: "+0D",
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''
            };
            
            $.datepicker.setDefaults($.datepicker.regional['es']);

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

            //$("#tabs").tabs();


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

            $("#modal_dialog").dialog({
                title: "Seguimiento Solicitudes",
                height: 600,
                width: 1180,
                autoOpen: false,
                modal: true,
                buttons: {
                    Guardar: function () {
                        if ($("#myForm").valid()) {
                            $('#sendMsn').html('Espere Mientras se Registra Solicitud.');
                            $("#sendConf").dialog('open');
                            $.ajax({
                                type: "POST",
                                url: "actualizaSolicitud.ashx",
                                data: $('#myForm').serialize(),
                                datatype: "xml",
                                success: function (data) {
                                    //$('#result').html(data);
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
                    $('#modal_dialog').dialog('option', 'title', 'Solicitud N° ' + cod + '-' + i);

                    $.ajax({
                        type: "GET",
                        url: "datosSolicitud.ashx",
                        data: { id: i },
                        dataType: "xml",
                        success: function (xml) {
                            $('row', xml).each(function (i) {
                                //alert($(this).find('DOC').text());
                                
                                $('#actsolID').val($(this).find('ID_SOLICITUD').text());
                                llena_regionesPacAct($(this).find('preg').text());
                                llena_comunasPacAct($(this).find('preg').text(), $(this).find('pcom').text());
                                llena_Profesionales_SugAct($(this).find('IDPROF').text(), $(this).find('ID_REGION_EPT').text())

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
                                //$("#actsolNseg option[value=" + $(this).find('N_SEGMENTO').text() + "]").attr('selected', 'selected');
                                $("#actsolSeg option[value=" + $(this).find('ID_SEGMENTO').text() + "]").attr('selected', 'selected');
                                $("#actsolLat option[value=" + $(this).find('ID_LATERAL').text() + "]").attr('selected', 'selected');
                                $("#actsolCaso option[value=" + $(this).find('ID_CASO').text() + "]").attr('selected', 'selected');

                                muestraSegmento($(this).find('ID_TIPO_SOLICITUD').text());

                                $('#tdLink').html($(this).find('DOC').text().replace("*", "<a href=# onclick=verDoc('").replace("/", "');>Ver</a>"));

                                validarFrm();
                            });
                        }
                    });

                    /*tablaAsignaciones(i);
                    tablaAcciones(i);
                    tablaDoc(i);
                    tablaFinal(i);*/
                    $('#modal_dialog').dialog('open');
                }

                function verDoc(doc) {
                    $("#ifPagina").attr('src', "Documentos/" + doc);
                    if (!$('#Doc').dialog('isOpen'))
                        $('#Doc').dialog('open');
                    //alert(doc);
                }

                function validaHoraAct(valor) {
                    if (valor.indexOf("_") == -1) {
                        var hora = valor.split(":")[0];
                        if (parseInt(hora) > 23) {
                            $("#actsolHora").val("");
                        }
                    }
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

                function llena_Profesionales_SugAct(id, id_region) {
                    $("#actsolProf").html("");
                    $.ajax({
                        type: "GET",
                        url: "listarProfesionales.ashx",
                        data: { t: "2", r: id_region },
                        dataType: "xml",
                        success: function (xml) {
                            $("#actsolProf").append("<option value=\"\">Seleccione</option>");
                            $('row', xml).each(function (i) {
                                if (id == $(this).find('ID').text())
                                    $("#actsolProf").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                            $(this).find('NOMBRE').text() + '</option>');
                                else
                                    $("#actsolProf").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                            $(this).find('NOMBRE').text() + '</option>');
                            });
                        }
                    });
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
                    validator = $("#myForm").validate({
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
                            actsolObsCaso: "required",
                            actsolProf: "required"
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
                            actsolObsCaso: "&bull; Ingrese Observaciones del caso.",
                            actsolProf: "&bull; Seleccione Profesional."
                        }
                    });
                }

  
    function muestraCorreo(e) {
        //alert(e);
        if (e == "1") {
            //$('#trdestino').show();
            $('#trcorreo').show();
        }
        else {
            //$('#trdestino').hide();
            $('#trcorreo').hide();
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
            $('#trSegmento').hide();
        }
        else {
            $('#MainContent_trSegmento').show();
            $('#trSegmento').show();
        }
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
                    $('#actsolEmpNom').val($(this).find('NOMBRE').text());
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
                    $('#actsolNomPac').val($(this).find('NOMBRE').text());
                    $('#actsolTelFijo').val($(this).find('FONO_FIJO').text());
                    $('#actsolTelMovil').val($(this).find('FONO_MOVIL').text());
                    $('#actsolEmailPac').val($(this).find('EMAIL').text());
                    $('#actsolDirPac').val($(this).find('DIRECCION').text());

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
                        //$('#solPend').dialog('open');
                    }*/
                });
            }
        });
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

    function tabla() {
        var comunaId = "0";

        comunaId = $('#busCom').val();

        sUrl = 'jqGridIngresos.ashx?r=' + $('#busReg').val() +
               '&c=' + comunaId + '&s=' + $('#bussol').val() +
               '&t=' + $('#bustipo').val() + '&fi=' + $('#busFD').val() +
               '&ff=' + $('#busFH').val() + '&rp=' + $('#busPac').val() +
               '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() + 
               '&est=' + $('#busEst').val() + '&di=' + $('#busDI').val();

        if (cargadaDoc) {
            jQuery("#jQGridDemo").jqGrid('setGridParam', { url: sUrl });
            jQuery("#jQGridDemo").trigger("reloadGrid");
        } else {
            cargadaDoc = true;

            jQuery("#jQGridDemo").jqGrid({
                url: 'jqGridIngresos.ashx?r=0&c=null&s=0&t=0&fi=&ff=&rp=&re=&os=&est=0&di=',
                datatype: "xml",
                colNames: ['Nº', 'Tipo', 'Fecha Solicitud', 'Agencia', 'Rut Empresa', 'Empresa', 'Rut Paciente', 'Paciente', 'Dias', 'Estado', 'Mail Enviado', ''],
                colModel: [
                            { name: 'ID_SOLICITUD', index: 'ID_SOLICITUD', width: 62, stype: 'text' },
                            { name: 'TIPO', index: 'TIPO', width: 40, stype: 'text' },
                            { name: 'FECHA_SOLICITUD', index: 'FECHA_SOLICITUD', width: 60, stype: 'text' },
                            { name: 'SOL', index: 'SOL', width: 65, stype: 'text' },
                            { name: 'RUT_E', index: 'RUT_E', width: 60, stype: 'text' },
                            { name: 'NOM_E', index: 'NOM_E', width: 100, stype: 'text' },
                            { name: 'TRAB_RUT', index: 'TRAB_RUT', width: 60, stype: 'text' },
                            { name: 'TRAB_NOM', index: 'TRAB_NOM', width: 100, stype: 'text' },
                            { name: 'ORDEN_SINIESTRO', index: 'ORDEN_SINIESTRO', width: 30, stype: 'text' },
                            { name: 'EST', index: 'EST', width: 70, stype: 'text' },
                            { name: 'EST', index: 'EST', width: 50, stype: 'text' },
                            { width: 20, stype: 'text' }
                ],
                rowNum: 50,
                width: 960,
                height: 200,
                mtype: 'GET',
                loadonce: false,
                rowList: [50, 100, 200],
                pager: '#jQGridDemoPager',
                sortname: 'cod',
                viewrecords: true,
                sortorder: 'desc',
                caption: "Listado de Solicitudes",
                editurl: 'jqGridConsultas.ashx'
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
        }
    }

    function llena_agencias(id) {
        $("#bussol").html("");
        $.ajax({
            type: "GET",
            url: "listaAgencias.ashx",
            data: { id: id },
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


</script>

<div id="modal_dialog">
    <!--<div id="tabs" style="height:570px">
	    <ul>
		    <li><a href="#tabs-1">Solicitud</a></li>
	    </ul>
	    <div id="tabs-1" >-->
    <form id="myForm">
        <table id="tablActSol" style="width:1130px;font-size: 11px;">
            <tr>
                <td colspan="6"><strong>Datos Solicitud</strong>&nbsp;&nbsp;<span><font color="red">(Información del Tipo y lugar a realizar la EPT)</font></span><HR></td>
            </tr>
	        <tr>
		        <td style="width:180px;">Tipo : </td>
                <td style="width:280px;"><input name="actsolID" type="hidden" id="actsolID"/><label id="actsolTipo" name="actsolTipo" onchange="muestraSegmento(this.value);"></label></td>
                <td style="width:200px;">Fecha : </td>
                <td style="width:280px;"><input name="actsolFecha" type="text" maxlength="50" id="actsolFecha" style="width:40%;" /></td>
                <td style="width:180px;">Hora : </td>
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
                <td colspan="4"><input name="actsolObs" type="text" maxlength="30" id="actsolObs" style="width:100%;"/></td>
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
			        <option value="">Seleccione</option>
			        <option value="1">STP</option>
			        <option value="2">CTP</option></select></td>
                <td>Profesional Sugerido : </td>
                <td><select name="actsolProf" id="actsolProf"></select></td>
                <td>Observaciones : </td>
                <td><input name="actsolObsCaso" type="text" maxlength="50" id="actsolObsCaso" /></td>
            </tr>
            <tr>
                <td>Documentos</td>
                <td name="tdLink" id="tdLink"></td>
	        </tr>
            <tr ID="trSegmento">
		        <td>Nº Segmento : </td>
                <td><select name="actsolNseg" id="actsolNseg">
			        <option value="N/A">N/A</option>
			        <option value="1">1</option>
			        <option value="2">2</option></select></td>
                <td>Segmento : </td>
                <td><select name="actsolSeg" id="actsolSeg" style="width:90%;">
                        <option value="1">Cervico Braquialgia</option>
                        <option value="2">Codo</option>
                        <option value="3">Dermatología</option>
                        <option value="4">Hombro</option>
                        <option value="5">Lumbar</option>
                        <option value="6">Mano-Dedo (T. Nodular)</option>
                        <option value="7">Mano-Muñeca (STC)</option>
                        <option value="8">Mano-Pulgar (T. Quervain)</option>
                        <option value="9">Miembro Inferior</option>
                        <option value="10">Muñeca- Mano (T. Flexores-Extensores)</option>
                        <option value="11">Otra</option>
                </select></td>
                <td>Lateralidad : </td>
                <td><select name="actsolLat" id="actsolLat">
			        <!--<option value="1">N/A</option>-->
			        <option value="1">Bilateral</option>
			        <!--<option value="3">Bilateral, Bilateral</option>-->
			        <option value="2">Derecho</option>
			        <!--<option value="5">Derecho, Derecho</option>-->
			        <option value="3">Izquierdo</option>
		        </select></td>

	        </tr>
        </table>   
        </form>
	    </div>
    <!--</div>
</div>-->
    
<div id="grilla"> 
    <h1>
        <%: Page.Title %>
    </h1>
    <table id=""  style="font-size: 11px;">
        <tr>
            <td>Región EPT : </td>
            <td colspan="3"><select name="busReg" id="busReg" onchange="llena_comunas(this.value,0);" style="width:100%;"></select></td>
            <td>Comuna EPT : </td>
            <td colspan="4"><select name="busCom" id="busCom" style="width:100%;" onchange="tabla();"></select></td>
            <td>Agencia : </td>
            <td ><select name="bussol" id="bussol" style="width:80%;" onchange="tabla();">
                    <option value="0">Seleccione</option>
                    <option value="1">Corporativo</option>
	            </select></td>
        </tr>
        <tr>
            <td style="width:130px">Tipo Solicitud : </td>
            <td style="width:180px"><select name="bustipo" id="bustipo" style="width:90%;" onchange="tabla();">
                    <option value="0">Seleccione</option>
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
            <td style="width:170px"><input id="busDI" name="busDI" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" style="width:25%;"/></td>
        </tr>
        <tr>
            <td>Rut Paciente : </td>
            <td colspan="2"><input id="busPac" name="busPac" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%;"/></td>
            <td>Rut Empresa : </td>
            <td colspan="2"><input id="busEmp" name="busEmp" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%;"/></td>
            <td>Orden Siniestro : </td>
            <td><input id="busOS" name="busOS" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();"/></td>
            <td></td>
            <td>Estado : </td>
            <td colspan="3"><select name="busEst" id="busEst" style="width:80%;" onchange="tabla();">
                    <option value="0">Seleccione</option>
                    <option value="4">Agendado Clinico</option>
                    <option value="5">Agendado Ejecutado</option>
                    <option value="6">En Auditoria Revisión EPT</option>
                    <option value="3">En Espera Respuesta</option>
                    <option value="1">En Gestión</option>
                    <option value="7">Finalizado</option>
                    <option value="2">Por Agendar</option>
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

<div id="resultadoIngreso" title="Registro de Solicitud">
     <p align="center" id="msnResult"></p>
</div>
</asp:Content>