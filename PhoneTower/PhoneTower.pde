import peasy.*;

int scale = 100;
int numHeight = 5;
PShape face;
PeasyCam cam;

void setup(){
  size(600, 600, P3D);
  face = multipleFace();
  cam = new PeasyCam(this, 0);
}

void draw(){
  background(0);
  translate(width/2, height/2);
  shape(face);
}

PShape multipleFace(){
  PShape s = createShape(GROUP);
  for (int j=0; j<numHeight; j++){
    for (int i=0; i<4; i++){
      PShape newFace = createFace( i%2 == 0 ? color(255, 255, 255) : color(255, 0, 0) );
      if (i==0) newFace.translate(0, scale*j, 0);
      if (i==1) newFace.translate(-scale*2, scale*j, 0);
      if (i==2) newFace.translate(-scale*2, scale*j, -scale*2);
      if (i==3) newFace.translate(0, scale*j, -scale*2);
      newFace.rotateY(PI/2*i);
      //newFace.rotateX(PI*j);
      s.addChild(newFace);
    }
  }

  return s;
}

PShape createFace(color c){
  PShape s = createShape();
  s.beginShape();
  s.stroke(c);
  s.strokeWeight(5);
  s.noFill();
  s.vertex(0*scale, 0*scale);
  s.vertex(0*scale, 1*scale);
  s.vertex(0*scale, 0*scale);
  s.vertex(1*scale, 1*scale);
  s.vertex(1*scale, 1*scale);
  s.vertex(2*scale, 0*scale);
  s.vertex(2*scale, 0*scale);
  s.vertex(2*scale, 1*scale);
  s.endShape();
  return s;
}