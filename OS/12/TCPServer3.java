// TCPServer3.java EECE6029 Cheng 2016
// an echo TCP server with a thread pool
// Usage: java TCPSerer3 12345

import java.io.*;
import java.util.*;
import java.net.*;

public class TCPServer3{

  static final int numberOfThreads = 3;
  static int MAXBF = 1024;

 static void delayedEcho(Socket sock) throws IOException{
   SocketAddress clntAddr = sock.getRemoteSocketAddress();
   System.out.println(clntAddr + " connects");
   InputStream in = sock.getInputStream();
   byte[] buffer = new byte[MAXBF];
   int recvSize = in.read(buffer);
   if (recvSize <= 0) return;
   OutputStream out = sock.getOutputStream();
   out.write(buffer, 0, recvSize);
   sock.close();
   System.out.println(clntAddr + " completes");
 }

 public static void main(String[] args) throws IOException {
   if (args.length < 1){
     System.err.println("Usage: java TCPServer3 port");
     System.exit(1);
   }
   int servPort = Integer.parseInt(args[0]);
   ServerSocket servSock = new ServerSocket(servPort);
   for (int i = 0; i < numberOfThreads; i++){
     Thread thread = new Thread(){
        public void run(){
           while (true){
             try {
               Socket clntSock = servSock.accept();
               delayedEcho(clntSock);
             } catch (IOException e){
               System.err.println("IOException");
               return;
             }
           }
       }
     };
     thread.start();
   }
 }
}

   