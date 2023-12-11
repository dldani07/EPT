using DocumentFormat.OpenXml.Wordprocessing;
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
    public partial class Ingresadas : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public static string ValidaNull(string valor)
        {
            if (string.IsNullOrWhiteSpace(valor))
            {
                return "NULL";
            }
            else
            {
                return valor;
            }
        }

        [WebMethod]
        public static void Duplicar(string id, string usr, string proy)
        {
            funciones fn = new funciones();
            string busFiltroCorr = "Null", tipoSol="", preCorr_Tipo_Proyecto = "";

            DataSet dsQuery = fn.dsSql("select * from SOLICITUDES s " +
                                        " where s.ID_SOLICITUD=" + id);

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                tipoSol = dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString();

                if (proy == "2")
                {
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

                DataSet dsCorre = fn.dsSql("SELECT C.N_CORRELATIVO,C.CORREOSANEXOS,C.ENVIA_CORREO_EMP_USR_INT,C.ENVIA_CORREO_INTERNO_SOLICITANTE," +
                    "C.ENVIA_CORREO_FORMATO_RM,preCorr=(CASE WHEN C.PRECORRELATIVO IS NULL THEN " +
                    "CONVERT(VARCHAR(4), YEAR(GETDATE()))+right('00' + CONVERT(VARCHAR(2),MONTH(GETDATE())), 2) " +
                    "ELSE C.PRECORRELATIVO END),T_EPT=ISNULL(c.TIPO_EPT,0)" +
                    " FROM CORRELATIVO C where C.ID_PROYECTO='" + proy + "'" + busFiltroCorr);

                fn.dsSql("update CORRELATIVO set N_CORRELATIVO=N_CORRELATIVO+1 where ID_PROYECTO='" + proy + "'" + busFiltroCorr);

                preCorr_Tipo_Proyecto = dsCorre.Tables[0].Rows[0]["preCorr"].ToString() + "-";
                if (dsCorre.Tables[0].Rows[0]["T_EPT"].ToString() != "0")
                {
                    preCorr_Tipo_Proyecto = dsCorre.Tables[0].Rows[0]["preCorr"].ToString() + tipoSol + "-";
                }

                string sql = "INSERT INTO [dbo].[SOLICITUDES] ([ID_TIPO_SOLICITUD] ,[FECHA_SOLICITUD], [FECHA_INGRESO],[ID_FORMA_INGRESO] ,[ID_USUARIO_INGRESO], ";
                sql = sql + " [HORA_SOLICITUD],[ID_REGION_EPT],[ID_COMUNA_EPT],[OBSERVACIONES],[ID_PACIENTE],[ORDEN_SINIESTRO],[ID_EMPRESA],[CONTACTO_NOMBRE], ";
                sql = sql + " [CONTACTO_FONO],[CONTACTO_EMAIL],[ID_REGION_EMPRESA],[ID_COMUNA_EMPRESA],[ID_DIRECTOR],[ID_CASO],[ID_SEGMENTO],[N_SEGMENTO], ";
                sql = sql + " [ID_LATERAL],[ESTADO],[DIRECCION_EMPRESA],[OBSERVACION_CASO],[COD_SOL],[ID_PROFESIONAL],[NUM_SOLICITUD],[ID_USUARIO_SOLICITUD],[FONO_FIJO], ";
                sql = sql + " [FONO_MOVIL],[DIRECCION],[EMAIL],[ID_REGION],[ID_COMUNA],[ID_PROFESIONAL_EVA],[ID_PROYECTO],[TIPO_SERVICIO],[ESTADO_EP], [MACROAR1], ";
                sql = sql + " [MACROAR2],[CRITERIO_OBS1],[CRITERIO_OBS2],[ID_GRUPO_CIUO],[ID_SUBGRUPO_CIUO],[ID_CLASIFICACION_COMITE],[ESTADO_ECT])";
                sql = sql + " VALUES (" + dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() + ",";
                sql = sql + " getDate(),";
                sql = sql + " getDate(),";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_FORMA_INGRESO"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_USUARIO_INGRESO"].ToString()) + ",";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["HORA_SOLICITUD"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_REGION_EPT"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_COMUNA_EPT"].ToString()) + ",";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["OBSERVACIONES"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_PACIENTE"].ToString()) + ",";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["ORDEN_SINIESTRO"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_EMPRESA"].ToString()) + ",";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["CONTACTO_NOMBRE"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["CONTACTO_FONO"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["CONTACTO_EMAIL"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_REGION_EMPRESA"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_COMUNA_EMPRESA"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_DIRECTOR"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_CASO"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_SEGMENTO"].ToString()) + ",";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["N_SEGMENTO"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_LATERAL"].ToString()) + ",";
                sql = sql + " 1,";  //ESTADO
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["DIRECCION_EMPRESA"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["OBSERVACION_CASO"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["COD_SOL"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_PROFESIONAL"].ToString()) + ",'";
                sql = sql + preCorr_Tipo_Proyecto + "' + right('00000' + CONVERT(VARCHAR(100), " + Convert.ToString(Convert.ToInt32(dsCorre.Tables[0].Rows[0]["N_CORRELATIVO"].ToString()) + 1) + "),5),";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_USUARIO_SOLICITUD"].ToString()) + ",";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["FONO_FIJO"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["FONO_MOVIL"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["DIRECCION"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_REGION"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_COMUNA"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_PROFESIONAL_EVA"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_PROYECTO"].ToString()) + ",";
                if (tipoSol == "2")
                {
                    sql = sql + " 1,"; //TIPO SERVICIO
                    sql = sql + " 1,"; //DEBE QUEDAR EN GESTION
                }
                else {
                    sql = sql + " NULL,"; //TIPO SERVICIO
                    sql = sql + " Null,"; //DEBE QUEDAR EN GESTION
                }
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["MACROAR1"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["MACROAR2"].ToString()) + ", ";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["CRITERIO_OBS1"].ToString()) + "',";
                sql = sql + " '" + ValidaNull(dsQuery.Tables[0].Rows[cont]["CRITERIO_OBS2"].ToString()) + "',";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_GRUPO_CIUO"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_SUBGRUPO_CIUO"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ID_CLASIFICACION_COMITE"].ToString()) + ",";
                sql = sql + " " + ValidaNull(dsQuery.Tables[0].Rows[cont]["ESTADO_ECT"].ToString()) + ")";
                fn.dsSql(sql);

                string sqlSegmentos = "insert into SOLICITUD_SEGMENTOS(ID_SOLICITUD, ID_SEGMENTO, ID_LATERAL, ESTADO," +
                      " FECHA_CREACION, N_SEGMENTO) " +
                      " select ID_SOLICITUD = (select s2.ID_SOLICITUD from SOLICITUDES s2 " +
                      " where s2.NUM_SOLICITUD = '" + preCorr_Tipo_Proyecto + "' + right('00000' + CONVERT(VARCHAR(100), " + Convert.ToString(Convert.ToInt32(dsCorre.Tables[0].Rows[0]["N_CORRELATIVO"].ToString()) + 1) + "),5)" + "),s.ID_SEGMENTO,s.ID_LATERAL,s.ESTADO, " +
                      " FECHA_CREACION = GETDATE(),s.N_SEGMENTO " +
                      " from SOLICITUD_SEGMENTOS s  " +
                      " inner join SOLICITUDES ss on ss.ID_SOLICITUD = s.ID_SOLICITUD  " +
                      " where s.ID_SOLICITUD = " + id + " and s.ESTADO = 1 and ss.ID_TIPO_SOLICITUD = 1;";

                fn.dsSql(sqlSegmentos);
            }


            //fn.dsSql("update PROFESIONALES set estado=0, USR_ELIMINA='" + usr + "' where ID_PROFESIONAL='" + id + "'");

        }

        [WebMethod]
        public static void Reabrir(string id, string usr, string proy)
        {
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select * from SOLICITUDES s " +
                                        " where s.ID_SOLICITUD=" + id);

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                fn.dsSql("UPDATE SOLICITUDES SET ESTADO_EP = 1 WHERE NUM_SOLICITUD = '" + dsQuery.Tables[0].Rows[cont]["NUM_SOLICITUD"].ToString() + "'");
                fn.dsSql("UPDATE ACTIVIDADES SET ESTADO = 5 WHERE ID_SOLICITUD = " + id + " AND ID_TIPO_ACTIVIDAD=4 AND ESTADO=0");
            }

        }
    }
}