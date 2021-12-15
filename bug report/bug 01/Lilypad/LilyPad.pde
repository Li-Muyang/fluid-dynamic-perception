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
String datapath = "rotate/";

int resolution = 32;final int Chord_lengthbyY = 8;//gird resolution
float ratio = 0.5;//ratio of h and a 
float rotation_init = 0;//attack angle of the ellipse//you should use PI here. In my code i wont use this init --tree
int start_point = 3;//the center position of the ellipse
int max_time = 180000;//max simulation time 
int n=resolution*Chord_lengthbyY ;
int m=resolution*Chord_lengthbyY;
float Re = 6000;//Re=6000
float nu = resolution/Re;
int countRotate = 0;//rotate shall be smooth, see at void draw()

void setup(){
  //float eccentricity=sqrt(1-ratio*ratio);//eccentricity temporarily not used
  size(800,800);      
  Window window = new Window(n,m);
  ellipse1 = new EllipseBody((int)resolution*start_point, m/2, (int)resolution, ratio, window);
  //ellipse1.rotate_init(PI/rotation_init);//i would rotate it from 0 to PI
  dat = new SaveData(datapath+"One_point_pressure_test.txt", ellipse1.coords, resolution, 8, 8, 1);
  flow = new BDIM(n,m,0.5,ellipse1,nu,true);

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
  if (time % 1000 == 0) countRotate = 0;
  if(countRotate<10){//rotate shall be smooth       
    ellipse1.rotate(PI/180*0.1);//everytime rotate 0.1, in all 10 steps rotate 1
    countRotate += 1;
  }
    
  if (time>max_time) exit();
}
