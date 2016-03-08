package com.services.com;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.InputStream;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import com.sun.jersey.core.header.FormDataContentDisposition;
import com.sun.jersey.multipart.FormDataParam;
import javax.imageio.ImageIO;

@Path("/file")
public class ColorTOGrey {

	@POST
	@Path("/upload")
	@Produces("image/png")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	public Response uploadFile(
		@FormDataParam("file") InputStream uploadedInputStream,
		@FormDataParam("file") FormDataContentDisposition fileDetail) throws IOException {
		
		System.out.println("$$$$$$$$"+fileDetail.getFileName());

	
		BufferedImage image = ImageIO.read(uploadedInputStream);
		int width = image.getWidth();
         int height = image.getHeight();
         for(int i=0; i<height; i++){
             
             for(int j=0; j<width; j++){
             
                Color c = new Color(image.getRGB(j, i));
                int red = (int)(c.getRed() * 0.299);
                int green = (int)(c.getGreen() * 0.587);
                int blue = (int)(c.getBlue() *0.114);
                Color newColor = new Color(red+green+blue,
                
                red+green+blue,red+green+blue);
                
                image.setRGB(j,i,newColor.getRGB());
             }
          }
         
         ResponseBuilder response = Response.ok((Object) image);
 		response.header("Content-Disposition",
 			"inline; filename=image_from_server.png");
 		return response.build();

	}


}