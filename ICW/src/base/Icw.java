package base;
import java.awt.geom.Line2D;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.lang.Math;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;

public class Icw {
//Radius of Earth in meters
public static final double RADIUS=6378100;
//Time to collision
public static final double TTC=8;
public static ArrayList<String> v1inputStrings=new ArrayList<String>();
public static ArrayList<String> v2inputStrings=new ArrayList<String>();
public static ArrayList<rectangle> v1Rectangles=new ArrayList<rectangle>();
public static ArrayList<rectangle> v2Rectangles=new ArrayList<rectangle>();
public static ArrayList<Boolean> probability = new ArrayList<Boolean>();

//class to represent coordinates(x,y,z) for a point.
class coordinates{
	public double x;
	public double y;
	public double z;
}

//class to represent the rectangle at each second
class rectangle{
	public double x1;
	public double x2;
	public double x3;
	public double x4;
	public double y1;
	public double y2;
	public double y3;
	public double y4;
}

//Method to read values from the file 
	public void readFile(String filePath) {
		int line=0;
		Boolean first=true;
		BufferedReader br = null;
		String sCurrentLine = null;
		try {
			br = new BufferedReader(new FileReader(filePath));
			while ((sCurrentLine = br.readLine()) != null) {
				//System.out.println(sCurrentLine);
				if(!first && !"".equals(sCurrentLine)){
					if(line%2==0)
						{
						v1inputStrings.add(sCurrentLine);}
					else 
					{v2inputStrings.add(sCurrentLine);}
				    line++;
				    }
				first=false;
			}
		} catch (IOException e) {
			System.out.println("Error reading the file");
			e.printStackTrace();
		} finally {
			try {
				if (br != null)
					br.close();
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
	}

//Method to calculate coordinates (x,y,z) from GPS values.
public coordinates GpsToCoordinates(double longi,double lati){
	double latitude = lati * Math.PI/180;
	double longitude = longi * Math.PI/180;
	coordinates coord=new coordinates();
	coord.x=RADIUS*Math.cos(latitude)*Math.cos(longitude);
	coord.y=RADIUS*Math.cos(latitude)*Math.sin(longitude);
	coord.z=RADIUS*Math.sin(latitude);
	//System.out.println(coord.x+" "+coord.y+" "+coord.z);
	return coord;
}

//Method to calculate haversine distance between two points using coordinates(x,y,z)
public double distBtwnCoordinates(coordinates p,coordinates q){
	double euclidianDist=Math.sqrt(Math.pow(p.x-q.x,2)+Math.pow(p.y-q.y,2)+
	                     Math.pow(p.z-q.z,2));
	double haversineDist = RADIUS*(Math.asin((euclidianDist/(2*Math.pow(RADIUS, 2)))*
			((Math.sqrt(4*RADIUS*RADIUS-euclidianDist*euclidianDist)))));
	return haversineDist;	
}

//Method to calculate difference in time(in seconds) from the given dates
public double time(String dateString1,String dateString2){
	double seconds = 0;
	DateTimeFormatter isoFormatter = DateTimeFormatter.ISO_INSTANT;
	try{
	Instant dateInstant1 = Instant.from(isoFormatter.parse(dateString1));
	Instant dateInstant2 = Instant.from(isoFormatter.parse(dateString2));
	LocalDateTime date1 = LocalDateTime.ofInstant(dateInstant1, ZoneId.of(ZoneOffset.UTC.getId()));
	LocalDateTime date2 = LocalDateTime.ofInstant(dateInstant2, ZoneId.of(ZoneOffset.UTC.getId()));
	seconds=date1.until(date2, ChronoUnit.SECONDS);
	}catch (Exception e){
	System.out.println("Error parsing the date");
	e.printStackTrace();
	}
	//System.out.println(Math.abs(seconds));
	return Math.abs(seconds);
    }

//Method to calculate the coordinate of the rectangle at each second
public void calculateRectCoor(int vehiclenumber){
	ArrayList<String> inputStrings = null;
	if(vehiclenumber==1)
		inputStrings=v1inputStrings;
	else 
		inputStrings=v2inputStrings;

	for(int i=0;i<inputStrings.size()-1;i++){
		String coor1String=inputStrings.get(i);
		String coor2String=inputStrings.get(i+1);
		String[] coor1StringArr=coor1String.split(",");
		String[] coor2StringArr=coor2String.split(",");
		coordinates coor1= GpsToCoordinates(Double.parseDouble(coor1StringArr[2].trim()),
				Double.parseDouble(coor1StringArr[3].trim()));
		coordinates coor2= GpsToCoordinates(Double.parseDouble(coor2StringArr[2].trim()),
				Double.parseDouble(coor2StringArr[3].trim()));
		double magnitude = Math.sqrt(Math.pow(coor2.x-coor1.x, 2)+Math.pow(coor2.y-coor1.y, 2));
		double velocityXunit = (coor2.x-coor1.x)/magnitude;
		double velocityYunit = (coor2.y-coor1.y)/magnitude;
		double perpToVelXunit= velocityYunit;
		double perpToVelYunit= -velocityXunit;
		double speed = distBtwnCoordinates(coor1,coor2)/time(coor2StringArr[1],coor1StringArr[1]);
		double midPointOtherEndX=coor1.x+velocityXunit*speed*TTC;
		double midPointOtherEndY=coor1.y+velocityYunit*speed*TTC;
		rectangle rect=new rectangle();
		rect.x1=coor1.x+(perpToVelXunit*2);
		rect.y1=coor1.y+(perpToVelYunit*2);
		rect.x2=coor1.x-(perpToVelXunit*2);
		rect.y2=coor1.y-(perpToVelYunit*2);
		rect.x3=midPointOtherEndX-(perpToVelXunit*2);
		rect.y3=midPointOtherEndY-(perpToVelYunit*2);
		rect.x4=midPointOtherEndX+(perpToVelXunit*2);
		rect.y4=midPointOtherEndY+(perpToVelYunit*2);
		if(vehiclenumber==1){
			v1Rectangles.add(rect);
			/*System.out.println(rect.x1+" "+rect.y1+" "+rect.x2+" "+rect.y2+" "+
					+rect.x3+" "+rect.y3+" "+rect.x4+" "+rect.y4);*/
		}else{
			v2Rectangles.add(rect);
		}
	}
}
//Method to calculate probability if two rectangles intersect 
public void probablity(){
	for(int i=0;i<v1Rectangles.size();i++){
		boolean collisionProb=false;
		rectangle rect1=v1Rectangles.get(i);
		rectangle rect2=v2Rectangles.get(i);
		Line2D vehOne12 = new Line2D.Double(rect1.x1, rect1.y1, rect1.x2, rect1.y2);
		Line2D vehOne23 = new Line2D.Double(rect1.x2, rect1.y2, rect1.x3, rect1.y3);
		Line2D vehOne34 = new Line2D.Double(rect1.x3, rect1.y3, rect1.x4, rect1.y4);
		Line2D vehOne41 = new Line2D.Double(rect1.x4, rect1.y4, rect1.x1, rect1.y1);
		
		Line2D vehTwo12 = new Line2D.Double(rect2.x1, rect2.y1, rect2.x2, rect2.y2);
		Line2D vehTwo23 = new Line2D.Double(rect2.x2, rect2.y2, rect2.x3, rect2.y3);
		Line2D vehTwo34 = new Line2D.Double(rect2.x3, rect2.y3, rect2.x4, rect2.y4);
		Line2D vehTwo41 = new Line2D.Double(rect2.x4, rect2.y4, rect2.x1, rect2.y1);
		
		if(vehTwo12.intersectsLine(vehOne12)|| vehTwo12.intersectsLine(vehOne23)||
			vehTwo12.intersectsLine(vehOne34)||vehTwo12.intersectsLine(vehOne41))
			collisionProb=true;
		if(vehTwo23.intersectsLine(vehOne12)|| vehTwo23.intersectsLine(vehOne23)||
				vehTwo23.intersectsLine(vehOne34)||vehTwo23.intersectsLine(vehOne41))
				collisionProb=true;
		if(vehTwo34.intersectsLine(vehOne12)|| vehTwo34.intersectsLine(vehOne23)||
				vehTwo34.intersectsLine(vehOne34)||vehTwo34.intersectsLine(vehOne41))
				collisionProb=true;
		if(vehTwo41.intersectsLine(vehOne12)|| vehTwo41.intersectsLine(vehOne23)||
				vehTwo41.intersectsLine(vehOne34)||vehTwo41.intersectsLine(vehOne41))
				collisionProb=true;
		probability.add(collisionProb);
	}
}


/*
//Method to calculate haversine distance from latitudes and longitudes
public double haversine(double lat1, double lon1, double lat2, double lon2) {
    double dLat = Math.toRadians(lat2 - lat1);
    double dLon = Math.toRadians(lon2 - lon1);
    lat1 = Math.toRadians(lat1);
    lat2 = Math.toRadians(lat2);
    double a = Math.pow(Math.sin(dLat / 2),2) + Math.pow(Math.sin(dLon / 2),2)
    		   * Math.cos(lat1) * Math.cos(lat2);
    double c = 2 * Math.asin(Math.sqrt(a));
    return RADIUS * c;
}
*/


}
