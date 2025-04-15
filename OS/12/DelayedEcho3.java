// DelayedEcho3.java EECS6029 Cheng 2016
// implements CompletionHandler<AsynchronousSocketChannel, Void>
// used by TCPServer6 via accpt()

import java.io.*;
import java.util.*;
import java.util.concurrent.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;

public class DelayedEcho3 implements CompletionHandler<AsynchronousSocketChannel, Void>{

    static final int MAXBF = 1024;
    AsynchronousServerSocketChannel asynchronousServerSocketChannel = null;

   public DelayedEcho3(AsynchronousServerSocketChannel servSocketChannel){
     asynchronousServerSocketChannel = servSocketChannel;
   }

   public void completed(AsynchronousSocketChannel asynchronousSocketChannel, Void attachment) {


     asynchronousServerSocketChannel.accept(null, this);

    try {
     SocketAddress clntAddr = asynchronousSocketChannel.getRemoteAddress();
     System.out.println(clntAddr + " connects.");
     ByteBuffer buffer = ByteBuffer.allocateDirect(MAXBF);

 
     asynchronousSocketChannel.read(buffer).get();
     buffer.flip();
     asynchronousSocketChannel.write(buffer);
     System.out.println(clntAddr + " completes.");
     asynchronousSocketChannel.close();
    } catch (IOException | InterruptedException | ExecutionException e){
      System.err.println(e.getMessage());
      return;
    }
   }

   public void failed(Throwable exc, Void attachment) {

      asynchronousServerSocketChannel.accept(null, this);

      throw new UnsupportedOperationException("Cannot accept cponnections!");

   }


 }
