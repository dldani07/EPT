using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridProfesionales
    /// </summary>
    public class jqGridProfesionales : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string xml = "", agencia = "", profesion = "";
            funciones fn = new funciones();

            string _search = context.Request["_search"];
            string numberOfRows = context.Request["rows"];
            string pageIndex = context.Request["page"];
            string sortColumnName = context.Request["sidx"];
            string sortOrderBy = context.Request["sord"];
            string nodeid = context.Request["nd"];

            if (context.Request["a"] != "0" && context.Request["a"] != "" && context.Request["a"] != "Null" && context.Request["a"] != null)
            {
                agencia = " AND  AG.ID_AGENCIA = " + context.Request["a"] + " ";
            }

            if (context.Request["pro"] != "0" && context.Request["pro"] != "" && context.Request["pro"] != "Null" && context.Request["pro"] != null)
            {
                profesion = " AND (PF.PROFESION LIKE '%" + context.Request["pro"] + "%' or PF.NOMBRE LIKE '%" + context.Request["pro"] + "%' or (case when pf.ESTADO2='A' THEN 'Activo' ELSE 'Inactivo' END) LIKE '" + context.Request["pro"] + "%')";
            }
            DataSet dsQuery = fn.dsSql("SELECT pf.ID_PROFESIONAL,PF.RUT,NOMBRE=dbo.MayMinTexto(PF.NOMBRE),prov=dbo.fun_prof_prov_desc(pf.ID_PROFESIONAL),PROFESION =dbo.MayMinTexto(PF.PROFESION), AGENCIA=AG.AGENCIA, TELEFONO = PF.FONO, EMAIL=PF.EMAIL,  ESTADO=(case when pf.ESTADO2='A' THEN 'Activo' ELSE 'Inactivo' END), ORGANIZACION =dbo.MayMinTexto(O.NOMBRE)  FROM PROFESIONALES PF " +
                                        //" INNER JOIN PROVEEDORES P ON P.ID_PROVEEDOR=PF.ID_PROVEEDOR " +
                                        " INNER JOIN PROFESIONALES_PROYECTO PP ON PP.ID_PROFESIONAL=PF.ID_PROFESIONAL " +
                                        " INNER JOIN AGENCIAS AG ON AG.ID_AGENCIA=PF.AGENCIA " +
                                        " LEFT JOIN ORGANIZACIONES O ON O.ID_ORGANIZACION=PF.ID_ORGANIZACION " +
                                        " WHERE PP.ESTADO=1 AND PP.ID_PROYECTO=" + context.Request["p"] + agencia + profesion +
                                        " ORDER BY " + sortColumnName + " " + sortOrderBy);

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
            int fila=0;

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>" +
                    "<page>" + pageIndex.ToString() + "</page>" +
                    "<total>" + total_pages.ToString() + "</total>" +
                    "<records>" + dsQuery.Tables[0].Rows.Count.ToString() + "</records>";
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                if (fila >= inicio && fila < (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)))
                {
                xml = xml + "<row id='" + fila.ToString() + "'>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["prov"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["PROFESION"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["AGENCIA"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["ORGANIZACION"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["TELEFONO"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString() + "]]></cell>" +
                                "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["ESTADO"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Actualizar Registro' class='ui-icon ui-icon-pencil' onclick='actualizar(" + dsQuery.Tables[0].Rows[cont]["ID_PROFESIONAL"].ToString() + ")'></a></span>]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Eliminar Registro' class='ui-icon ui-icon-trash' onclick='eliminar(" + dsQuery.Tables[0].Rows[cont]["ID_PROFESIONAL"].ToString() + ")'></a></span>]]></cell>" +
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