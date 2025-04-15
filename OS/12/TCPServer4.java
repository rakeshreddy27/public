// TCPServer4.java EECE6029 Cheng 2016
// an echo TCP server with thread pool via Executor
// DelayedEcho.class must be in the same directory
// Usage: java TCPSerer4 12345

import java.io.*;
import java.util.concurrent.*;
import java.net.*;

public class TCPServer4{

 public static void main(String[] args) throws IOException {
   if (args.length < 1){
     System.err.println("Usage: java TCPServer4 port");
     System.exit(1);
   }
   int servPort = Integer.parseInt(args[0]);
   Executor service = Executors.newCachedThreadPool();
   ServerSocket servSock = new ServerSocket(servPort);
   while (true){
     Socket clntSock = servSock.accept();
     service.execute(new DelayedEcho(clntSock));
   }
 }
}

   