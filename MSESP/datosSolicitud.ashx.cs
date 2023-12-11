using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de datosSolicitud
    /// </summary>
    public class datosSolicitud : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string xml = "", DOCS = "", DOCS2="", SEGDATOS = "", SEGN = "";
            funciones fn = new funciones();

            DataSet dsQuery = fn.dsSql("select fecha=CONVERT(VARCHAR(10),s.FECHA_SOLICITUD, 105),s.ID_SOLICITUD," +
                                       "S.HORA_SOLICITUD,S.ID_REGION_EPT,S.ID_COMUNA_EPT,S.ID_REGION_EMPRESA,S.ID_COMUNA_EMPRESA,S.DIRECCION_EMPRESA," +
                                       "S.OBSERVACIONES,S.ORDEN_SINIESTRO,S.CONTACTO_NOMBRE,S.CONTACTO_FONO,S.CONTACTO_EMAIL,TIPO=TP.NOMBRE,S.ID_TIPO_SOLICITUD,FORMA=f.NOMBRE,S.ID_SEGMENTO,S.N_SEGMENTO,S.ID_LATERAL,S.ID_CASO," +
                                       "S.OBSERVACION_CASO,e.RUT,e.NOMBRE,trab_rut=p.RUT,trab_nom=p.NOMBRE,p.ID_GENERO,S.MACROAR1,S.MACROAR2,S.MACROAR3,S.CRITERIO_OBS1,S.CRITERIO_OBS2,S.CRITERIO_OBS3," +
                                       "S.ID_CLASIFICACION_COMITE,S.ID_GRUPO_CIUO,S.ID_SUBGRUPO_CIUO,p.FONO_FIJO,p.FONO_MOVIL,p.EMAIL,p.DIRECCION,preg=isnull(p.ID_REGION,0),pcom=isnull(p.ID_COMUNA,0),SOLICITANTE=dbo.MayMinTexto(u.NOMBRE),IDPROF=isnull(s.ID_PROFESIONAL,0),IDPROFEVA=isnull(s.ID_PROFESIONAL_EVA,0),TIPOSERVICIO=isnull(s.TIPO_SERVICIO,1) from SOLICITUDES s " +
                                       " inner join empresas e on e.ID_EMPRESA=s.ID_EMPRESA " +
                                       " inner join pacientes p on p.ID_PACIENTE=s.ID_PACIENTE " +
                                       " inner join usuarios u on u.ID_USUARIO=s.ID_USUARIO_INGRESO " +
                                       " INNER JOIN TIPO_SOLICITUD TP ON TP.ID_TIPO_SOLICITUD=S.ID_TIPO_SOLICITUD " +
                                       " inner join FORMAS_INGRESO f on f.ID_FORMA_INGRESO=s.ID_FORMA_INGRESO " +
                                       " where s.ID_SOLICITUD=" + context.Request["id"].ToString());

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                  "<solicitud>";

            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                DOCS="";
                xml = xml + "<row>" +
                                "<FECHA>" + dsQuery.Tables[0].Rows[cont]["FECHA"].ToString() + "</FECHA>" +
                                "<HORA>" + dsQuery.Tables[0].Rows[cont]["HORA_SOLICITUD"].ToString() + "</HORA>" +
                                "<ID_REGION_EPT>" + dsQuery.Tables[0].Rows[cont]["ID_REGION_EPT"].ToString() + "</ID_REGION_EPT>" +
                                "<ID_COMUNA_EPT>" + dsQuery.Tables[0].Rows[cont]["ID_COMUNA_EPT"].ToString() + "</ID_COMUNA_EPT>" +
                                "<ID_REGION_EMPRESA>" + dsQuery.Tables[0].Rows[cont]["ID_REGION_EMPRESA"].ToString() + "</ID_REGION_EMPRESA>" +
                                "<ID_COMUNA_EMPRESA>" + dsQuery.Tables[0].Rows[cont]["ID_COMUNA_EMPRESA"].ToString() + "</ID_COMUNA_EMPRESA>" +
                                "<DIRECCION_EMPRESA>" + dsQuery.Tables[0].Rows[cont]["DIRECCION_EMPRESA"].ToString() + "</DIRECCION_EMPRESA>" +
                                "<OBSERVACIONES>" + dsQuery.Tables[0].Rows[cont]["OBSERVACIONES"].ToString() + "</OBSERVACIONES>" +
                                "<ORDEN_SINIESTRO>" + dsQuery.Tables[0].Rows[cont]["ORDEN_SINIESTRO"].ToString() + "</ORDEN_SINIESTRO>" +
                                "<CONTACTO_NOMBRE>" + dsQuery.Tables[0].Rows[cont]["CONTACTO_NOMBRE"].ToString() + "</CONTACTO_NOMBRE>" +
                                "<CONTACTO_FONO>" + dsQuery.Tables[0].Rows[cont]["CONTACTO_FONO"].ToString() + "</CONTACTO_FONO>" +
                                "<CONTACTO_EMAIL>" + dsQuery.Tables[0].Rows[cont]["CONTACTO_EMAIL"].ToString() + "</CONTACTO_EMAIL>" +
                                "<OBSERVACION_CASO>" + dsQuery.Tables[0].Rows[cont]["OBSERVACION_CASO"].ToString() + "</OBSERVACION_CASO>" +
                                "<RUT>" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "</RUT>" +
                                "<NOMBRE>" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "</NOMBRE>" +
                                "<trab_rut>" + dsQuery.Tables[0].Rows[cont]["trab_rut"].ToString() + "</trab_rut>" +
                                "<trab_nom>" + dsQuery.Tables[0].Rows[cont]["trab_nom"].ToString() + "</trab_nom>" +
                                "<ID_GENERO>" + dsQuery.Tables[0].Rows[cont]["ID_GENERO"].ToString() + "</ID_GENERO>" +
                                "<FONO_FIJO>" + dsQuery.Tables[0].Rows[cont]["FONO_FIJO"].ToString() + "</FONO_FIJO>" +
                                "<FONO_MOVIL>" + dsQuery.Tables[0].Rows[cont]["FONO_MOVIL"].ToString() + "</FONO_MOVIL>" +
                                "<EMAIL>" + dsQuery.Tables[0].Rows[cont]["EMAIL"].ToString() + "</EMAIL>" +
                                "<DIRECCION>" + dsQuery.Tables[0].Rows[cont]["DIRECCION"].ToString() + "</DIRECCION>" +
                                "<SOLICITANTE>" + dsQuery.Tables[0].Rows[cont]["SOLICITANTE"].ToString() + "</SOLICITANTE>" +
                                "<FORMA>" + dsQuery.Tables[0].Rows[cont]["FORMA"].ToString() + "</FORMA>" +
                                "<ID_SEGMENTO>" + dsQuery.Tables[0].Rows[cont]["ID_SEGMENTO"].ToString() + "</ID_SEGMENTO>" +
                                "<N_SEGMENTO>" + dsQuery.Tables[0].Rows[cont]["N_SEGMENTO"].ToString() + "</N_SEGMENTO>" +
                                "<ID_LATERAL>" + dsQuery.Tables[0].Rows[cont]["ID_LATERAL"].ToString() + "</ID_LATERAL>" +
                                "<ID_CASO>" + dsQuery.Tables[0].Rows[cont]["ID_CASO"].ToString() + "</ID_CASO>" +
                                "<ID_TIPO_SOLICITUD>" + dsQuery.Tables[0].Rows[cont]["ID_TIPO_SOLICITUD"].ToString() + "</ID_TIPO_SOLICITUD>" +
                                "<preg>" + dsQuery.Tables[0].Rows[cont]["preg"].ToString() + "</preg>" +
                                "<pcom>" + dsQuery.Tables[0].Rows[cont]["pcom"].ToString() + "</pcom>" +
                                "<IDPROF>" + dsQuery.Tables[0].Rows[cont]["IDPROF"].ToString() + "</IDPROF>" +
                                "<IDPROFEVA>" + dsQuery.Tables[0].Rows[cont]["IDPROFEVA"].ToString() + "</IDPROFEVA>" +
                                "<ID_SOLICITUD>" + dsQuery.Tables[0].Rows[cont]["ID_SOLICITUD"].ToString() + "</ID_SOLICITUD>" +
                                "<TIPOSERVICIO>" + dsQuery.Tables[0].Rows[cont]["TIPOSERVICIO"].ToString() + "</TIPOSERVICIO>" +
                                "<MACROAR1>" + dsQuery.Tables[0].Rows[cont]["MACROAR1"].ToString() + "</MACROAR1>" +
                                "<MACROAR2>" + dsQuery.Tables[0].Rows[cont]["MACROAR2"].ToString() + "</MACROAR2>" +
                                "<MACROAR3>" + dsQuery.Tables[0].Rows[cont]["MACROAR3"].ToString() + "</MACROAR3>" +
                                "<CRITERIO_OBS1>" + dsQuery.Tables[0].Rows[cont]["CRITERIO_OBS1"].ToString() + "</CRITERIO_OBS1>" +
                                "<CRITERIO_OBS2>" + dsQuery.Tables[0].Rows[cont]["CRITERIO_OBS2"].ToString() + "</CRITERIO_OBS2>" +
                                "<CRITERIO_OBS3>" + dsQuery.Tables[0].Rows[cont]["CRITERIO_OBS3"].ToString() + "</CRITERIO_OBS3>" +
                                "<ID_GRUPO_CIUO>" + dsQuery.Tables[0].Rows[cont]["ID_GRUPO_CIUO"].ToString() + "</ID_GRUPO_CIUO>" +
                                "<ID_SUBGRUPO_CIUO>" + dsQuery.Tables[0].Rows[cont]["ID_SUBGRUPO_CIUO"].ToString() + "</ID_SUBGRUPO_CIUO>" +
                                "<ID_CLASIFICACION_COMITE>" + dsQuery.Tables[0].Rows[cont]["ID_CLASIFICACION_COMITE"].ToString() + "</ID_CLASIFICACION_COMITE>" +
                                "<TIPO>" + dsQuery.Tables[0].Rows[cont]["TIPO"].ToString() + "</TIPO>";

                DataSet dsSeg = fn.dsSql("SELECT SS.N_SEGMENTO,S.SEGMENTO,L.LATERIDAD,SS.ID_SEGMENTO,SS.ID_LATERAL,POS=ISNULL(ss.POSTERIOR,0) FROM SOLICITUD_SEGMENTOS SS " +
                                             " INNER JOIN SEGMENTOS S ON S.ID_SEGMENTO=SS.ID_SEGMENTO " +
                                             " INNER JOIN LATERIDAD L ON L.ID_LATERIDAD=SS.ID_LATERAL " +
                                             " WHERE SS.ID_SOLICITUD='" + context.Request["id"].ToString() + "'" +
                                             " ORDER BY SS.N_SEGMENTO");

                    if (dsSeg.Tables[0].Rows.Count > 0)
                    {
                        for (int segCont = 0; segCont < dsSeg.Tables[0].Rows.Count; segCont++)
                        {
                            SEGDATOS = SEGDATOS + dsSeg.Tables[0].Rows[segCont]["N_SEGMENTO"].ToString() + "##" +
                                                  dsSeg.Tables[0].Rows[segCont]["SEGMENTO"].ToString() + "##" +
                                                  dsSeg.Tables[0].Rows[segCont]["LATERIDAD"].ToString() + "###";

                            SEGN = SEGN + dsSeg.Tables[0].Rows[segCont]["N_SEGMENTO"].ToString() + "##" +
                                                  dsSeg.Tables[0].Rows[segCont]["ID_SEGMENTO"].ToString() + "##" +
                                                  dsSeg.Tables[0].Rows[segCont]["ID_LATERAL"].ToString() + "##" +
                                                  dsSeg.Tables[0].Rows[segCont]["POS"].ToString() + "###";
                        }
                    }
                    else
                    {
                        DataSet dsSeg2 = fn.dsSql("SELECT SS.N_SEGMENTO,S.SEGMENTO,L.LATERIDAD,SS.ID_SEGMENTO,SS.ID_LATERAL FROM SOLICITUDES SS " +
                                                  "  INNER JOIN SEGMENTOS S ON S.ID_SEGMENTO=SS.ID_SEGMENTO " +
                                                  "  INNER JOIN LATERIDAD L ON L.ID_LATERIDAD=SS.ID_LATERAL " +
                                                  "  WHERE SS.ID_SOLICITUD='" + context.Request["id"].ToString() + "'");

                        if (dsSeg2.Tables[0].Rows.Count > 0)
                        {
                            SEGDATOS = SEGDATOS + dsSeg2.Tables[0].Rows[0]["N_SEGMENTO"].ToString() + "##" +
                                                    dsSeg2.Tables[0].Rows[0]["SEGMENTO"].ToString() + "##" +
                                                    dsSeg2.Tables[0].Rows[0]["LATERIDAD"].ToString() + "###";

                            SEGN = SEGN + dsSeg2.Tables[0].Rows[0]["N_SEGMENTO"].ToString() + "##" +
                                                  dsSeg2.Tables[0].Rows[0]["ID_SEGMENTO"].ToString() + "##" +
                                                  dsSeg2.Tables[0].Rows[0]["ID_LATERAL"].ToString() + "###";
                        }

                    }
                
                    xml = xml + "<SEGDATOS>" + SEGDATOS.ToString() + "</SEGDATOS>" +
                                "<SEGN>" + SEGN.ToString() + "</SEGN>";

                    DataSet dsDocs = fn.dsSql("select /*top 1*/ SD.ARCHIVO from SOLICITUDES_DETALLE SD where SD.ID_SOLICITUD='" + context.Request["id"].ToString() + "'");
                    //if(dsDocs.Tables[0].Rows.Count > 0)
                    for (int Doccont = 0; Doccont < dsDocs.Tables[0].Rows.Count; Doccont++)
                    {
                            //DOCS = DOCS + "<a href='#' onclick='verDoc('" + dsDocs.Tables[0].Rows[contdOC]["ARCHIVO"].ToString() + "')';>Link</a>";
                          //DOCS = DOCS + "<a href=# onclick=verDoc('" + dsDocs.Tables[0].Rows[Doccont]["ARCHIVO"].ToString() + "');>Link</a>";
                        DOCS = DOCS + "*" + dsDocs.Tables[0].Rows[Doccont]["ARCHIVO"].ToString() + "/";
                        DOCS2 = DOCS2 + dsDocs.Tables[0].Rows[Doccont]["ARCHIVO"].ToString() + "/";
                    }/**/
                    xml = xml + "<DOC>" + DOCS.ToString().Replace("'","\"") + "</DOC>" +
                                "<DOC2>" + DOCS2 + "</DOC2>" +
                                "</row>";
            }
            xml = xml + "</solicitud>";

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