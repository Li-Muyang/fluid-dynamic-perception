BDIM flow;
EllipseBody ellipse1; 
FloodPlot flood;
float time=0;
SaveData dat;
String datapath = "test101/";
int resolution_powIndex = 7;//resolution = 2^7
float ratio = 0.5;//ratio of h and a 
float length_rate = 0.125;//length compare to the resolution
int rotation_init = 180;//attack angle of the ellipse
int start_point = 3;//the center position of the ellipse
int max_time = 1000;//max simulation time 

int n=(int)pow(2,resolution_powIndex);
int m=(int)pow(2,resolution_powIndex);
float ellipseL = length_rate*n;
Window window = new Window(n,m);

void setup(){
  int n=(int)pow(2,resolution_powIndex);
  int m=(int)pow(2,resolution_powIndex);
  float ellipseL = length_rate*n;
  Window window = new Window(n,m);
  //float eccentricity=sqrt(1-ratio*ratio);//eccentricity temporarily not used
  size(800,800);      
  ellipse1 = new EllipseBody(ellipseL*start_point, m/2, ellipseL, ratio, window);
  ellipse1.rotate_init(PI/rotation_init);
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
  if (time % 10 == 0) {
    setUpNewSim();
  }
  if (time>max_time) exit();
}

void setUpNewSim() {
  rotation_init -= 1;
  ellipse1 = new EllipseBody(ellipseL*start_point, m/2, ellipseL, ratio, window);
  ellipse1.rotate_init(PI/rotation_init);
}
