package manager;

import java.io.RandomAccessFile;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.util.concurrent.Callable;

public class DownloadExecutor implements Callable<Boolean> {
	private RandomAccessFile file;
	private String ul;
	private Long range1;
	private Long range2;
	private int part;
	public DownloadExecutor(String ul, Long range1, Long range2, int part, RandomAccessFile file) {
		this.ul = ul;
		this.range1 = range1;
		this.range2 = range2;
		this.part = part;
		this.file = file;
	}
	@Override
	public Boolean call() {
		try {
			URL url = new URL(ul);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestProperty("User-Agent", "NING/1.0");
			if(!(range2<=0)){
			con.setRequestProperty("range", "bytes=" + range1 + "-" + range2);}
			ReadableByteChannel rbc = Channels.newChannel(con.getInputStream());
			file.getChannel().position(range1).transferFrom(rbc, range1, Long.MAX_VALUE);
			con.disconnect();
			rbc.close();
			//System.out.println("end of part:::" + part +" "+ range1 +"  "+range2);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
