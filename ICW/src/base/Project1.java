package base;
import java.io.*;

public class Project1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String timeStamp;
        String latitude;
        String longtitude;
String csvFilePath = (String)args[0];
        String gps[][]= new String[200][3];
        Double xy[][]=new Double[200][5];
        Double R=6378.0;
        Double distance[]=new Double[200];
        Double time[]=new Double[200];
        Double speed[]=new Double[200];
        Double maximumspeed;
        Double minimumspeed;
        Double avgspeed=0.0;
        Double totaldist=0.0;
        Double heading[]=new Double[200];
        Double maximumheading;
        Double minimumheading;
        Double avgheading=0.0;
        Double totalheading=0.0;
        // TODO code application logic here
        try {
            if ((args != null) && (args.length > 0)) {

//                csvFilePath = Arrays.toString(args);
                System.out.println(csvFilePath);
            } else {
                System.out.println("Path of csv not given");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (csvFilePath != null) {
        	
            BufferedReader csvReader = null;
            try {
                csvReader = new BufferedReader(new FileReader(csvFilePath));
                String[] row = null;

                if (csvReader.lines()!= null) {// to skip field names
                    int i=0,j=0;
                    
                    while (((csvReader.readLine()) != null)) {
                        
                        try {
                            //Reading iinput
                            String csvline = csvReader.readLine();
                            row = csvline.split(",");
                            timeStamp = row[0];
                            gps[i][j]=timeStamp;j++;
                            latitude = row[1];
                            gps[i][j]=latitude;j++;
                            longtitude =(row[2]);
                            gps[i][j]=longtitude;j++;
                            i++;
                            j=0;
                            
                        } catch (Exception e) {
                            System.out.println("Error in csv data format ");
                            e.printStackTrace();
                        }
                    }
                  for(int k=0;k<200;k++)
                  {
                      if(gps[k][1]==null)
                          continue;
                      //Calculation for x,y,hr,min,sec.
                    xy[k][0]=R*Math.cos(Double.parseDouble(gps[k][2]))*Math.cos(Double.parseDouble(gps[k][1]));
                    xy[k][1]=R*Math.cos(Double.parseDouble(gps[k][2]))*Math.sin(Double.parseDouble(gps[k][1]));
                    char[] temp=new char[50];
                    temp=gps[k][0].toCharArray();
                    xy[k][2]=Double.parseDouble(Character.toString(temp[11]))*10+Double.parseDouble(Character.toString(temp[12]));
                    xy[k][3]=Double.parseDouble(Character.toString(temp[14]))*10+Double.parseDouble(Character.toString(temp[15]));
                    xy[k][4]=Double.parseDouble(Character.toString(temp[17]))*10+Double.parseDouble(Character.toString(temp[18]));
                    
                  }
                   for(int k=0;k<199;k++)
                  {     //calculation of distance,time difference, speed.
                      if(xy[k+1][0]==null)
                          continue;
                      distance[k]=Math.sqrt((xy[k][0]-xy[k+1][0])*(xy[k][0]-xy[k+1][0])+(xy[k][1]-xy[k+1][1])*(xy[k][1]-xy[k+1][1]));
                      time[k]=(xy[k][2]-xy[k+1][2])*60*60+(xy[k][3]-xy[k+1][3])*60+(xy[k][4]-xy[k+1][4]);
                      speed[k]=distance[k]/time[k];
                      heading[k]=Math.atan2(xy[k][0],xy[k][1]);
                  }
                 maximumspeed=speed[0];
                 minimumspeed=speed[0];
                 maximumheading=heading[0];
                 minimumheading=heading[0];
               
                  for(int k=0;k<199;k++)
                  {
                      if(speed[k+1]==null)
                          continue;
                      if(speed[k+1]>speed[k])
                      maximumspeed=speed[k+1];
                      if(speed[k+1]<speed[k])
                          minimumspeed=speed[k];
                      totaldist=totaldist+speed[k];
                   
                  if(heading[k+1]>heading[k])
                      maximumheading=heading[k+1];
                      if(heading[k+1]<heading[k])
                          minimumheading=heading[k];
                      totalheading=totalheading+heading[k];               
                  }
                  avgspeed=totaldist/200;
                  avgheading=totalheading/200;
                    System.out.print("totaldist");
                    System.out.println(totaldist);
                    System.out.print("speed");
                    System.out.println(maximumspeed);
                    System.out.println(minimumspeed);
                    System.out.println(avgspeed);
                    System.out.print("heading");
                    System.out.println(maximumheading);
                    System.out.println(minimumspeed);
                    System.out.println(avgheading);
                    
                }
            } catch (FileNotFoundException e) {
            	e.printStackTrace();
                System.out.println("csv file is not uploaded");
            } catch (IOException e) {
                System.out.println("Error while reading details from csv");
            } finally {
                try {
                    if (csvReader != null) {
                        csvReader.close();
                    }
                } catch (IOException e) {
                    System.out.println("Error while reading from csv");
                }
            }
        }
    }
    
}
