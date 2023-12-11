using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class Revision : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static void Revisiones(string id_act, string det_act, string obs, string usr, string est)
        {
           funciones fn = new funciones();
            string actualizaEstados = "", strEmp = "";

            //fn.dsSql("update ACTIVIDADES set estado=" + est + " where ID_ACTIVIDAD=" + id_act);
            fn.dsSql("update ACTIVIDAD_DETALLE set estado=" + est + "where ID_ACTIVIDAD_DETALLE=" + det_act);

            fn.dsSql("insert into ACTIVIDAD_REVISION (ID_ACTIVIDAD_DETALLE,ID_USUARIO,FECHA_REVISION,ESTADO,OBSERVACION) values('" +
                     det_act + "','" + usr + "',getdate(),'" + est + "','" + obs + "');");

            actualizaEstados = "IF NOT EXISTS (select * from ACTIVIDAD_DETALLE where estado=2 AND ID_ACTIVIDAD=" + id_act + " AND REEMPLAZADO=0) BEGIN " +
                             "    IF EXISTS (select * from ACTIVIDAD_DETALLE where estado=3 AND ID_ACTIVIDAD=" + id_act + " AND REEMPLAZADO=0) BEGIN " +
                             "      IF EXISTS (select * from actividades a where a.ID_ACTIVIDAD='" + id_act + "' and a.ID_TIPO_ACTIVIDAD=4) BEGIN " +
                             "          update SOLICITUDES set ESTADO_EP=3 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " + 
                             "          where a.ID_ACTIVIDAD='" + id_act + "');" +
                             "      end else BEGIN " +
                             "          update SOLICITUDES set estado=3 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                             "          where a.ID_ACTIVIDAD='" + id_act + "');" +
                             "      end " +
                             "      update ACTIVIDADES set estado=3 where ID_ACTIVIDAD=" + id_act + ";" +
                             "    end else BEGIN " +
                             "      IF EXISTS (select * from actividades a where a.ID_ACTIVIDAD='" + id_act + "' and a.ID_TIPO_ACTIVIDAD=4) BEGIN " +
                             "          update SOLICITUDES set ESTADO_EP=11 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                             "          where a.ID_ACTIVIDAD='" + id_act + "');" +
                             "      end else BEGIN " +
                             "          update SOLICITUDES set estado=8 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                             "          where a.ID_ACTIVIDAD='" + id_act + "');" +
                             "      end " +
                             "      update ACTIVIDADES set estado=4 where ID_ACTIVIDAD=" + id_act + ";" +
		                     "    end  " +
		                     " end ";

            strEmp = "Set Nocount on ";
            strEmp = strEmp + actualizaEstados;
            strEmp = strEmp + " set nocount off";

            fn.dsSql(strEmp);

            /*if (est=="4")
            {
                fn.dsSql("update SOLICITUDES set estado=8 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                     " where a.ID_ACTIVIDAD='" + id_act + "')");
            }
            else
            {
                fn.dsSql("update SOLICITUDES set estado=3 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                     " where a.ID_ACTIVIDAD='" + id_act + "')");
            }*/
        }
    }
}