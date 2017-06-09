//import queasycam.*;
import processing.vr.*;

PolySphere o;
PolySphere o2;
//QueasyCam cam;
//PShader lineShader;

PApplet sketchPApplet;

void setup(){

  sketchPApplet = this;
  
  //size(700, 700, P3D);
  //cam = new QueasyCam(this);
  
  fullScreen(STEREO);

  o = new PolySphere(500, "pyramid");
  o2 = new PolySphere(50, "spike");
  
  //lineShader = loadShader("linefrag.glsl", "linevert.glsl");
  
  printCameraCoordinates();
}

void draw(){ 
  background(50);
  translate(width/2, height/2, 100);
  pushMatrix();
  rotateY(millis()/1000.0);
  o.display();
  o2.display();
  popMatrix();
  //println(frameRate);
  
  //shader(lineShader);
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