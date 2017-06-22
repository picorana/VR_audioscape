import queasycam.*;
import java.util.*;
//import processing.vr.*;

QueasyCam cam;
Terrain t;
PApplet sketchPApplet;
int cameraOffsetZ = 2;
int strips_length = 1, tile_length = 20, strips_width = 100, strips_num = 100;
PShader fogShader;

float curveValue = 0;

long freeMemory;
boolean recording = false;

void setup(){

  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  size(600, 600, P3D);
  cam = new QueasyCam(this);
  //fullScreen(STEREO);
  sketchPApplet = this;
  
  t = new Terrain(tile_length, strips_length, strips_width, strips_num);
  
  println("strips_width: " + strips_width);
  println("strips_num: " + strips_num);
  
}

void draw() {
  
  curveValue = sin(float(frameCount)/100.0)*20.0;
  
  cameraToOrigin();
  background(255);
 
  translate(- tile_length*strips_num/2, 350, -cameraOffsetZ - strips_num*tile_length*1.5);
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

void cameraToOrigin(){
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY + 50, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
}

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