using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridDocRev
    /// </summary>
    public class jqGridDocRev : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", archivo = "", actId = "";
            funciones fn = new funciones();

            string reg = "", com = "", sol = "", tipo = "", mes = "", ano = "", rutp = "", rute = "", orden = "";

            reg = "";
            if (context.Request["r"] != "null" && context.Request["r"] != "0")//Convert.ToInt32(context.Request["r"]) > 0)
            {
                reg = " and s.ID_REGION_EPT='" + context.Request["r"] + "'";
            }

            com = "";
            if (context.Request["c"] != "null" && context.Request["c"] != "0")
            {
                com = " and s.ID_COMUNA_EPT='" + context.Request["c"] + "'";
            }

            sol = "";
            if (context.Request["s"] != "" && context.Request["s"] != "0" && context.Request["s"] != "null")
            {
                sol = " and a.ID_PROFESIONAL='" + context.Request["s"] + "'";
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

            string _search = context.Request["_search"];
            string numberOfRows = context.Request["rows"];
            string pageIndex = context.Request["page"];
            string sortColumnName = context.Request["sidx"];
            string sortOrderBy = context.Request["sord"];
            string nodeid = context.Request["nd"];

            DataSet dsQuery = fn.dsSql("select A.ID_ACTIVIDAD,A.ID_SOLICITUD,USR=dbo.MayMinTexto(U.NOMBRE),PROF=dbo.MayMinTexto(PR.NOMBRE),TIPOS=TPS.NOMBRE," +
                                       "fecha=CONVERT(VARCHAR(10),A.FECHA_PROGRAMACION, 105),TIPO=TP.NOMBRE,est=AD.ESTADO," +
                                       "RUT_E=E.RUT, NOM_E = E.NOMBRE, TRAB_RUT = P.RUT, TRAB_NOM = P.NOMBRE, S.ORDEN_SINIESTRO, S.ESTADO," +
                                       "nomEst=(case AD.ESTADO when 1 then 'Opcional' when 2 then 'Subido' when 3 then 'Rechazado' when 4 then 'Aprobado' else 'Pendiente Subir' end)," +
                                       "F_REL=CONVERT(VARCHAR(10),AD.FECHA_REALIZACION, 105),AD.ID_ACTIVIDAD_DETALLE,S.ORDEN_SINIESTRO," +
                                       "cod=(case when s.NUM_SOLICITUD is null THEN " +
                                       "CONVERT(VARCHAR(4), YEAR(S.FECHA_SOLICITUD))+right('00' + " +
                                       "CONVERT(VARCHAR(2),MONTH(S.FECHA_SOLICITUD)), 2)+'-'+ " +
                                       "CONVERT(VARCHAR(4), s.ID_SOLICITUD) else s.NUM_SOLICITUD END),TDOC.DOCUMENTO from ACTIVIDADES a " +
                                       " inner join SOLICITUDES S on S.ID_SOLICITUD=a.ID_SOLICITUD " +
                                       " inner join USUARIOS u on u.ID_USUARIO=a.ID_USUARIO " +
                                       " inner join PROFESIONALES PR on PR.ID_PROFESIONAL=a.ID_PROFESIONAL " +
                                       " INNER JOIN PACIENTES P ON P.ID_PACIENTE=S.ID_PACIENTE " +
                                       " INNER JOIN EMPRESAS E ON E.ID_EMPRESA=S.ID_EMPRESA " +
                                       " INNER JOIN TIPO_ACTIVIDAD TP ON TP.ID_TIPO_ACTIVIDAD=A.ID_TIPO_ACTIVIDAD " +
                                       " INNER JOIN ACTIVIDAD_DETALLE AD ON AD.ID_ACTIVIDAD=A.ID_ACTIVIDAD " +
                                       " INNER JOIN TIPO_DOCUMENTO TDOC ON TDOC.ID_TIPO_DOCUMENTO=AD.ID_TIPO_DOCUMENTO" +
                                       " INNER JOIN TIPO_SOLICITUD TPS ON TPS.ID_TIPO_SOLICITUD=S.ID_TIPO_SOLICITUD " +
                                       " WHERE AD.ESTADO=2 and s.id_proyecto=" + context.Request["p"] + reg + sol + com + tipo + ano + mes + rutp + rute + orden + " ORDER BY " + sortColumnName + " " + sortOrderBy);

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
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPOS"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT_E"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["NOM_E"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_RUT"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TRAB_NOM"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["ORDEN_SINIESTRO"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["DOCUMENTO"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["PROF"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["fecha"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["F_REL"].ToString() + "]]></cell>"; 
                                //"<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["nomEst"].ToString() + "]]></cell>";

                    DataSet dsQueryDet = fn.dsSql("SELECT TOP 1 DT.DOCUMENTO,DT.ID_ACTIVIDAD_DETALLE FROM ACTIVIDAD_DETALLE DT " +
                                                  " where DT.ID_ACTIVIDAD_DETALLE=" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD_DETALLE"].ToString() +
                                                  " ORDER BY DT.ID_ACTIVIDAD_DETALLE DESC");

                    for (int contDet = 0; contDet < dsQueryDet.Tables[0].Rows.Count; contDet++)
                    {
                        archivo = dsQueryDet.Tables[0].Rows[contDet]["DOCUMENTO"].ToString();
                        actId = dsQueryDet.Tables[0].Rows[contDet]["ID_ACTIVIDAD_DETALLE"].ToString();
                    }

                    if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "0")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid2'><a href='#' title='Ver Registro' class='ui-icon ui-icon-close'></a></span>]]></cell>";
                    }
                    else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "2")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-check' onclick=verDocRev(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",'" + archivo + "'," + actId + ")></a></span>]]></cell>";
                    }
                    else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "3")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid2'><a href='#' title='Ver Registro' class='ui-icon ui-icon-circle-arrow-s' onclick=verDocRev(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",'" + archivo + "'," + actId + ")></a></span>]]></cell>";
                    }
                    else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "4")
                    {
                        xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-circle-arrow-n' onclick=verDocRev(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",'" + archivo + "'," + actId + ")></a></span>]]></cell>";
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