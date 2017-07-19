
/* TODO:
*  solve cracks in the road issue
*  solve color + texture shader
*  add houses! and phone towers! and maybe plants!
*  grass blades aren't removed when camera is too far
*  cacti aren't removed too
*  uhh is the stroke around cacti nice?
* 
*  Terrain:
*    - are we wasting resources by keeping an arraylist of PShapes? Is there a better way to do this?
*    - better use a quad strip instead of custom PShapes?
*  move every util function into util class?
*  load configuration from json file?
*  the normals of the terrain are wrong. meh.
*
*/

//import queasycam.*;
//import peasy.*;
import java.util.*;

import processing.vr.*;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;

//QueasyCam cam;
//PeasyCam cam;
PApplet sketchPApplet;
boolean recording   = false;
boolean grassEnabled = false;
int colorScheme = 0;

// Shader data
PShader skyShader;
PShader fogShader;
boolean shaderEnabled = false;

// Terrain data
Terrain terrain;
int strips_length   = 1;
int tile_length     = 50;
int strips_width    = 60;
int strips_num      = 80;

Dunes dunes;

// Skybox data
PShape skybox;
boolean skyboxEnabled = true;
color skyboxColor   = color(200, 200, 255);

// Movement data
boolean moving = true;
float curveValue    = 0;
int cameraOffsetZ   = 2;

// Memory management
long freeMemory; 

ArrayList<Cactus> cacti;

MusicAnalyzer ma;
Visualizer mVisualizer;
boolean recordAudioPermission = false;

void settings(){
  smooth();
  //size(1000, 700, P3D);
  fullScreen(STEREO);
}


void setup(){
  
  requestPermission("android.permission.RECORD_AUDIO", "permissionCallback");
  
  sketchPApplet = this;
  
  //cam = new QueasyCam(this);
  //cam = new PeasyCam(this, 1000);
  //cam.setMaximumDistance(50000);
  
  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  
  skybox = createSkybox();
  
  terrain = new Terrain(tile_length, strips_length, strips_width, strips_num);
  
  fogShader.set("fogMinDistance", 1100.0);
  fogShader.set("fogMaxDistance", 1300.0);
  setColorScheme(colorScheme);
  terrain.startTerrain();
  
  cacti = new ArrayList();
  cacti.add(new Cactus(new PVector(0, 0, 0)));
  
  dunes = new Dunes();
}

void draw() {
  println("framerate: " + frameRate);
  
  background(skyboxColor);
  if (skyboxEnabled) shape(skybox);
  dunes.display();
  
  cameraCenter();
  
  // move the curve of the road according to a sine wave
  curveValue += sin(frameCount/20.0)*.2; 
  
  terrain.display();
  
  for (int i=0; i<cacti.size(); i++){
    cacti.get(i).display();
    if (abs(cacti.get(i).position.z - cameraOffsetZ) >=2000) {
      //println("removing cactus x:" + cacti.get(i).position.x);
      cacti.remove(i);
    }
  }
  
  //if (random(0, 1)<.015) cacti.add(new Cactus(new PVector(-curveValue*tile_length, 0, cameraOffsetZ)));
  //if (random(0, 1)<.005) cacti.add(new Cactus(new PVector(-curveValue*tile_length + 600, 0, cameraOffsetZ)));
  
  if (moving) cameraOffsetZ+=tile_length;
  if (recordAudioPermission) terrain.addMusicStrip(ma.analyze());

  //if (cameraOffsetZ%(strips_length*tile_length)<1) terrain.addStrip();
  
  if (shaderEnabled) shader(fogShader);
  
  if (recording && (frameCount%5)==0) saveFrame("line-######.png");
}


// function used to change the colors
// 0 --> day, 1 --> night
void setColorScheme(int colorScheme){
  if (colorScheme == 0){
    terrain.setColorScheme(color(204, 102, 0), color(173, 152, 122));
    skyboxColor = color(255, 255, 255);
    //skybox.setFill(skyboxColor);
    fogShader.set("fogColor", 225/255.0, 211/255.0, 190/255.0);
    fogShader.set("lightingEnabled", false);
  } else if (colorScheme == 1){
    terrain.setColorScheme(#185768, #308096);
    skyboxColor = color(50, 93, 102);
    skyboxEnabled = true;
    //skybox.setFill(skyboxColor);
    fogShader.set("fogColor", 50.0/255, 93.0/255, 102.0/255);
    fogShader.set("lightingEnabled", true);
  }
}


PShape createSkybox(){
  PShape p = createShape(BOX, 9000);
  PShape s = createShape();
  p.setFill(color(#7EB583));
  s.beginShape(QUADS);
  s.noStroke();
  s.translate(0, -200);
  for (int i=0; i<p.getVertexCount(); i++){
    PVector v = p.getVertex(i);
    if (v.y<100) s.fill(color(#7EB583));
    else s.fill(color(255, 255, 255));
    s.vertex(v.x, v.y, v.z);
  }
  s.scale(1, 0.8, 1);
  s.endShape();
  return s;
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
  translate(- tile_length*strips_num*.5 /*- curveValue*tile_length*2*/, 350, -cameraOffsetZ - strips_num*tile_length*1.5);
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

void permissionCallback(boolean granted){
  if (granted){
    ma = new MusicAnalyzer();
    recordAudioPermission = true;
  }
}