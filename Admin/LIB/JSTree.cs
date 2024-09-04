using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using EBMSMap30;

namespace EBMSMap.Web
{
    public class JSTree
    {
        public String id { get; set; }
        public String parent { get; set; }
        public String text { get; set; }
        public String icon { get; set; }
        public State state { get; set; }
        public String source { get; set; }
    }

    public class State
    {
        public bool opened { get; set; }
        public bool disabled { get; set; }
        public bool selected { get; set; }
    }


    public class JSData
    {
        public static string Join(DataTable tb, string Col)
        {
            string ret = "";
            for (int i = 0; i < tb.Rows.Count; i++)
            {
                if (i > 0)
                    ret += ",";

                ret += tb.Rows[i][Col].ToString();
            }

            return ret;
        }

        public static bool Check(string data, string val)
        {
            string[] datas = data.Split(',');

            for (int i = 0; i < datas.Length; i++)
            {
                if (datas[i] == val)
                    return true;
            }

            return false;
        }
        public static string GetUsers(string sUID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["uID"].ToString(),
                    text = tb.Rows[i]["Login"] + "(" + tb.Rows[i]["FName"] + " " + tb.Rows[i]["LName"] + ")",
                    parent = "#"
                };
                if (sUID == tb.Rows[i]["uID"].ToString())
                {
                    ret.state = new State()
                    {
                        selected = true
                    };
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        public static string GetUGrps(string sUGID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_GetUGrp]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["UGID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = "#"
                };
                if (sUGID == tb.Rows[i]["UGID"].ToString())
                {
                    ret.state = new State()
                    {
                        selected = true
                    };
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        public static string GetOrgs(string sOrgID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spOrg_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["OrgID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = tb.Rows[i]["pOrgID"].ToString()
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened=true;
                if (sOrgID == tb.Rows[i]["OrgID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        public static string GetUnderOrgs(string sOrgID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spOrg_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();
            var ret0 = new JSTree()
            {
                id = "0",
                text = "Root Org",
                parent = "#"
            };
            ret0.state = new State();
            ret0.state.opened = true;
            if (sOrgID == "0")
            {
                ret0.state.selected = true;
            }
            rets.Add(ret0);

            for (int i = 0; i < tb.Rows.Count; i++)
            {
               // if (sOrgID == tb.Rows[i]["OrgID"].ToString())
                 //   continue;
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["OrgID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = tb.Rows[i]["pOrgID"].ToString()
                };
                ret.state = new State();
                ret.state.opened = true;
                if (sOrgID == tb.Rows[i]["OrgID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        public static string GetDownloads(string sDlID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spDLd_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["DlID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = "#"
                };
                if (sDlID == tb.Rows[i]["DlID"].ToString())
                {
                    ret.state = new State()
                    {
                        selected = true
                    };
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }


        ////


        public static string GetLayers(string sLyID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spLyr_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["LyID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = tb.Rows[i]["pLyID"].ToString()
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                if (sLyID == tb.Rows[i]["LyID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }


        public static string GetUnderLayers(string sLyID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spLyr_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();
            var ret0 = new JSTree()
            {
                id = "0",
                text = "Root Layer",
                parent = "#"
            };
            ret0.state = new State();
            ret0.state.opened = true;
            if (sLyID == "0")
            {
                ret0.state.selected = true;
            }
            rets.Add(ret0);

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                // if (sOrgID == tb.Rows[i]["OrgID"].ToString())
                //   continue;
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["LyID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = tb.Rows[i]["pLyID"].ToString()
                };
                ret.state = new State();
                ret.state.opened = true;
                if (sLyID == tb.Rows[i]["LyID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        ///

        public static string GetGISLayers(string sLyID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spLyrGIS_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["LyID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = tb.Rows[i]["pLyID"].ToString()
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                if (sLyID == tb.Rows[i]["LyID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }


        public static string GetUnderGISLayers(string sLyID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spLyrGIS_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();
            var ret0 = new JSTree()
            {
                id = "0",
                text = "Root Layer",
                parent = "#"
            };
            ret0.state = new State();
            ret0.state.opened = true;
            if (sLyID == "0")
            {
                ret0.state.selected = true;
            }
            rets.Add(ret0);

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                // if (sOrgID == tb.Rows[i]["OrgID"].ToString())
                //   continue;
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["LyID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = tb.Rows[i]["pLyID"].ToString()
                };
                ret.state = new State();
                ret.state.opened = true;
                if (sLyID == tb.Rows[i]["LyID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        ////

        public static string GetCGrps(string sCGID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spCon_GetGrp]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["CGID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = "0"
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                if (sCGID == tb.Rows[i]["CGID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }


        ////

        public static string GetCTypes(string sTypeID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spCon_GetType]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tbT = DS.Tables[0];
            DataTable tbG = DS.Tables[1];

            var rets = new List<JSTree>();

            for (int i = 0; i < tbG.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = "G"+tbG.Rows[i]["CGID"].ToString(),
                    text = tbG.Rows[i]["Name"].ToString(),
                    parent = "0"
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                rets.Add(ret);
            }
            for (int i = 0; i < tbT.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tbT.Rows[i]["TypeID"].ToString(),
                    text = tbT.Rows[i]["Name"].ToString(),
                    parent = "G"+tbT.Rows[i]["pCGID"].ToString(),
                    icon ="../img/ic_file.png"
                };

                ret.state = new State();
                ret.state.opened = true;
                if (sTypeID == tbT.Rows[i]["TypeID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }


        ////

        public static string GetTemplates(string sTplID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spCon_GetTPL]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["TplID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = "0"
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                if (sTplID == tb.Rows[i]["TplID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        //

        public static string GetEquips(string sPoiID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spEquip_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            SqlCmd.SelectCommand.Parameters.Add("@LyID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@LyID"].Value = 0;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tbL = DS.Tables[0];
            DataTable tbE = DS.Tables[1];

            var rets = new List<JSTree>();

            for (int i = 0; i < tbL.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = "L"+tbL.Rows[i]["LyID"].ToString(),
                    text = tbL.Rows[i]["Name"].ToString(),
                    parent = "L"+tbL.Rows[i]["pLyID"].ToString()
                };
                if (ret.parent == "L0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                rets.Add(ret);
            }

            for (int i = 0; i < tbE.Rows.Count; i++)
            {
                DataRow[] dr = tbL.Select("LyID=" + tbE.Rows[i]["LyID"]);
                if (dr.Length == 0) continue;
               
                var ret = new JSTree()
                {
                    id = tbE.Rows[i]["PoiID"].ToString(),
                    text = tbE.Rows[i]["Name"].ToString(),
                    parent = "L"+tbE.Rows[i]["LyID"].ToString(),
                    icon = "../img/ic_file.png"
                };
                if (ret.parent == "0")
                    continue;

                ret.state = new State();
                ret.state.opened = true;
                if (sPoiID == tbE.Rows[i]["PoiID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        public static string GetDomains(string sDmID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spUR_GetDomain]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["DmID"].ToString(),
                    text = tb.Rows[i]["Name"].ToString(),
                    parent = "#"
                };
                if (sDmID == tb.Rows[i]["DmID"].ToString())
                {
                    ret.state = new State()
                    {
                        selected = true
                    };
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }


        public static string GetAreas(string sPvID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spArea_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["Code"].ToString(),
                    text = tb.Rows[i]["Name_T"].ToString(),
                    parent = "0"
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                if (sPvID == tb.Rows[i]["Code"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }

        public static string GetOrgVers(string sOrgID)
        {
            SqlConnection SqlConn = new SqlConnection(ConfigurationManager.AppSettings["EBMSMapD"]);
            SqlDataAdapter SqlCmd = new SqlDataAdapter("[spOrgVer_Get]", SqlConn);
            SqlCmd.SelectCommand.CommandType = CommandType.StoredProcedure;

            SqlCmd.SelectCommand.Parameters.Add("@AUID", SqlDbType.Int);
            SqlCmd.SelectCommand.Parameters["@AUID"].Value = cUsr.UID;

            DataSet DS = new DataSet();
            SqlCmd.Fill(DS);
            SqlConn.Close();
            DataTable tb = DS.Tables[0];

            var rets = new List<JSTree>();

            for (int i = 0; i < tb.Rows.Count; i++)
            {
                var ret = new JSTree()
                {
                    id = tb.Rows[i]["VerID"].ToString(),
                    text = tb.Rows[i]["Ver"] + " (" + tb.Rows[i]["Name"] + ")",
                    parent = "0"
                };
                if (ret.parent == "0") ret.parent = "#";
                ret.state = new State();
                ret.state.opened = true;
                if (sOrgID == tb.Rows[i]["VerID"].ToString())
                {
                    ret.state.selected = true;
                }
                rets.Add(ret);
            }

            System.Web.Script.Serialization.JavaScriptSerializer jSearializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            jSearializer.MaxJsonLength = int.MaxValue;
            return jSearializer.Serialize(rets);
        }
    }
}