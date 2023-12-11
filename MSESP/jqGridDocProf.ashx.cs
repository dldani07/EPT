using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridDocProf
    /// </summary>
    public class jqGridDocProf : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", filtro = "";
            funciones fn = new funciones();

            if (context.Request["t"].ToString() == "4")
            {
                filtro = " and p.ID_PROFESIONAL=" + context.Request["u"].ToString();
            }

            string reg = "", com = "", sol = "", tipo = "", mes = "", ano = "", rutp = "", rute = "", orden = "", fi = "", ff = "", est = "", di = "";

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
            if (context.Request["td"] != "" && context.Request["td"] != "0")
            {
                tipo = " and A.ID_TIPO_ACTIVIDAD='" + context.Request["td"] + "'";
            }
            
            rutp = "";
            if (context.Request["rp"] != "")
            {
                rutp = " and Pc.RUT like '%" + context.Request["rp"] + "%'";
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

            fi = "";
            if (context.Request["fi"] != "")
            {
                fi = " and a.FECHA_PROGRAMACION>=convert(date, '" + context.Request["fi"] + "')";
            }

            ff = "";
            if (context.Request["ff"] != "")
            {
                ff = " and a.FECHA_PROGRAMACION<=convert(date, '" + context.Request["ff"] + "')";
            }

            /*est = "";
            if (context.Request["est"] != "")
            {
                est = " and S.ESTADO=" + context.Request["est"];
            }*/

            di = "";
            if (context.Request["di"] != "")
            {
                di = " and DATEDIFF(day, a.FECHA_PROGRAMACION, GETDATE())=" + context.Request["di"];
            }/**/

            string _search = context.Request["_search"];
            string numberOfRows = context.Request["rows"];
            string pageIndex = context.Request["page"];
            string sortColumnName = context.Request["sidx"];
            string sortOrderBy = context.Request["sord"];
            string nodeid = context.Request["nd"];

            DataSet dsQuery = fn.dsSql("select RUT_E=E.RUT,NOM_E=dbo.MayMinTexto(E.NOMBRE),TRAB_RUT=Pc.RUT,TRAB_NOM=Pc.NOMBRE," +
                                        "A.ID_ACTIVIDAD,A.ID_SOLICITUD,USR=U.NOMBRE,PROF=dbo.MayMinTexto(P.NOMBRE),S.ORDEN_SINIESTRO," +
                                        "fecha=CONVERT(VARCHAR(10),A.FECHA_PROGRAMACION, 105),TIPO=TP.NOMBRE,TP.ID_TIPO_ACTIVIDAD,est=A.ESTADO," +
                                        "cod=(case when s.NUM_SOLICITUD is null THEN " +
                                        "CONVERT(VARCHAR(4), YEAR(S.FECHA_SOLICITUD))+right('00' + " +
                                        "CONVERT(VARCHAR(2),MONTH(S.FECHA_SOLICITUD)), 2)+'-'+ " +
                                        "CONVERT(VARCHAR(4), s.ID_SOLICITUD) else s.NUM_SOLICITUD END),S.ID_TIPO_SOLICITUD,A.FECHA_PROGRAMACION, " +
                                        "dias=DATEDIFF(day, a.FECHA_PROGRAMACION, GETDATE()),Ecaso=dbo.EstadoEPT(s.estado) from ACTIVIDADES a " +
                                        " inner join USUARIOS u on u.ID_USUARIO=a.ID_USUARIO " +
                                        " inner join PROFESIONALES p on p.ID_PROFESIONAL=a.ID_PROFESIONAL " +
                                        " INNER JOIN TIPO_ACTIVIDAD TP ON TP.ID_TIPO_ACTIVIDAD=A.ID_TIPO_ACTIVIDAD " +
                                        " inner join solicitudes s on s.ID_SOLICITUD=a.ID_SOLICITUD " +
                                        " INNER JOIN PACIENTES Pc ON Pc.ID_PACIENTE=S.ID_PACIENTE " + 
                                        " INNER JOIN EMPRESAS E ON E.ID_EMPRESA=S.ID_EMPRESA " +
                                        " where a.estado IN (0,3) and s.id_proyecto=" + context.Request["p"] + reg + sol + com + tipo + rutp + rute + orden + fi + ff + di + est + filtro + " ORDER BY " + sortColumnName + " " + sortOrderBy);

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
                if (fila >= inicio && fila < (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)))
                {
                xml = xml + "<row id='" + cont.ToString() + "'>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["cod"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT_E"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["NOM_E"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_RUT"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_NOM"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["ORDEN_SINIESTRO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["Ecaso"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["PROF"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["fecha"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["dias"].ToString() + "]]></cell>";
                    if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "0")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid2'><a href='#' title='Ver Registro' class='ui-icon ui-icon-close'onclick='verDoc(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + "," + dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() + "," + dsQuery.Tables[0].Rows[cont]["ID_TIPO_ACTIVIDAD"].ToString() + ")'></a></span>]]></cell>";
                    }
                    else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "2")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-check' onclick='verDoc(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ")'></a></span>]]></cell>";
                    }
                    else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "3")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid2'><a href='#' title='Ver Registro' class='ui-icon ui-icon-circle-arrow-s' onclick='verDoc(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + "," + dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() + "," + dsQuery.Tables[0].Rows[cont]["ID_TIPO_ACTIVIDAD"].ToString() + ")'></a></span>]]></cell>";
                    }
                    else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "4")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-circle-arrow-n' onclick='verDoc(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ")'></a></span>]]></cell>";
                    }
                    else
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-minus'></a></span>]]></cell>";
                    }
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