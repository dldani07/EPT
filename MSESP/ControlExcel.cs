using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MSESP
{
    public class ControlExcel : ApiController
    {
        [HttpPost]

        public void download()
        {
           /* var data = new[]{ 
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
            Response.Write("downloaded");*/
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

        // GET api/<controller>
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/<controller>/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<controller>
        public void Post([FromBody]string value)
        {
        }

        // PUT api/<controller>/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/<controller>/5
        public void Delete(int id)
        {
        }
    }
}