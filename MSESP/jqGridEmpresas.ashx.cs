using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Providers.Entities;
using System.Web.Script.Serialization;

namespace MSESP
{
    /// <summary>
    /// Descripción breve de jqGridEmpresas
    /// </summary>
    public class jqGridEmpresas : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            string xml = "";
            funciones fn = new funciones();

            string _search = context.Request["_search"];
            string numberOfRows = context.Request["rows"];
            string pageIndex = context.Request["page"];
            string sortColumnName = context.Request["sidx"];
            string sortOrderBy = context.Request["sord"];
            string nodeid = context.Request["nd"];

            DataSet dsQuery = fn.dsSql("select e.ID_EMPRESA,e.RUT,e.NOMBRE,e.N_ADHERENTE from empresas e where e.estado=1 and e.mandante=0" + " ORDER BY " + sortColumnName + " " + sortOrderBy);

            int total_pages = 0;
            if (dsQuery.Tables[0].Rows.Count > 0)
            {
                if ((dsQuery.Tables[0].Rows.Count % Convert.ToInt32(numberOfRows)) > 0)
                {

                    //total_pages = dsQuery.Tables[0].Rows.Count / Convert.ToInt32(numberOfRows) + 1;
                    total_pages = (int)Math.Ceiling(Convert.ToDouble(dsQuery.Tables[0].Rows.Count / Convert.ToInt32(numberOfRows) + 1)); // 1
                }
                else
                {
                    total_pages = Convert.ToInt32(dsQuery.Tables[0].Rows.Count) / Convert.ToInt32(numberOfRows);
                }
            }
            else
            {
                total_pages = 1;
            }

            if (Convert.ToInt32(pageIndex) > Convert.ToInt32(total_pages)) { pageIndex = total_pages.ToString(); }
            int inicio = (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)) - Convert.ToInt32(numberOfRows);
            int fila = 0;

            xml = "<?xml version='1.0' encoding='utf-8' ?>" +
                    "<rows>" +
                    "<page>" + pageIndex.ToString() + "</page>" +
                    "<total>" + total_pages.ToString() + "</total>" +
                    "<records>" + dsQuery.Tables[0].Rows.Count.ToString() + "</records>";
            for (int cont = 0; cont < dsQuery.Tables[0].Rows.Count; cont++)
            {
                if (fila >= inicio && fila < (Convert.ToInt32(numberOfRows) * Convert.ToInt32(pageIndex)))
                {
                xml = xml + "<row id='" + cont.ToString() + "'>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["RUT"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["NOMBRE"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[" + dsQuery.Tables[0].Rows[cont]["N_ADHERENTE"].ToString() + "]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Actualizar Registro' class='ui-icon ui-icon-pencil' onclick='actualizar(" + dsQuery.Tables[0].Rows[cont]["ID_EMPRESA"].ToString() + ")'></a></span>]]></cell>" +
                            "<cell><![CDATA[<span><a href='#' title='Eliminar Registro' class='ui-icon ui-icon-trash' onclick='eliminar(" + dsQuery.Tables[0].Rows[cont]["ID_EMPRESA"].ToString() + ")'></a></span>]]></cell>" +
                            "</row>";
                  }
                fila = fila + 1;
            }
            xml = xml + "</rows>";

            context.Response.Write(xml);
            /*HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            string _search = request["_search"];
            string numberOfRows = request["rows"];
            string pageIndex = request["page"];
            string sortColumnName = request["sidx"];
            string sortOrderBy = request["sord"];

            int totalRecords;*/
            //Collection<User> users = GetUsers(numberOfRows, pageIndex, sortColumnName, sortOrderBy, out totalRecords);
            //string output = BuildJQGridResults(users, Convert.ToInt32(numberOfRows), Convert.ToInt32(pageIndex), Convert.ToInt32(totalRecords));
            //response.Write(output);
        }

   // private string BuildJQGridResults(Collection<User> users,int numberOfRows, int pageIndex,int totalRecords)
    //{
       // JQGridResults result = new JQGridResults();
        //List<JQGridRow> rows = new List<JQGridRow>();
       // foreach (User user in users)
       // {
          //  JQGridRow row = new JQGridRow();
            //row.id = user.UserID;
            //row.cell = new string[6];
            /*row.cell[0] = user.UserID.ToString();
            row.cell[1] = user.UserName;
            row.cell[2] = user.FirstName;
            row.cell[3] = user.MiddleName;
            row.cell[4] = user.LastName;
            row.cell[5] = user.EmailID;*/
            //rows.Add(row);
        //}
        /*result.rows = rows.ToArray();
        result.page = pageIndex;
        result.total = totalRecords / numberOfRows;
        result.records = totalRecords;
        return new JavaScriptSerializer().Serialize(result);*/
    //}

    private  Collection<User>  GetUsers(string numberOfRows,string pageIndex,string sortColumnName, string sortOrderBy,out int totalRecords)
    {
        Collection<User> users = new Collection<User>();
        string connectionString =
        "Data Source=YourServerName; Initial Catalog=YourDatabase; User ID=YourUserName; Password=YourPassword";
        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand())
            {
                /*command.Connection = connection;
                command.CommandText = "SelectjqGridUsers";
                command.CommandType = CommandType.StoredProcedure;

                SqlParameter paramPageIndex = new SqlParameter("@PageIndex", SqlDbType.Int);
                paramPageIndex.Value =Convert.ToInt32(pageIndex);
                command.Parameters.Add(paramPageIndex);

                SqlParameter paramColumnName = new SqlParameter("@SortColumnName", SqlDbType.VarChar, 50);
                paramColumnName.Value = sortColumnName;
                command.Parameters.Add(paramColumnName);

                SqlParameter paramSortorderBy = new SqlParameter("@SortOrderBy", SqlDbType.VarChar, 4);
                paramSortorderBy.Value = sortOrderBy;
                command.Parameters.Add(paramSortorderBy);

                SqlParameter paramNumberOfRows = new SqlParameter("@NumberOfRows", SqlDbType.Int);
                paramNumberOfRows.Value =Convert.ToInt32(numberOfRows);
                command.Parameters.Add(paramNumberOfRows);

                SqlParameter paramTotalRecords= new SqlParameter("@TotalRecords", SqlDbType.Int);
                totalRecords = 0;
                paramTotalRecords.Value = totalRecords;
                paramTotalRecords.Direction = ParameterDirection.Output;
                command.Parameters.Add(paramTotalRecords);     */                                                           
                
                
                connection.Open();
                using (SqlDataReader dataReader = command.ExecuteReader())
                {
                    User user;
                    while (dataReader.Read())
                    {
                        user = new User();
                        /*user.UserID = (int) dataReader["UserID"];
                        user.UserName = Convert.ToString(dataReader["UserName"]);
                        user.FirstName = Convert.ToString(dataReader["FirstName"]);
                        user.MiddleName = Convert.ToString(dataReader["MiddleName"]);
                        user.LastName = Convert.ToString(dataReader["LastName"]);
                        user.EmailID = Convert.ToString(dataReader["EmailID"]);*/
                        users.Add(user);
                    }
                }
                totalRecords = 1;// (int)paramTotalRecords.Value;
            }
            
            return users;
        }

    }
    public bool IsReusable
    {
        // To enable pooling, return true here.
        // This keeps the handler in memory.
        get { return false; }
    }
}
}