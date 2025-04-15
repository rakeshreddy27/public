// TCPServer6.java EECE6029 Cheng 2016
// an echo TCP server with completion handler and asynchronous channel
// requires DelayedEcho3.class in the same directory
// Usage: java TCPSerer6 12345

import java.io.*;
import java.util.concurrent.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;

public class TCPServer6{

 public static void main(String[] args) throws IOException {
   if (args.length < 1){
     System.err.println("Usage: java TCPServer6 port");
     System.exit(1);
   }
   int servPort = Integer.parseInt(args[0]);
   ExecutorService taskExecutor = Executors.newCachedThreadPool(Executors.defaultThreadFactory());

   try (AsynchronousServerSocketChannel asynchronousServerSocketChannel = AsynchronousServerSocketChannel.open()) {


     if (asynchronousServerSocketChannel.isOpen()) {


        asynchronousServerSocketChannel.bind(new InetSocketAddress("127.0.0.1", servPort));

        asynchronousServerSocketChannel.accept(null, new DelayedEcho3(asynchronousServerSocketChannel));

        System.in.read();
     } else System.out.println("The asynchronous server-socket channel not opened.");


   } catch (IOException ex) {

      System.err.println(ex);

   }

 }
}

   