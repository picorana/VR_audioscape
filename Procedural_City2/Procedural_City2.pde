import java.util.*;
import processing.vr.*;
//import queasycam.*;
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;
import processing.opengl.*;

//QueasyCam cam;
ProceduralCity pc;
Reference_axes ref;

PApplet sketchPApplet;

PShape s1, s2;

void setup(){

  sketchPApplet = this;
  
  //size(700, 700, P3D);
  fullScreen(STEREO);
  
  //cam = new QueasyCam(this);
  ref = new Reference_axes();
  
  s1 = loadShape("building1.obj");
  s1.setTexture(loadImage("building1.png"));
  s1.scale(50);
  
  s2 = loadShape("building2.obj");
  s2.setTexture(loadImage("building2.png"));
  s2.scale(20);
  
  noSmooth();
  ((PGraphicsOpenGL)g).textureSampling(2);
  hint(DISABLE_TEXTURE_MIPMAPS);
  
}

void draw(){

  background(0);
  lights();
  ambientLight(255, 255, 255);
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY + 1000, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
  
  pushMatrix();
  rotateX(PI);
  //translate(520, -650, -200);
  translate(500, 0, 0);
  shape(s1, 0, 0);
  popMatrix();
  
  pushMatrix();
  rotateX(PI);
  //translate(520, -650, -430);
  translate(0, 0, 500);
  shape(s2, 0, 0);
  popMatrix();

  ref.display();

}

void mouseClicked(){
  save("screenshot.png");
}

void printCameraCoordinates(){
  if (frameCount%100==0){
    println("Camera X:" + ((PGraphicsOpenGL)sketchPApplet.g).cameraX);
    println("Camera Y:" + ((PGraphicsOpenGL)sketchPApplet.g).cameraY);
    println("Camera Z:" + ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
  }
}