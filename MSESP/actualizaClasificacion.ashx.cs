using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de actualizaClasificacion
    /// </summary>
    public class actualizaClasificacion : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string actsolClaComi = "0", addSol = "";
            funciones fn = new funciones();

            if (context.Request["actsolClaComi"] != "")
            {
                actsolClaComi = context.Request["actsolClaComi"];
            }

            addSol = "update SOLICITUDES set ID_CLASIFICACION_COMITE=" + actsolClaComi + " " +
            " where ID_SOLICITUD=" + context.Request["actsolIDClaComi"];

            fn.dsSql(addSol);
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