using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Configuration;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.IO;
using System.Net.Mail;

namespace EBMSMap30
{
    public class Gmail
    {
        public static void SentMail_GMail(string To, string Subject, string MailText)
        {
            //Create Mail Message Object with content that you want to send with mail.
            if (ConfigurationManager.AppSettings["MailServer"] == null)
            {
                try
                {
                    System.Net.Mail.MailMessage MyMailMessage = new System.Net.Mail.MailMessage(ConfigurationManager.AppSettings["MailUser"], To, Subject, MailText);

                    MyMailMessage.IsBodyHtml = true;

                    //Proper Authentication Details need to be passed when sending email from gmail
                    System.Net.NetworkCredential mailAuthentication = new System.Net.NetworkCredential(ConfigurationManager.AppSettings["MailUser"], ConfigurationManager.AppSettings["MailPwd"]);

                    //Smtp Mail server of Gmail is "smpt.gmail.com" and it uses port no. 587
                    //For different server like yahoo this details changes and you can
                    //get it from respective server.
                    System.Net.Mail.SmtpClient mailClient = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                    ServicePointManager.ServerCertificateValidationCallback = delegate(object s, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };

                    //Enable SSL
                    mailClient.EnableSsl = true;
                    mailClient.UseDefaultCredentials = false;
                    mailClient.Credentials = mailAuthentication;
                    mailClient.Send(MyMailMessage);
                }
                catch (Exception ex)
                {
                    cUtils.Log("mail", "MailTo :" + To + " - > " + Subject + " ERR " + ex.ToString());
                }
            }
            else
            {
                try
                {
                    string User = ConfigurationManager.AppSettings["MailUser"];
                    string Pwd = ConfigurationManager.AppSettings["MailPwd"];
                    SmtpClient smtpClient = new SmtpClient(ConfigurationManager.AppSettings["MailServer"], 25);

                    smtpClient.Credentials = new System.Net.NetworkCredential(User, Pwd);
                    //smtpClient.UseDefaultCredentials = true;
                    smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                    //smtpClient.EnableSsl = true;
                    MailMessage mail = new MailMessage();

                    //Setting From , To and CC
                    mail.From = new MailAddress(ConfigurationManager.AppSettings["Email"]);
                    mail.To.Add(new MailAddress(To));
                    mail.Subject = Subject;
                    mail.Body = MailText;
                    mail.IsBodyHtml = true;
                    smtpClient.Send(mail);

                    cUtils.Log("mail", "MailTo :" + To + " - > " + Subject + " OK");
                }
                catch (Exception ex)
                {
                    cUtils.Log("mail", "MailTo :" + To + " - > " + Subject + " ERR " + ex.ToString());
                }
            }
        }
    }
}