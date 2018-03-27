import java.io.IOException;
import java.util.*;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/link")
public class Server {
  static Map<String,Session> sessionMap = new Hashtable<String,Session>();

@OnOpen
  public void start(Session session){
    sessionMap.put(session.getId(), session);
    String list="list-";
    for(Map.Entry<String,Session> entry:sessionMap.entrySet())
    {
      list=list+"游客"+entry.getKey()+"在线....\r\n";
    }
    broadcast(list);
    for(Map.Entry<String,Session> entry:sessionMap.entrySet())
    {
      dan("shu-"+entry.getKey(),entry.getKey());
    }
  }

@OnMessage
  public void process(Session session, String message){
    String[] fenge=message.split("-");
    if(fenge[0].equals("say"))
    {
      broadcast("say-游客" + session.getId() + "[发言]:" + fenge[1]);
    }
    if(fenge[0].equals("dan"))
    {
      dan("dan-游客-"+session.getId()+"-[发言]:"+fenge[2],fenge[1]);
    }
  }


@OnClose
  public void end(Session session){
    sessionMap.remove(session.getId());
    String out="out-";
    for(Map.Entry<String,Session> outt:sessionMap.entrySet())
    {
      out=out+"游客"+outt.getKey()+"在线....\r\n";
    }
    broadcast(out);
  }

@OnError
  public void error(Session session, java.lang.Throwable throwable){
    end(session);
  }

  void broadcast(String message){
    RemoteEndpoint.Basic remote = null;
    Set<Map.Entry<String,Session>> set = sessionMap.entrySet();
    for(Map.Entry<String,Session> i: set)
    {
      remote = i.getValue().getBasicRemote();
      try
      {
        remote.sendText(message);
      }
      catch (IOException e)
      {
        e.printStackTrace();
      }
    }
  }

  void dan(String message,String id)
  {
    RemoteEndpoint.Basic remote = null;
    Set<Map.Entry<String,Session>> set = sessionMap.entrySet();
    for(Map.Entry<String,Session> i:set)
    {
      if(id.equals(i.getKey()))
      {
        remote=i.getValue().getBasicRemote();
        try
        {
          remote.sendText(message);
        }
        catch (IOException e)
        {
          e.printStackTrace();
        }
      }
    }
  }
}