using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class Profesionales : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //solZonal.Items.Clear();
            //llenaZonal();
        }

        public void llenaZonal()
        {
            ListItem oItem;
            oItem = new ListItem("Seleccione", "");
            solZonal.Items.Add(oItem);
            oItem = new ListItem("Centro", "1");
            solZonal.Items.Add(oItem);
            oItem = new ListItem("Norte", "2");
            solZonal.Items.Add(oItem);
            oItem = new ListItem("Punta Arenas", "3");
            solZonal.Items.Add(oItem);
            oItem = new ListItem("RM", "4");
            solZonal.Items.Add(oItem);
            oItem = new ListItem("RM / Centro", "5");
            solZonal.Items.Add(oItem);
            oItem = new ListItem("Sur", "6");
            solZonal.Items.Add(oItem);
            this.solZonal.ClearSelection();
        }

        [WebMethod]
        public static string Guardar(string rut, string nombre, string[] proveedor, string clave, 
                                     string CheckDE, string CheckME, string CheckSM, string CheckPC, 
                                     string CheckManLun, string CheckManMar, string CheckManMie, 
                                     string CheckManJue, string CheckManVie, string CheckManSab, 
                                     string CheckManDom, string CheckTarLun, string CheckTarMar, 
                                     string CheckTarMie, string CheckTarJue, string CheckTarVie, 
                                     string CheckTarSab, string CheckTarDom, string vrbTar, string vcmbTarFin, 
                                     string vcmbTarIni, string vrbMan, string vcmbManFin, string vcmbManIni, 
                                     string vsolAgencia, string vsolZonal, string vtxtProf, string vtxtEmail, 
                                     string vxtFono, string vsolAte, string vsolDispComent, string vtxtDir,
                                     string vsolVeh, string CheckDF, string proy, string estado, string organizacion)
        {
            string TRealiza = "", bloquemnn = "", bloquetar = "", txtDir = "Null", solVeh = "Null", insProf = "", strProf = "", strSQLProf = "", addProfPro = "", addProfProProv="";

            if (CheckDE == "1") { TRealiza = TRealiza + "13/"; }
            if (CheckME == "1") { TRealiza = TRealiza + "5/"; }
            if (CheckSM == "1") { TRealiza = TRealiza + "12/"; }
            if (CheckPC == "1") { TRealiza = TRealiza + "4/"; }
            if (CheckDF == "1") { TRealiza = TRealiza + "19/"; }

            if (TRealiza != "")
            {
                TRealiza = "'" + TRealiza + "'";
            }
            else { TRealiza = "Null"; }

            if (CheckManLun == "1") { bloquemnn = bloquemnn + "Lunes,"; }
            if (CheckManMar == "1") { bloquemnn = bloquemnn + "Martes,"; }
            if (CheckManMie == "1") { bloquemnn = bloquemnn + "Miércoles,"; }
            if (CheckManJue == "1") { bloquemnn = bloquemnn + "Jueves,"; }
            if (CheckManVie == "1") { bloquemnn = bloquemnn + "Viernes,"; }
            if (CheckManSab == "1") { bloquemnn = bloquemnn + "Sábado,"; }
            if (CheckManDom == "1") { bloquemnn = bloquemnn + "Domingo,"; }

            if (bloquemnn != "")
            {
                bloquemnn = "'" + bloquemnn + "'";
            }
            else { bloquemnn = "Null"; }

            if (CheckTarLun == "1") { bloquetar = bloquetar + "Lunes,"; }
            if (CheckTarMar == "1") { bloquetar = bloquetar + "Martes,"; }
            if (CheckTarMie == "1") { bloquetar = bloquetar + "Miércoles,"; }
            if (CheckTarJue == "1") { bloquetar = bloquetar + "Jueves,"; }
            if (CheckTarVie == "1") { bloquetar = bloquetar + "Viernes,"; }
            if (CheckTarSab == "1") { bloquetar = bloquetar + "Sábado,"; }
            if (CheckTarDom == "1") { bloquetar = bloquetar + "Domingo,"; }

            if (bloquetar != "")
            {
                bloquetar = "'" + bloquetar + "'";
            }
            else { bloquetar = "Null"; }

            if (vtxtDir != "")
            {
                txtDir = "'" + vtxtDir + "'";
            }

            if (vsolVeh != "")
            {
                solVeh = "'" + vsolVeh + "'";
            }
   
            funciones fn = new funciones();
            insProf = "IF NOT EXISTS (select * from PROFESIONALES where RUT='" + rut + "') BEGIN " +
                     "insert into PROFESIONALES (RUT,NOMBRE,ESTADO,PASSWORD,REALIZA,AGENCIA,ZONAL,PROFESION,EMAIL,FONO,ATENCION,CONSIDERACIONES," +
                     "jornManana,manHoraIni,manHoraFin,jornTarde,tarHoraIni,tarHoraFin,ID_VEHICULO,DIRECCION,ESTADO2, ID_ORGANIZACION) values(" +
                     "'" + rut + "','" + nombre + "',1,'" + clave + "'," + TRealiza +
                     ",'" + vsolAgencia + "','" + vsolZonal + "','" + vtxtProf + "','" + vtxtEmail + "','" + vxtFono + "','" + vsolAte + "','" + vsolDispComent +
                     "'," + bloquemnn + ",'" + vcmbManIni + "','" + vcmbManFin + "'," + bloquetar + ",'" + vcmbTarIni + "','" + vcmbTarFin + "'," + solVeh + "," + txtDir + ",'" + estado + "'," + organizacion + "); " +
                     " select ID=ID_PROFESIONAL from PROFESIONALES where RUT='" + rut + "'; end " +
                     " ELSE begin UPDATE PROFESIONALES SET NOMBRE=dbo.MayMinTexto('" + nombre + "')," +
                     "PASSWORD='" + clave + "', REALIZA=" + TRealiza + "," +
                     "AGENCIA='" + vsolAgencia + "', ZONAL='" + vsolZonal + "'," +
                     "PROFESION='" + vtxtProf + "', EMAIL='" + vtxtEmail + "', FONO='" + vxtFono + "'," +
                     "ATENCION='" + vsolAte + "', CONSIDERACIONES='" + vsolDispComent + "'," + "ESTADO2 = '" + estado + "', ID_ORGANIZACION = " + organizacion + ", " +
                     "jornManana=" + bloquemnn + ", manHoraIni='" + vcmbManIni + "', manHoraFin='" + vcmbManFin + "'," +
                     "jornTarde=" + bloquetar + ", tarHoraIni='" + vcmbTarIni + "', tarHoraFin='" + vcmbTarFin + "', ID_VEHICULO=" + solVeh + ",DIRECCION=" + txtDir +
                     " WHERE RUT='" + rut + "';" +
                     " select ID=ID_PROFESIONAL from PROFESIONALES where RUT='" + rut + "'; END ";

            strProf = "Set Nocount on ";
            strProf = strProf + insProf;
            strProf = strProf + " set nocount off";

            DataSet rsProf = fn.dsSql(strProf);

            addProfPro = "IF NOT EXISTS (select * from PROFESIONALES_PROYECTO UP where UP.ID_PROFESIONAL='" + rsProf.Tables[0].Rows[0]["ID"].ToString() + "' and UP.ID_PROYECTO=" + proy + ") BEGIN " +
                         " insert into PROFESIONALES_PROYECTO (ID_PROFESIONAL,ID_PROYECTO,FECHA_CREACION,ESTADO) values('" + rsProf.Tables[0].Rows[0]["ID"].ToString() + "'," + proy + ",getdate(),1); end " +
                         " ELSE begin UPDATE PROFESIONALES_PROYECTO SET ESTADO=1 where ID_PROFESIONAL='" + rsProf.Tables[0].Rows[0]["ID"].ToString() + "' AND ID_PROYECTO=" + proy + " END";

            fn.dsSql(addProfPro);

            fn.dsSql("delete from PROFESIONALES_PROVEEDOR WHERE ID_PROFESIONAL = " + rsProf.Tables[0].Rows[0]["ID"].ToString());

            foreach (string s in proveedor)
            {

                addProfProProv = "IF NOT EXISTS (select * from PROFESIONALES_PROVEEDOR UP where UP.ID_PROFESIONAL='" + rsProf.Tables[0].Rows[0]["ID"].ToString() + "' and UP.ID_PROVEEDOR=" + s + ") BEGIN " +
                         " insert into PROFESIONALES_PROVEEDOR (ID_PROFESIONAL,ID_PROVEEDOR,FECHA_CREACION) values('" + rsProf.Tables[0].Rows[0]["ID"].ToString() + "'," + s + ",getdate()); end " +
                         " ELSE begin UPDATE PROFESIONALES_PROVEEDOR SET FECHA_CREACION= getdate() where ID_PROFESIONAL='" + rsProf.Tables[0].Rows[0]["ID"].ToString() + "' AND ID_PROVEEDOR=" + s + " END";

                fn.dsSql(addProfProProv);
            }


            return "Exit!!";
        }

        [WebMethod]
        public static void Eliminar(string id, string usr, string proy)
        {
            funciones fn = new funciones();
            //fn.dsSql("update PROFESIONALES set estado=0, USR_ELIMINA='" + usr + "' where ID_PROFESIONAL='" + id + "'");
            fn.dsSql("update PROFESIONALES_PROYECTO set estado=0, USR_ELIMINA='" + usr + "' where ID_PROYECTO=" + proy + " and ID_PROFESIONAL='" + id + "'");
        }
    }
}