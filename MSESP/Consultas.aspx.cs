using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;
using System.Globalization;
using Spire.Xls;
using System.Net;
using System.Text;

namespace MSESP
{
    public partial class Consultas : System.Web.UI.Page
    {
        Sheet Worksheet = null;
        WorksheetPart WorksheetPart = null;
        SheetData SheetData = null;
        SpreadsheetDocument MiDocumento = null;
        WorkbookPart WorkbookPart = null;
        string nuevoArchivo;

        protected void Page_Load(object sender, EventArgs e)
        {
            //bustipo.Items.Clear();
            //cargaEtp();
            //ExportListFromTsv();

            //if (Request.Params["__EVENTTARGET"] == "CambioCliente")
                //ExportListFromTsv();
        }

        public void cargaEtp()
        {
            /*ListItem oItem;
            /oItem = new ListItem("Seleccione", "");
            bustipo.Items.Add(oItem);
            oItem = new ListItem("EPT ME", "1");
            bustipo.Items.Add(oItem);
            oItem = new ListItem("EPT SM", "2");
            bustipo.Items.Add(oItem);
            this.solTipo.ClearSelection();*/
        }

        [WebMethod]
        public static void SeleccionItems()
        {
            //MSESP.Usuarios.limpia();
            MSESP.Consultas fn = new MSESP.Consultas();

            //fn.UsuarioTipo.SelectedValue = "22";

            fn.download();
            //fn.txtAgencia.SelectedValue = a;
        }

        //[HttpPost]

        public void download()
        {
            var data = new[]{ 
                           new{ Name="Ram", Email="ram@techbrij.com", Phone="111-222-3333" },
                           new{ Name="Shyam", Email="shyam@techbrij.com", Phone="159-222-1596" },
                           new{ Name="Mohan", Email="mohan@techbrij.com", Phone="456-222-4569" },
                           new{ Name="Sohan", Email="sohan@techbrij.com", Phone="789-456-3333" },
                           new{ Name="Karan", Email="karan@techbrij.com", Phone="111-222-1234" },
                           new{ Name="Brij", Email="brij@techbrij.com", Phone="111-222-3333" }                       
                  };

            HttpResponse Response = HttpContext.Current.Response;

            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment;filename=Contact.xls");
            Response.AddHeader("Content-Type", "application/vnd.ms-excel");
            WriteTsv(data, Response.Output);
            Response.End();
            Response.Write("downloaded");
        }

        protected void ExportToExcel()
        {
            /*
            //Crea copia de la plantilla, para ser modificada.
            string rutaPlantilla = Server.MapPath(@"~\Documentos\InformeMensualAP_" + DateTime.Now.ToString("ddMMyyyyHHmmss") + ".xlsx");
            //string nuevaPlantilla = Server.MapPath(@"~\Planillas\Nuevas\InformeMensualAP_" + lstbxComunas.SelectedItem.Text.Replace(" ", "").ToString() + DateTime.Now.ToString("ddMMyyyyHHmmss") + ".xlsx");
            //nuevoArchivo = nuevaPlantilla;
            //File.Copy(rutaPlantilla, nuevaPlantilla, true);
            MiDocumento = SpreadsheetDocument.Open(nuevaPlantilla, true);
            WorkbookPart = MiDocumento.WorkbookPart;
            string Hoja = "Inf. Mensual AP";

            Worksheet = WorkbookPart.Workbook.Descendants<Sheet>().Where(c => c.Name == Hoja).FirstOrDefault();
            if (Worksheet == null)
            {
                Response.Write("<script>alert('Error al crear la planilla, falta la hoja de Informe: ' +Hoja);</script>");
            }
            WorksheetPart = (WorksheetPart)WorkbookPart.GetPartById(Worksheet.Id);
            SheetData = WorksheetPart.Worksheet.Elements<SheetData>().First();
            MiDocumento.WorkbookPart.Workbook.CalculationProperties.ForceFullCalculation = true;
            MiDocumento.WorkbookPart.Workbook.CalculationProperties.FullCalculationOnLoad = true;

            OXHelper.Reset();
            OXHelper.WorkbookPart = WorkbookPart;
            OXHelper.SheetData = SheetData;*/

             /*  funciones fn = new funciones();
               HttpResponse response = HttpContext.Current.Response;
   
               // first let's clean up the response.object
               response.Clear();
               response.Charset = "";
   
               // set the response mime type for excel
               response.ContentType = "application/vnd.ms-excel";
               response.AddHeader("Content-Disposition", "attachment;filename=\"" + "excel" + "\"");
   
               // create a string writer
               using (StringWriter sw = new StringWriter())
               {
                   using (HtmlTextWriter htw = new HtmlTextWriter(sw))
                   {
                       // instantiate a datagrid
                       DataGrid dg = new DataGrid();
                       DataSet dsTrab = fn.dsSql("select ID_USUARIO='', NOMBRE='Seleccione' union all  SELECT ID_USUARIO, NOMBRE FROM USUARIOS WHERE ID_TIPO_USUARIO=3 and ESTADO=1");
                       dg.DataSource = dsTrab.Tables[0];
                       dg.DataBind();
                       dg.RenderControl(htw);
                       response.Write(sw.ToString());
                       response.End();
                   }
               }*/
            var data = new[]{ 
                               new{ Name="Ram", Email="ram@techbrij.com", Phone="111-222-3333" },
                               new{ Name="Shyam", Email="shyam@techbrij.com", Phone="159-222-1596" },
                               new{ Name="Mohan", Email="mohan@techbrij.com", Phone="456-222-4569" },
                               new{ Name="Sohan", Email="sohan@techbrij.com", Phone="789-456-3333" },
                               new{ Name="Karan", Email="karan@techbrij.com", Phone="111-222-1234" },
                               new{ Name="Brij", Email="brij@techbrij.com", Phone="111-222-3333" }                       
                      };

            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment;filename=Contact.xls");
            Response.AddHeader("Content-Type", "application/vnd.ms-excel");
            WriteTsv(data, Response.Output);
            Response.End();
        }

        public void WriteTsv<T>(IEnumerable<T> data, TextWriter output)
        {
            PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));
            foreach (PropertyDescriptor prop in props)
            {
                output.Write(prop.DisplayName); // header
                output.Write("\t");
            }
            output.WriteLine();
            foreach (T item in data)
            {
                foreach (PropertyDescriptor prop in props)
                {
                    output.Write(prop.Converter.ConvertToString(
                         prop.GetValue(item)));
                    output.Write("\t");
                }
                output.WriteLine();
            }
        }
    }
}