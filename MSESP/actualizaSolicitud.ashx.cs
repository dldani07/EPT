using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de actualizaSolicitud
    /// </summary>
    public class actualizaSolicitud : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "texto/normal";
            //context.Response.Write("Hola a todos");

            string inspaciente = "", strPac = "", insEmpresa = "", strEmp = "", conEmail = "", vf_sol = "", vh_sol = "",
            addSol = "", tabla = "", asuntoCorreo = "", cabezeraCorreo = "", estadoSol = "2", correoEmpresa = "Null", strAccAct = "", insAccionAct = "";
            funciones fn = new funciones();

            string fono_form = "Null", movil_form = "Null", email_form = "Null", vcomPac = "Null", vregPac = "Null", vidProfEC = "Null";
            string vactsolReg = "", vactsolCom = "", vactsolObs = "", vactsolRutPac = "", vactsolNomPac = "", vactsolSin = "", vactsolTelFijo = "", vactsolTelMovil,
                   vactsolEmailPac = "", vactsolRegPac = "", vactsolComPac = "", vactsolDirPac = "", vactsolEmp = "", vactsolEmpNom = "", vactsolRegEmp = "", vactsolComEmp,
                   vactsolDirEmp = "", vactSolConEmp = "", vactSolConTel = "", vactSolConEmail = "", vactsolCaso = "", vactsolProf = "", vactsolProfEva = "", vactsolObsCaso = "", vactsolNseg,
                   vactsolSeg = "", vactsolLat = "", vactsolGeneroPac = "", actsolNomGrup = "Null", actsolOcup = "Null", actsolMacroAR = "0", actsolMacroAR2 = "0", actsolMacroAR3 = "0", actsolIDObs1 = "0", actsolIDObs2 = "0", actsolIDObs3 = "0";

            if (context.Request["actsolComPac"] != "")
            {
                vcomPac = "'" + context.Request["actsolComPac"] + "'";
            }

            if (context.Request["actsolRegPac"] != "")
            {
                vregPac = "'" + context.Request["actsolRegPac"] + "'";
            }

            if (context.Request["actsolTelFijo"] != "")
            {
                fono_form = "'" + context.Request["actsolTelFijo"] + "'";
            }

            if (context.Request["actsolTelMovil"] != "")
            {
                movil_form = "'" + context.Request["actsolTelMovil"] + "'";
            }

            if (context.Request["actsolEmailPac"] != "")
            {
                email_form = "LOWER('" + context.Request["actsolEmailPac"] + "')";
            }


            vactsolReg = context.Request["actsolReg"];
            vactsolCom = context.Request["actsolCom"];
            vactsolObs = context.Request["actsolObs"];
            vactsolRutPac = context.Request["actsolRutPac"];
            vactsolNomPac = context.Request["actsolNomPac"];
            vactsolGeneroPac = context.Request["actsolGeneroPac"];
            vactsolSin = context.Request["actsolSin"];
            vactsolDirPac = context.Request["actsolDirPac"];
            vactsolEmp = context.Request["actsolEmp"];
            vactsolEmpNom = context.Request["actsolEmpNom"];
            vactsolRegEmp = context.Request["actsolRegEmp"];
            vactsolComEmp = context.Request["actsolComEmp"];
            vactsolDirEmp = context.Request["actsolDirEmp"];
            vactSolConEmp = context.Request["actSolConEmp"];
            vactSolConTel = context.Request["actSolConTel"];
            vactSolConEmail = context.Request["actSolConEmail"];
            vactsolCaso = context.Request["actsolCaso"];
            vactsolProf = context.Request["actsolProf"];

            if (context.Request["IdactsolTipo"] == "2" && context.Request["actsolTipoServicio"] == "1")
            {
                vactsolProf = context.Request["actsolProfEva"];
                vactsolProfEva = context.Request["actsolProf"];
            }

            vactsolObsCaso = context.Request["actsolObsCaso"];
            //vactsolNseg = context.Request["actsolNseg"];
            vactsolSeg = context.Request["actsolSeg1"];
            vactsolLat = context.Request["actsolLat1"];

            inspaciente = "IF NOT EXISTS (select * from PACIENTES where RUT='" + vactsolRutPac + "') BEGIN " +
              "insert into PACIENTES (RUT,NOMBRE,FONO_FIJO,FONO_MOVIL,EMAIL,DIRECCION,ID_REGION,ID_COMUNA,ID_GENERO) values('" + vactsolRutPac + "'," +
              "dbo.MayMinTexto('" + vactsolNomPac + "')," + fono_form + "," + movil_form + "," + email_form + ",'" + vactsolDirPac + "'," + vregPac + "," + vcomPac + "," + vactsolGeneroPac + ") " +
              " select ID=ID_PACIENTE from PACIENTES where RUT='" + vactsolRutPac + "' end " +
              " ELSE begin UPDATE PACIENTES SET NOMBRE=dbo.MayMinTexto('" + vactsolNomPac + "'), FONO_FIJO=" + fono_form + ", " +
              "EMAIL=" + email_form + ", FONO_MOVIL=" + movil_form + "," +
              "DIRECCION='" + vactsolDirPac + "', ID_REGION=" + vregPac + ",ID_COMUNA=" + vcomPac + ",ID_GENERO=" + vactsolGeneroPac + " WHERE RUT='" + vactsolRutPac + "'" +
              " select ID=ID_PACIENTE from PACIENTES where RUT='" + vactsolRutPac + "' END ";

            strPac = "Set Nocount on ";
            strPac = strPac + inspaciente;
            strPac = strPac + " set nocount off";

            DataSet rsPaciente = fn.dsSql(strPac);

            vactsolEmp = context.Request["actsolEmp"];
            vactsolEmpNom = context.Request["actsolEmpNom"];

            insEmpresa = "IF NOT EXISTS (select * from EMPRESAS where RUT='" + vactsolEmp + "') BEGIN " +
                  "insert into EMPRESAS (RUT,NOMBRE,ENVIO_CORREO) values('" + vactsolEmp + "'," +
                  "dbo.MayMinTexto('" + vactsolEmpNom + "'),0) " +
                  " select ID=ID_EMPRESA from EMPRESAS where RUT='" + vactsolEmp + "' end " +
                  " ELSE begin UPDATE EMPRESAS SET NOMBRE=dbo.MayMinTexto('" + vactsolEmpNom + "') " +
                  " WHERE RUT='" + vactsolEmp + "'" +
                  " select ID=ID_EMPRESA from EMPRESAS where RUT='" + vactsolEmp + "' END ";

            strEmp = "Set Nocount on ";
            strEmp = strEmp + insEmpresa;
            strEmp = strEmp + " set nocount off";

            DataSet rsEmpresa = fn.dsSql(strEmp);

            string obs_sol_form = "Null", actTipoServicio = "Null";

            if (context.Request["actsolObs"] != "")
            {
                obs_sol_form = "'" + context.Request["actsolObs"] + "'";
            }

            if (context.Request["actSolConEmail"] != "")
            {
                //estadoSol = "1";
                fn.dsSql("update SOLICITUDES set estado=1 where estado=2 and ID_SOLICITUD=" + context.Request["actsolID"]);
                correoEmpresa = "'" + context.Request["actSolConEmail"] + "'";
            }

            if (context.Request["actsolTipoServicio"] != "")
            {
                actTipoServicio = "'" + context.Request["actsolTipoServicio"] + "'";
            }

            if (context.Request["actsolNomGrup"] != "")
            {
                actsolNomGrup = "'" + context.Request["actsolNomGrup"] + "'";
            }

            if (context.Request["actsolOcup"] != "")
            {
                actsolOcup = "'" + context.Request["actsolOcup"] + "'";
            }

            if (context.Request["actsolMacroAR"] != "")
            {
                actsolMacroAR = "'" + context.Request["actsolMacroAR"] + "'";
            }

            if (context.Request["actsolMacroAR2"] != "")
            {
                actsolMacroAR2 = "'" + context.Request["actsolMacroAR2"] + "'";
            }

            if (context.Request["actsolIDObs1"].ToString() != "")
            {
                actsolIDObs1 = "'" + context.Request["actsolIDObs1"].ToString() + "'";
            }

            if (context.Request["actsolIDObs2"].ToString() != "")
            {
                actsolIDObs2 = "'" + context.Request["actsolIDObs2"].ToString() + "'";
            }

            if (context.Request["actsolMacroAR6"] != "")
            {
                actsolMacroAR3 = "'" + context.Request["actsolMacroAR6"] + "'";
            }

            if (context.Request["actsolIDObs6"].ToString() != "")
            {
                actsolIDObs3 = "'" + context.Request["actsolIDObs6"].ToString() + "'";
            }


            vf_sol = "CONVERT(datetime,'" + context.Request["actsolFecha"] + "')";
            vh_sol = "'" + context.Request["actsolHora"] + "'";

            addSol = "update SOLICITUDES set ID_REGION_EPT='" + context.Request["actsolReg"] + "',ID_COMUNA_EPT='" + context.Request["actsolCom"] + "'," +
            "OBSERVACIONES=" + obs_sol_form + ",ID_PACIENTE='" + rsPaciente.Tables[0].Rows[0]["ID"].ToString() + "',ORDEN_SINIESTRO='" + context.Request["actsolSin"] + "'," +
            "ID_EMPRESA='" + rsEmpresa.Tables[0].Rows[0]["ID"].ToString() + "',CONTACTO_NOMBRE='" + context.Request["actSolConEmp"] + "'," +
            "CONTACTO_FONO='" + context.Request["actSolConTel"] + "',CONTACTO_EMAIL=" + correoEmpresa + "," +
            "ID_REGION_EMPRESA='" + context.Request["actsolRegEmp"] + "'," +
            "ID_COMUNA_EMPRESA='" + context.Request["actsolComEmp"] + "'," +
            "ID_CASO='" + context.Request["actsolCaso"] + "',ID_SEGMENTO='" + context.Request["actsolSeg1"] + "'," +
            "ID_LATERAL='" + context.Request["actsolLat1"] + "'," +
            "DIRECCION_EMPRESA='" + context.Request["actsolDirEmp"] + "'," +
            "OBSERVACION_CASO='" + context.Request["actsolObsCaso"] + "',ID_PROFESIONAL='" + vactsolProf + "', " +
            "FONO_FIJO=" + fono_form + ", ID_PROFESIONAL_EVA='" + vactsolProfEva + "', " +
            "EMAIL=" + email_form + ", FONO_MOVIL=" + movil_form + "," +
            "DIRECCION='" + vactsolDirPac + "', ID_REGION=" + vregPac + ",ID_COMUNA=" + vcomPac + ",TIPO_SERVICIO=" + actTipoServicio + ", " +
            "ID_GRUPO_CIUO=" + actsolNomGrup + ", ID_SUBGRUPO_CIUO=" + actsolOcup + ", " +
            "MACROAR1=" + actsolMacroAR + ", MACROAR2=" + actsolMacroAR2 + ", MACROAR3=" + actsolMacroAR3 + ", " +
            "CRITERIO_OBS1=" + actsolIDObs1 + ", CRITERIO_OBS2=" + actsolIDObs2 + ", CRITERIO_OBS3=" + actsolIDObs3 + ", " +
            "FECHA_SOLICITUD=" + vf_sol + ", HORA_SOLICITUD=" + vh_sol +
            " where ID_SOLICITUD=" + context.Request["actsolID"];

            fn.dsSql(addSol);

            fn.dsSql("update solicitudes set FECHA_SOLICITUD=convert(date,FECHA_INGRESO) where ID_SOLICITUD=" + context.Request["actsolID"] + " and FECHA_SOLICITUD=convert(date,'01-01-1900')");

            DataSet dsSoliD = fn.dsSql("SELECT ID_SOLICITUD,ID_USUARIO_INGRESO,cod=CONVERT(VARCHAR(4), YEAR(FECHA_SOLICITUD))+CONVERT(VARCHAR(2),MONTH(FECHA_SOLICITUD)) FROM SOLICITUDES WHERE ID_SOLICITUD=" + context.Request["actsolID"]);

            //fn.dsSql("update SOLICITUDES_DETALLE set ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "' where COD_SOL='" + codSol + "';");

            /**/
            tabla = tabla + "<tr style=\"width:180px;\"><td>Fecha : </td>" +
                            "    <td></td>" +
                            "</tr>"; /*+
                            "<tr><td>Hora : </td>" +
                            "    <td>" + h_sol + "</td>" +
                            "</tr>" +
                            "<tr><td>Forma Ingreso : </td>" +
                            "    <td>Email</td>" +
                            "</tr>" +
                            "<tr><td>Observaciones : </td>" +
                            "    <td>" + obs_sol + "</td>" +
                            "</tr>" +
                            "<tr><td>Rut Paciente : </td>" +
                            "    <td>" + rut + "</td>" +
                            "</tr>" +
                            "<tr><td>Nombre Paciente : </td>" +
                            "    <td>" + nombre + "</td>" +
                            "</tr>" +
                            "<tr><td>Teléfono Fijo : </td>" +
                            "    <td>" + fono + "</td>" +
                            "</tr>" +
                            "<tr><td>Teléfono Móvil : </td>" +
                            "    <td>" + movil + "</td>" +
                            "</tr>" +
                            "<tr><td>Email : </td>" +
                            "    <td>" + email + "</td>" +
                            "</tr>" +
                            "<tr><td>Orden Siniestro : </td>" +
                            "    <td>" + o_sol + "</td>" +
                            "</tr>" +
                            "<tr><td>Rut Empresa : </td>" +
                            "    <td>" + rutEmp + "</td>" +
                            "</tr>" +
                            "<tr><td>Nombre Empresa : </td>" +
                            "    <td>" + nombreEmp + "</td>" +
                            "</tr>" +
                            "<tr><td>Dirección : </td>" +
                            "    <td>" + dirEmp + "</td>" +
                            "</tr>" +
                            "<tr><td>Contacto : </td>" +
                            "    <td>" + conEmp + "</td>" +
                            "</tr>" +
                            "<tr><td>Contacto Telefono: </td>" +
                            "    <td>" + conFono + "</td>" +
                            "</tr>" +
                            "<tr><td>Contacto Email : </td>" +
                            "    <td>" + conEmail + "</td>" +
                            "</tr>";*/

            tabla = "<tr style=\"width:180px;\"><td></td><td></td></tr>";

            DataSet dsEnviaCorreo = fn.dsSql("SELECT * FROM EMPRESAS E WHERE E.ENVIO_CORREO<>0 AND E.ID_EMPRESA=" + rsEmpresa.Tables[0].Rows[0]["ID"].ToString());

            if (dsEnviaCorreo.Tables[0].Rows.Count > 0)
            {
            if (context.Request["actSolConEmail"] != "")
            {
                DataSet dsCorreoDir = fn.dsSql("select top 1 D.ID_DIRECTOR,D.EMAIL from EMPRESAS E " +
                                                               " INNER JOIN DIRECTORES D ON D.ID_DIRECTOR=E.ID_DIRECTOR " +
                                                               " where E.RUT='" + vactsolEmp + "' AND E.ESTADO=1");

                if (context.Request["IdactsolTipo"] == "2" && context.Request["actsolTipoServicio"] == "1")
                {
                    conEmail = "notificaciones@solicitudept.cl";
                }
                else
                {
                    conEmail = context.Request["actSolConEmail"];
                }


                if (dsCorreoDir.Tables[0].Rows.Count > 0)
                {
                    //conEmail = conEmail + ", " + dsCorreoDir.Tables[0].Rows[0]["EMAIL"].ToString();
                }

                asuntoCorreo = "Informa Inicio de Estudio de Calificación Enfermedad Profesional Sr.(a) Sr.(a) " + vactsolNomPac + ", N° " + context.Request["actsolSin"];
                cabezeraCorreo = "<p align=\"justify\">Informo a usted que en cumplimiento de lo establecido en Circular N° 3241 de la Superintendencia de Seguridad Social, debe realizarse el estudio de calificación de enfermedad profesional de Sr.(a) <b>" + vactsolNomPac + "</b> , RUT <b>" + vactsolRutPac + "</b>  trabajador(a) de vuestra empresa.</p>" +
                                "<p align=\"justify\">Por este motivo, es necesario realizar un Estudio de Puesto de Trabajo para el (la) trabajador(a) mencionado. Para ello, se contactará con ustedes nuestro equipo de coordinación de especialistas, para programar la evaluación que se realizará por un profesional debidamente acreditado por Mutual de Seguridad, para lo cual solicitamos vuestra colaboración.</p>" +
                                "<p align=\"justify\">Se cuenta con un plazo de 10 días hábiles para cumplir con este requerimiento. Posterior a este plazo, Mutual de Seguridad deberá realizar la calificación del caso con los elementos de juicio que tenga disponibles, en virtud de lo establecido por la Circular SUSESO ya mencionada.</p>" +
                                "<p align=\"justify\">En caso de presentar algún inconveniente o dudas puede contactarse a nuestra unidad especialista, a través del correo electrónico contactoept@mutual.cl.</p>" +
                                "<p align=\"justify\">Saluda atentamente a usted,</p>" +
                                "<p align=\"justify\"><b>Mutual de Seguridad CChC</b></p>";

                DataSet dsVerEnvio = fn.dsSql("select * from ACCIONES where ID_TIPO_ACTIVIDAD='3' and ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "'");
                
                if (dsVerEnvio.Tables[0].Rows.Count == 0)
                {
                    fn.enviaCorreo("Sr. " + vactsolEmpNom, conEmail, tabla, context.Request["actsolSin"], asuntoCorreo, cabezeraCorreo);

                    string insAccion = "", strAcc = "";

                    //if (context.Request["IdactsolTipo"] != "2")
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
                                 "'" + rsAccion.Tables[0].Rows[0]["ID"].ToString() + "','" + dsSoliD.Tables[0].Rows[0]["ID_USUARIO_INGRESO"].ToString() + "',CONVERT(datetime, getdate()),'Envio Automatico de Correo',2); ");
                    //}
                }
            }
            }

            fn.dsSql("delete from SOLICITUD_SEGMENTOS where ID_SOLICITUD=" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString());

            if (context.Request["actsolSeg1"] != null && context.Request["actsolSeg1"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg1"] + "','" + context.Request["actsolLat1"] + "',1,GETDATE(),1);");
            }
            if (context.Request["actsolSeg2"] != null && context.Request["actsolSeg2"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg2"] + "','" + context.Request["actsolLat2"] + "',1,GETDATE(),2);");
            }
            if (context.Request["actsolSeg3"] != null && context.Request["actsolSeg3"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg3"] + "','" + context.Request["actsolLat3"] + "',1,GETDATE(),3);");
            }
            if (context.Request["actsolSeg4"] != null && context.Request["actsolSeg4"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg4"] + "','" + context.Request["actsolLat4"] + "',1,GETDATE(),4);");
            }
            if (context.Request["actsolSeg5"] != null && context.Request["actsolSeg5"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg5"] + "','" + context.Request["actsolLat5"] + "',1,GETDATE(),5);");
            }
            if (context.Request["actsolSeg6"] != null && context.Request["actsolSeg6"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg6"] + "','" + context.Request["actsolLat6"] + "',1,GETDATE(),6);");
            }
            if (context.Request["actsolSeg7"] != null && context.Request["actsolSeg7"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg7"] + "','" + context.Request["actsolLat7"] + "',1,GETDATE(),7);");
            }
            if (context.Request["actsolSeg8"] != null && context.Request["actsolSeg8"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg8"] + "','" + context.Request["actsolLat8"] + "',1,GETDATE(),8);");
            }
            if (context.Request["actsolSeg9"] != null && context.Request["actsolSeg9"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg9"] + "','" + context.Request["actsolLat9"] + "',1,GETDATE(),9);");
            }
            if (context.Request["actsolSeg10"] != null && context.Request["actsolSeg10"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg10"] + "','" + context.Request["actsolLat10"] + "',1,GETDATE(),10);");
            }
            if (context.Request["actsolSeg11"] != null && context.Request["actsolSeg11"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg11"] + "','" + context.Request["actsolLat11"] + "',1,GETDATE(),11);");
            }
            if (context.Request["actsolSeg12"] != null && context.Request["actsolSeg12"] != "")
            {
                fn.dsSql("insert into SOLICITUD_SEGMENTOS (ID_SOLICITUD,ID_SEGMENTO,ID_LATERAL,ESTADO,FECHA_CREACION,N_SEGMENTO) values('" +
                         dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "','" + context.Request["actsolSeg12"] + "','" + context.Request["actsolLat12"] + "',1,GETDATE(),12);");
            }

            if (context.Request["actsolUsrMod"].ToString() != "")
            {
                    insAccionAct = "IF NOT EXISTS (select * from ACCIONES where ID_TIPO_ACTIVIDAD='35' and ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "') BEGIN " +
                          "insert into ACCIONES (ID_TIPO_ACTIVIDAD,FECHA_CREACION,ESTADO,ID_SOLICITUD) values('35'," +
                          "getdate(),1,'" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "') " +
                          " select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='35' and ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "' END " +
                          " ELSE begin select ID=ID_ACCION from ACCIONES where ID_TIPO_ACTIVIDAD='35' and ID_SOLICITUD='" + dsSoliD.Tables[0].Rows[0]["ID_SOLICITUD"].ToString() + "' END ";

                    strAccAct = "Set Nocount on ";
                    strAccAct = strAccAct + insAccionAct;
                    strAccAct = strAccAct + " set nocount off";

                    DataSet rsAccionAct = fn.dsSql(strAccAct);

                    fn.dsSql("insert into ACCION_DETALLE (ID_ACCION,ID_USUARIO,FECHA_REALIZACION,OBSERVACIONES,DESTINATARIO) values(" +
                                 "'" + rsAccionAct.Tables[0].Rows[0]["ID"].ToString() + "','" + context.Request["actsolUsrMod"].ToString() + "',CONVERT(datetime, getdate()),'Solicitud Actualizada',2); ");
            }

            string xml = "";
            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                        "<insetar>" +
                            "<sql>" + addSol + "</sql>";
            xml = xml + "</insetar>";
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