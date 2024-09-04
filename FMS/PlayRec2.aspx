<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PlayRec2.aspx.cs" Inherits="AFMProj.FMS.PlayRec2" %>

<!doctype html>

<html>

<head>
   <meta charset="utf-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" href="js/skin.css">
   <script src="js/jquery-1.12.4.min.js"></script>
   <script src="js/flowplayer.min.js"></script>
                  
   
<script>
    // display information about the video type
    flowplayer(function (api) {
        api.on("load", function (e, api, video) {
            
        });
        api.bind("ready", function (e, api) {
            //api.seek(0);
            api.play();
        });

    });

    /*
    $(function () {

        flowplayer("#player", {
            autoplay: true,
             clip: {
                sources: [
                { type: "application/x-mpegurl", src: "https://lmtr.nbtc.go.th/afm/1.01/157566584398062980871442080699889105485/record/5-316789-322220/playlist.m3u8" }
                ],
            }
        });
    });*/
</script>

</head>

<body>
<!--div id="player" class="fp-slim"></div-->

<div class="flowplayer" data-ratio="0.5625">
  <video>
      <source type="application/x-mpegurl" src="<%=StreamURL %>">
   </video>
</div>

</body>
</html>