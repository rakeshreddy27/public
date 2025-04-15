// DelayedEcho2.java EECS6029 Cheng 2016
// implements Callable<String>
// used by TCPServer5 via 

import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;

public class DelayedEcho2 implements Callable<String>{

    static final int MAXBF = 1024;
    AsynchronousSocketChannel asynchronousSocketChannel = null;
  
    public DelayedEcho2(AsynchronousSocketChannel socketChannel){ asynchronousSocketChannel = socketChannel; }

    public String call() {
    try {
     SocketAddress clntAddr = asynchronousSocketChannel.getRemoteAddress();
     System.out.println(clntAddr + " connects");
     ByteBuffer buffer = ByteBuffer.allocateDirect(MAXBF);

 
     asynchronousSocketChannel.read(buffer).get();
     buffer.flip();
     asynchronousSocketChannel.write(buffer);
     asynchronousSocketChannel.close();
     System.out.println(clntAddr + " completes");
    } catch (IOException | InterruptedException | ExecutionException e){
      System.err.println(e.getMessage());
      return "";
    }
    return "";
   }
 }
