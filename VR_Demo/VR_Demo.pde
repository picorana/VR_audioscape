//import queasycam.*;
import processing.vr.*;

PolySphere o;
PolySphere o2;
//QueasyCam cam;

void setup(){

  //size(700, 700, P3D);
  fullScreen(STEREO);

  o = new PolySphere(500, "pyramid");
  o2 = new PolySphere(50, "spike");
  //cam = new QueasyCam(this);
  
  //camera(100, 0, 0, 0, 0, 0, 0.0, 1.0, 0.0);
  
}

void draw(){
  background(50);
  smooth();
  translate(width/2, height/2, 100);
  pushMatrix();
  rotateY(millis()/1000.0);
  o.display();
  o2.display();
  popMatrix();
  println(frameRate);
}

void mouseClicked(){
  save("screenshot.png");
}