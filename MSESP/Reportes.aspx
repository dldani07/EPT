<%@ Page Title="Reportes" Language="C#" MasterPageFile="~/SiteMES.Master" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="MSESP.Reportes" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">  
 <script type="text/javascript">
     var validator = "";
     $(document).ready(function () {
         $('#busFD').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
         $('#busFH').datepicker({ firstDay: 1, dateFormat: 'dd-mm-yy' });
         //tabla();

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
         $("#tabs").tabs();
     });

     function ver() {
         //alert("aqui");
         sUrl = 'ReportesXLS.aspx?t=' + $('#bustipo').val() + '&fi=' + $('#busFD').val() + '&ft=' + $('#busFH').val() + '&p=<%=(string)(Session["IDProyecto"])%>';

         window.open(sUrl, 'Reportabilidad');
     }

 </script>
     <div id="grilla"> 
        <h1>
            <%:Page.Title%>
        </h1>
    <div id="tabs" style="height:250px">
	    <ul>
		    <li><a href="#tabs-1" onclick="$('#button-GuardarLab').show();">Informes</a></li>
        </ul>


    <div id="tabs-1" style="font-size: 10px;">
             <table id="" style="font-size: 11px;">
                <tr>
                     <td colspan="7">&nbsp;</td>
   		        </tr>
                <tr>
                    <td>Tipo : </td>
                    <td><select name="bustipo" id="bustipo">
                            <option value="1">Detalle Interacciones</option>
                            <option value="2">Asignaciones</option></select>
                    </td>
                </tr>
                <tr>
                    <td style="width:100px">Fecha Desde : </td>
                    <td style="width:100px"><input id="busFD" name="busFD" type="text" tabindex="1" maxlength="10" size="10" /></td>
                    <td style="width:10px"></td>
                    <td style="width:100px">Fecha Hasta : </td>
                    <td style="width:100px"><input id="busFH" name="busFH" type="text" tabindex="1" maxlength="10" size="10" /></td>
                    <td style="width:10px"></td>
                    <td style="width:380px"><button id="dialog-link" class="ui-state-default ui-corner-all" onclick="ver();">&nbsp;Ver Informe&nbsp;</button></td>
                </tr>
                <tr>
                     <td colspan="7">&nbsp;</td>
   		        </tr>
               </table>
             </div>
         </div>
      </div>
</asp:Content>