using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridIngresosRA
    /// </summary>
    public class jqGridIngresosRA : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string reg = "", com = "", sol = "", tipo = "", mes = "", ano = "", rutp = "", rute = "", orden = "", fi = "", ff = "", est = "", di = "", nc = "", estep = "", usr = "";

            usr = context.Request["usr"];

            reg = "";
            if (context.Request["r"] != "" && context.Request["r"] != "0" && context.Request["r"] != "null" && context.Request["r"] != null)
            {
                reg = " and s.ID_REGION_EPT=" + context.Request["r"];
            }

            com = "";
            if (context.Request["c"] != "null" && context.Request["c"] != "0" && context.Request["c"] != null)
            {
                com = " and s.ID_COMUNA_EPT='" + context.Request["c"] + "'";
            }

            sol = "";
            if (context.Request["s"] != "" && context.Request["s"] != "0" && context.Request["s"] != "null" && context.Request["s"] != null)
            {
                sol = " and s.ID_USUARIO_INGRESO in (SELECT u.ID_USUARIO from usuarios u where u.ID_TIPO_USUARIO=3 and u.ID_AGENCIA in (" + context.Request["s"] + ")) ";
            }

            tipo = "";
            if (context.Request["t"] != "" && context.Request["t"] != "0")
            {
                tipo = " and s.ID_TIPO_SOLICITUD='" + context.Request["t"] + "'";
            }

            rutp = "";
            if (context.Request["rp"] != "")
            {
                rutp = " and (P.RUT like '%" + context.Request["rp"] + "%' OR P.NOMBRE like '%" + context.Request["rp"] + "%')";
            }

            rute = "";
            if (context.Request["re"] != "")
            {
                rute = " and (E.RUT like '%" + context.Request["re"] + "%' OR E.NOMBRE like '%" + context.Request["re"] + "%')";
            }

            orden = "";
            if (context.Request["os"] != "")
            {
                orden = " and S.ORDEN_SINIESTRO like '%" + context.Request["os"] + "%'";
            }

            fi = "";
            if (context.Request["fi"] != "")
            {
                fi = " and S.FECHA_SOLICITUD>=convert(date, '" + context.Request["fi"] + "')";
            }

            ff = "";
            if (context.Request["ff"] != "")
            {
                ff = " and S.FECHA_SOLICITUD<=convert(date, '" + context.Request["ff"] + "')";
            }

            est = " and ((s.ID_TIPO_SOLICITUD=2 and s.ESTADO_EP in (1,2) and s.ESTADO in (1,2)) " +
                  " OR (s.ID_TIPO_SOLICITUD not in (2) and s.ESTADO in (1,2)))";
            //if (context.Request["est"] != "0")
            //{
            //    est = " and S.ESTADO=" + context.Request["est"];
            //}

            di = "";
            if (context.Request["di"] != "")
            {
                di = " and DATEDIFF(day, S.FECHA_SOLICITUD, GETDATE())=" + context.Request["di"];
            }

            nc = "";
            if (context.Request["nc"] != "")
            {
                nc = " and S.NUM_SOLICITUD like '%" + context.Request["nc"] + "%'";
            }

            estep = "";
            if (context.Request["estep"] != "0")
            {
                estep = " and S.ESTADO_EP=" + context.Request["estep"];
            }

            string xml = "";
            funciones fn = new funciones();

            string _search = context.Request["_search"];
            string numberOfRows = context.Request["rows"];
            string pageIndex = context.Request["page"];
            string sortColumnName = context.Request["sidx"];
            string sortOrderBy = context.Request["sord"];
            string nodeid = context.Request["nd"];

            DataSet dsQuery = fn.dsSql("SELECT S.ID_SOLICITUD,F_SOLICITUD=CONVERT(VARCHAR(10),S.FECHA_SOLICITUD, 105),TIPO=TP.NOMBRE,SOL=dbo.MayMinTexto(U.NOMBRE),RUT_E=E.RUT," +
                                       "NOM_E=dbo.MayMinTexto(E.NOMBRE),TRAB_RUT=P.RUT,TRAB_NOM=dbo.MayMinTexto(P.NOMBRE),S.ORDEN_SINIESTRO,S.ESTADO,A.AGENCIA,ddf=DATEDIFF(day, S.FECHA_SOLICITUD, GETDATE())," +
                                       "E_SOL=(DBO.EstadoEPT(s.estado)),EP_SOL=(CASE WHEN S.ID_TIPO_SOLICITUD=2 and (S.TIPO_SERVICIO=1 OR S.TIPO_SERVICIO IS NULL) THEN (DBO.EstadoEPT(ISNULL(S.ESTADO_EP,0))) ELSE '' END)," +
                                       "mail=(case (select COUNT(*) from ACCIONES a " +
                                       " inner join ACCION_DETALLE ac on ac.ID_ACCION=a.ID_ACCION " +
                                       " where a.ID_TIPO_ACTIVIDAD='3' and a.ID_SOLICITUD=S.ID_SOLICITUD and ac.DESTINATARIO=2 and ac.OBSERVACIONES='Envio Automatico de Correo') when 0 then 'No Enviado' else 'Enviado' end)," +
                                       "cod=(case when s.NUM_SOLICITUD is null THEN " +
                                       "CONVERT(VARCHAR(4), YEAR(S.FECHA_SOLICITUD))+right('00' + CONVERT(VARCHAR(2),MONTH(S.FECHA_SOLICITUD)), 2)+'-'+ " +
                                       "CONVERT(VARCHAR(4), s.ID_SOLICITUD) else s.NUM_SOLICITUD END),cod2=dbo.RemoveChars(s.NUM_SOLICITUD),s.TIPO_SERVICIO,s.ESTADO_EP,S.ID_TIPO_SOLICITUD FROM SOLICITUDES S " +
                                       " INNER JOIN PACIENTES P ON P.ID_PACIENTE=S.ID_PACIENTE " +
                                       " INNER JOIN TIPO_SOLICITUD TP ON TP.ID_TIPO_SOLICITUD=S.ID_TIPO_SOLICITUD " +
                                       " INNER JOIN USUARIOS U ON U.ID_USUARIO=S.ID_USUARIO_INGRESO " +
                                       " left JOIN AGENCIAS A ON A.ID_AGENCIA=U.ID_AGENCIA " +
                                       " INNER JOIN EMPRESAS E ON E.ID_EMPRESA=S.ID_EMPRESA " +
                                       " where 1=1 /*s.estado=2*/ and s.id_proyecto=" + context.Request["p"] + reg + sol + com + tipo + ano + mes + rutp + rute + orden + fi + ff + est + di + nc + " and s.ID_USUARIO_INGRESO=" + context.Request["idUsr"] + " ORDER BY " + sortColumnName + " " + sortOrderBy);
            //" /*WHERE S.ESTADO=1*/"
            int total_pages = 0;
            if (dsQuery.Tables[0].Rows.Count > 0)
            {
                if ((dsQuery.Tables[0].Rows.Count % Convert.ToInt32(numberOfRows)) > 0)
                {

                    //total_pages = dsQuery.Tables[0].Rows.Count / Convert.ToInt32(numberOfRows) + 1;
                    total_pages = (int)Math.Ceiling(Convert.ToDouble(dsQuery.Tables[0].Rows.Count / Convert.ToInt32(numberOfRows) + 1)); // 1
                }
                else
                {
                    total_pages = Convert.ToInt32(dsQuery.Tables[0].Rows.Count) / Convert.ToInt32(numberOfRows) + 1;
                }
            }
            else
            {
                total_pages = 1;
            }

            if (Convert.ToInt32(pageIndex) > Convert.ToInt32(total_pages)) { pageIndex = total_pages.ToString(); }
            int inicio = (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)) - Convert.ToInt32(numberOfRows);
            int fila = 0;

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>" +
                    "<page>" + pageIndex.ToString() + "</page>" +
                    "<total>" + total_pages.ToString() + "</total>" +
                    "<records>" + dsQuery.Tables[0].Rows.Count.ToString() + "</records>";
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                if (fila >= inicio && fila < (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)))
                {
                    xml = xml + "<row id='" + cont.ToString() + "'>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["cod"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["F_SOLICITUD"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["AGENCIA"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT_E"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["NOM_E"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_RUT"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_NOM"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["ddf"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["EP_SOL"].ToString() + "]]></cell>";

                    if (dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() == "2" && dsQuery.Tables[0].Rows[cont]["TIPO_SERVICIO"].ToString() == "1")
                    {
                        if (dsQuery.Tables[0].Rows[cont]["ESTADO_EP"].ToString() != "7" && dsQuery.Tables[0].Rows[cont]["ESTADO_EP"].ToString() != "9"
                        && dsQuery.Tables[0].Rows[cont]["ESTADO_EP"].ToString() != "0"
                            /*&& dsQuery.Tables[0].Rows[cont]["TIPO_SERVICIO"].ToString() == "1" && dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() == "2"*/ && usr == "1")
                        {
                            xml = xml + "<cell><![CDATA[<span><a href='#' title='Finalizar EV.PS.' class='ui-icon ui-icon-circle-triangle-s' onclick='finalizarCaso(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + ",25)'></a></span>]]></cell>";
                        }
                        else if (dsQuery.Tables[0].Rows[cont]["ESTADO_EP"].ToString() == "7" /*&& dsQuery.Tables[0].Rows[cont]["TIPO_SERVICIO"].ToString() == "1" && dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() == "2"*/)
                        {
                            xml = xml + "<cell><![CDATA[<span><a href='#' title='EV.PS. Finalizada' class='ui-icon ui-icon-check'></a></span>]]></cell>";
                        }
                        else
                        {
                            xml = xml + "<cell><![CDATA[<span><a href='#' title='No disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                        }
                    }
                    else
                    {
                        xml = xml + "<cell><![CDATA[<span><a href='#' title='No disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                    }

                    xml = xml + "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["E_SOL"].ToString() + "]]></cell>";

                    if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() != "7" &&
                     dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() != "9" && dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() != "0" && usr == "1")
                    {
                        xml = xml + "<cell><![CDATA[<span><a href='#' title='Finalizar EPT' class='ui-icon ui-icon-circle-triangle-s' onclick='finalizarCaso(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + ",26)'></a></span>]]></cell>";
                    }
                    else if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "7")
                    {
                        xml = xml + "<cell><![CDATA[<span><a href='#' title='EPT Finalizada' class='ui-icon ui-icon-check'></a></span>]]></cell>";
                    }
                    else
                    {
                        xml = xml + "<cell><![CDATA[<span><a href='#' title='No disponible' class='ui-icon ui-icon-cancel'></a></span>]]></cell>";
                    }

                    xml = xml + "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["mail"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[<span><a href='#' title='Seguimiento' class='ui-icon ui-icon-pencil' onclick='Seguimiento(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + "," + dsQuery.Tables[0].Rows[cont]["cod2"].ToString().Replace("-", "").Replace("RM", "") + ")'></a></span>]]></cell>";

                    if (dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "7" || dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "9" || dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() == "0")
                    {
                        xml = xml + "<cell><![CDATA[<span><a href='#' title='Reabrir' class='ui-icon ui-icon-unlocked' onclick='cambiaEstadoSol(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + ",1)'></a></span>]]></cell>";
                    }
                    else
                    {
                        xml = xml + "<cell><![CDATA[<span><a href='#' title='Anular/Cancelar' class='ui-icon ui-icon-arrowthickstop-1-s' onclick='cambiaEstadoSol(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + ",0)'></a></span>]]></cell>";
                    }

                    xml = xml + "<cell><![CDATA[<span><a href='#' title='Enviar Notificación' class='ui-icon ui-icon-mail-closed' onclick='enviaNotiSol(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + ")'></a></span>]]></cell>";
                    xml = xml + "</row>";
                }
                fila = fila + 1;
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