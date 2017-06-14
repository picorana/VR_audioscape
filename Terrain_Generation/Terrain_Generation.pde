//import queasycam.*;
import java.util.*;
import processing.vr.*;

//QueasyCam cam;
Terrain t;
PApplet sketchPApplet;
int cameraOffsetZ = 2;
int strips_length = 1, tile_length = 20, strips_width = 100, strips_num = 100;

void setup(){
  sketchPApplet = this;
  
  //size(600, 600, P3D);
  //cam = new QueasyCam(this);
  fullScreen(STEREO);
  t = new Terrain(tile_length, strips_length, strips_width, strips_num);
}

void draw() {
  cameraToOrigin();
  background(color(50, 102, 153));
  lights();
  ambientLight(102, 102, 102);
 
  translate(- tile_length*strips_num/2, 500, -cameraOffsetZ - strips_num*tile_length*1.5);
  t.display();
  
  cameraOffsetZ++;
  if (cameraOffsetZ%(strips_length*tile_length)<1) t.addStrip();
  
  println(frameRate);
}

void mouseClicked(){
  save("screenshot.png");
}

void cameraToOrigin(){
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY + 50, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
}