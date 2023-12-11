﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridUsuarios
    /// </summary>
    public class jqGridUsuarios : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "texto/normal";
            //context.Response.Write("Hola a todos");

            string xml = "";
            funciones fn = new funciones();

            string _search = context.Request["_search"];
            string numberOfRows = context.Request["rows"];
            string pageIndex = context.Request["page"];
            string sortColumnName = context.Request["sidx"];
            string sortOrderBy = context.Request["sord"];
            string nodeid = context.Request["nd"];

            DataSet dsQuery = fn.dsSql("select U.ID_USUARIO,U.RUT,nom=dbo.MayMinTexto(U.NOMBRE),EMAIL=lower(u.EMAIL),u.FONO,tp.TIPO from USUARIOS u " +
                                       " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                       " inner join TIPO_USUARIOS tp on tp.ID_TIPO_USUARIO=u.ID_TIPO_USUARIO " +
                                       " where Up.ESTADO=1 and UP.id_proyecto=" + context.Request["p"] + " ORDER BY " + sortColumnName + " " + sortOrderBy);

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
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["nom"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["FONO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Actualizar Registro' class='ui-icon ui-icon-pencil' onclick='actualizar(" + dsQuery.Tables[0].Rows[cont]["ID_USUARIO"].ToString() + ")'></a></span>]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Eliminar Registro' class='ui-icon ui-icon-trash' onclick='eliminar(" + dsQuery.Tables[0].Rows[cont]["ID_USUARIO"].ToString() + ")'></a></span>]]></cell>" +
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