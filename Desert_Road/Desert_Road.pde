
/* TODO:
*  solve cracks in the road issue
*  solve color + texture shader
*  add houses! and phone towers! and maybe plants!
*  grass blades aren't removed when camera is too far
*  Terrain:
*    - are we wasting resources by keeping an arraylist of PShapes? Is there a better way to do this?
*    - better use a quad strip instead of custom PShapes?
*  move every util function into util class?
*  load configuration from json file?
*  the normals of the terrain are wrong. meh.
*
*  Things I'd like to do in the future:
*    - Put very far mountains in the background
*/

//import queasycam.*;
import java.util.*;
import processing.vr.*;

//QueasyCam cam;
PApplet sketchPApplet;
boolean recording   = false;
boolean grassEnabled = false;
int colorScheme = 0;

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
  //size(700, 700, P3D);
  fullScreen(STEREO);
}


void setup(){
  
  sketchPApplet = this;
  
  //cam = new QueasyCam(this);
  
  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  
  skybox = createShape(SPHERE, 1000);
  skybox.setFill(skyboxColor);
  skybox.setStroke(false);
  
  terrain = new Terrain(tile_length, strips_length, strips_width, strips_num);
  
  fogShader.set("fogMinDistance", 700.0);
  fogShader.set("fogMaxDistance", 800.0);
  setColorScheme(colorScheme);
  terrain.startTerrain();
}

void draw() {
  background(skyboxColor);
  
  cameraCenter();
  
  // move the curve of the road according to a sine wave
  curveValue += sin(frameCount/100.0)*.1; 
  
  terrain.display();
  
  if (moving) cameraOffsetZ+=2;
  if (cameraOffsetZ%(strips_length*tile_length)<1) terrain.addStrip();
  
  if (shaderEnabled) shader(fogShader);
  
  //println(frameRate);
  if (recording && (frameCount%5)==0) saveFrame("line-######.png");
}


// function used to change the colors
// 0 --> day, 1 --> night
void setColorScheme(int colorScheme){
  if (colorScheme == 0){
    terrain.setColorScheme(color(204, 102, 0), color(173, 152, 122));
    skyboxColor = color(255, 255, 255);
    skybox.setFill(skyboxColor);
    fogShader.set("fogColor", 1.0, 1.0, 1.0);
    fogShader.set("lightingEnabled", false);
  } else if (colorScheme == 1){
    terrain.setColorScheme(#0A252C, #0A252C);
    skyboxColor = color(50, 93, 102);
    skybox.setFill(skyboxColor);
    fogShader.set("fogColor", 50.0/255, 93.0/255, 102.0/255);
    fogShader.set("lightingEnabled", true);
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
  cameraToOrigin();
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