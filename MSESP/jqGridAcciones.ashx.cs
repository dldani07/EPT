using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridAcciones
    /// </summary>
    public class jqGridAcciones : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select usuario=dbo.MayMinTexto(u.NOMBRE),Accion=tp.NOMBRE," +
                                    "Fecha_Real=(case tp.ID_TIPO_ACTIVIDAD " +
                                    " when 2 then CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) " +
                                    " when 3 then " +
                                    "       case when ad.DESTINATARIO=2 and ad.OBSERVACIONES='Envio Automatico de Correo' THEN " +
                                    "           CONVERT(VARCHAR(10),a.FECHA_CREACION, 105) ELSE CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) end " +
                                    " when 6 then CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) " +
                                    " when 7 then CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) " + 
                                    " when 8 then CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) " +
                                    " when 9 then CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) " +
                                    " when 14 then CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) " +
                                    " when 16 then CONVERT(VARCHAR(10),ad.FECHA_CREACION, 105) " +
                                    " when 17 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 18 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 24 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 25 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 26 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 32 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 33 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 34 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 35 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 39 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 40 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 41 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 42 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " when 43 then CONVERT(VARCHAR(10),ad.FECHA_REALIZACION, 105) " +
                                    " else CONVERT(VARCHAR(10),Ad.FECHA_CREACION, 105) end),ad.ID_ACCION_DETALLE," +
                                    " interaccion=(case ad.DESTINATARIO when 1 then 'Paciente' when 2 then 'Empresa' " +
                                    " when 3 then 'Profesional' when 4 then 'Otros' else '' end)" +
                                    " from ACCIONES a " +
                                    " inner join ACCION_DETALLE ad on ad.ID_ACCION=a.ID_ACCION " +
                                    " INNER JOIN USUARIOS U ON U.ID_USUARIO=AD.ID_USUARIO " +
                                    " INNER JOIN TIPO_ACTIVIDAD TP ON TP.ID_TIPO_ACTIVIDAD=A.ID_TIPO_ACTIVIDAD " +
                                    " where A.ID_SOLICITUD=" + context.Request["id"] + " order by ad.FECHA_REALIZACION asc");

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>" +
                    "<page>1</page>" +
                    "<total>1</total>" +
                    "<records>1</records>";
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row id='" + cont.ToString() + "'>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["Accion"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["interaccion"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["usuario"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["Fecha_Real"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Ver Registro' class='ui-icon ui-icon-pencil' onclick='verAccion(" + dsQuery.Tables[0].Rows[cont]["ID_ACCION_DETALLE"].ToString() + ")'></a></span>]]></cell>" +
                            "</row>";
            }
            xml = xml + "</rows>";

            context.Response.Write(xml);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}