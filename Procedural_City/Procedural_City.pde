import java.util.*;
//import processing.vr.*;
import queasycam.*;
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;


QueasyCam cam;
ProceduralCity pc;

PApplet sketchPApplet;

void setup(){
  noSmooth();

  sketchPApplet = this;
  size(700, 700, P3D);
  //fullScreen(STEREO);
  cam = new QueasyCam(this);
  
  pc = new ProceduralCity();
}

void draw(){
  background(0);
  //lights();
  pc.update();
  pc.display();
}

void mouseClicked(){
  save("screenshot.png");
}