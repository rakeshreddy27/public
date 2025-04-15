// TCPServer2.java EECE6029 Cheng 2016
// an echo TCP server with one thread per client
// DelayEcho.class required in the same directory
// Usage: java TCPSerer2 12345

import java.io.*;
import java.util.*;
import java.net.*;

public class TCPServer2{

 public static void main(String[] args) throws IOException {
   if (args.length < 1){
     System.err.println("Usage: java TCPServer2 port");
     System.exit(1);
   }
   int servPort = Integer.parseInt(args[0]);
   ServerSocket servSock = new ServerSocket(servPort);
   while (true){
     Socket clntSock = servSock.accept();
     Thread thread = new Thread(new DelayedEcho(clntSock));
     thread.start();
   }
 }
}

   