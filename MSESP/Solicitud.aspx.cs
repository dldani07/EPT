using CuteWebUI;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MSESP
{
    public partial class Solicitud : System.Web.UI.Page
    {
        int nContArch = 0;
        string fIngresoSol = DateTime.Now.ToString().Replace("/", "").Replace(":", "").Replace(" ", "").Replace("-", "");
        protected void Page_Load(object sender, EventArgs e)
        {
            solTipo.Items.Clear();

            cargaEtp();

            solForma.Items.Clear();
            //cargaForma();

            /*solNseg.Items.Clear();
            cargaNsegmento();

            solSeg.Items.Clear();
            cargasegmento();

            solLat.Items.Clear();
            cargaLateral();*/

            solSol.Items.Clear();

            solReg.Enabled = true;
            solTipoServicio.Enabled = true;
            /*ProfSug1Prof.Visible = true;
            ProfSug1.Visible = true;
            tdProfSugTxt.Visible = true;
            tdProfSugSel.Visible = true;*/

            if ((string)(Session["IDProyecto"]) == "2")
            {
                solReg.Enabled = false;
                solTipoServicio.Enabled = false;
                /*ProfSug1Prof.Visible = false;
                ProfSug1.Visible = false;
                tdProfSugTxt.Visible = false;
                tdProfSugSel.Visible = false;*/
            }

            if ((string)(Session["TpUsuario"])=="3")
            {
                    cargaSolicitante((string)(Session["IdUsuario"]));
                    solSol.Enabled = false;
                    solFecha.Text = DateTime.Now.ToString().Replace("/", "-").Substring(0, 10);
                    solFecha.Enabled = false;
                    solHora.Text = DateTime.Now.ToString().Substring(11, 5);
                    solHora.Enabled = false;
                    solForma.Enabled = false;

                    cargaForma("2");
            }
            else
            {
                    cargaSolicitante("");
                    //solSol.Text = "Seleccione";
                    solSol.Enabled = true;
                    solFecha.Text = "";
                    solFecha.Enabled = true;
                    solHora.Text = "";
                    solHora.Enabled = true;
                    solForma.Enabled = true;

                    cargaForma("0");

                    if ((string)(Session["IDProyecto"]) == "2")
                    {
                        cargaForma("2");
                    }
                    //this.solForma.ClearSelection();
            }

            //solCaso.Items.Clear();
            //cargaCasos();

            SubeDoc();

            Session["datos"] = true;
            //trSegmento.Visible = false;
            //btnMensaje4.Attributes["onclick"] = "alert('Se ha presionado el boton: 4'); return false;";
        }

        private void SubeDoc()
        {
            funciones fn = new funciones();
            string nomArchivo = "";
            var codSol = HttpContext.Current.Request["codSol"];

            HttpFileCollection files = Request.Files;
            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];
                if (file.ContentLength > 0)
                {
                    nContArch = nContArch + 1;
                    /**/
                    if (files.AllKeys[i].ToString().Replace("fileUpload", "") == "MainContent_FileDocMotConsulta")
                    {
                        nomArchivo = "Mot_Cons_";
                    }
                    else if (files.AllKeys[i].ToString().Replace("fileUpload", "") == "MainContent_FileDocListaTestigos")
                    {
                        nomArchivo = "Lis_Tes_";
                    }
                    else
                    {
                        nomArchivo = "Res_Sol_";
                    }

                    string nomArch = String.Format("{0}_{1:yyyyMMddhhmmss}{2}",
                                                   nomArchivo + codSol.ToString() + "_" + nContArch.ToString(), fIngresoSol,
                                                   System.IO.Path.GetExtension(file.FileName));

                    var guardarArch = Path.Combine(HttpContext.Current.Server.MapPath("~/Documentos"), nomArch);

                    file.SaveAs(guardarArch);

                    fn.dsSql("insert into SOLICITUDES_DETALLE (ID_SOLICITUD,ARCHIVO,FECHA_INGRESO,ESTADO,COD_SOL) values(1,'" + nomArch + "',GETDATE(),1,'" + codSol + "');");
                }
            }
        }

        public void cargaEtp()
        {
            ListItem oItem;

            if ((string)(Session["IDProyecto"]) != "5")
            {
                oItem = new ListItem("Seleccione", "");
                solTipo.Items.Add(oItem);
                //oItem = new ListItem("EPT Disfonía", "4");
                //solTipo.Items.Add(oItem);
                oItem = new ListItem("EPT Musculo-Esq", "1");
                solTipo.Items.Add(oItem);
                oItem = new ListItem("EPT Salud Mental", "2");
                solTipo.Items.Add(oItem);
                oItem = new ListItem("EPT Dermatológico", "3");
                solTipo.Items.Add(oItem);
                this.solTipo.ClearSelection();
            }
            else
            {
                oItem = new ListItem("Seleccione", "");
                solTipo.Items.Add(oItem);
                oItem = new ListItem("EPT Salud Mental", "2");
                solTipo.Items.Add(oItem);
            }
        }

        public void cargaForma(string id)
        {
            ListItem oItem;
            oItem = new ListItem("Seleccione", "");
            solForma.Items.Add(oItem);
            oItem = new ListItem("Email", "1");
            solForma.Items.Add(oItem);
            oItem = new ListItem("Web", "2");
            solForma.Items.Add(oItem);
            this.solForma.SelectedValue = id;
            //this.solForma.ClearSelection();
        }

        public void cargaNsegmento()
        {
            /*ListItem oItem;
            oItem = new ListItem("N/A", "N/A");
            solNseg.Items.Add(oItem);
            oItem = new ListItem("1", "1");
            solNseg.Items.Add(oItem);
            oItem = new ListItem("2", "2");
            solNseg.Items.Add(oItem);
            this.solNseg.ClearSelection();*/
        }

        public void cargasegmento()
        {
                /*ListItem oItem;
                oItem = new ListItem("Seleccione", "");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Cervico Braquialgia", "1");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Codo", "2");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Dermatología", "3");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Hombro", "4");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Lumbar", "5");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Mano-Dedo (T. Nodular)", "6");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Mano-Muñeca (STC)", "7");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Mano-Pulgar (T. Quervain)", "8");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Miembro Inferior", "9");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Muñeca- Mano (T. Flexores-Extensores)", "10");
                solSeg.Items.Add(oItem);
                oItem = new ListItem("Otra", "11");
                solSeg.Items.Add(oItem);
                this.solSeg.ClearSelection();

                oItem = new ListItem("Seleccione", "");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Cervico Braquialgia", "1");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Codo", "2");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Dermatología", "3");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Hombro", "4");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Lumbar", "5");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Mano-Dedo (T. Nodular)", "6");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Mano-Muñeca (STC)", "7");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Mano-Pulgar (T. Quervain)", "8");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Miembro Inferior", "9");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Muñeca- Mano (T. Flexores-Extensores)", "10");
                solSeg2.Items.Add(oItem);
                oItem = new ListItem("Otra", "11");
                solSeg2.Items.Add(oItem);
                this.solSeg2.ClearSelection();

                oItem = new ListItem("Seleccione", "");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Cervico Braquialgia", "1");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Codo", "2");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Dermatología", "3");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Hombro", "4");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Lumbar", "5");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Mano-Dedo (T. Nodular)", "6");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Mano-Muñeca (STC)", "7");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Mano-Pulgar (T. Quervain)", "8");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Miembro Inferior", "9");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Muñeca- Mano (T. Flexores-Extensores)", "10");
                solSeg3.Items.Add(oItem);
                oItem = new ListItem("Otra", "11");
                solSeg3.Items.Add(oItem);
                this.solSeg3.ClearSelection();

                oItem = new ListItem("Seleccione", "");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Cervico Braquialgia", "1");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Codo", "2");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Dermatología", "3");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Hombro", "4");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Lumbar", "5");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Mano-Dedo (T. Nodular)", "6");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Mano-Muñeca (STC)", "7");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Mano-Pulgar (T. Quervain)", "8");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Miembro Inferior", "9");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Muñeca- Mano (T. Flexores-Extensores)", "10");
                solSeg4.Items.Add(oItem);
                oItem = new ListItem("Otra", "11");
                solSeg4.Items.Add(oItem);
                this.solSeg4.ClearSelection();*/
        }

        public void cargaLateral()
        {
            /*ListItem oItem;

            oItem = new ListItem("Bilateral", "1");
            solLat.Items.Add(oItem);
            oItem = new ListItem("Derecho", "2");
            solLat.Items.Add(oItem);
            oItem = new ListItem("Izquierdo", "3");
            solLat.Items.Add(oItem);
            oItem = new ListItem("N/A", "4");
            solLat.Items.Add(oItem);
            this.solLat.ClearSelection();

            oItem = new ListItem("Bilateral", "1");
            solLat2.Items.Add(oItem);
            oItem = new ListItem("Derecho", "2");
            solLat2.Items.Add(oItem);
            oItem = new ListItem("Izquierdo", "3");
            solLat2.Items.Add(oItem);
            oItem = new ListItem("N/A", "4");
            solLat2.Items.Add(oItem);
            this.solLat2.ClearSelection();

            oItem = new ListItem("Bilateral", "1");
            solLat3.Items.Add(oItem);
            oItem = new ListItem("Derecho", "2");
            solLat3.Items.Add(oItem);
            oItem = new ListItem("Izquierdo", "3");
            solLat3.Items.Add(oItem);
            oItem = new ListItem("N/A", "4");
            solLat3.Items.Add(oItem);
            this.solLat3.ClearSelection();

            oItem = new ListItem("Bilateral", "1");
            solLat4.Items.Add(oItem);
            oItem = new ListItem("Derecho", "2");
            solLat4.Items.Add(oItem);
            oItem = new ListItem("Izquierdo", "3");
            solLat4.Items.Add(oItem);
            oItem = new ListItem("N/A", "4");
            solLat4.Items.Add(oItem);
            this.solLat4.ClearSelection();*/
        }

        public void cargaCasos()
        {
            ListItem oItem;
            oItem = new ListItem("Seleccione", "");
            solCaso.Items.Add(oItem);
            oItem = new ListItem("CTP", "2");
            solCaso.Items.Add(oItem);
            oItem = new ListItem("STP", "1");
            solCaso.Items.Add(oItem);
            this.solCaso.ClearSelection();
        }

        public void cargaSolicitante(string id)
        {
            funciones fn = new funciones();
            string usrProyecto = "0";

            if ((string)(Session["IDProyecto"]) != "" && (string)(Session["IDProyecto"]) != null)
            {
                usrProyecto = Session["IDProyecto"].ToString();
            }

            DataSet dsTrab = fn.dsSql("/**/select ID_USUARIO='', nom=' Seleccione' union all  " +
                                     " SELECT U.ID_USUARIO, nom=dbo.MayMinTexto(U.NOMBRE) FROM USUARIOS U" +
                                     " inner join USUARIO_PROYECTO up on up.ID_USUARIO=u.ID_USUARIO " +
                                     " WHERE U.ID_TIPO_USUARIO=3 and UP.ESTADO=1 AND UP.ID_PROYECTO=" + usrProyecto + " order by NOM asc");

            solSol.DataSource = dsTrab.Tables[0].DefaultView;
            solSol.DataValueField = "ID_USUARIO";
            solSol.DataTextField = "nom";
            solSol.DataBind();

            solSol.SelectedValue = id;
        }

        [WebMethod()]
        public static bool KeepActiveSession()
        {
            if (HttpContext.Current.Session["datos"] != null)
                return true;
            else
                return false;
        }

        [WebMethod()]
        public static void SessionAbandon()
        {
            HttpContext.Current.Session.Remove("datos");
        }

        [WebMethod]
        public static string Guardar(string rut, string nombre, string fono, string movil,
                                    string email, string dirp, string rutEmp, string nombreEmp,
                                    string tipoSol, string f_sol, string h_sol, string u_sol, string com_sol,
                                    string reg_sol, string obs_sol, string o_sol, string conEmp, string conFono,
                                    string conEmail, string idregemp, string idcomemp, string idcaso,
                                    string idseg1, string idlat1, string dirEmp, string obsCaso, string codSol,
                                    string idProf, string regpac, string compac, string idseg2, string idlat2, string idseg3,
                                    string idlat3, string idseg4, string idlat4, string idseg5, string idlat5, string idseg6,
                                    string idlat6, string idseg7, string idlat7, string idseg8, string idlat8, string idseg9,
                                    string idlat9, string idseg10, string idlat10, string idseg11, string idlat11,
                                    string idseg12, string idlat12, string forma_sol, string usrSol, string idProfEC, string idtipoUser, string tServicio, string proy, string idgenero, string detCriterio)
        {
            string inspaciente = "", strPac = "", insEmpresa = "", strEmp = "", vf_sol = "", vh_sol = "", idTipoServicio = "Null", dirEmp_form = "Null", conEmp_form = "Null", conFono_form = "Null", busFiltroCorr = "Null", preCorr_Tipo_Proyecto = "", ESTADO_EP = "Null",
                   addSol = "", strSol = "", tabla = "", asuntoCorreo = "", cabezeraCorreo = "", estadoSol = "2", correoEmpresa = "Null", vidProfEC = "Null", conEmail2 = "", asuntoCorreo2 = "", cabezeraCorreo2 = "", correosAnexos = "";
            funciones fn = new funciones();

            string fono_form = "Null", movil_form = "Null", email_form = "Null", vcomPac = "Null", vregPac = "Null", vidProf = "Null", vobsCaso = "Null";

            if (proy == "2")
            {
                forma_sol = "2";
                busFiltroCorr = " and TIPO_EPT=1";
                if (tipoSol == "2")
                {
                    busFiltroCorr = " and TIPO_EPT=2";
                }
            }
            else
            {
                busFiltroCorr = " and (TIPO_EPT=" + tipoSol.ToString() + " OR TIPO_EPT IS NULL) ";
            }

            if (compac != "")
            {
                vcomPac = "'" + compac + "'";
            }

            if (regpac != "")
            {
                vregPac = "'" + regpac + "'";
            }

            if (fono != "")
            {
                fono_form = "'" + fn.convierte(fono) + "'";
            }

            if (movil != "")
            {
                movil_form = "'" + fn.convierte(movil) + "'";
            }

            if (dirEmp != "")
            {
                dirEmp_form = "'" + fn.convierte(dirEmp) + "'";
            }

            if (conEmp != "")
            {
                conEmp_form = "'" + fn.convierte(conEmp) + "'";
            }

            if (conFono != "")
            {
                conFono_form = "'" + fn.convierte(conFono) + "'";
            }

            if (email != "")
            {
                email_form = "LOWER('" + email + "')";
            }

            inspaciente = "IF NOT EXISTS (select * from PACIENTES where RUT='" + rut + "') BEGIN " +
                  "insert into PACIENTES (RUT,NOMBRE,FONO_FIJO,FONO_MOVIL,EMAIL,DIRECCION,ID_REGION,ID_COMUNA,ID_GENERO) values('" + rut + "'," +
                  "dbo.MayMinTexto('" + fn.convierte(nombre) + "')," + fono_form + "," + movil_form + "," + email_form + ",'" + fn.convierte(dirp) + "'," + vregPac + "," + vcomPac + "," + idgenero + ") " +
                  " select ID=ID_PACIENTE from PACIENTES where RUT='" + rut + "' end " +
                  " ELSE begin UPDATE PACIENTES SET NOMBRE=dbo.MayMinTexto('" + fn.convierte(nombre) + "'), FONO_FIJO=" + fono_form + ", " +
                  "EMAIL=" + email_form + ", FONO_MOVIL=" + movil_form + "," +
                  "DIRECCION='" + fn.convierte(dirp) + "', ID_REGION=" + vregPac + ",ID_COMUNA=" + vcomPac + ", ID_GENERO=" + idgenero + " WHERE RUT='" + rut + "'" +
                  " select ID=ID_PACIENTE from PACIENTES where RUT='" + rut + "' END ";

            strPac = "Set Nocount on ";
            strPac = strPac + inspaciente;
            strPac = strPac + " set nocount off";

            DataSet rsPaciente = fn.dsSql(strPac);

            insEmpresa = "IF NOT EXISTS (select * from EMPRESAS where RUT='" + rutEmp + "') BEGIN " +
                  "insert into EMPRESAS (RUT,NOMBRE,ENVIO_CORREO) values('" + rutEmp + "'," +
                  "dbo.MayMinTexto('" + fn.convierte(nombreEmp) + "'),1) " +
                  " select ID=ID_EMPRESA from EMPRESAS where RUT='" + rutEmp + "' end " +
                  " ELSE begin UPDATE EMPRESAS SET NOMBRE=dbo.MayMinTexto('" + fn.convierte(nombreEmp) + "') " +
                  " WHERE RUT='" + rutEmp + "'" +
                  " select ID=ID_EMPRESA from EMPRESAS where RUT='" + rutEmp + "' END ";

            strEmp = "Set Nocount on ";
            strEmp = strEmp + insEmpresa;
            strEmp = strEmp + " set nocount off";

            DataSet rsEmpresa = fn.dsSql(strEmp);

            DataSet dsEnviaCorreo = fn.dsSql("SELECT * FROM EMPRESAS E WHERE E.ENVIO_CORREO<>0 AND E.ID_EMPRESA=" + rsEmpresa.Tables[0].Rows[0]["ID"].ToString());

            string obs_sol_form = "Null";

            if (obs_sol != "")
            {
                obs_sol_form = "'" + fn.convierte(obs_sol) + "'";
            }

            if (conEmail != "")
            {
                if (dsEnviaCorreo.Tables[0].Rows.Count > 0)
                {
                    estadoSol = "1";
                    ESTADO_EP = estadoSol;
                }
                correoEmpresa = "'" + conEmail + "'";
            }

            if (idProf != "")
            {
                vidProf = "'" + idProf + "'";
            }

            if (obsCaso != "")
            {
                vobsCaso = "'" + fn.convierte(obsCaso) + "'";
            }

            if (tipoSol == "2")
            {
                if (tServicio == "1")
                {
                    estadoSol = "2";
                    ESTADO_EP = estadoSol;
                    if (idProfEC != "")
                    {
                        vidProfEC = "'" + idProf + "'";
                    }

                    if (idProf != "")
                    {
                        vidProf = "'" + idProfEC + "'";
                    }
                }
            }

            if (tipoSol == "2")
            {
                idTipoServicio = "'" + tServicio + "'";
            }

            vf_sol = "CONVERT(datetime,'" + f_sol + "')";
            vh_sol = "'" + h_sol + "'";

            if (idtipoUser == "3")
            {
                vf_sol = "dbo.BuscaFechaIngresoHabil (CONVERT(varchar(10),getdate(),105))";//"CONVERT(DATETIME,CONVERT(DATE,GETDATE()))";
                vh_sol = "(case when convert(datetime,getdate())>" +
                         " CONVERT(datetime, CONVERT(varchar(10), getdate(), 105) + ' ' + '18:30' +':00') then " +
                         "'08:30' else convert(char(5), getdate(), 108) END) ";//"convert(char(5), getdate(), 108)";
            }

            DataSet dsCorre = fn.dsSql("SELECT C.N_CORRELATIVO,C.CORREOSANEXOS,C.ENVIA_CORREO_EMP_USR_INT,C.ENVIA_CORREO_INTERNO_SOLICITANTE," +
                                "C.ENVIA_CORREO_FORMATO_RM,preCorr=(CASE WHEN C.PRECORRELATIVO IS NULL THEN " +
                                "CONVERT(VARCHAR(4), YEAR(GETDATE()))+right('00' + CONVERT(VARCHAR(2),MONTH(GETDATE())), 2) " +
                                "ELSE C.PRECORRELATIVO END),T_EPT=ISNULL(c.TIPO_EPT,0)" +
                                " FROM CORRELATIVO C where C.ID_PROYECTO='" + proy + "'" + busFiltroCorr);

            fn.dsSql("update CORRELATIVO set N_CORRELATIVO=N_CORRELATIVO+1 where ID_PROYECTO='" + proy + "'" + busFiltroCorr);

            preCorr_Tipo_Proyecto = dsCorre.Tables[0].Rows[0]["preCorr"].ToString() + "-";
            if (dsCorre.Tables[0].Rows[0]["T_EPT"].ToString()!="0")
            {
                preCorr_Tipo_Proyecto = dsCorre.Tables[0].Rows[0]["preCorr"].ToString() + tipoSol + "-";
            }

            DataSet dsCriterio = fn.dsSql("select tc.ID_MACRO_AGENTE," +
            "'DET_CRITERIO'=[dbo].[DET_CRITERIO_OBSERVACION](tc.ID_MACRO_AGENTE,'" + detCriterio + "') " +
            " FROM TIPO_CRITERIO_OBSERVACION TC " +
            " inner join TIPO_MACRO_AGENTE TM on tm.ID_MACRO_AGENTE=tc.ID_MACRO_AGENTE " +
            " WHERE TC.ESTADO=1 and tm.ESTADO=1 and tc.ID_CRITERIO_OBSERVACION in (" + detCriterio + ") " +
            " group by tc.ID_MACRO_AGENTE");

            string Macro1 = "0", Macro2 = "0", Macro3 = "0", Criterio1 = "'0'", Criterio2 = "'0'", Criterio3 = "'0'";
            for (int contCriterio = 0; contCriterio < dsCriterio.Tables[0].Rows.Count; contCriterio++)
            {
                if (contCriterio == 0)
                {
                    Macro1 = dsCriterio.Tables[0].Rows[contCriterio]["ID_MACRO_AGENTE"].ToString();
                    Criterio1 = "'" + dsCriterio.Tables[0].Rows[contCriterio]["DET_CRITERIO"].ToString() + "'";
                }

                if (contCriterio == 1)
                {
                    Macro2 = dsCriterio.Tables[0].Rows[contCriterio]["ID_MACRO_AGENTE"].ToString();
                    Criterio2 = "'" + dsCriterio.Tables[0].Rows[contCriterio]["DET_CRITERIO"].ToString() + "'";
                }

                if (contCriterio == 2)
                {
                    Macro3 = dsCriterio.Tables[0].Rows[contCriterio]["ID_MACRO_AGENTE"].ToString();
                    Criterio3 = "'" + dsCriterio.Tables[0].Rows[contCriterio]["DET_CRITERIO"].ToString() + "'";
                }
            }

            addSol = "insert into SOLICITUDES (ID_TIPO_SOLICITUD,FECHA_SOLICITUD,FECHA_INGRESO,ID_FORMA_INGRESO," +
            "ID_USUARIO_INGRESO,HORA_SOLICITUD,ID_REGION_EPT,ID_COMUNA_EPT,OBSERVACIONES,ID_PACIENTE,ORDEN_SINIESTRO," +
            "ID_EMPRESA,CONTACTO_NOMBRE,CONTACTO_FONO,CONTACTO_EMAIL,ID_REGION_EMPRESA,ID_COMUNA_EMPRESA,ID_DIRECTOR," +
            "ID_CASO,ID_SEGMENTO,N_SEGMENTO,ID_LATERAL,ESTADO,DIRECCION_EMPRESA,OBSERVACION_CASO,COD_SOL,ID_PROFESIONAL," +
            "NUM_SOLICITUD,ID_USUARIO_SOLICITUD,FONO_FIJO,FONO_MOVIL,EMAIL,DIRECCION,ID_REGION,ID_COMUNA,ID_PROFESIONAL_EVA,id_proyecto,TIPO_SERVICIO,ESTADO_EP, " +
            "MACROAR1,MACROAR2,MACROAR3,CRITERIO_OBS1,CRITERIO_OBS2,CRITERIO_OBS3) " +
            "values('" + tipoSol + "'," + vf_sol + ",getdate(),'" + forma_sol + "','" +
            u_sol + "'," + vh_sol + ",'" + reg_sol + "','" + com_sol + "'," + obs_sol_form + ",'" +
            rsPaciente.Tables[0].Rows[0]["ID"].ToString() + "','" + o_sol + "','" +
            rsEmpresa.Tables[0].Rows[0]["ID"].ToString() + "'," + conEmp_form + "," + conFono_form + "," +
            correoEmpresa + ",'" + idregemp + "','" + idcomemp + "',null,'" + idcaso + "','" + idseg1 + "','" +
            "1" + "','" + idlat1 + "'," + estadoSol + "," + dirEmp_form + "," + vobsCaso + ",'" + codSol + "'," + vidProf + ",'" +
            preCorr_Tipo_Proyecto + "' + right('00000' + CONVERT(VARCHAR(100), " + Convert.ToString(Convert.ToInt32(dsCorre.Tables[0].Rows[0]["N_CORRELATIVO"].ToString()) + 1) + "),5)," +
            "'" + usrSol + "'," + fono_form + "," + movil_form + "," + email_form + ",'" + fn.convierte(dirp) + "'," + vregPac + "," + vcomPac + "," + vidProfEC + "," + proy + "," + idTipoServicio + "," + ESTADO_EP +
            "," + Macro1 + "," + Macro2 + "," + Macro3 + "," + Criterio1 + "," + Criterio2 + "," + Criterio3 + ");";

            strSol = " Set Nocount on ";
            strSol = strSol + addSol;
            strSol = strSol + " set nocount off ";

            fn.dsSql(strSol);

            DataSet dsSoliD = fn.dsSql("SELECT s.ID_SOLICITUD,cod=CONVERT(VARCHAR(4), YEAR(s.FECHA_SOLICITUD))+CONVERT(VARCHAR(2),MONTH(s.FECHA_SOLICITUD))," + 
                                       "s.NUM_SOLICITUD,usr=u.NOMBRE,tipo=tp.NOMBRE,'com'=c.NOMBRE," +
                                       "'NoHabil'=(case when CONVERT(date, s.FECHA_INGRESO)<CONVERT(date, s.FECHA_SOLICITUD) then '1' else '0' END) " +
                                       " FROM SOLICITUDES s " +
                                       " inner join USUARIOS u on u.ID_USUARIO=s.ID_USUARIO_SOLICITUD " +
                                       " inner join TIPO_SOLICITUD tp on tp.ID_TIPO_SOLICITUD=s.ID_TIPO_SOLICITUD " +
                                       " left join comuna c on c.ID_COMUNA=s.ID_COMUNA_EMPRESA " +
                                       " WHERE s.COD_SOL='" + codSol + "'");

            fn.dsSql("update SOLICITUDES_DETALLE set ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "' where COD_SOL='" + codSol + "';");

            tabla = "<tr style=\"width:180px;\"><td></td><td></td></tr>";

            correosAnexos = dsCorre.Tables[0].Rows[0]["CORREOSANEXOS"].ToString();

            DataSet dsCorreoUsr = fn.dsSql("select u.EMAIL from usuarios u " +
                                            " where u.ID_USUARIO in (" + usrSol + "," + u_sol + ") and u.EMAIL is not null and u.EMAIL<>''");

            for (int cont = 0; cont < dsCorreoUsr.Tables[0].Rows.Count; cont++)
            {
                if (conEmail2 == "")
                {
                    conEmail2 = dsCorreoUsr.Tables[0].Rows[cont]["EMAIL"].ToString();
                }
                else
                {
                    conEmail2 = conEmail2 + ", " + dsCorreoUsr.Tables[0].Rows[cont]["EMAIL"].ToString();
                }
            }

            if (dsEnviaCorreo.Tables[0].Rows.Count > 0)
            {
                if (conEmail != "")
                {
                    if (tipoSol == "2" && tServicio == "1")
                    {
                        conEmail = "notificaciones@solicitudept.cl";
                    }

                    //########### Tercer Correo a Empresa #########//
                    asuntoCorreo = "Informa Inicio de Estudio de Calificación Enfermedad Profesional Sr.(a) " + nombre + ", N° " + o_sol;
                    cabezeraCorreo = "<p align=\"justify\">Informo a usted que en cumplimiento de lo establecido por la Superintendencia de Seguridad Social, debe realizarse el estudio de calificación de enfermedad profesional de Sr.(a) <b>" + nombre + "</b> , RUT <b>" + rut + "</b>  trabajador(a) de vuestra empresa.</p>" +
                                    "<p align=\"justify\">Por este motivo, es necesario realizar un Estudio de Puesto de Trabajo para el (la) trabajador(a) mencionado. Para ello, se contactará con ustedes un miembro de nuestro equipo de coordinación para programar la evaluación que será llevada a cabo por un profesional acreditado por Mutual de Seguridad, siendo imprescindible contar con vuestra colaboración.</p>" +
                                    //"<p align=\"justify\"><b>Para dar cumplimiento a los plazos legales impuestos por dicha circular, usted cuenta con 48 horas para acusar recibo de esta información al correo contactoept@mutual.cl para coordinar la visita de nuestro especialista, la cual tiene plazo legal de 72 horas.</b></p>" +
                                    //"<p align=\"justify\"><b>El no acusar recibo de esta notificación, faculta a Mutual de Seguridad de C.Ch.C. para calificar el caso con la información disponible.</b></p>" +
                                    //"<p align=\"justify\">En caso de presentar algún inconveniente o dudas puede contactarse a nuestra unidad especialista, a través del correo electrónico contactoept@mutual.cl.</p>" +
                                    "<p align=\"justify\">Agradeceremos desde ya brindar las facilidades para llevar a cabo este proceso exitosamente.</p>" +
                                    "<p align=\"justify\">Saluda atentamente a usted,</p>" +
                                    "<p align=\"justify\"><b>Mutual de Seguridad CChC</b></p>";

                    try
                    {
                        if (dsCorre.Tables[0].Rows[0]["ENVIA_CORREO_EMP_USR_INT"].ToString() != "0")
                        {
                            fn.enviaCorreo("Sr. " + nombreEmp, conEmail + ", " + conEmail2, tabla, o_sol, asuntoCorreo, cabezeraCorreo);
                        }
                        else
                        {
                            fn.enviaCorreo("Sr. " + nombreEmp, conEmail, tabla, o_sol, asuntoCorreo, cabezeraCorreo);
                        }
                    }
                    catch (Exception e)
                    {
                        //fn.enviaCorreo("Sr. " + nombreEmp, conEmail + ", " + conEmail2, tabla, o_sol, asuntoCorreo, cabezeraCorreo);
                    }

                    string insAccion = "", strAcc = "";

                    //if (tipoSol != "2")
                    //{
                        insAccion = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='3' and ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "') BEGIN " +
                              "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('3'," +
                              "getdate(),1,'" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "') " +
                              " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='3' and ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "' END " +
                              " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='3' and ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "' END ";

                        strAcc = "Set Nocount on ";
                        strAcc = strAcc + insAccion;
                        strAcc = strAcc + " set nocount off";

                        DataSet rsAccion = fn.dsSql(strAcc);

                        fn.dsSql("insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO) values(" +
                                 "'" + rsAccion.Tables[0].Rows[0]["ID"].ToString() + "','" + u_sol + "',getdate(),'Envio Automatico de Correo',2); ");
                    //}
                }
            }

            if (idseg1 != null && idseg1 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg1 + "','" + idlat1 + "',1,GETDATE(),1);");
            }
            if (idseg2 != null && idseg2 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg2 + "','" + idlat2 + "',1,GETDATE(),2);");
            }
            if (idseg3 != null && idseg3 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg3 + "','" + idlat3 + "',1,GETDATE(),3);");
            }
            if (idseg4 != null && idseg4 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg4 + "','" + idlat4 + "',1,GETDATE(),4);");
            }
            if (idseg5 != null && idseg5 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg5 + "','" + idlat5 + "',1,GETDATE(),5);");
            }
            if (idseg6 != null && idseg6 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg6 + "','" + idlat6 + "',1,GETDATE(),6);");
            }
            if (idseg7 != null && idseg7 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg7 + "','" + idlat7 + "',1,GETDATE(),7);");
            }
            if (idseg8 != null && idseg8 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg8 + "','" + idlat8 + "',1,GETDATE(),8);");
            }
            if (idseg9 != null && idseg9 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg9 + "','" + idlat9 + "',1,GETDATE(),9);");
            }
            if (idseg10 != null && idseg10 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg10 + "','" + idlat10 + "',1,GETDATE(),10);");
            }
            if (idseg11 != null && idseg11 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg11 + "','" + idlat11 + "',1,GETDATE(),11);");
            }
            if (idseg12 != null && idseg12 != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + idseg12 + "','" + idlat12 + "',1,GETDATE(),12);");
            }

            if (dsCorre.Tables[0].Rows[0]["ENVIA_CORREO_FORMATO_RM"].ToString() == "1")
            {
                DataSet dsSolSeg = fn.dsSql("select 'Nseg'=ISNULL(sum(l.N_LATERIDAD),0),'Segmentos'=ISNULL(dbo.DET_SEG_EPT(" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "), '') from SOLICITUD_SEGMENTOS ss " +
                                         " inner join LATERIDAD l on l.ID_LATERIDAD=ss.ID_LATERAL " +
                                         " where ss.ID_SOLICITUD=" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString());

                //########### Primer Correo Claudio Soto RM #########//
                asuntoCorreo2 = "Ingreso de Caso N° " + dsSoliD.Tables[0].Rows[0]["NUM_SOLICITUD"].ToString();
                cabezeraCorreo2 = "";
                tabla = "<tr style=\"width:400px;\"><td style=\"width:150px; border-style: solid; border-width: 1px;\">N° Caso </td>" +
                                            "    <td style=\"width:250px; border-style: solid; border-width: 1px;\">" + dsSoliD.Tables[0].Rows[0]["NUM_SOLICITUD"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Fecha de Solicitud </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + f_sol + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">N° Siniestro </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + o_sol + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Nombre Paciente </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + nombre + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Rut Paciente </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + rut + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Teléfono </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + movil + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Dirección Trabajador </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + fn.convierte(dirp) + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Correo Electrónico</td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + email + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Razón Social Empleador </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + nombreEmp + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Contacto Empresa </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + conEmp + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Rut Empresa </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + rutEmp + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Teléfono Empresa </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + conFono + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Dirección</td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dirEmp + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Comuna Empresa</td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsSoliD.Tables[0].Rows[0]["com"].ToString() + "</td>" +
                                            "</tr>";
                if (tipoSol == "1")
                {
                    tabla = tabla + "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">N° Segmentos</td>" +
                                   "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsSolSeg.Tables[0].Rows[0]["Nseg"].ToString() + "</td>" +
                                   "</tr>" +
                                   "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Segmentos</td>" +
                                   "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsSolSeg.Tables[0].Rows[0]["Segmentos"].ToString() + "</td>" +
                                   "</tr>";
                }

                try
                {
                    fn.enviaCorreo("", conEmail2 + ", " + correosAnexos, tabla, o_sol, asuntoCorreo2, cabezeraCorreo2);
                }
                catch (Exception e)
                {

                }
            }

            if (dsCorre.Tables[0].Rows[0]["ENVIA_CORREO_INTERNO_SOLICITANTE"].ToString() == "1")
            {
                //########### Segundo Correo Interno a Solicitante #########//
                tabla = "<tr style=\"width:180px;\"><td></td><td></td></tr>";
                asuntoCorreo2 = "Ingreso exitoso de solicitud de Estudio de Calificación Enfermedad Profesional del Sr.(a) " + nombre + ", Siniestro N° " + o_sol;
                cabezeraCorreo2 = "<p align=\"justify\">Se ha creado el caso N°<b>" + dsSoliD.Tables[0].Rows[0]["NUM_SOLICITUD"].ToString() + "</b> del paciente <b>" + nombre + "</b> con rut: <b>" + rut + "</b> para el caso tipo : <b>" + dsSoliD.Tables[0].Rows[0]["tipo"].ToString() + "</b></p>" +
                              "<p align=\"justify\">&nbsp;</p>" +
                              "<p align=\"justify\">Saluda atentamente a usted,</p>" +
                              "<p align=\"justify\"><b>Mutual de Seguridad CChC</b></p>";

                try
                {
                    fn.enviaCorreo("Sr.(a) " + dsSoliD.Tables[0].Rows[0]["usr"].ToString(), conEmail2, tabla, o_sol, asuntoCorreo2, cabezeraCorreo2);
                }
                catch (Exception e)
                {
                    //fn.enviaCorreo("Sr.(a) " + dsSoliD.Tables[0].Rows[0]["usr"].ToString(), conEmail2, tabla, o_sol, asuntoCorreo2, cabezeraCorreo2);
                }
            }
            /*if (email != "")
            {
                correos = correos + ", " + email ;
            }*/
            //tabla = "";

            string xml = "", msnFinal = "";

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<resultado>";

            xml = xml + "<row>" +
                            "<texto>" + dsSoliD.Tables[0].Rows[0]["NUM_SOLICITUD"].ToString() + "</texto>" +
                        "</row>";

            xml = xml + "</resultado>";

            if (dsSoliD.Tables[0].Rows[0]["NoHabil"].ToString() == "1")
            {
                msnFinal = ". Le recordamos que esta solicitud tendrá como Fecha de Ingreso el próximo día Hábil, por que su ingreso es posterior a las 18:30 horas o en un fin de semana o día festivo.";
            }
            //return JSON.parse("[{Id: " + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "}]");
            //return "'results': [{'DocId': " + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "}]";

            return "{\"dato\": \"" + dsSoliD.Tables[0].Rows[0]["NUM_SOLICITUD"].ToString() + msnFinal + "\"}";
        }

        [WebMethod]
        public static string GuardarAccion(string tipo, string fecha, string obs, string id_sol, string usr, string accDestinatario, string accCorreo)
        {
            string insAccion = "", strAcc = "", insAccionDet = "", dcorreo = "Null", ddest = "Null";
            funciones fn = new funciones();

            if(accDestinatario!="")
            {
                ddest="'" + accDestinatario + "'";
            }

            if(accCorreo!="")
            {
                dcorreo = "'" + accCorreo + "'";
            }

            insAccion = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                  "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('" + tipo + "'," +
                  "getdate(),1,'" + id_sol + "') " +
                  " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END " +
                  " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END ";

            strAcc = "Set Nocount on ";
            strAcc = strAcc + insAccion;
            strAcc = strAcc + " set nocount off";

            DataSet rsAccion = fn.dsSql(strAcc);

            insAccionDet = "insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO,CORREO,FECHA_CREACION) values(" +
                         "'" + rsAccion.Tables[0].Rows[0]["ID"].ToString() + "','" + usr + "',CONVERT(datetime,'" + fecha + "'),'" + obs + "'," + ddest + "," + dcorreo + ",getdate()); ";

            DataSet rsAccionDet = fn.dsSql(insAccionDet);

            return insAccionDet;
        }

        [WebMethod]
        public static string GuardarAsignacion(string tipo, string fecha, string prof, string id_sol, string usr, string region, string hora, string dir, string hora2, string asignacion, string comuna, string medio, string otros)
        {
            string insAccion = "", insAccion2 = "", strAcc = "", strAcc2 = "";
            funciones fn = new funciones();

            insAccion = "IF NOT EXISTS (select * from ACTIVIDADES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' and ESTADO NOT IN (5)) BEGIN " +
                  "insert into ACTIVIDADES (ID_PROFESIONAL,ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,FECHA_PROGRAMACION,ID_USUARIO,ID_SOLICITUD,HORA1,ID_REGION,DIRECCION,HORA2,ASIGNACION, COMUNA, MEDIO, OTROS) values('" + prof + "'," +
                  "'" + tipo + "',getdate(),0,CONVERT(datetime,'" + fecha + "'),'" + usr + "','" + id_sol + "','" + hora + "','" + region + "','" + dir + "','" + hora2 + "', '" + asignacion + "','" + comuna + "','" + medio + "','" + otros + "') " +
                  " select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' and ESTADO NOT IN (5) END " +
                  " ELSE begin select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "'  and ESTADO NOT IN (5) END ";

            strAcc = "Set Nocount on ";
            strAcc = strAcc + insAccion;
            strAcc = strAcc + " set nocount off";

            DataSet rsAccion = fn.dsSql(strAcc);

            DataSet dsExiste = fn.dsSql("select * from ACTIVIDADES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' and ESTADO IN (5)");

            if (dsExiste.Tables[0].Rows.Count == 0)
            {
                if (tipo == "4")// || tipo == "12")
                {
                    fn.dsSql("update SOLICITUDES set ESTADO_EP=4 where ID_SOLICITUD='" + id_sol + "'");
                }
                else
                {
                    fn.dsSql("update SOLICITUDES set estado=5 where ID_SOLICITUD='" + id_sol + "'");
                }
            }
            else
            {
                if (tipo == "4")// || tipo == "12")
                {
                    fn.dsSql("update SOLICITUDES set ESTADO_EP=10 where ID_SOLICITUD='" + id_sol + "'");
                }
                else
                {
                    fn.dsSql("update SOLICITUDES set estado=10 where ID_SOLICITUD='" + id_sol + "'");
                }
            }

            insAccion2 = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='15' and ID_SOLICITUD='" + id_sol + "') BEGIN " +
            "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('15'," +
            "getdate(),1,'" + id_sol + "') " +
            " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='15' and ID_SOLICITUD='" + id_sol + "' END " +
            " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='15' and ID_SOLICITUD='" + id_sol + "' END ";

            strAcc2 = "Set Nocount on ";
            strAcc2 = strAcc2 + insAccion2;
            strAcc2 = strAcc2 + " set nocount off";

            DataSet rsAccion2 = fn.dsSql(strAcc2);

            fn.dsSql("insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO,CORREO,DOCUMENTO,FECHA_CREACION,ID_SEGMENTO,ID_LATERAL) values(" +
                                 "'" + rsAccion2.Tables[0].Rows[0]["ID"].ToString() + "','" + usr + "',CONVERT(datetime,'" + fecha + "'),(select ta.NOMBRE from TIPO_ACTIVIDAD ta where ta.ID_TIPO_ACTIVIDAD='" + tipo + "'),3,null,null,getdate(),null,null); ");


            return strAcc;
        }

       /* [WebMethod]
        public static string cambiaEstado(string tipo, string obs, string id_sol, string usr)
        {
            string insAccion = "", strAcc = "", insAccionDet = "", strFinal = "", insFinal = "";
            funciones fn = new funciones();

            insAccion = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                  "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('" + tipo + "'," +
                  "getdate(),1,'" + id_sol + "') " +
                  " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END " +
                  " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END ";

            strAcc = "Set Nocount on ";
            strAcc = strAcc + insAccion;
            strAcc = strAcc + " set nocount off";

            DataSet rsAccion = fn.dsSql(strAcc);

            insAccionDet = "insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO) values(" +
                         "'" + rsAccion.Tables[0].Rows[0]["ID"].ToString() + "','" + usr + "',getdate(),'" + obs + "',2); ";

            fn.dsSql(insAccionDet);

            if (tipo == "17")
            {
                fn.dsSql("update SOLICITUDES set estado=9,ESTADO_EP=9 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "18")
            {
                fn.dsSql("update SOLICITUDES set estado=0,ESTADO_EP=0 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "25")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_EP=7 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "26")
            {
                fn.dsSql("update SOLICITUDES set estado=7 where ID_SOLICITUD='" + id_sol + "'");

                insFinal = "IF NOT EXISTS (select * from ACTIVIDADES where ID_TIPO_ACTIVIDAD=11 and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                          "insert into ACTIVIDADES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,FECHA_PROGRAMACION,ID_USUARIO,ID_SOLICITUD) values(" +
                          "11,getdate(),2,CONVERT(datetime,getdate()),'" + usr + "','" + id_sol + "') " +
                          " select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD=11 and ID_SOLICITUD='" + id_sol + "' END " +
                          " ELSE begin select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD=11 and ID_SOLICITUD='" + id_sol + "' END ";

                strFinal = "Set Nocount on ";
                strFinal = strFinal + insFinal;
                strFinal = strFinal + " set nocount off";

                DataSet rsFinal = fn.dsSql(strFinal);

                fn.dsSql("insert into ACTIVIDAD_DETALLE(ID_ACTIVIDAD,DOCUMENTO,OBSERVACIONES,ESTADO) values(" + rsFinal.Tables[0].Rows[0]["ID"].ToString() + ",null,'" + obs + "',2);");
            }
            else
            {
                fn.dsSql("update SOLICITUDES set estado=1,ESTADO_EP=1,FECHA_SOLICITUD=CONVERT(DATETIME,CONVERT(DATE,GETDATE())), HORA_SOLICITUD=convert(char(5), getdate(), 108) where ID_SOLICITUD='" + id_sol + "'");
            }

            return "Exit!!";
        }*/

        [WebMethod]
        public static string cambiaEstado(string tipo, string obs, string fecha, string id_sol, string usr)
        {
            string insAccion = "", strAcc = "", insAccionDet = "", insFinal = "", strFinal = "";
            funciones fn = new funciones();

            insAccion = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                  "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('" + tipo + "'," +
                  "getdate(),1,'" + id_sol + "') " +
                  " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END " +
                  " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='" + tipo + "' and ID_SOLICITUD='" + id_sol + "' END ";

            strAcc = "Set Nocount on ";
            strAcc = strAcc + insAccion;
            strAcc = strAcc + " set nocount off";

            DataSet rsAccion = fn.dsSql(strAcc);

            if (fecha == "")
            {
                fecha = DateTime.Now.Date.ToString();
            }

            insAccionDet = "insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO) values(" +
                         "'" + rsAccion.Tables[0].Rows[0]["ID"].ToString() + "','" + usr + "',CONVERT(datetime,'" + fecha + "'),'" + obs + "',2); ";

            fn.dsSql(insAccionDet);

            if (tipo == "17")
            {
                fn.dsSql("update SOLICITUDES set estado=9,ESTADO_EP=9 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "18")
            {
                fn.dsSql("update SOLICITUDES set estado=0,ESTADO_EP=0 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "40")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_EP=9 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "41")
            {
                fn.dsSql("update SOLICITUDES set estado=9 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "42")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_EP=0 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "43")
            {
                fn.dsSql("update SOLICITUDES set estado=0 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (tipo == "25")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_EP=7 where ID_SOLICITUD='" + id_sol + "'");

                insFinal = "IF NOT EXISTS (select * from ACTIVIDADES where ID_TIPO_ACTIVIDAD=44 and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                "insert into ACTIVIDADES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,FECHA_PROGRAMACION,ID_USUARIO,ID_SOLICITUD) values(" +
                "44,getdate(),2,CONVERT(datetime,'" + fecha + "'),'" + usr + "','" + id_sol + "') " +
                " select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD=44 and ID_SOLICITUD='" + id_sol + "' END " +
                " ELSE begin select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD=44 and ID_SOLICITUD='" + id_sol + "' END ";

                strFinal = "Set Nocount on ";
                strFinal = strFinal + insFinal;
                strFinal = strFinal + " set nocount off";

                DataSet rsFinal = fn.dsSql(strFinal);

                fn.dsSql("insert into ACTIVIDAD_DETALLE(ID_ACTIVIDAD,DOCUMENTO,OBSERVACIONES,ESTADO) values(" + rsFinal.Tables[0].Rows[0]["ID"].ToString() + ",null,'" + obs + "',2);");
            }
            else if (tipo == "26")
            {
                fn.dsSql("update SOLICITUDES set estado=7 where ID_SOLICITUD='" + id_sol + "'");

                insFinal = "IF NOT EXISTS (select * from ACTIVIDADES where ID_TIPO_ACTIVIDAD=11 and ID_SOLICITUD='" + id_sol + "') BEGIN " +
                          "insert into ACTIVIDADES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,FECHA_PROGRAMACION,ID_USUARIO,ID_SOLICITUD) values(" +
                          "11,getdate(),2,CONVERT(datetime,'" + fecha + "'),'" + usr + "','" + id_sol + "') " +
                          " select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD=11 and ID_SOLICITUD='" + id_sol + "' END " +
                          " ELSE begin select ID=ID_ACTIVIDAD from ACTIVIDADES where ID_TIPO_ACTIVIDAD=11 and ID_SOLICITUD='" + id_sol + "' END ";

                strFinal = "Set Nocount on ";
                strFinal = strFinal + insFinal;
                strFinal = strFinal + " set nocount off";

                DataSet rsFinal = fn.dsSql(strFinal);

                fn.dsSql("insert into ACTIVIDAD_DETALLE(ID_ACTIVIDAD,DOCUMENTO,OBSERVACIONES,ESTADO) values(" + rsFinal.Tables[0].Rows[0]["ID"].ToString() + ",null,'" + obs + "',2);");
            }
            else
            {
                fn.dsSql("update SOLICITUDES set estado=1,ESTADO_EP=1,FECHA_SOLICITUD=CONVERT(DATETIME,CONVERT(DATE,GETDATE())), HORA_SOLICITUD=convert(char(5), getdate(), 108) where ID_SOLICITUD='" + id_sol + "'");
            }

            return insAccionDet;
        }
       
        [WebMethod]
        public static string enviaNoti(string id_sol, string usr)
        {
            funciones fn = new funciones();
            string asuntoCorreo2 = "", cabezeraCorreo2 = "", tabla = "", tipoSol = "", conEmail2 = "", correosAnexos = "", o_sol="";

            DataSet dsEnviaCorreo = fn.dsSql("SELECT s.NUM_SOLICITUD,FECHA=CONVERT(NVARCHAR(10),s.FECHA_SOLICITUD, 105),s.ORDEN_SINIESTRO," +
                                            "npaciente=dbo.MayMinTexto(p.NOMBRE),p.RUT,s.ID_USUARIO_SOLICITUD,s.ID_USUARIO_INGRESO," +
                                            "s.FONO_MOVIL,DIR=dbo.MayMinTexto(s.DIRECCION),s.EMAIL,s.ID_TIPO_SOLICITUD," +
                                            "e.NOMBRE,rute=e.RUT,s.DIRECCION_EMPRESA,s.CONTACTO_FONO,com=c.NOMBRE,s.CONTACTO_NOMBRE" +
                                            " FROM SOLICITUDES S " +
                                            " inner join pacientes p on p.ID_PACIENTE=s.ID_PACIENTE " +
                                            " inner join empresas e on e.ID_EMPRESA=s.ID_EMPRESA " +
                                            " inner join comuna c on c.ID_COMUNA=s.ID_COMUNA_EMPRESA " +
                                            " WHERE S.ID_SOLICITUD=" + id_sol);

            if (dsEnviaCorreo.Tables[0].Rows.Count > 0)
            {
                //########### Primer Correo Claudio Soto RM #########//
                asuntoCorreo2 = "Ingreso de Caso N° " + dsEnviaCorreo.Tables[0].Rows[0]["NUM_SOLICITUD"].ToString();
                cabezeraCorreo2 = "";
                tabla = "<tr style=\"width:400px;\"><td style=\"width:150px; border-style: solid; border-width: 1px;\">N° Caso </td>" +
                                            "    <td style=\"width:250px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["NUM_SOLICITUD"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Fecha de Solicitud </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["FECHA"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">N° Siniestro </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["ORDEN_SINIESTRO"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Nombre Paciente </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["npaciente"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Rut Paciente </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["RUT"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Teléfono </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["FONO_MOVIL"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Dirección Trabajador </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["DIR"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Correo Electrónico</td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["EMAIL"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Razón Social Empleador </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["NOMBRE"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Contacto Empresa </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["CONTACTO_NOMBRE"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Rut Empresa </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["rute"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Teléfono Empresa </td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["CONTACTO_FONO"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Dirección</td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["DIRECCION_EMPRESA"].ToString() + "</td>" +
                                            "</tr>" +
                                            "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Comuna Empresa</td>" +
                                            "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsEnviaCorreo.Tables[0].Rows[0]["com"].ToString() + "</td>" +
                                            "</tr>";

                tipoSol = dsEnviaCorreo.Tables[0].Rows[0]["ID_TIPO_SOLICITUD"].ToString();

                if (tipoSol == "1")
                {
                    DataSet dsSolSeg = fn.dsSql("select 'Nseg'=ISNULL(sum(l.N_LATERIDAD),0),'Segmentos'=ISNULL(dbo.DET_SEG_EPT(" + id_sol + "), '') from SOLICITUD_SEGMENTOS ss " +
                                                " inner join LATERIDAD l on l.ID_LATERIDAD=ss.ID_LATERAL " +
                                                " where ss.ID_SOLICITUD=" + id_sol);

                    tabla = tabla + "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">N° Segmentos</td>" +
                                    "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsSolSeg.Tables[0].Rows[0]["Nseg"].ToString() + "</td>" +
                                    "</tr>" +
                                    "<tr><td style=\"width:150px; border-style: solid; border-width: 1px;\">Segmentos</td>" +
                                    "    <td style=\"width:150px; border-style: solid; border-width: 1px;\">" + dsSolSeg.Tables[0].Rows[0]["Segmentos"].ToString() + "</td>" +
                                    "</tr>";
                }

                correosAnexos = "notificaciones@solicitudept.cl";
                /*
                    if (tipoSol == "2")
                    {
                        correosAnexos = "casotom@mutualasesorias.cl, eptsm@mutualasesorias.cl, cpizarroc@mutualasesorias.cl, eptsaludmental@gmail.com";
                    }
                    else
                    {
                        correosAnexos = "facortes@mutualasesorias.cl, gburgos@mutualasesorias.cl, eptmusculoesqueletico@mutualasesorias.cl";
                    }*/

                DataSet dsCorreoUsr = fn.dsSql("select u.EMAIL from usuarios u " +
                                                " where u.ID_USUARIO in (" + dsEnviaCorreo.Tables[0].Rows[0]["ID_USUARIO_SOLICITUD"].ToString() + "," + dsEnviaCorreo.Tables[0].Rows[0]["ID_USUARIO_INGRESO"].ToString() + ") and u.EMAIL is not null and u.EMAIL<>''");

                for (int cont = 0; cont < dsCorreoUsr.Tables[0].Rows.Count; cont++)
                {
                    if (conEmail2 == "")
                    {
                        conEmail2 = dsCorreoUsr.Tables[0].Rows[cont]["EMAIL"].ToString();
                    }
                    else
                    {
                        conEmail2 = conEmail2 + ", " + dsCorreoUsr.Tables[0].Rows[cont]["EMAIL"].ToString();
                    }
                }
                //conEmail2 "casotom@mutualasesorias.cl"
                try
                {
                    fn.enviaCorreo("", "casotom@mutualasesorias.cl" + ", " + correosAnexos, tabla, o_sol, asuntoCorreo2, cabezeraCorreo2);
                }
                catch (Exception e)
                {

                }
            }

            return "";
        }

        [WebMethod]
        public static void cancelaAsignacion(string tipo, string obs, string id_act, string usr)
        {
            funciones fn = new funciones();
            string strSol = "", actualizaEstados = "";

            fn.dsSql("update ACTIVIDADES set estado=5 where ID_ACTIVIDAD=" + id_act);
            fn.dsSql("update ACTIVIDAD_DETALLE set estado=5 where ID_ACTIVIDAD=" + id_act);

            fn.dsSql("insert into ACTIVIDAD_CANCELADA (ID_ACTIVIDAD,ID_USUARIO,FECHA_CANCELADA,ESTADO,OBSERVACION) values('" +
                     id_act + "','" + usr + "',getdate(),'" + tipo + "','" + obs + "');");


            actualizaEstados = "IF EXISTS (select * from actividades a where a.ID_ACTIVIDAD='" + id_act + "' and a.ID_TIPO_ACTIVIDAD=4) BEGIN " +
                                 "          update SOLICITUDES set ESTADO_EP=2 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                                 "          where a.ID_ACTIVIDAD='" + id_act + "');" +
                                 "      end else BEGIN " +
                                 "          update SOLICITUDES set estado=2 where ID_SOLICITUD in (select a.ID_SOLICITUD from actividades a " +
                                 "          where a.ID_ACTIVIDAD='" + id_act + "');" +
                                 "      end ";

            strSol = "Set Nocount on " + 
                     actualizaEstados + 
                     " set nocount off";

            fn.dsSql(strSol);

        }

        [WebMethod]
        public static string recepcionInforme(string fecha, string id_act, string tipo, string usr)
        {
            funciones fn = new funciones();

            if (tipo == "1")
            {
                fn.dsSql("update ACTIVIDADES set FECHA_RECEPCION_INFORME=CONVERT(datetime,'" + fecha + "') where ID_ACTIVIDAD=" + id_act);
            }
            else
            {
                fn.dsSql("update ACTIVIDADES set FECHA_CORRECCION=CONVERT(datetime,'" + fecha + "') where ID_ACTIVIDAD=" + id_act);
            }

            return "";
        }

        [WebMethod]
        public static string recepcionInforme2(string fecha, string id_act, string tipo, string usr, string id_sol)
        {
            funciones fn = new funciones();
            string strAcc3 = "", insAccion3 = "";

            if (tipo == "1")
            {
                if (fecha != "")
                {
                    fn.dsSql("update ACTIVIDADES set FECHA_RECEPCION_INFORME=CONVERT(datetime,'" + fecha + "') where ID_ACTIVIDAD=" + id_act);

                    insAccion3 = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='45' and ID_SOLICITUD  in (select a.ID_SOLICITUD from ACTIVIDADES a where a.ID_ACTIVIDAD=" + id_act + ")) BEGIN " +
                    "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('45'," +
                    "getdate(),1,(select a.ID_SOLICITUD from ACTIVIDADES a where a.ID_ACTIVIDAD=" + id_act + "))  " +
                    " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='45' and ID_SOLICITUD in (select a.ID_SOLICITUD from ACTIVIDADES a where a.ID_ACTIVIDAD=" + id_act + ") END " +
                    " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='45' and ID_SOLICITUD in (select a.ID_SOLICITUD from ACTIVIDADES a where a.ID_ACTIVIDAD=" + id_act + ") END ";

                    strAcc3 = "Set Nocount on ";
                    strAcc3 = strAcc3 + insAccion3;
                    strAcc3 = strAcc3 + " set nocount off";

                    DataSet rsAccion3 = fn.dsSql(strAcc3);

                    fn.dsSql("insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO,CORREO,DOCUMENTO,FECHA_CREACION,ID_SEGMENTO,ID_LATERAL) values(" +
                                         "'" + rsAccion3.Tables[0].Rows[0]["ID"].ToString() + "','" + usr + "',CONVERT(datetime,'" + fecha + "'),(select tp.NOMBRE from ACTIVIDADES a " +
                                         " inner join TIPO_ACTIVIDAD tp on tp.ID_TIPO_ACTIVIDAD=a.ID_TIPO_ACTIVIDAD where a.ID_ACTIVIDAD=" + id_act + "),null,null,null,getdate(),null,null); ");
                }
                else
                {
                    fn.dsSql("update ACTIVIDADES set FECHA_RECEPCION_INFORME=null where ID_ACTIVIDAD=" + id_act);
                }

            }
            else
            {
                fn.dsSql("update ACTIVIDADES set FECHA_CORRECCION=CONVERT(datetime,'" + fecha + "') where ID_ACTIVIDAD=" + id_act);
            }

            DataSet dsCorreoUsr = fn.dsSql("select id_tipo_actividad from ACTIVIDADES  " +
                                            " where ID_ACTIVIDAD =  " + id_act);

            if (dsCorreoUsr.Tables[0].Rows[0]["id_tipo_actividad"].ToString() == "4")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_EP=13 where  ID_SOLICITUD=" + id_sol);

            }
            else
            {
                fn.dsSql("update SOLICITUDES set ESTADO=13 where (ESTADO =5 OR ESTADO = 8 OR ESTADO = 10) AND ID_SOLICITUD=" + id_sol);
            }

            return "";
        }

        [WebMethod]
        public static string rechComite(string rechazado, string id_act, string tipo, string usr)
        {
            funciones fn = new funciones();

            if(tipo == "1"){
                fn.dsSql("update ACTIVIDADES set RECHAZO_INTERNO=" + rechazado + " where ID_ACTIVIDAD=" + id_act);
            }
            else{
            fn.dsSql("update ACTIVIDADES set RECHAZO_COMITE=" + rechazado + " where ID_ACTIVIDAD=" + id_act);
            }

            return "";
        }

        [WebMethod]
        public static string cambiaEstadoECT(string id_sol, string id_estado)
        {
            funciones fn = new funciones();

            if (id_estado == "1")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_ECT=1 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (id_estado == "2")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_ECT=2 where ID_SOLICITUD='" + id_sol + "'");
            }
            else if (id_estado == "3")
            {
                fn.dsSql("update SOLICITUDES set ESTADO_ECT=3 where ID_SOLICITUD='" + id_sol + "'");
            }
            else
            {
                fn.dsSql("update SOLICITUDES set ESTADO_ECT=NULL where ID_SOLICITUD='" + id_sol + "'");
            }

            return "ok";
        }

        [WebMethod]
        public static void Revision(string id_act, string det_act, string obs, string usr, string est)
        {
            funciones fn = new funciones();

            fn.dsSql("update ACTIVIDADES set estado=" + est + "where ID_ACTIVIDAD=" + id_act);
            fn.dsSql("update ACTIVIDAD_DETALLE set estado=" + est + "where ID_ACTIVIDAD_DETALLE=" + det_act);

            fn.dsSql("insert into ACTIVIDAD_REVISION (ID_ACTIVIDAD_DETALLE,ID_USUARIO,FECHA_REVISION,ESTADO,OBSERVACION) values('" +
                     det_act + "','" + usr + "',getdate(),'" + est + "','" + obs + "');");
        }
    }
}