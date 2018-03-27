<%--
  Created by IntelliJ IDEA.
  User: koo12-lenovo
  Date: 18-1-20
  Time: 下午2:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>聊天室</title>
  <style type="text/css">
      body
      {
          background-color: lightgoldenrodyellow;
      }

      #danliao
      {
          display: block;
      }

      p
      {
          display: inline;
      }

      #number
      {
          position: absolute;
          top: 30px;
          left: 280px;
          font-size: 40px;
          color: purple;
      }
  </style>
  <script language="JavaScript">
      var wsuri = "ws://localhost:8080/link";
      var ws = null;

      function connectEndpoint(){
          window.WebSocket = window.WebSocket || window.MozWebSocket;
          if (!window.WebSocket){
              alert("WebSocket 不被你的浏览器所支持");
              return;
          }

          ws = new WebSocket(wsuri);
          ws.onmessage = function(evt) {

              var old = document.getElementById("echo").value;
              var old3=document.getElementById("danliao").value;
              var strs=new Array();
              strs=evt.data.split("-");
              if(strs[0]=="say")
              {
                  document.getElementById("echo").value = old + strs[1]+ "\r\n";
              }
              if(strs[0]=="list")
              {
                  document.getElementById("liebiao").value=strs[1]+"\r\n";
              }
              if(strs[0]=="out")
              {
                  document.getElementById("liebiao").value=strs[1]+"\r\n";
              }
              if(strs[0]=="dan")
              {
                  document.getElementById("danliao").value=old3+strs[1]+strs[2]+strs[3]+"\r\n";
                  document.getElementById("bianhao").value=strs[2];
              }
              if(strs[0]=="shu")
              {
                  document.getElementById("shuzi").innerHTML=strs[1];
              }
          };

          ws.onclose = function(evt) {

              document.getElementById("echo").value = "服务没有连接成功....\r\n";
          };

          ws.onopen = function(evt) {

              document.getElementById("echo").value = "服务连接成功....\r\n";
          };
      }

      function sendmsg(){
          ws.send("say-" + document.getElementById("send").value);
          document.getElementById("send").value="";
      }

      document.onkeyup=function (ev) {
          var code=ev.charCode||ev.keyCode;
          if(code==13)
          {
              ws.send("say-" + document.getElementById("send").value);
              document.getElementById("send").value="";
          }
      }

      function fasong()
      {
          var old=document.getElementById("danliao").value;
          var neirong="dan-"+document.getElementById("bianhao").value+"-"+document.getElementById("send2").value;
          old=old+"我[发言]:"+document.getElementById("send2").value+"\r\n";
          document.getElementById("send2").value="";
          document.getElementById("danliao").value=old;
          ws.send(neirong);
      }
  </script>
</head>
<body onload="connectEndpoint()">
    <div id="number">
        <h1 id="shuzi">1</h1>
    </div>
    <center>
        <div id="zhuti">
        <h1>欢迎来到聊天室</h1>
            <textarea id="echo"  rows="10" cols="60">
            </textarea>
            <textarea id="liebiao" rows="10" cols="20">
            </textarea>
            <br>
        <input type="text" size="40" value="Hello，大家好！" id="send">
        <input type="button" value="发送" onclick="sendmsg()">
        </div>
    </center>
    <center>
        <h1>你对谁情有独钟呢</h1>
        <p>游客编号：</p><input type="text" size="20" id="bianhao" value="number">
        <textarea id="danliao" rows="10" cols="82"></textarea>
        <input type="text" size="40" value="Hello,我想和你单聊" id="send2">
        <input type="button" value="发送" onclick="fasong()">
    </center>
</body>
</html>
