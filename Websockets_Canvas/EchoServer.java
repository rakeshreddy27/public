package a.b;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
 


@ServerEndpoint("/echo") 
public class EchoServer {
	
	private static Queue<Session> queue = new ConcurrentLinkedQueue<Session>();
	

	
	 private static void sendAll(String msg) {
		  try {
		   /* Send the msg to all open WebSocket sessions */  
		   ArrayList<Session > closedSessions= new ArrayList<>();
		   for (Session session : queue) {
		    if(!session.isOpen())
		    {
		     System.err.println("Closed session: "+session.getId());
		     closedSessions.add(session);
		    }
		    else
		    {
		 session.getBasicRemote().sendText(msg);
		 System.out.println(msg);
		    }    
		   }
		   queue.removeAll(closedSessions);
		   System.out.println("Sending "+msg+" to "+queue.size()+" clients");
		  } catch (Throwable e) {
		   e.printStackTrace();
		  }
		 }
	
	
    
    @OnOpen
    public void onOpen(Session session){
    	queue.add(session);
        System.out.println(session.getId() + " has opened a connection"); 
        
        try {
            session.getBasicRemote().sendText("Connection Established");
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
 
  
    @OnMessage
    public void onMessage(String message, Session session){
       // System.out.println("Message from " + session.getId() + ": " + message);
    	try {
 		   /* Send the msg to all open WebSocket sessions */  
 		   ArrayList<Session > closedSessions= new ArrayList<>();
 		   for (Session session1 : queue) {
 		    if(!session1.isOpen())
 		    {
 		     System.err.println("Closed session: "+session1.getId());
 		     closedSessions.add(session1);
 		    }
 		    else
 		    {
 		 session1.getBasicRemote().sendText(message);
 		System.out.println(message);
 		    }    
 		   }
 		   queue.removeAll(closedSessions);
 		 //  System.out.println("Sending "+msg+" to "+queue.size()+" clients");
 		  } catch (Throwable e) {
 		   e.printStackTrace();
 		  }
        
        
      
    }
 
    @OnClose
    public void onClose(Session session){
    	queue.remove(session);
        System.out.println("Session " +session.getId()+" has ended");
    }
}