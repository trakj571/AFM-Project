<%@ Page Language="C#" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Street View side-by-side</title>
    <style>
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #map
      {
          display:none
      }
      #pano {
        float: left;
        height: 100%;
        width: 100%;
      }
    </style>
  </head>
  <body>
    <div id="map"></div>
    <div id="pano"></div>
    <script>
        //http://googlemaps.googlermania.com/google_maps_api_v3/en/map_example_49.html
        var map;
        function setCenter(lat, lng) {
            location="StView.aspx?lat="+lat+"&lng="+lng;
            //map.setCenter({ lat: lat, lng: lng });
            //alert(map.getStreetView());
           // var panorama = map.getStreetView();
            //panorama.setPosition(new google.maps.LatLng(lat, lng));
        }
        function initialize() {
            var center = { lat: 13.75, lng: 100.5 };
            <%if(Request["Lat"] != null){ %>
                center = { lat: <%=Request["Lat"]  %>, lng: <%=Request["Lng"]  %> };
            <%} %>
            map = new google.maps.Map(document.getElementById('map'), {
                center: center,
                zoom: 14
            });
            var panorama = new google.maps.StreetViewPanorama(
            document.getElementById('pano'), {
                position: center,
                pov: {
                    heading: 34,
                    pitch: 10
                }
            });
            map.setStreetView(panorama);
            map.bindTo("center", panorama, "position");
        }
    </script>
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAZcQjsSXilTjZgvrYCCz9evGM79MXRBBU&callback=initialize">
    </script>
  </body>
</html>