using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridDoc
    /// </summary>
    public class jqGridDoc : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string xml = "", archivo="", actId="";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select A.ID_ACTIVIDAD,A.ID_SOLICITUD,USR=U.NOMBRE,PROF=P.NOMBRE," +
                                       "fecha=CONVERT(VARCHAR(10),A.FECHA_PROGRAMACION, 105),TIPO=TP.NOMBRE,est=A.ESTADO," +
                                       "nomEst=(case A.ESTADO when 1 then 'Opcional' when 2 then 'Subido' when 3 then 'Rechazado' when 4 then 'Aprobado' else 'Pendiente Subir' end)" +
                                       " from ACTIVIDADES a " +
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
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["PROF"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["fecha"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["nomEst"].ToString() + "]]></cell>";

                DataSet dsQueryDet = fn.dsSql("SELECT TOP 1 DT.DOCUMENTO,DT.ID_ACTIVIDAD_DETALLE FROM ACTIVIDAD_DETALLE DT " +
                                              " where DT.ID_ACTIVIDAD=" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() +
                                              " ORDER BY DT.ID_ACTIVIDAD_DETALLE DESC");

                for (int contDet = 0; contDet < dsQueryDet.Tables[0].Rows.Count; contDet++)
                {
                    archivo = dsQueryDet.Tables[0].Rows[contDet]["DOCUMENTO"].ToString();
                    actId = dsQueryDet.Tables[0].Rows[contDet]["ID_ACTIVIDAD_DETALLE"].ToString();
                }

                //xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-check' onclick=verDocRev(" + dsQuery.Tables[0].Rows[cont]["ID_ACTIVIDAD"].ToString() + ",'" + archivo + "'," + actId + ")></a></span>]]></cell>";
                            if(dsQuery.Tables[0].Rows[cont]["est"].ToString()=="0")
                            {
                                xml = xml + "<cell><![CDATA[<span class='ui-state-valid2'><a href='#' title='Ver Registro' class='ui-icon ui-icon-close'></a></span>]]></cell>";
                            }
                            else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "2")
                            {
                                xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-check' onclick=verDoc('" + archivo + "')></a></span>]]></cell>";
                            }
                            else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "3")
                            {
                                xml = xml + "<cell><![CDATA[<span class='ui-state-valid2'><a href='#' title='Ver Registro' class='ui-icon ui-icon-circle-arrow-s' onclick=verDoc('" + archivo + "')></a></span>]]></cell>";
                            }
                            else if (dsQuery.Tables[0].Rows[cont]["est"].ToString() == "4")
                            {
                                xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-circle-arrow-n' onclick=verDoc('" + archivo + "')></a></span>]]></cell>";
                            }
                            else
                            {
                 xml = xml + "<cell><![CDATA[<span class='ui-state-valid'><a href='#' title='Ver Registro' class='ui-icon ui-icon-minus'></a></span>]]></cell>";
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