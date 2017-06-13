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
ArrayList<PImage> billboardTextures;
PShape skybox;

int cameraOffsetZ = 2;
Boolean moving = true;

int numChunks = 3;
int numBuildingsPerChunk = 9;
int buildingSpacing = 150;

void setup(){
  //skybox = createShape(SPHERE);
  //skybox.scale(20);
  
  textures = new ArrayList();
  for (int i=0; i<3; i++){
    textures.add(createTexture(i));
  }
  
  billboardTextures = new ArrayList();
  fillBillboardTextures();
  
  noSmooth();

  sketchPApplet = this;
  //size(700, 700, P3D);
  fullScreen(STEREO);
  
  //cam = new QueasyCam(this);
  pc = new ProceduralCity(numChunks, numBuildingsPerChunk, buildingSpacing);
  ref = new ReferenceAxes();
  
  // Nearest neighbor texture sampling
  ((PGraphicsOpenGL)g).textureSampling(2);
  hint(DISABLE_TEXTURE_MIPMAPS);
  
}

void draw(){
  //println(frameRate);
  cameraToOrigin();
  if (moving) {
    cameraOffsetZ+=2;
    if (cameraOffsetZ%(buildingSpacing*sqrt(numBuildingsPerChunk)/2)==0){
      pc.addChunks();
    }
  }
  
  translate(-numChunks*sqrt(numBuildingsPerChunk)*buildingSpacing/2 + buildingSpacing/2, 100, -(numChunks/2)*sqrt(numBuildingsPerChunk)*buildingSpacing/2 -cameraOffsetZ);
  
  background(0);
  pc.update();
  pc.display();
  ref.display();
}

/////////////////////////////////////////////////

// INPUT

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

///////////////////////////////

// TEXTURES 

// I think this needs to be in a correct class
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

void fillBillboardTextures(){
  billboardTextures.add(loadImage("pixelartburger.jpg"));
  billboardTextures.add(loadImage("pixelartshark.jpg")); 
  PGraphics pg = createGraphics(80, 20);
  pg.beginDraw();
  pg.textAlign(CENTER,CENTER);
  pg.textSize(6);
  pg.noStroke();
  pg.textFont(loadFont("Microfuture-12.vlw"));
  pg.fill(color(50, 50, 50));
  pg.text("WORLD", pg.width/2 + 2, pg.height/2 + 2);
  pg.fill(color(255, 50, 150));
  pg.text("WORLD", pg.width/2, pg.height/2);
  pg.endDraw();
  pg.save("test.png");
  billboardTextures.add((PImage)pg);
  billboardTextures.add(loadImage("billboard.png"));
}