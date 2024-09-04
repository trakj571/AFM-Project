using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace EBMSMap30
{
    public class ReturnSet
    {
        public string result { get; set; }
        public object datas { get; set; }
    }

    public class POISet
    {
        public int PoiID { get; set; }
        public int PoiType { get; set; }
        public int LyID { get; set; }
        public int TypeID { get; set; }
        public string Name { get; set; }
        public string LayerName { get; set; }
        public string pLayerName { get; set; }
        public string Icon { get; set; }
        public string LineColor { get; set; }
        public int LineWidth { get; set; }
        public int LineOpacity { get; set; }
        public string FillColor { get; set; }
        public int FillOpacity { get; set; }
        public string LayerType { get; set; }
        public string Points { get; set; }
        public double Lat1 { get; set; }
        public double Lng1 { get; set; }
        public double Lat2 { get; set; }
        public double Lng2 { get; set; }
        public double Radius { get; set; }
        public double Heading { get; set; }
        public string EquType { get; set; }
        public string IsLock { get; set; }
        public string IsOnline { get; set; }
        
    }

    public class POIDetailSet
    {
        public int PoiID { get; set; }
        public int PoiType { get; set; }
        public int LyID { get; set; }
        public int TypeID { get; set; }
        public string Name { get; set; }
        public string Points { get; set; }
        public string Icon { get; set; }
        public string LineColor { get; set; }
        public int LineWidth { get; set; }
        public int LineOpacity { get; set; }
        public string FillColor { get; set; }
        public int FillOpacity { get; set; }
        public double Distance { get; set; }
        public double Area { get; set; }
        public double Radius { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
        public List<POICol> POICols { get; set; }
        public List<POIForm> POIForms { get; set; }
        public List<PointHisSet> PointHis { get; set; }
        public string EquType { get; set; }
        //public int PMS_SubTypeID { get; set; }
        //public int PMS_BdFlrID { get; set; }
        public string FreqStat { get; set; }
    }
    public class PointHisSet
    {
        public int Sec { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
        public double Heading { get; set; }
        public double Speed { get; set; }
    }
    public class POIForm
    {
        public int FormID { get; set; }
        public string Name { get; set; }
        public List<POICol> POICols { get; set; }
    }
    public class POICol
    {
        public int ColID { get; set; }
        public string DataName { get; set; }
        public string DataType { get; set; }
        public string Label { get; set; }
        public string Unit { get; set; }
        public short MaxLength { get; set; }
        public bool IsHeader { get; set; }
        public bool IsRequire { get; set; }
        public bool IsHide { get; set; }
        public string InputType { get; set; }
        public int DpColID { get; set; }
        public List<POIColOpt> Options { get; set; }
        public string Data { get; set; }
        public string DataText { get; set; }
    }
    public class POIColOpt
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }

    public class GroupSet
    {
        public int GrpID { get; set; }
        public string Name { get; set; }
        public List<TypeSet> Children { get; set; }
    }
    public class TypeSet
    {
        public int TypeID { get; set; }
        public string Name { get; set; }
        public int PoiType { get; set; }
        public string Icon { get; set; }
    }

    public class FileUpload
    {
        public string Key { get; set; }
        public byte[] Buffer { get; set; }
    }

    public class PlayBackSet
    {
        public string Name { get; set; }
        public string Key { get; set; }
        public string Icon { get; set; }
        public string Points { get; set; }
        public string Playlist { get; set; }
        public int Duration { get; set; }
     }

    public class PoiStatSet
    {
        public int PoiID { get; set; }
        public string EquType { get; set; }
        public string Stream { get; set; }
        public string Name { get; set; }
        public bool IsOnline { get; set; }
        public string GPSStat { get; set; }
        public string Speed { get; set; }
    }
    public class PoiGPSDetSet
    {
        public int PoiID { get; set; }
        public string Name { get; set; }
        public int nPage { get; set; }
        public int Page { get; set; }
        public List<GpsDataSet> Datas { get; set; }
    }
    public class GpsDataSet
    {
        public int LogID { get; set; }
        public string DtS { get; set; }
        public string TmS { get; set; }
        public string DtC { get; set; }
        public string TmC { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
        public double Speed { get; set; }
        public double Heading { get; set; }
        public double Alt { get; set; }
        public string F { get; set; }
        public string Sat { get; set; }
        public string FuelR { get; set; }
    }

    public class EventSet
    {
        public int EvID { get; set; }
        public int PoiID { get; set; }
        public int EvPoiID { get; set; }
        public string HostName { get; set; }
        public string Station { get; set; }
        public string EvName { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
        public double Freq { get; set; }
        public double Signal { get; set; }
        public string DtAdd { get; set; }
        public string TmAdd { get; set; }
        public string rType { get; set; }
    }

    public class GPSHisSet
    {
        public string Name { get; set; }
        public string Dt { get; set; }
        public string Tm { get; set; }
        public string Key { get; set; }
        public string Icon { get; set; }
        public string Points { get; set; }
        public int EvTypeID { get; set; }
        public string EvName { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
        public double Speed { get; set; }
        public double Heading { get; set; }
        public double Alt { get; set; }
        public string DtAdd { get; set; }
        public string TmAdd { get; set; }
    }

    public class EventHisSet
    {
        public string Name { get; set; }
        public string DtAdd { get; set; }
        public string TmAdd { get; set; }
        public string Key { get; set; }
        public string Icon { get; set; }
        public string Points { get; set; }
        public int EvTypeID { get; set; }

        public int EvID { get; set; }
        public int PoiID { get; set; }
        public string HostName { get; set; }
        public string Station { get; set; }
        public string EvName { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
        public double Freq { get; set; }
        public double Signal { get; set; }
        public string rType { get; set; }

    }
}