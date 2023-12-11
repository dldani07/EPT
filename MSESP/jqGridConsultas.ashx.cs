using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridConsultas
    /// </summary>
    public class jqGridConsultas : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            /*string reg = "", com = "", sol = "", tipo = "", mes = "", ano = "", rutp = "", rute = "", orden = "", usrIngreso = "";

            reg="";
            if (context.Request["r"] != "" && context.Request["r"] != "0" && context.Request["r"] != "null" && context.Request["r"] != null)
            {
                reg = " and s.ID_REGION_EPT='" + context.Request["r"] + "'";
            }

            com = "";
            if (context.Request["c"] != "" && context.Request["c"] != "0" && context.Request["c"] != "null" && context.Request["c"] != null)
            {
                com = " and s.ID_COMUNA_EPT='" + context.Request["c"] + "'";
            }

            sol = "";
            if (context.Request["s"] != "" && context.Request["s"] != "0" && context.Request["s"] != "null" && context.Request["s"] != null)
            {
                sol = " and s.ID_USUARIO_INGRESO in (SELECT u.ID_USUARIO from usuarios u where u.ID_TIPO_USUARIO=3 and u.ID_AGENCIA in ('" + context.Request["s"] + "')) ";
            }
            
            tipo = "";
            if (context.Request["t"] != "" && context.Request["t"] != "0")
            {
                tipo = " and s.ID_TIPO_SOLICITUD='" + context.Request["t"] + "'";
            }

            mes = "";
            if (context.Request["m"] != "0")
            {
                mes = " and month(s.FECHA_SOLICITUD)='" + context.Request["m"] + "'";
            }

            ano = "";
            if (context.Request["a"] != "0")
            {
                ano = " and year(s.FECHA_SOLICITUD)='" + context.Request["a"] + "'";
            }

            rutp = "";
            if (context.Request["rp"] != "")
            {
                rutp = " and P.RUT like '%" + context.Request["rp"] + "%'";
            }

            rute = "";
            if (context.Request["re"] != "")
            {
                rute = " and E.RUT like '%" + context.Request["re"] + "%'";
            }

            orden = "";
            if (context.Request["os"] != "")
            {
                orden = " and S.ORDEN_SINIESTRO like '%" + context.Request["os"] + "%'";
            }
            
            usrIngreso = "";
            if (context.Request["tp"].ToString() == "3")
            {
                usrIngreso = " and s.FECHA_SOLICITUD>=CONVERT(date,'07-04-2017')";
            }*/

            string reg = "", com = "", sol = "", tipo = "", mes = "", ano = "", rutp = "", rute = "", orden = "", fi = "", ff = "", est = "", di = "", nc = "", tc = "", estep="";

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

            est = "";
            if (context.Request["est"] != "")
            {
                est = " and S.ESTADO=" + context.Request["est"];
            }

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
            //

            tc = "";
            if (context.Request["tc"] != "0")
            {
                tc = " and s.ESTADO NOT IN (9,7,0) ";
            }

            estep = "";
            if (context.Request["estep"] != "" && context.Request["estep"] != "0" && context.Request["estep"] != "null" && context.Request["estep"] != null)
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
                                       "NOM_E=dbo.MayMinTexto(E.NOMBRE),TRAB_RUT=P.RUT,TRAB_NOM=dbo.MayMinTexto(P.NOMBRE),S.ORDEN_SINIESTRO,S.ESTADO," +
                                       "E_SOL=(case S.ESTADO when 4 then 'Agendado Clinico' when 5 then 'Agendado' " +
                                       " when 6 then 'En Auditoria Revisión EPT' when 3 then 'En Espera Respuesta' when 1 then 'En Gestión' " +
                                       " when 7 then 'Finalizado' when 2 then 'Por Agendar' when 8 then 'Fecha de Programación Vencida' when 9 then 'Anulado' when 10 then 'Reagendado' when 11 then 'Fecha de Prog. Vencida EV.PS.' when 12 then 'En Auditoria Revisión Ev.Ps.' when 13 then 'En Revision' else 'Cancelado' end)," +
                                       "EP_SOL=(CASE WHEN S.ID_TIPO_SOLICITUD=2 and (S.TIPO_SERVICIO=1 OR S.TIPO_SERVICIO IS NULL) THEN (DBO.EstadoEPT(ISNULL(S.ESTADO_EP,2))) ELSE '' END)," +
                                       "cod=(case when s.NUM_SOLICITUD is null THEN " +
                                       "CONVERT(VARCHAR(4), YEAR(S.FECHA_SOLICITUD))+right('00' + CONVERT(VARCHAR(2),MONTH(S.FECHA_SOLICITUD)), 2)+'-'+ " +
                                       "CONVERT(VARCHAR(4), s.ID_SOLICITUD) else s.NUM_SOLICITUD END),A.AGENCIA,TIPO_CASO=dbo.TIPO_CASO_EPT(S.ID_CASO), " +
                                       "ISNULL(PARSENAME(REPLACE(dbo.fun_ultima_accion(s.ID_SOLICITUD), '--SPLIT--', '.'), 1), '') AS desc_act, " +
                                       "ISNULL(PARSENAME(REPLACE(dbo.fun_ultima_accion(s.ID_SOLICITUD), '--SPLIT--', '.'), 2), '') AS fecha_act,cod2=dbo.RemoveChars(s.NUM_SOLICITUD) " +
                                       " FROM SOLICITUDES S " +
                                       " INNER JOIN PACIENTES P ON P.ID_PACIENTE=S.ID_PACIENTE " +
                                       " INNER JOIN TIPO_SOLICITUD TP ON TP.ID_TIPO_SOLICITUD=S.ID_TIPO_SOLICITUD " +
                                       " INNER JOIN USUARIOS U ON U.ID_USUARIO=S.ID_USUARIO_INGRESO " +
                                       " left JOIN AGENCIAS A ON A.ID_AGENCIA=U.ID_AGENCIA " +
                                       " INNER JOIN EMPRESAS E ON E.ID_EMPRESA=S.ID_EMPRESA "+
                                       " where 1=1 and s.id_proyecto=" + context.Request["p"] + reg + sol + com + tipo + rutp + rute + orden + fi + ff + di + est + estep + nc + tc + " ORDER BY " + "S.ID_SOLICITUD" + " " + sortOrderBy);//sortColumnName
            //" LEFT JOIN dbo.vw_actividad_max_full V ON S.ID_SOLICITUD = V.ID_SOLICITUD " + 
            int total_pages = 0;
            if (dsQuery.Tables[0].Rows.Count > 0)
            {
                if ((dsQuery.Tables[0].Rows.Count % Convert.ToInt32(numberOfRows)) > 0)
                {
                    total_pages = (int)Math.Ceiling(Convert.ToDouble(dsQuery.Tables[0].Rows.Count / Convert.ToInt32(numberOfRows) + 1)); // 1
                }
                else
                {
                    total_pages = Convert.ToInt32(dsQuery.Tables[0].Rows.Count) / Convert.ToInt32(numberOfRows);
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

                //dsQuery.Tables[0].Rows[cont]["F_SOLICITUD"].ToString().Replace("-","").Substring(1,6)
                if (fila >= inicio && fila < (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)))
                {
                xml = xml + "<row id='" + cont.ToString() + "'>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["cod"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPO_CASO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["F_SOLICITUD"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["SOL"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["AGENCIA"].ToString() + "]]></cell>" +                            
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT_E"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["NOM_E"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_RUT"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_NOM"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["ORDEN_SINIESTRO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["EP_SOL"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["E_SOL"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["fecha_act"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["desc_act"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Seguimiento' class='ui-icon ui-icon-pencil' onclick='Seguimiento(" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + "," + dsQuery.Tables[0].Rows[cont]["cod2"].ToString().Replace("-", "").Replace("RM", "") + ")'></a></span>]]></cell>" +
                            "</row>";
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