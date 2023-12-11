using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Net.Mail;
using System.Text.RegularExpressions;

namespace MSESP
{
    class funciones
    {
        //private string conexion = "Data Source=200.35.156.46;Initial Catalog=MSESP;User ID=uMsep;Password=mutu4ls3g*2017;";
        private string conexion = "Data Source=10.1.0.5;Initial Catalog=MSESP;User ID=uMsep;Password=mutu4ls3g*2017;";
        //private string conexion = "Data Source=192.168.10.11;Initial Catalog=MSESP;User ID=uMsep;Password=mutu4ls3g*2017;";
        //private string conexion = "Data Source=4.201.59.236;Initial Catalog=MSESP;User ID=uMsep;Password=mutu4ls3g*2017;";
        //private string conexion = "Data Source=200.35.156.46;Initial Catalog=MSESP_TEST;User ID=uMsep;Password=mutu4ls3g*2017;";
        //private string conexion = "Data Source=127.0.0.1;Initial Catalog=MSESP_TEST;User ID=uMsep;Password=mutu4ls3g*2017;";

        private SqlConnection cnn = new SqlConnection();
        public DataSet dsSql(string Consulta)
        {
            /*using (SqlConnection cnn = new SqlConnection(conexion))
            {
            cnn.Open();*/
            cnn.ConnectionString = conexion;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = new SqlCommand(Consulta, cnn);
            DataSet ds = new DataSet();
            da.Fill(ds);
            return ds;
            //}
        }

        public string convierte(string str)
        {
            Regex regex = new Regex(@"\s*\w*");
            string str2 = "";

            foreach (Match match in regex.Matches(str))
            {
                str2 = str2 + match.Value;
            }

            return str2;
        }

        public string enletras(string num)
        {

            string res, dec = "";

            Int64 entero;

            int decimales;

            double nro;

            try
            {

                nro = Convert.ToDouble(num);

            }

            catch
            {

                return "";

            }

            entero = Convert.ToInt64(Math.Truncate(nro));

            decimales = Convert.ToInt32(Math.Round((nro - entero) * 100, 2));

            if (decimales > 0)
            {

                dec = " CON " + decimales.ToString() + "/100";

            }

            res = toText(Convert.ToDouble(entero)) + dec;

            return res;

        }

        private string toText(double value)
        {

            string Num2Text = "";

            value = Math.Truncate(value);

            if (value == 0) Num2Text = "CERO";

            else if (value == 1) Num2Text = "UNO";

            else if (value == 2) Num2Text = "DOS";

            else if (value == 3) Num2Text = "TRES";

            else if (value == 4) Num2Text = "CUATRO";

            else if (value == 5) Num2Text = "CINCO";

            else if (value == 6) Num2Text = "SEIS";

            else if (value == 7) Num2Text = "SIETE";

            else if (value == 8) Num2Text = "OCHO";

            else if (value == 9) Num2Text = "NUEVE";

            else if (value == 10) Num2Text = "DIEZ";

            else if (value == 11) Num2Text = "ONCE";

            else if (value == 12) Num2Text = "DOCE";

            else if (value == 13) Num2Text = "TRECE";

            else if (value == 14) Num2Text = "CATORCE";

            else if (value == 15) Num2Text = "QUINCE";

            else if (value < 20) Num2Text = "DIECI" + toText(value - 10);

            else if (value == 20) Num2Text = "VEINTE";

            else if (value < 30) Num2Text = "VEINTI" + toText(value - 20);

            else if (value == 30) Num2Text = "TREINTA";

            else if (value == 40) Num2Text = "CUARENTA";

            else if (value == 50) Num2Text = "CINCUENTA";

            else if (value == 60) Num2Text = "SESENTA";

            else if (value == 70) Num2Text = "SETENTA";

            else if (value == 80) Num2Text = "OCHENTA";

            else if (value == 90) Num2Text = "NOVENTA";

            else if (value < 100) Num2Text = toText(Math.Truncate(value / 10) * 10) + " Y " + toText(value % 10);

            else if (value == 100) Num2Text = "CIEN";

            else if (value < 200) Num2Text = "CIENTO " + toText(value - 100);

            else if ((value == 200) || (value == 300) || (value == 400) || (value == 600) || (value == 800)) Num2Text = toText(Math.Truncate(value / 100)) + "CIENTOS";

            else if (value == 500) Num2Text = "QUINIENTOS";

            else if (value == 700) Num2Text = "SETECIENTOS";

            else if (value == 900) Num2Text = "NOVECIENTOS";

            else if (value < 1000) Num2Text = toText(Math.Truncate(value / 100) * 100) + " " + toText(value % 100);

            else if (value == 1000) Num2Text = "MIL";

            else if (value < 2000) Num2Text = "MIL " + toText(value % 1000);

            else if (value < 1000000)
            {

                Num2Text = toText(Math.Truncate(value / 1000)) + " MIL";

                if ((value % 1000) > 0) Num2Text = Num2Text + " " + toText(value % 1000);

            }

            else if (value == 1000000) Num2Text = "UN MILLON";

            else if (value < 2000000) Num2Text = "UN MILLON " + toText(value % 1000000);

            else if (value < 1000000000000)
            {

                Num2Text = toText(Math.Truncate(value / 1000000)) + " MILLONES ";

                if ((value - Math.Truncate(value / 1000000) * 1000000) > 0) Num2Text = Num2Text + " " + toText(value - Math.Truncate(value / 1000000) * 1000000);

            }

            else if (value == 1000000000000) Num2Text = "UN BILLON";

            else if (value < 2000000000000) Num2Text = "UN BILLON " + toText(value - Math.Truncate(value / 1000000000000) * 1000000000000);

            else
            {

                Num2Text = toText(Math.Truncate(value / 1000000000000)) + " BILLONES";

                if ((value - Math.Truncate(value / 1000000000000) * 1000000000000) > 0) Num2Text = Num2Text + " " + toText(value - Math.Truncate(value / 1000000000000) * 1000000000000);

            }

            return Num2Text;

        }


