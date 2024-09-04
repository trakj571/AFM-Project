using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace EBMSMap30
{
    public class cMath
    {
        public static double RadToDeg(double rad)
        {
            return rad / Math.PI * 180;
        }
        public static double DegToRad(double deg)
        {
            return deg / 180 * Math.PI;
        }
        public static DT2.Point PointAtR(double deg, DT2.Point c, double radius)
        {
            var Latitud = DegToRad(c.Y);
            var Longitud = DegToRad(c.X);
            var d_rad = (radius / 6378137);
            var radial = (Math.PI * deg) / 180;
            var lat_rad = Math.Asin((Math.Sin(Latitud) * Math.Cos(d_rad)) + (Math.Cos(Latitud) * Math.Sin(d_rad) * Math.Cos(radial)));
            var dlon_rad = Math.Atan2(Math.Sin(radial) * Math.Sin(d_rad) * Math.Cos(Latitud), Math.Cos(d_rad) - Math.Sin(Latitud) * Math.Sin(lat_rad));
            var lon_rad = ((Longitud + dlon_rad + Math.PI) % (2 * Math.PI)) - Math.PI;
            return new DT2.Point()
            {
                Y = RadToDeg(lat_rad),
                X = RadToDeg(lon_rad)
            };
        }
        public static double Distance(DT2.Point loc1, DT2.Point loc2)
        {
            double d = loc1.Y * 0.017453292519943295;
            double num3 = loc1.X * 0.017453292519943295;
            double num4 = loc2.Y * 0.017453292519943295;
            double num5 = loc2.X * 0.017453292519943295;
            double num6 = num5 - num3;
            double num7 = num4 - d;
            double num8 = Math.Pow(Math.Sin(num7 / 2.0), 2.0) + ((Math.Cos(d) * Math.Cos(num4)) * Math.Pow(Math.Sin(num6 / 2.0), 2.0));
            double num9 = 2.0 * Math.Atan2(Math.Sqrt(num8), Math.Sqrt(1.0 - num8));
            return (6376500.0 * num9);

        }
        public static double DistVincenty(DT2.Point loc1, DT2.Point loc2)
        {
            double a = 6378137;
            double b = 6356752.3142;
            double f = 1 / 298.257223563; // WGS-84 ellipsoid params  
            double L = ((loc2.X - loc1.X) * Math.PI) / 180;
            double U1 = Math.Atan((1 - f) * Math.Tan((loc1.Y * Math.PI) / 180));
            double U2 = Math.Atan((1 - f) * Math.Tan((loc2.Y * Math.PI) / 180));
            double sinU1 = Math.Sin(U1), cosU1 = Math.Cos(U1);
            double sinU2 = Math.Sin(U2), cosU2 = Math.Cos(U2);
            double lambda = L;
            double lambdaP;
            double iterLimit = 100;
            double cosSqAlpha;
            double sinSigma;
            double sigma;
            double cos2SigmaM;
            double cosSigma;
            do
            {
                double sinLambda = Math.Sin(lambda), cosLambda = Math.Cos(lambda);
                sinSigma =
                    Math.Sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
                              (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
                if (sinSigma == 0) return 0; // co-incident points    
                cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
                sigma = Math.Atan2(sinSigma, cosSigma);
                double sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
                cosSqAlpha = 1 - sinAlpha * sinAlpha;
                cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
                if (double.IsNaN(cos2SigmaM)) // equatorial line: cosSqAlpha=0 (§6) 
                {
                    cos2SigmaM = 0;
                }
                double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
                lambdaP = lambda;
                lambda = L +
                         (1 - C) * f * sinAlpha *
                         (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
            } while (Math.Abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);

            if (iterLimit == 0) // formula failed to converge 
            {
                return double.NaN;
            }

            double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
            double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
            double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
            double deltaSigma = B * sinSigma *
                                (cos2SigmaM +
                                 B / 4 *
                                 (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
                                  B / 6 * cos2SigmaM * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
            double s = b * A * (sigma - deltaSigma);
            return s;
        }


        public static DT2.Point FromKmToNPosition(DT2.Point p, double km)
        {
            double r_earth = 6378;
            var pi = Math.PI;
            var new_latitude = p.Y + (km / r_earth) * (180 / pi);
            return new DT2.Point(p.X, new_latitude,  0);
        }
        public static DT2.Point FromKmToEPosition(DT2.Point p, double km)
        {
            double r_earth = 6378;
            var pi = Math.PI;
            var new_longitude = p.X + (km / r_earth) * (180 / pi) / Math.Cos(p.Y * pi / 180);
            return new DT2.Point( new_longitude, p.Y,0);
        }
        public static DT2.Point FromKmToSPosition(DT2.Point p, double km)
        {
            double r_earth = 6378;
            var pi = Math.PI;
            var new_latitude = p.Y - (km / r_earth) * (180 / pi);
            return new DT2.Point(p.X,new_latitude,0);
        }
        public static DT2.Point FromKmToWPosition(DT2.Point p, double km)
        {
            double r_earth = 6378;
            var pi = Math.PI;
            var new_longitude = p.X - (km / r_earth) * (180 / pi) / Math.Cos(p.Y * pi / 180);
            return new DT2.Point(new_longitude,p.Y, 0);
        }
    }
}