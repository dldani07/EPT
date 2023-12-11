using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class Inicio : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["IDProyecto"] = Request.QueryString["p"];
            Session["USRSuper"] = Request.QueryString["s"];

            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select PROY=p.NOMBRE from PROYECTO p " +
                                       " where p.ID_PROYECTO='" + Session["IDProyecto"] + "' AND p.ESTADO=1");

            Session["NomProyecto"] = dsQuery.Tables[0].Rows[0]["PROY"].ToString();
        }
    }
}