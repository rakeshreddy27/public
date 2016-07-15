package base;

import java.awt.geom.Line2D;
import java.text.ParseException;

public class Test {
	public static void main(String[] args) throws ParseException {
/*		Icw ic=new Icw();
		Icw.coordinates cor1=ic.new coordinates();
		Icw.coordinates cor2=ic.new coordinates();
		cor1=ic.GpsToCoordinates(-83.19120689, 42.50300772);
		//System.out.println(cor1.getX()+ " "+cor1.getY()+" "+cor1.getZ());
		cor2=ic.GpsToCoordinates(-83.19108405, 42.50301042);
		//System.out.println(cor2.getX()+ " "+cor2.getY()+" "+cor2.getZ());
		System.out.println(ic.distBtwnCoordinates(cor2, cor1));
		//System.out.println(ic.haversine(42.50301042, -83.19108405, 42.50300772, -83.19120689));
		System.out.println(ic.time("2013-01-14T21:05:01Z","2013-01-14T21:05:11Z"));
		ic.readFile("input.csv");
		
		Line2D l1 = new Line2D.Double(0, 0, 20.03, 20.22);
		Line2D l2 = new Line2D.Double(5, 0, 0, 5);
		System.out.println("l1.intsects(l2) = " + l1.intersectsLine(l2));*/
		
		Icw ic=new Icw();
		ic.readFile("input.csv");
		ic.calculateRectCoor(1);
		ic.calculateRectCoor(2);
		ic.probablity();
		System.out.println(ic.probability.size());
		for(Boolean b:ic.probability){
			System.out.println(b);
		}
	}

}
