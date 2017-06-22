
/* TODO:
*  solve cracks in the road issue
*  solve problem with starting road (it's straight)
*  move road to proper class
*  solve color + texture shader
*  manage colors on terrain by using different colors for different vertices
*  refactor & comment everything
*  try plants
*  I'd rethink the way the terrain is implemented:
*    - are we wasting resources by keeping an arraylist of PShapes? Is there a better way to do this?
*    - better use a quad strip instead of custom PShapes?
*  move every util function into util class?
*/

import queasycam.*;
import java.util.*;
//import processing.vr.*;

QueasyCam cam;
PApplet sketchPApplet;
boolean recording   = false;

PShader fogShader;

// Terrain data
Terrain t;
int strips_length   = 1;
int tile_length     = 20;
int strips_width    = 100;
int strips_num      = 100;

// Movement data
float curveValue    = 0;
int cameraOffsetZ   = 2;

// Memory management
long freeMemory; 


void setup(){
  size(600, 600, P3D);
  cam = new QueasyCam(this);
  //fullScreen(STEREO);
  
  sketchPApplet = this;
  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  
  t = new Terrain(tile_length, strips_length, strips_width, strips_num);
}

void draw() {
  background(255);
  cameraToOrigin(); // set the camera position to [0, 0, 0]
  
  curveValue += sin(frameCount/100.0)*.1; // move the curve according to a sine wave
  
  translate(- tile_length*strips_num*.5, 350, -cameraOffsetZ - strips_num*tile_length*1.5);
  
  t.display();
  
  cameraOffsetZ+=2;
  if (cameraOffsetZ%(strips_length*tile_length)<1) t.addStrip();
  
  shader(fogShader);
  
  //println(frameRate);
  if (recording && (frameCount%5)==0) saveFrame("line-######.png");
}


void mouseClicked(){
  save("screenshot.png");
}


void keyPressed(){
  if (key=='l'){
    println("curveValue: " + --curveValue);
  }
  if (key=='r'){
    println("curveValue: " + ++curveValue);
  }
  if (key=='c'){
    if (recording == false) recording = true;
    else recording = false;
  }
}


// sets the camera position to [0, 0, 0]
void cameraToOrigin(){
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
}


// queries the memory of the phone to understand how much memory is the app using
long getMemorySize() {
  long freeSize = 0L;
  long totalSize = 0L;
  long usedSize = -1L;
  try {
    Runtime info = Runtime.getRuntime();
    freeSize = info.freeMemory();
    totalSize = info.totalMemory();
    usedSize = totalSize - freeSize;
    println("free memory: " + freeSize);
    println("total memory: " + totalSize);
    println("used memory: " + usedSize);
  } catch (Exception e) {
    e.printStackTrace();
  }
  return freeSize;
}