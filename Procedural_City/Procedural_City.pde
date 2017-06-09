import java.util.*;
import java.lang.instrument.Instrumentation;
import processing.vr.*;
//import queasycam.*;
import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

//QueasyCam cam;
ProceduralCity pc;
ReferenceAxes ref;
PApplet sketchPApplet;

ArrayList<PImage> textures;

int cameraOffsetZ = 2;
Boolean moving = true;

void setup(){
  
  textures = new ArrayList();
  for (int i=0; i<3; i++){
    textures.add(createTexture(i));
  }
  
  noSmooth();

  sketchPApplet = this;
  //size(700, 700, P3D);
  fullScreen(STEREO);
  
  //cam = new QueasyCam(this);
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
  cameraToOrigin();
  if (moving) {
    cameraOffsetZ+=2;
    if (cameraOffsetZ%(5*150)==0){
      pc.addChunks();
    }
  }
  
  translate(20, 300, -cameraOffsetZ);
  
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

PImage createTexture(int chunkType){
  float resolution = 0.5;
  float size = 30;
  float building_height = 200;
  
  PImage img = createImage((int)(size*resolution*4), (int)(building_height*resolution), ARGB);

  img.loadPixels();

  for (int x=0; x<img.width; x++){
    for (int y=0; y<img.height; y++){
      int i = (int)(x+y*img.width);
      if (chunkType==0){
        if (y%5==0) img.pixels[i] = color(200, 200+y, 200+y);
        else img.pixels[i] = color(50, 50+y, 50+ y);
      } else if (chunkType == 1) {
        if (y%5==0) img.pixels[i] = color(200+y, 200, 200+y);
        else img.pixels[i] = color(50+y, 50, 50+ y);
      } else if (chunkType == 2) {
        if (y%5==0) img.pixels[i] = color(200+y, 200+y, 200);
        else img.pixels[i] = color(50+y, 50+y, 50);
      }
    }
  }

  img.updatePixels();
  return img;
}