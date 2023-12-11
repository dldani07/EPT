<%@ Page Language="C#" Title="Inicio" MasterPageFile="~/SiteZona.Master" AutoEventWireup="true" CodeBehind="Acceso.aspx.cs" Inherits="MSESP.Acceso" %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent"> 

   <script type="text/javascript">
       var divZonas = "";
       var contZonas = 0;
       $(document).ready(function () {
           $("#ZonasEtpTabla").html("");
           contZonas = 0;
           divZonas = '<tr>';

           $.ajax({
               type: "GET",
               url: "listaZonasUsuarios.ashx",
               data: { id: '<%=(string)(Session["IdUsuario"])%>' },
               dataType: "xml",
               success: function (xml) {
                   $('row', xml).each(function (i) {
                       divZonas = divZonas + '<td width="250"><div style="background:url(images/box_top_999999.png) no-repeat;background-size: 180px 20px;height:20px;padding-right:-20px;"></div>' +
                                '<div style="background:url(images/box_med_999999.png) repeat-y; background-size: 180px 10px;">' +
                                '<img style="padding-left:17px;width:164px;border:0px solid;max-height:122px;cursor:pointer;" src="images/' + $(this).find('LOGO').text() + '" onclick="document.location.href=\'Inicio.aspx?p=' + $(this).find('IDP').text() + '&s=' + $(this).find('SUPER').text() + '\';"></div>' +
	                            '<div style="background:url(images/box_base_999999.png) no-repeat;background-size: 180px 20px;height:20px;"></div></td>';
                       contZonas = contZonas + 1;
                       if (contZonas == 3) {
                           divZonas = divZonas + '</tr><tr>';
                       }
                   });

                   if (contZonas == 0 || contZonas == 2) {
                       divZonas = divZonas + '<td>&nbsp;</td>';
                   }


                   divZonas = divZonas + '</tr>';
                   $("#ZonasEtpTabla").html(divZonas);
               }
           });
       });
</script>

    <div id="grilla"> 
    <h1>Acceso Usuarios</h1>
        <p>Seleccione Proyecto por el cual desea ingresar:</p>
        <table border="0" id="ZonasEtpTabla">
        </table>
   </div>
</asp:Content>
