
import java.awt.geom.Line2D;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.Math;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;

public class ICW{
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
		System.out.println("Reading the input file...");
		int line=0;
		Boolean first=true;
		BufferedReader br = null;
		String sCurrentLine = null;
		try {
			br = new BufferedReader(new FileReader(filePath));
			while ((sCurrentLine = br.readLine()) != null) {
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
	return Math.abs(seconds);
    }

//Method to calculate the coordinate of the rectangle at each second
public void calculateRectCoor(int vehiclenumber){
	System.out.println("Calculating the coordinates of rectangle for vehicle"+vehiclenumber+"...");
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
		}else{
			v2Rectangles.add(rect);
		}
	}
}
//Method to calculate probability if two rectangles intersect 
public void probablity(){
	System.out.println("Calculating the probability of collision at each time frame...");
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

//Method to create a output.kml file for the given input
public void createKML(){
	System.out.println("Generating the .KML File.....");
	try{
	String exampleString="<Placemark><TimeStamp><when>ReplaceTimestamp</when></TimeStamp><styleUrl>"
			+ "ReplaceIcontype</styleUrl><Point><coordinates>ReplaceCoordinates"
			+ "</coordinates></Point></Placemark>";
	String path="output.kml";
    File file = new File(path);
    FileWriter fw = new FileWriter(file.getAbsoluteFile());
    @SuppressWarnings("resource")
	BufferedWriter bw = new BufferedWriter(fw);
    @SuppressWarnings("resource")
	BufferedReader br = new BufferedReader(new FileReader("KmlTemplate.txt"));
    String sCurrentLine=null;
    
    //Write every thing from template to the output file(This includes styles)
	while ((sCurrentLine = br.readLine()) != null) {
		bw.write(sCurrentLine+"\n");
	}
	
for(int i=0;i<probability.size();i++){
	
	String icon;
	if(probability.get(i))
		icon="#msn_cabs3";
	else
		icon="#msn_cabs1";

	String[] V1detailsArr = v1inputStrings.get(i).split(",");
	String finalString= exampleString.replace("ReplaceTimestamp", V1detailsArr[1])
			.replace("ReplaceIcontype", icon).replace("ReplaceCoordinates",
					V1detailsArr[2]+","+V1detailsArr[3]+",0");
	bw.write(finalString+"\n");
}

for(String s:v2inputStrings){
	String[] V2detailsArr = s.split(",");
	String finalString= exampleString.replace("ReplaceTimestamp", V2detailsArr[1])
			.replace("ReplaceIcontype", "#msn_cabs2").replace("ReplaceCoordinates",
					V2detailsArr[2]+","+V2detailsArr[3]+",0");
	bw.write(finalString+"\n");
	
}

bw.write("</Document></kml>\n");
bw.close();
br.close();

	}catch(Exception e){
		System.out.println("Error creating the .KML file");
		e.printStackTrace();
	}
    }

//Running the code
public static void main(String[] args){
	if ((args != null) && (args.length > 0)) {
	    String csvFilePath = (String)args[0];
	    ICW ic=new ICW();
		ic.readFile(csvFilePath);
		ic.calculateRectCoor(1);
		ic.calculateRectCoor(2);
		ic.probablity();
		ic.createKML();
		System.out.println("Done");
  } else {
      System.out.println("Path of csv not given");
  }
}


}
