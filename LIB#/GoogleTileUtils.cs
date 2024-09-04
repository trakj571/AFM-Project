using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EBMSMap30
{
    public class GoogleTileUtils
    {
        public static int TILE_SIZE = 256;

        /**
         * Returns the pixel offset of a latitude and longitude within a single typical google tile.
         * @param lat
         * @param lng
         * @param zoom
         * @return
         */
        public static System.Drawing.Point getPixelOffsetInTile(double lat, double lng, int zoom)
        {
            System.Drawing.Point pixelCoords = toZoomedPixelCoords(lat, lng, zoom);

            return new System.Drawing.Point(pixelCoords.X % TILE_SIZE, pixelCoords.Y % TILE_SIZE);
        }

        /**
        * returns a Rectangle2D with x = lon, y = lat, width=lonSpan, height=latSpan
        * for an x,y,zoom as used by google.
        */
        public static System.Drawing.RectangleF getTileRect(int x, int y, int zoom)
        {
            int tilesAtThisZoom = 1 << zoom;
            double lngWidth = 360.0 / tilesAtThisZoom; // width in degrees longitude
            double lng = -180 + (x * lngWidth); // left edge in degrees longitude

            double latHeightMerc = 1.0 / tilesAtThisZoom; // height in "normalized" mercator 0,0 top left
            double topLatMerc = y * latHeightMerc; // top edge in "normalized" mercator 0,0 top left
            double bottomLatMerc = topLatMerc + latHeightMerc;

            // convert top and bottom lat in mercator to degrees
            // note that in fact the coordinates go from about -85 to +85 not -90 to 90!
            double bottomLat = (180 / Math.PI) * ((2 * Math.Atan(Math.Exp(Math.PI * (1 - (2 * bottomLatMerc)))))
                               - (Math.PI / 2));

            double topLat = (180 / Math.PI) * ((2 * Math.Atan(Math.Exp(Math.PI * (1 - (2 * topLatMerc))))) - (Math.PI / 2));

            double latHeight = topLat - bottomLat;

            return new System.Drawing.RectangleF((float)lng, (float)bottomLat, (float)lngWidth, (float)latHeight);
        }

        /**
         * returns the lat/lng as an "Offset Normalized Mercator" pixel coordinate,
         * this is a coordinate that runs from 0..1 in latitude and longitude with 0,0 being
         * top left. Normalizing means that this routine can be used at any zoom level and
         * then multiplied by a power of two to get actual pixel coordinates.
         * @param lat in degrees
         * @param lng in degrees
         * @return
         */
        public static System.Drawing.PointF toNormalisedPixelCoords(double lat, double lng)
        {
            // first convert to Mercator projection
            // first convert the lat lon to mercator coordintes.
            if (lng > 180)
            {
                lng -= 360;
            }

            lng /= 360;
            lng += 0.5;

            lat = 0.5 - ((Math.Log(Math.Tan((Math.PI / 4) + ((0.5 * Math.PI * lat) / 180))) / Math.PI) / 2.0);

            return new System.Drawing.PointF((float)lng, (float)lat);
        }

        /**
         * returns a point that is a google tile reference for the tile containing the lat/lng and at the zoom level.
         * @param lat
         * @param lng
         * @param zoom
         * @return
         */
        public static System.Drawing.Point toTileXY(double lat, double lng, int zoom)
        {
            System.Drawing.PointF normalised = toNormalisedPixelCoords(lat, lng);
            int scale = 1 << zoom;

            // can just truncate to integer, this looses the fractional "pixel offset"
            return new System.Drawing.Point((int)(normalised.X * scale), (int)(normalised.Y * scale));
        }

        /**
         * returns a point that is a google pixel reference for the particular lat/lng and zoom
         * @param lat
         * @param lng
         * @param zoom
         * @return
         */
        public static System.Drawing.Point toZoomedPixelCoords(double lat, double lng, int zoom)
        {
            System.Drawing.PointF normalised = toNormalisedPixelCoords(lat, lng);
            double scale = (1 << zoom) * TILE_SIZE;

            return new System.Drawing.Point((int)(normalised.X * scale), (int)(normalised.Y * scale));
        }

    }
}