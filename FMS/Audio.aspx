﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Audio.aspx.cs" Inherits="AFMProj.FMS.Audio" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    
    <%if(IsMobile()){ %>
        <script> location = "rtmp://lmtr.nbtc.go.th/flvplayback/<%=Request["stream"] %>";</script>
    <%
        Response.Write("</head></html>");  
        Response.End();
    } %>
   
    <script type="text/javascript" src="../_inc/js/jquery-3.2.0.min.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer-3.2.13.min.js"></script>
    <script type="text/javascript" src="../gis/libs/flowplayer/flowplayer.ipad-3.2.13.min.js"></script>	

<script>
    function play_now(stream) {
        f = $f("audio", {
            //src: "http://releases.flowplayer.org/swf/flowplayer-3.2.18.swf",
            src: "../gis/libs/flowplayer/flowplayer-3.2.18.swf",
            bgcolor: "#12699f"
        },
		{
		    play: {
		        //opacity: 0.0,
		        //label: null, // label text; by default there is no text
		        //replayLabel: null, // label text at end of video clip
		    },
		    clip: {
		        //url: 'live',
		        url: stream,
		        netConnectionUrl: 'rtmp://lmtr.nbtc.go.th/flvplayback',
		        live: true,
		        autoPlay: true,
		        //autoBuffering: true,
		        bufferLength: 0,
		        //fadeInSpeed: 0,
		        //fadeOutSpeed: 0,

		        provider: 'influxis'
		        //ipadUrl: "http://27.254.41.35:8000/test.mp3"
		    },
		    onFinish: function () {
		        //alert('onFinish');
		    },
		    onBegin: function () {
		        //alert('onBegin');
		    },
		    onPause: function () {
		        //alert('onPause');
		        //this.stop();
		        //this.stopBuffering();
		    },
		    onBeforeResume: function () {
		        //alert('onBeforeResume');

		        this.stop();
		        this.play();
		        //disable resume, use play() instead -- bufferLength 0
		        return false;
		    },
		    onResume: function () {
		        //alert('onResume');
		    },
		    onStart: function () {
		        //alert('onStart');
		    },
		    onStop: function () {
		        //alert('onStop');
		    },
		    onBufferEmpty: function () {
		        //alert('onBufferEmpty');
		    },
		    onBufferStop: function () {
		        //alert('onBufferStop');
		    },
		    onBufferFull: function () {
		        //alert('onBufferFull');
		    },
		    onBeforeSeek: function () {
		        //alert('onBeforeSeek');
		    },

		    canvas: {
		        //backgroundImage: '/offline.png'
		    },
		    plugins: {
		        controls: {
		            scrubber: false,
		            fullscreen: false,
		            autoHide: false,
		            height: 30,
		            timeFontSize: 20,
		            backgroundColor: "#12699f",
		            backgroundGradient: [0.3, 0]
		            //url: "flowplayer/flowplayer.controls-3.2.15.swf",
		            //play: true
		            //all: false,
		            //scrubber: false
		            //time: true,
		            //fullscreen: true				

		        },
		        influxis: {
		            url: "../gis/libs/flowplayer/flowplayer.rtmp-3.2.13.swf",
		            inBufferSeek: false
		        }
		    }
		}).ipad();

    }

    $(function () {
        play_now("<%=Request["stream"] %>");
    });
    </script>
</head>
<body style='overflow:hidden;'>
   <div id="audio" style='width:150px;height:30px;'></div>
</body>
</html>