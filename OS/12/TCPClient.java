// TCPClient.java EECE6029 Cheng 2016
// connect to TCPServerx and send a message and then wait for a reply
// Usage: java TCPClient localhost 12345 message

import java.io.*;
import java.net.*;

public class TCPClient{

   static int MAXBF = 1024;

 public static void main(String[] args) throws IOException {
    if (args.length < 2){
      System.err.println("Usage: java TCPClient serverIP serverPort");
      return;
    }
    int servPort = Integer.parseInt(args[1]);
    byte[] data = new byte[MAXBF];
    byte[] buffer = new byte[MAXBF];
    Socket sock = new Socket(args[0], servPort);
    System.out.println("Connected to server.  Type your message. ");
    int len = System.in.read(data);
    InputStream in = sock.getInputStream();
    OutputStream out = sock.getOutputStream();
    out.write(data, 0, len);
    int recvSize = in.read(buffer);
    if (recvSize > 0) System.out.println("Received " + new String(buffer, 0, recvSize));
    sock.close();
 }
}
