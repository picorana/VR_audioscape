import queasycam.*;

PolySphere o;
PolySphere o2;
QueasyCam cam;

void setup(){

  size(displayWidth, displayHeight, P3D);
  orientation(LANDSCAPE);

  o = new PolySphere(200, "pyramid");
  o2 = new PolySphere(50, "spike");
  cam = new QueasyCam(this);
  
  //camera(100, 0, 0, 0, 0, 0, 0.0, 1.0, 0.0);
  
}

void draw(){
  background(50);
  pushMatrix();
  rotateY(millis()/1000.0);
  o.display();
  o2.display();
  popMatrix();
}

void mouseClicked(){
  save("screenshot.png");
}