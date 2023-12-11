<%@ Page Title="Revisión Documentos" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Revision.aspx.cs" Inherits="MSESP.Revision" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent"> 
    <script type="text/javascript">
        var validator = "";
        var cargadaDoc = false;
        
        $(document).ready(function () {
           
            llena_regiones(0);
            llena_comunas(0, 0);
            llena_Profesionales(0,0);
            tablaDoc(0);


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
        });

        function guardarRevision(e) {
            var parametros = {
                id_act: $("#revActId").val(),
                det_act: $("#revActDetId").val(),
                obs: $('#revObs').val(),
                usr: '<%=(string)(Session["IdUsuario"])%>',
            est: e
        };

        $.ajax({
            url: 'Revision.aspx/Revisiones',
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

        function tablaDoc(id) {

            var comunaId = "0";
            //var comunaId = "0";

            comunaId = $('#busCom').val();

            sUrl = 'jqGridDocRev.ashx?r=' + $('#busReg').val() +
                   '&c=' + comunaId + '&s=' + $('#busProf').val() +
                   '&t=' + $('#bustipo').val() + '&m=' + $('#busMes').val() +
                   '&a=' + $('#busAno').val() + '&rp=' + $('#busPac').val() +
                   '&re=' + $('#busEmp').val() + '&os=' + $('#busOS').val() + '&p=<%=(string)(Session["IDProyecto"])%>';

        if (cargadaDoc) {
            jQuery("#jQGridDoc").jqGrid('setGridParam', { url: sUrl });
            jQuery("#jQGridDoc").trigger("reloadGrid");
        } else {
            cargadaDoc = true;
            jQuery("#jQGridDoc").jqGrid({
                url: 'jqGridDocRev.ashx?r=0&c=null&s=0&t=0&m=0&a=0&rp=&re=&os=&p=<%=(string)(Session["IDProyecto"])%>',
                datatype: "xml",
                colNames: ['Nº', 'Tipo', 'Rut Empresa', 'Empresa', 'Rut Paciente', 'Paciente', 'Siniestro', 'Tipo Documento', 'Profesional', 'Programado', 'Subido', ''],
                colModel: [
                            { name: 'cod', index: 'cod', width: 80, stype: 'text' },
                            { name: 'TIPOS', index: 'TIPOS', width: 50, stype: 'text' },
                            { name: 'RUT_E', index: 'RUT_E', width: 100, stype: 'text' },
                            { name: 'NOM_E', index: 'NOM_E', width: 100, stype: 'text' },
                            { name: 'TRAB_RUT', index: 'TRAB_RUT', width: 100, stype: 'text' },
                            { name: 'TRAB_NOM', index: 'TRAB_NOM', width: 100, stype: 'text' },
                            { name: 'ORDEN_SINIESTRO', index: 'ORDEN_SINIESTRO', width: 70, stype: 'text' },
                            { name: 'DOCUMENTO', index: 'DOCUMENTO', width: 100, stype: 'text' },
                            { name: 'PROF', index: 'PROF', width: 80, stype: 'text' },
                            { name: 'fecha', index: 'fecha', width: 75, stype: 'text' },
                            { name: 'F_REL', index: 'F_REL', width: 75, stype: 'text' },
                            { width: 22, stype: 'text' }
                ],
                rowNum: 50,
                width: 960,
                height: 200,
                mtype: 'GET',
                loadonce: false,
                rowList: [50, 100, 200],
                pager: '#jQGridDocPager',
                sortname: 'ID_ACTIVIDAD',
                viewrecords: true,
                sortorder: 'desc',
                caption: "Listado de Documentos",
                editurl: 'jqGridDocRev.ashx'
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

        function verDocRev(idact, doc, idactdet) {
            //alert(idact + ' ' + doc + ' ' + idactdet)
            $("#revActId").val(idact);
            $("#revActDetId").val(idactdet);

            $("#ifPagina2").attr('src', "Documentos/" + doc);
            if (!$('#DocRev').dialog('isOpen'))
                $('#DocRev').dialog('open');
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
            tablaDoc();
        }

        function llena_Profesionales(id, region) {
            $("#busProf").html("");
            $.ajax({
                type: "GET",
                url: "listarProfesionales.ashx",
                data: { r: region, proy: '<%=(string)(Session["IDProyecto"])%>' },
                dataType: "xml",
                success: function (xml) {
                    $("#busProf").append("<option value='0'>Seleccione</option>");
                    $('row', xml).each(function (i) {
                        if (id == $(this).find('ID').text())
                            $("#busProf").append('<option value="' + $(this).find('ID').text() + '" selected="selected">' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                        else
                            $("#busProf").append('<option value="' + $(this).find('ID').text() + '" >' +
                                                                    $(this).find('NOMBRE').text() + '</option>');
                    });
                }
            });
        }
</script>

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

<div id="grilla"> 
    <h1>
        <%: Page.Title %>
    </h1>
    <table id="">
        <tr>
            <td style="width:100px">Región EPT : </td>
            <td style="width:180px"><select name="busReg" id="busReg" onchange="llena_comunas(this.value,0);llena_Profesionales(0,this.value);" style="width:100%;"></select></td>
            <td style="width:10px"></td>
            <td style="width:100px">Comuna EPT : </td>
            <td style="width:180px"><select name="busCom" id="busCom" style="width:80%;" onchange="tablaDoc();"></select></td>
            <td style="width:10px"></td>
            <td style="width:120px">Profesional : </td>
            <td style="width:180px"><select name="busProf" id="busProf" style="width:80%;" onchange="tablaDoc();"></select></td>
        </tr>
        <tr>
            <td>Tipo Solicitud : </td>
            <td><select name="bustipo" id="bustipo" style="width:80%;" onchange="tablaDoc();">
                    <option value="0">Seleccione</option>
                    <option value="4">EPT Disfonía</option>
                    <option value="1">EPT ME</option>
                    <option value="2">EPT SM</option>
                    <option value="3">EP Dermat</option>
                </select>
            </td>
            <td></td>
            <td>Mes : </td>
            <td><select id="busMes" name="busMes" onchange="tablaDoc();">
                                    <OPTION VALUE="0">Todos</OPTION>
                                    <OPTION VALUE="1">Enero</OPTION>
                                    <OPTION VALUE="2">Febrero</OPTION>
                                    <OPTION VALUE="3">Marzo</OPTION>
                                    <OPTION VALUE="4">Abril</OPTION>
                                    <OPTION VALUE="5">Mayo</OPTION>
                                    <OPTION VALUE="6">Junio</OPTION>
                                    <OPTION VALUE="7">Julio</OPTION>
                                    <OPTION VALUE="8">Agosto</OPTION>
                                    <OPTION VALUE="9">Septiembre</OPTION>
                                    <OPTION VALUE="10">Octubre</OPTION>
                                    <OPTION VALUE="11">Noviembre</OPTION>
                                    <OPTION VALUE="12">Diciembre</OPTION>
                            </select></td>
            <td></td>
            <td>Año : </td>
            <td><select id="busAno" name="busAno" onchange="tablaDoc();">
                                            	<OPTION VALUE="0">Todos</OPTION>
                                                <OPTION VALUE="2017">2017</OPTION>
                            </select></td>
        </tr>
        <tr>
            <td>Rut Paciente : </td>
            <td><input id="busPac" name="busPac" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tablaDoc();" placeholder="Rut Ej: 16313889-8" style="width:100%;"/></td>
            <td></td>
            <td>Rut Empresa : </td>
            <td><input id="busEmp" name="busEmp" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tablaDoc();" placeholder="Rut Ej: 16313889-8" style="width:100%;"/></td>
            <td></td>
            <td>Orden Siniestro : </td>
            <td><input id="busOS" name="busOS" type="text" tabindex="1" maxlength="10" size="10" onkeyup="tablaDoc();"/></td>
        </tr>
    </table>
    <table id="jQGridDoc">
     </table>
     <div id="jQGridDocPager">
    </div>
</div>
</asp:Content>
