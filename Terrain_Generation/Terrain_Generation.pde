//import queasycam.*;
import java.util.*;
import processing.vr.*;

//QueasyCam cam;
Terrain t;
PApplet sketchPApplet;
int cameraOffsetZ = 2;
int strips_length = 1, tile_length = 20, strips_width = 100, strips_num = 100;
//PShader fogShader;

void setup(){
  sketchPApplet = this;
  
  //size(600, 600, P3D);
  //cam = new QueasyCam(this);
  fullScreen(STEREO);
  t = new Terrain(tile_length, strips_length, strips_width, strips_num);
  
  //fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
}

void draw() {
  cameraToOrigin();
  background(255);
 
  translate(- tile_length*strips_num/2, 350, -cameraOffsetZ - strips_num*tile_length*1.5);
  t.display();
  
  cameraOffsetZ++;
  if (cameraOffsetZ%(strips_length*tile_length)<1) t.addStrip();
  
  println(frameRate);
  //shader(fogShader);
}

void mouseClicked(){
  save("screenshot.png");
}

void cameraToOrigin(){
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY + 50, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
}