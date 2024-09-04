<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PlayRec3.aspx.cs" Inherits="AFMProj.FMS.PlayRec3" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="favicon.ico">

    <title></title>

    <style>
        body {
            /*padding-top: 50px;*/
            color: #868688;
            background-color: #000;

        }

        nav {
            background-color: #e7e7e7
        }

            nav a {
                color: #868688;
            }

                nav a:hover {
                    color: #606062;
                    text-decoration: none;
                }

        .navbar-toggle .icon-bar {
            background-color: #868688;
        }

        .starter-template {
            /*padding: 40px 15px;*/
            text-align: center;
        }

        .video-js {
            margin: 0 auto;
        }

        input {
            margin-top: 15px;
            min-width: 450px;
            padding: 5px;
        }
    </style>

    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
</head>

<body>

    <div class="container">

        <section class="starter-template">

            <select id="mPlayList" runat="server"></select><br /><br />


            <video id=example-video width=200 height=30 class="video-js vjs-default-skin" controls>
                <%if(tbD!=null){
                        int n = EBMSMap30.cConvert.ToInt(tbD.Rows[0]["VoicePart"]);
                        for(int i = 0; i <=0; i++) { 
                        %>
               
                        <source src="<%="../Files/FTPAFM2/"+tbD.Rows[0]["POIID"]+"/Voice/"+tbD.Rows[0]["VoiceFile"]+ (i>0?"-^"+string.Format("{0:000}",i):"")+".wav" %>"
                        type="audio/wav">
                <%}}else{ %>
                <source src="<%=StreamURL %>"
                        type="application/x-mpegURL">
                <%} %>
            </video>

        </section>

    </div><!-- /.container -->


    <script src="http://27.254.65.228/html5/jquery.min.js"></script>

    <link href="http://27.254.65.228/html5/video-js.css" rel="stylesheet">

    <script src="http://27.254.65.228/html5/video.js"></script>
    <script src="http://27.254.65.228/html5/videojs-contrib-hls.js"></script>

    <script>
        (function (window, videojs) {

            var player = window.player = videojs('example-video', { "controls": true, "autoplay": true, "preload": "auto" });

        }(window, window.videojs));

        $(function () {
            $("#mPlayList").change(function () {

                var myVideo = videojs('example-video');
                myVideo.src([
                    { type: "audio/wav", src: $(this).val() }
                ]);


            });

        });
    </script>
</body>
</html>