        public string FormatNumber(double numero, int decimales)
        {
            NumberFormatInfo oNum = new NumberFormatInfo();
            oNum.NumberDecimalSeparator = ",";
            oNum.NumberGroupSeparator = ".";
            oNum.NumberDecimalDigits = decimales;
            return String.Format(oNum, "{0:n}", numero);
        }
        public string FormatNumber(string texto, int decimales)
        {
            double numero = Convert.ToDouble(texto);
            return FormatNumber(numero, decimales);
        }
        public string FormatNumber(double numero)
        {
            return FormatNumber(numero, 0);
        }
        public string FormatNumber(string texto)
        {
            return FormatNumber(Convert.ToDouble(texto));
        }

        public void enviaCorreo(object empresa, object correo, object tabla, object orden, object asunto, object cabezera)
        {
            string From;
            string To;
            string Message;
            string Subject;

            System.Net.Mail.MailMessage Email;

            //Aplicando los campos a cada variable 
            From = "notificaciones@solicitudept.cl";
            To = "notificaciones@solicitudept.cl, " + correo;

            Message = "<table width=\"1100\" border=\"0\" align=\"justify\" style=\"font-family: Arial; font-size: 13px; \">" +
                      "<tr>" +
                      "  <td colspan=\"4\"><strong>" + empresa + "</strong></td>" +
                      "</tr>" +
                      "<tr>" +
                      "  <td colspan=\"4\"></td>" +
                      "</tr>";

             if (tabla.ToString() != "")
             {
                 Message = Message + "<tr>" +
                            "  <td colspan=\"4\">&nbsp;</td>" +
                            "</tr>" +
                            "<tr>" +
                            "  <td colspan=\"4\" align=\"justify\">" + cabezera + "</td>" +
                            "</tr>" +
                            "<tr>" +
                            "  <td colspan=\"4\">&nbsp;</td>" +
                            "</tr><tr>" + tabla.ToString() + "</tr>";
             }/*


            Message = Message + "<tr>" +
                       "  <td colspan=\"4\">&nbsp;</td>" +
                       "</tr>" +
                       "<tr>" +
                       "  <td colspan=\"4\">Saludos Cordiales</td>" +
                       "</tr>" +
                       "<tr>" +
                       "  <td colspan=\"4\">&nbsp;</td>" +
                       "</tr>" +
                       "<tr>" +
                       "  <td colspan=\"4\"><b>Mutual</b></td>" +
                       "</tr>" +*/
             Message = Message + "</table>";


            Subject = asunto.ToString();

            //Establesco El Email 

            Email = new System.Net.Mail.MailMessage(From, To, Subject, Message);
            Email.From = new MailAddress(From, "Solicitud EPT", System.Text.Encoding.UTF8);
            Email.SubjectEncoding = System.Text.Encoding.UTF8;
            System.Net.Mail.SmtpClient smtpMail = new System.Net.Mail.SmtpClient("smtp.gmail.com");
            //Email.IsBodyHtml = false;
            Email.IsBodyHtml = true;
            smtpMail.EnableSsl = true;
            smtpMail.UseDefaultCredentials = false;
            smtpMail.Host = "smtp.gmail.com";
            smtpMail.Port = 25;
            smtpMail.Host = "smtp.gmail.com";
            smtpMail.Credentials = new System.Net.NetworkCredential("notificaciones@solicitudept.cl", "mutual2017");

            smtpMail.Send(Email);
        }
    }
}
