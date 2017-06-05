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

PShape s;


void setup(){
  noSmooth();

  sketchPApplet = this;
  //size(700, 700, P3D);
  noSmooth();
  fullScreen(STEREO);
  //cam = new QueasyCam(this);
  
  pc = new ProceduralCity();

  s = createShape(BOX, 400);
  PImage img = loadImage("pixelartmodels/building1.png");
  //Texture t = new Texture(((PGraphicsOpenGL)g), img.width, img.height);
  
  s.setTexture(loadImage("pixelartmodels/building1.png"));
  Texture t = s.image;
  hint(DISABLE_TEXTURE_MIPMAPS);
}

void draw(){

  background(0);
  //lights();
  //pc.update();
  //pc.display();
  shape(s, 0, 0);

}

void mouseClicked(){
  save("screenshot.png");
}