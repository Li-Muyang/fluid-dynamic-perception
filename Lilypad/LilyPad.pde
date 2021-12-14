/*********************************************************
                  Main Window!

Click the "Run" button to Run the simulation.

Change the geometry, flow conditions, numerical parameters
visualizations and measurements from this window.

This screen has an example. Other examples are found at 
the top of each tab. Copy/paste them here to run, but you 
can only have one setup & run at a time.

*********************************************************/
// Circle that can be dragged by the mouse

/*
BDIM flow;
Body body;
FloodPlot flood;

void setup(){
  size(1000,1000);                             // display window size
  int n=(int)pow(2,7);                       // number of grid points
  float L = n/8.;                            // length-scale in grid units
  Window view = new Window(n,n);

  body = new EllipseBody(n/2,n/2,L,0.5,view);     // define geom
  flow = new BDIM(n,n,1.5,body);             // solve for flow using BDIM
  flood = new FloodPlot(view);               // initialize a flood plot...
  flood.setLegend("vorticity",-.5,.5);       //    and its legend
}
void draw(){
  body.follow();                             // update the body
  flow.update(body); flow.update2();         // 2-step fluid update
  flood.display(flow.u.curl());              // compute and display vorticity
  body.display();                            // display the body
}
void mousePressed(){body.mousePressed();}    // user mouse...
void mouseReleased(){body.mouseReleased();}  // interaction methods
void mouseWheel(MouseEvent event){body.mouseWheel(event);}
*/

/*
PI/6 = test1
PI/8 = test2
PI/10 = test3
0 = test4
PI/9 = test5
PI/7 = test6
PI/18 = test7
PI/12 = test8
*/

BDIM flow;
EllipseBody ellipse1; 
FloodPlot flood;
float time=0;
SaveData dat;
String datapath = "test101/";
int resolution_powIndex = 7;//resolution = 2^7
float ratio = 0.5;//ratio of h and a 
float length_rate = 0.125;//length compare to the resolution
float rotation_init = PI/4;//attack angle of the ellipse
int start_point = 3;//the center position of the ellipse
int max_time = 1000;//max simulation time 

void setup(){
  int n=(int)pow(2,resolution_powIndex);
  int m=(int)pow(2,resolution_powIndex);
  float ellipseL = length_rate*n;
  //float eccentricity=sqrt(1-ratio*ratio);//eccentricity temporarily not used
  size(800,800);      
  Window window = new Window(n,m);
  ellipse1 = new EllipseBody(ellipseL*start_point, m/2, ellipseL, ratio, window);
  ellipse1.rotate_init(rotation_init);
  dat = new SaveData(datapath+"One_point_pressure_test.txt", ellipse1.coords, (int)ellipseL, 8, 8, 1);
  flow = new BDIM(n,m,0.5,ellipse1,0,false);

  flood = new FloodPlot(window);
  flood.range = new Scale(-.5,.5);
  flood.setLegend("vorticity");
  flood.setColorMode(1);
}
void draw(){
  time += flow.dt;
  flow.update(ellipse1);
  flow.update2();
  flood.display(flow.u.curl());
  ellipse1.display();
  dat.addData(time, ellipse1.pressForce(flow.p), ellipse1, flow.p);
  if (time>max_time) exit();
}
