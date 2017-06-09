import java.util.*;
import java.lang.instrument.Instrumentation;
//import processing.vr.*;
import queasycam.*;
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

QueasyCam cam;
ProceduralCity pc;
ReferenceAxes ref;
PApplet sketchPApplet;

int cameraOffsetZ = 0;
Boolean moving = false;

void setup(){
  noSmooth();

  sketchPApplet = this;
  size(700, 700, P3D);
  //fullScreen(STEREO);
  
  cam = new QueasyCam(this);
  pc = new ProceduralCity();
  ref = new ReferenceAxes();
  
  // Nearest neighbor texture sampling
  ((PGraphicsOpenGL)g).textureSampling(2);
  hint(DISABLE_TEXTURE_MIPMAPS);
  
  /* 
  CAMERA NEAR ISN'T WORKING
  println("camera near: " + ((PGraphicsOpenGL)sketchPApplet.g).cameraNear);
  ((PGraphicsVR)sketchPApplet.g).defCameraNear = 500;
  println("camera near: " + ((PGraphicsOpenGL)sketchPApplet.g).cameraNear);
  */
}

void draw(){
  //cameraToOrigin();
  if (moving) cameraOffsetZ++;
  translate(0, 10, -cameraOffsetZ);
  
  background(0);
  pc.update();
  pc.display();
  ref.display();
}

void mouseClicked(){
  save("screenshot.png");
}

void keyPressed(){
  if (key=='b') moving = false;
  if (key=='n') moving = true;
}

////////////////////////////////

// CAMERA ADJUSTING

void printCameraCoordinates(){
  if (frameCount%100==0){
    println("Camera X:" + ((PGraphicsOpenGL)sketchPApplet.g).cameraX);
    println("Camera Y:" + ((PGraphicsOpenGL)sketchPApplet.g).cameraY);
    println("Camera Z:" + ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
  }
}

void cameraToOrigin(){
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY + 50, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
}