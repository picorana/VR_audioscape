//import queasycam.*;
import java.util.*;
import processing.vr.*;

//QueasyCam cam;
Terrain t;

void setup(){
  //size(600, 600, P3D);
  //cam = new QueasyCam(this);
  fullScreen(STEREO);
  t = new Terrain();
}

void draw() {
  background(255);
  lights();
  ambientLight(102, 102, 102);
 
  translate(0, 900, 1000);
  t.display();
  t.update();
  
  println(frameRate);
}

void mouseClicked(){
  save("screenshot.png");
}