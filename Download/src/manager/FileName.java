package manager;

import java.net.URISyntaxException;
import org.apache.commons.io.FilenameUtils;

public class FileName {
	
    public String filename(String url) throws URISyntaxException {
    	url=url.trim();
		return FilenameUtils.getBaseName(url)+"."+FilenameUtils.getExtension(url);
    }

}
