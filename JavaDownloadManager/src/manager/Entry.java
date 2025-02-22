package manager;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.net.HttpURLConnection;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Entry {
	
	public static void main(String[] args) {
		try {
			download("http://hagan.okstate.edu/NNDesign.pdf","D:/");
		} catch (InterruptedException | ExecutionException | IOException | URISyntaxException e){
			e.printStackTrace();
		}
	}
	
	public static void download(String url,String folder)throws InterruptedException,
	ExecutionException, IOException, URISyntaxException{
		int numberParts=1;
		String filename= (new FileName()).filename(url);
		RandomAccessFile file=new RandomAccessFile(folder+filename,"rw");
        HttpURLConnection urlConnection = (HttpURLConnection) (new URL(url)).openConnection();
        if("bytes".equals(urlConnection.getHeaderField("Accept-Ranges")))
        	{numberParts=10;}
        Long len=urlConnection.getContentLengthLong();
        System.out.println(len);
        file.setLength(len);
        ArrayList<Future<Boolean>> list = new ArrayList<Future<Boolean>>();
        ExecutorService es = Executors.newFixedThreadPool(numberParts+2);
        int quo=(int) (len/numberParts);
        int rem=(int) (len%numberParts);
        int start=0;
        int end=0;
        if(numberParts!=1){
        for(int i=1;i<=numberParts;i++){
        	if(i!=numberParts){
          end=i*quo;}
        	else{
        		end=quo*i+rem;
        	}
        System.out.println(i+ " "+start+" "+end);
		// Mapping a range of file to each executor
        Future<Boolean> result = es.submit(new DownloadExecutor(url,
				(long)start,(long)end,i,file));
		start=end+1;
		list.add(result);
		}
        }
        else{
        	Future<Boolean> result = es.submit(new DownloadExecutor(url,0L,-1L,1,file));
    		list.add(result);
        }
        boolean complete=false;
        boolean temp;
        int count;
        int perCom=0;
        while(!complete){
        	count=0;
        	temp=true;
        for(Future<Boolean> future : list)
        {
        	temp=temp && future.isDone();
        	if(future.isDone()){count++;}
        }
        complete=temp;
        if(((100*count)/numberParts)!=perCom){
        	perCom=((100*count)/numberParts);
            System.out.println("Percentage Complete::"+perCom);
        }
        }
        urlConnection.disconnect();
		es.shutdown();
		file.close();
	}
}
