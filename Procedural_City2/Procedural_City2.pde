import java.util.*;
import processing.vr.*;
//import queasycam.*;
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;
import processing.opengl.*;


//QueasyCam cam;
ProceduralCity pc;

PApplet sketchPApplet;

PShape s1, s2;


void setup(){
  noSmooth();

  sketchPApplet = this;
  //size(700, 700, P3D);

  fullScreen(STEREO);
  //cam = new QueasyCam(this);
  
  s1 = loadShape("building1.obj");
  s1.setTexture(loadImage("building1.png"));
  s1.scale(50);
  
  s2 = loadShape("building2.obj");
  s2.setTexture(loadImage("building2.png"));
  s2.scale(20);
  
  ((PGraphicsOpenGL)g).textureSampling(2);
  hint(DISABLE_TEXTURE_MIPMAPS);
}

void draw(){

  background(0);
  lights();
  ambientLight(255, 255, 255);
  
  pushMatrix();
  rotateX(PI);
  translate(520, -650, -200);
  shape(s1, 0, 0);
  popMatrix();
  
  pushMatrix();
  rotateX(PI);
  translate(520, -650, -430);
  shape(s2, 0, 0);
  popMatrix();

}

void mouseClicked(){
  save("screenshot.png");
}