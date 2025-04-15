// DelayedEcho.java EECS6029 Cheng 2016
// implements Runnable 
// to be used by TCPServer2 and TCPServer4 via Thread

import java.util.*;
import java.net.*;
import java.io.*;

public class DelayedEcho implements Runnable{

    static final int MAXBF = 1024;
    Socket sock = null;
  
    public DelayedEcho(Socket socket){ sock = socket; }

    public void run() {
    try {
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
   } catch (IOException e){
       System.err.println("IOException");
       return;
   }
 }
 }
