
/* TODO:
*  solve cracks in the road issue
*  solve color + texture shader
*  refactor & comment everything
*  try plants
*  grass blades aren't removed when camera is too far
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
boolean grassEnabled = false;

// Shader data
PShader skyShader;
PShader fogShader;
boolean shaderEnabled = true;

// Terrain data
Terrain terrain;
int strips_length   = 1;
int tile_length     = 30;
int strips_width    = 100;
int strips_num      = 100;

// Skybox data
PShape skybox;
color skyboxColor   = color(200, 200, 255);

// Movement data
boolean moving = true;
float curveValue    = 0;
int cameraOffsetZ   = 2;

// Memory management
long freeMemory; 

void settings(){
  smooth();
  size(700, 700, P3D);
}

void setup(){
  
  sketchPApplet = this;
  
  cam = new QueasyCam(this);
  //fullScreen(STEREO);
  
  skyShader = loadShader("sky7.glsl");
  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  
  //skyShader.set("iResolution", float(width), float(height));
  //skyShader.set("iMouse", float(mouseX), float(mouseY));
  
  skybox = createShape(SPHERE, 1000);
  skybox.setFill(skyboxColor);
  skybox.setStroke(false);
  
  terrain = new Terrain(tile_length, strips_length, strips_width, strips_num);
  
  fogShader.set("fogMinDistance", 700.0);
  fogShader.set("fogMaxDistance", 800.0);
  setColorScheme(1);
}

void draw() {
  background(255);

  shape(skybox);
  
  //filter(skyShader);
  
  cameraCenter();
  
  curveValue += sin(frameCount/100.0)*.1; // move the curve according to a sine wave
  
  terrain.display();
  
  if (moving) cameraOffsetZ+=2;
  if (cameraOffsetZ%(strips_length*tile_length)<1) terrain.addStrip();
  
  if (shaderEnabled) shader(fogShader);
  
  //println(frameRate);
  if (recording && (frameCount%5)==0) saveFrame("line-######.png");
}


void setColorScheme(int colorScheme){
  if (colorScheme == 0){
    terrain.setColorScheme(color(204, 102, 0), color(173, 152, 122));
    skybox.setFill(color(200, 200, 255));
    fogShader.set("fogColor", 1, 0.96957, 0.88235);
  } else if (colorScheme == 1){
    //terrain.setColorScheme(#0A252C, #325D66);
    terrain.setColorScheme(#0A252C, #0A252C);
    skybox.setFill(color(50, 93, 102));
    fogShader.set("fogColor", 50.0/255, 93.0/255, 102.0/255);
  }
}


void mouseClicked(){
  save("screenshot.png");
}


void keyPressed(){
  if (key == 'c'){
    if (recording == false) recording = true;
    else recording = false;
  } 
  if (key == 'v'){
    if (shaderEnabled) shaderEnabled = false;
    else shaderEnabled = true;
  }
}

// sets the camera to terrain center
void cameraCenter(){
  //cameraToOrigin();
  translate(- tile_length*strips_num*.5, 350, -cameraOffsetZ - strips_num*tile_length*1.5);
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