using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridAsignaciones
    /// </summary>
    public class jqGridAsignaciones : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select A.ID_ACTIVIDAD,A.ID_SOLICITUD,USR=U.NOMBRE,PROF=P.NOMBRE,F_Asig=CONVERT(VARCHAR(10),a.FECHA_CREACION, 105)," +
                                       "fecha=CONVERT(VARCHAR(10),A.FECHA_PROGRAMACION, 105),TIPO=TP.NOMBRE,a.ESTADO," +
                                       "FECHA_RECEPCION=CONVERT(VARCHAR(10),A.FECHA_RECEPCION_INFORME, 105),A.RECHAZO_COMITE,A.RECHAZO_INTERNO," +
                                       "rechazoInterno=(case A.RECHAZO_INTERNO when 0 THEN 'Rechazado' else '' END)," +
                                       "rechazo=(case A.RECHAZO_COMITE when 0 THEN 'Rechazado' else '' END)," +
                                       "FECHA_CORRECCION=CONVERT(VARCHAR(10),A.FECHA_CORRECCION, 105) from ACTIVIDADES a " +
                                       " inner join USUARIOS u on u.ID_USUARIO=a.ID_USUARIO " +
                                       " inner join PROFESIONALES p on p.ID_PROFESIONAL=a.ID_PROFESIONAL " +
                                       " INNER JOIN TIPO_ACTIVIDAD TP ON TP.ID_TIPO_ACTIVIDAD=A.ID_TIPO_ACTIVIDAD " +
                                       " where a.ID_SOLICITUD=" + context.Request["id"]);

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>" +
                    "<page>1</page>" +
                    "<total>1</total>" +
                    "<records>1</records>";
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                xml = xml + "<row id='" + cont.ToString() + "'>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["F_Asig"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["USR"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["PROF"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["fecha"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Ver Registro' class='ui-icon ui-icon-pencil' onclick='verAsignacion(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ")'></a></span>]]></cell>";
                            if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "5")
                            {
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='No Disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                            }
                            else
                            {
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='Cancelar Asignación' class='ui-icon ui-icon-arrowthickstop-1-s' onclick='cancelaEptSol(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ")'></a></span>]]></cell>";
                            }

                            xml = xml + "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["FECHA_RECEPCION"].ToString() + "]]></cell>";
                            /*if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "5" || dsQuery.Tables[0].Rows[cont]["FECHA_RECEPCION"].ToString() != "")
                            {
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='No Disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                            }
                            else
                            {*/
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='Ingresar Fecha de Recepción de Informes' class='ui-icon ui-icon-calendar' onclick='recepcionInforme(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",1)'></a></span>]]></cell>";
                            //}

                            xml = xml + "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["rechazoInterno"].ToString() + "]]></cell>";
                            if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "5" || dsQuery.Tables[0].Rows[cont]["RECHAZO_INTERNO"].ToString() == "0")
                            {
                                    xml = xml + "<cell><![CDATA[<span><a href='#' title='No Disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                            }
                            else
                            {
                                    xml = xml + "<cell><![CDATA[<span><a href='#' title='Rechazo Interno' class='ui-icon ui-icon-alert' onclick='rechComite(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",1)'></a></span>]]></cell>";
                            }

                            xml = xml + "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["rechazo"].ToString() + "]]></cell>";
                            if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "5" || dsQuery.Tables[0].Rows[cont]["RECHAZO_COMITE"].ToString() == "0")
                            {
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='No Disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                            }
                            else
                            {
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='Rechazar por Comité' class='ui-icon ui-icon-alert' onclick='rechComite(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",2)'></a></span>]]></cell>";
                            }

                            xml = xml + "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["FECHA_CORRECCION"].ToString() + "]]></cell>";
                            if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "5" || dsQuery.Tables[0].Rows[cont]["FECHA_CORRECCION"].ToString() != "")
                            {
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='No Disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                            }
                            else
                            {
                                xml = xml + "<cell><![CDATA[<span><a href='#' title='Ingresar Fecha Corrección de Informe' class='ui-icon ui-icon-calendar' onclick='recepcionInforme(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",2)'></a></span>]]></cell>";
                            }
                            xml = xml + "</row>";

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