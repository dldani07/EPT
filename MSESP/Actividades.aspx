<%@ Page Title="Actividades" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Actividades.aspx.cs" Inherits="MSESP.Actividades" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">   
    <script type="text/javascript">
        var validator = "";
        var cargada = false;
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
                dateFormat: 'dd/mm/yy',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''
            };

            $.datepicker.setDefaults($.datepicker.regional['es']);

            $("#modal_dialog").dialog({
                title: "Subir Documento",
                height: 500,
                width: 980,
                autoOpen: false,
                modal: true,
                buttons: {
                    Guardar: function () {
                        validarFrm();
                        if ($("#formArchivo").valid()) {
                            //sube();
                            var data = new FormData();
                            var d = $("#formArchivo");
                            for (var i = 0; i < (d.find('input[type=file]').length) ; i++) {
                                data.append((d.find('input[type="file"]').eq(i).attr("id")), ((d.find('input[type="file"]:eq(' + i + ')')[0]).files[0]));
                            }
                            /*var archivos = $("#fileUpload");

                            for (var i = 0; i < archivos[0].files.length; i++)
                                data.append("arch[" + i + "]", archivos[0].files[i])

                            if (files.length > 0) {
                                data.append("UploadedImage", files[0]);
                            }*/
                            data.append("obs", $("#Obs").val());
                            data.append("id", $("#actId").val());
                           
                            $.ajax({
                                type: "POST",
                                url: "Actividades.aspx",
                                contentType: false,
                                processData: false,
                                data: data,
                                success: function () {
                                    $("#jQGridDoc").trigger("reloadGrid");
                                    validator.resetForm();
                                }
                            });
                            $(this).dialog('close');
                        }
                    },
                    Cerrar: function () {
                        validator.resetForm();
                        $(this).dialog('close');
                    }
                },
                closeOnEscape: false,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); }
            });
        });

        function sube() {
            var data = new FormData();
            var files = $("#fileUpload").get(0).files;

            if (files.length > 0) {
                data.append("UploadedImage", files[0]);
            }
            data.append("obs2", $("#Obs").val());

            var ajaxRequest = $.ajax({
                type: "POST",
                url: "Actividades.aspx",
                contentType: false,
                processData: false,
                data: data,
                success: function () {
                    $("#jQGridDoc").trigger("reloadGrid");
                    validator.resetForm();
                }
            });

            ajaxRequest.done(function (xhr, textStatus) {
                // Do other operation
            });
        }

        function validarFrm() {
            validator = $("#formArchivo").validate({
                rules: {
                    fileUpload1: "required",
                    fileUpload2: "required",
                    fileUpload3: "required",
                    Obs: "required"
                },
                messages: {
                    fileUpload1: "&bull; Seleccione Documento",
                    fileUpload2: "&bull; Seleccione Documento",
                    fileUpload3: "&bull; Seleccione Documento",
                    Obs: "&bull; Ingrese Observaciones."
                }
            });
        }

        function verDoc(i, ept, tact) {
            //alert(i + " " + ept);
            $("#fileUpload1").val("");
            $("#fileUpload2").val("");
            $("#fileUpload3").val("");
            $("#fileUpload4").val("");

            $("#arch2").show();
            if (ept=="2") {
                $("#arch1").show();
                if (tact=="4") { 
                    $("#arch3").hide();
                    $("#arch2").hide();
                }
                else {
                    $("#arch3").show();
                    $("#arch2").show();
                }
            }
            else {
                $("#arch1").hide();
                $("#arch3").hide();
            }

            $("#Obs").val("");
            $("#actId").val(i);
            $('#modal_dialog').dialog('open');
            validarFrm();
        }

        function tabla() {
            var rowsToColor = [];
            var comunaId = "0";

            comunaId = $('#busCom').val();

            sUrl = 'jqGridDocProf.ashx?r=' + $('#busReg').val() +
                           '&c=' + comunaId + '&s=' + $('#bussol').val() +
                           '&td=' + $('#bustipo').val() + '&m=' + $('#busMes').val() +
                           '&a=' + $('#busAno').val() + '&rp=' + $('#busPac').val() +
                           '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() +
                           '&est=' + $('#busEst').val() + '&di=' + $('#busDI').val() +
                           '&fi=' + $('#busFD').val() + '&ff=' + $('#busFH').val() +
                           '&u=<%=(string)(Session["IdUsuario"])%>&t=<%=(string)(Session["TpUsuario"])%>&p=<%=(string)(Session["IDProyecto"])%>';

                if (!cargada) {
                    jQuery("#jQGridDoc").jqGrid({
                        url: sUrl,
                        datatype: "xml",
                        colNames: ['Nº', 'Rut Empresa', 'Empresa', 'Rut Paciente', 'Paciente', 'Orden Siniestro', 'Estado', 'Tipo', 'Profesional', 'Programación', 'Plazo', ''],
                        colModel: [
                                    { name: 'cod', index: 'cod', width: 55, stype: 'text' },
                                    { name: 'RUT_E', index: 'RUT_E', width: 50, stype: 'text' },
                                    { name: 'NOM_E', index: 'NOM_E', width: 90, stype: 'text' },
                                    { name: 'TRAB_RUT', index: 'TRAB_RUT', width: 50, stype: 'text' },
                                    { name: 'TRAB_NOM', index: 'TRAB_NOM', width: 90, stype: 'text' },
                                    { name: 'ORDEN_SINIESTRO', index: 'ORDEN_SINIESTRO', width: 50, stype: 'text' },
                                    { name: 'Ecaso', index: 'Ecaso', width: 70, stype: 'text' },
                                    { name: 'TIPO', index: 'TIPO', width: 40, stype: 'text' },
                                    { name: 'PROF', index: 'PROF', width: 90, stype: 'text' },
                                    { name: 'FECHA_PROGRAMACION', index: 'FECHA_PROGRAMACION', width: 50, stype: 'text' },
                                    { name: 'DIAS', index: 'DIAS', width: 18, stype: 'text' },
                                    { width: 18, stype: 'text' }
                        ],
                        rowNum: 300,
                        width: 960,
                        height: 200,
                        mtype: 'GET',
                        loadonce: false,
                        rowList: [300, 500, 1000],
                        pager: '#jQGridDocPager',
                        sortname: 'FECHA_PROGRAMACION',
                        viewrecords: true,
                        sortorder: 'desc',
                        caption: "Listado de Documentos",
                        gridComplete: function () {
                            /*for (var i = 0; i < rowsToColor.length; i++) {
                                alert($("#" + rowsToColor[i]).find("td").eq(7).html());
                                var status = $("#" + rowsToColor[i]).find("CDATA[").eq(7).html();
                                if (status == "Complete") {
                                    $("#" + rowsToColor[i]).find("td").css("background-color", "green");
                                    $("#" + rowsToColor[i]).find("td").css("color", "silver");
                                }
                            }*/
                            var rows = $("#jQGridDoc").getDataIDs();
                            for (var i = 0; i < rows.length; i++) {
                                //alert();
                                var status = $("#jQGridDoc").getCell(rows[i], "DIAS");
                                if (status >= 2) {
                                    $("#jQGridDoc").jqGrid('setRowData', rows[i], false, { color: 'Red', weightfont: 'bold'});
                                }
                            }
                        }
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
                    cargada = true;
                    //jQuery("#jQGridDoc").jqGrid('setGridParam', { url: sUrl }).trigger("reloadGrid");
                }
                else {
                    jQuery("#jQGridDoc").jqGrid('setGridParam', { url: sUrl }).trigger("reloadGrid");
                }
        }

        function rowColorFormatter(cellValue, options, rowObject) {
            if (cellValue == "True")
                rowsToColor[rowsToColor.length] = options.rowId;
            return cellValue;
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
    </script>
<div id="modal_dialog">
  <form id="formArchivo" style="font-size: 11px; width:800px">
         <table id="tablaArchivo">
            <tr>
                <td colspan="2"><strong>Documentación de Respaldo :<HR></strong><input id="actId" name="actId" type="hidden"/></td>
            </tr>
            <tr id="arch1">
                <td style="width:280px">Entrevista Psicológica : </td>
                <td><input id="fileUpload1" name="fileUpload1" type="file" /></td>
            </tr>
            <tr id="arch2">
                <td>Estudio de Puestos de Trabajo (EPT) : </td>
                <td><input id="fileUpload2" name="fileUpload2" type="file" /></td>
            </tr>
            <tr id="arch3">
                <td>Estudio de Condiciones de Trabajo (ECT) : </td>
                <td><input id="fileUpload3" name="fileUpload3" type="file" /></td>
            </tr>
            <tr id="arch4">
                <td>Otros documentos : </td>
                <td><input id="fileUpload4" name="fileUpload4" type="file" /></td>
            </tr>
            <tr>
                <td colspan="2"><HR></td>
            </tr>
            <tr>                
                <td>Observación : </td>
                <td><textarea id="Obs" name="Obs" cols="30" rows="6"></textarea></td>
            </tr>
        </table>
    </form> 
</div>

    <div id="grilla"> 
        <h1>
            <%:Page.Title%>
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
            <td style="width:130px">Tipo : </td>
            <td style="width:180px"><select name="bustipo" id="bustipo" style="width:90%;" onchange="tabla();">
                    <option value="0">Seleccione</option>
                    <option value="13">EPT Dermatología</option>
                    <option value="5">EPT ME</option>
                    <option value="12">EPT SM</option>
                    <option value="4">Eval. Psicológica</option></select>
            </td>
            <td style="width:10px"></td>
            <td style="width:120px">Fecha Desde : </td>
            <td style="width:115px"><input id="busFD" name="busFD" type="text" tabindex="1" maxlength="10" size="10" onchange="tabla();"/></td>
            <td style="width:10px"></td>
            <td style="width:135px">Fecha Hasta : </td>
            <td style="width:10px"><input id="busFH" name="busFH" type="text" tabindex="1" maxlength="10" size="10" onchange="tabla();"/></td>
            <td style="width:10px"></td>
            <td style="width:110px">Dias Solicitud</td>
            <td style="width:170px"><input id="busDI" name="busDI" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" style="width:25%;"/></td>
        </tr>
        <tr>
            <td>Rut Paciente : </td>
            <td colspan="2"><input id="busPac" name="busPac" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%;"/></td>
            <td>Rut Empresa : </td>
            <td colspan="2"><input id="busEmp" name="busEmp" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();" placeholder="Ej: 16313889-8" style="width:100%;"/></td>
            <td>Orden Siniestro : </td>
            <td><input id="busOS" name="busOS" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tabla();"/></td>
            <!--<td></td>
            <td>Estado : </td>
            <td colspan="3"><select name="busEst" id="busEst" style="width:80%;" onchange="tabla();">
                    <option value="">Seleccione</option>
                    <option value="5">Agendado</option>
                    <option value="4">Agendado Clinico</option>
                    <option value="9">Anulado</option>
                    <option value="8">Ejecutados</option>
                    <option value="6">En Auditoria Revisión EPT</option>
                    <option value="3">En Espera Respuesta</option>
                    <option value="1">En Gestión</option>
                    <option value="7">Finalizado</option>
                    <option value="2">Por Agendar</option>
	            </select></td>-->
        </tr>
    </table>

                <table id="jQGridDoc">
                </table>
                <div id="jQGridDocPager">
                </div>
    </div>
</asp:Content>
