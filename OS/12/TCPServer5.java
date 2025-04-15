// TCPServer5.java EECE6029 Cheng 2016
// an echo TCP server with future and asynchronous channel
// requires DelayedEcho2.class in the same directory
// Usage: java TCPSerer5 12345

import java.io.*;
import java.util.concurrent.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;

public class TCPServer5{

 public static void main(String[] args) throws IOException {
   if (args.length < 1){
     System.err.println("Usage: java TCPServer5 port");
     System.exit(1);
   }
   int servPort = Integer.parseInt(args[0]);
   ExecutorService taskExecutor = Executors.newCachedThreadPool(Executors.defaultThreadFactory());

   try (AsynchronousServerSocketChannel asynchronousServerSocketChannel = AsynchronousServerSocketChannel.open()) {


     if (asynchronousServerSocketChannel.isOpen()) {


        asynchronousServerSocketChannel.bind(new InetSocketAddress("127.0.0.1", servPort));

        
while (true) {
          Future<AsynchronousSocketChannel> asynchronousSocketChannelFuture = asynchronousServerSocketChannel.accept();


          try {
            final AsynchronousSocketChannel asynchronousSocketChannel = asynchronousSocketChannelFuture.get();

            taskExecutor.submit(new DelayedEcho2(asynchronousSocketChannel));
          } catch (InterruptedException | ExecutionException ex) {

               System.err.println(ex);


               System.err.println("\n Server is shutting down ...");

               taskExecutor.shutdown();


               
while (!taskExecutor.isTerminated()) ;
               break;
                    
          }

         }

       } else System.out.println("The asynchronous server-socket channel not opened.");


   } catch (IOException ex) {

      System.err.println(ex);

   }

 }
}

   