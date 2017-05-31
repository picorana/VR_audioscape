import queasycam.*;

QueasyCam cam;

float noiseScale = 0.02;
float y_scale = 200;
int terrain_length = 100, tile_length = 5;
int waterHeight = -10;
PShape s;

void setup(){
  size(600, 600, P3D);
  cam = new QueasyCam(this);
  s = createTerrain();
}

void draw() {
  background(50);
  translate(0, 100, 0);
  shape(s, 0, 0);
}

PShape createTerrain(){
  PShape s = createShape(GROUP);
  
  for (int i=0; i<terrain_length; i++){
    for (int j=0; j<terrain_length; j++){
      PShape r = createShape();
      r.beginShape();
      r.stroke(255);
      r.fill(50);
      
      float y0 = -noise(i*tile_length*noiseScale, j*tile_length*noiseScale)*y_scale;
      float y1 = -noise((i*tile_length+tile_length)*noiseScale, j*tile_length*noiseScale)*y_scale;
      float y2 = -noise((i*tile_length+tile_length)*noiseScale, (j*tile_length+tile_length)*noiseScale)*y_scale;
      float y3 = -noise((i*tile_length)*noiseScale, (j*tile_length+tile_length)*noiseScale)*y_scale;
      
      r.vertex(i*tile_length, y0, j*tile_length);
      r.vertex(i*tile_length + tile_length, y1, j*tile_length);
      r.vertex(i*tile_length + tile_length, y2, j*tile_length + tile_length);
      r.vertex(i*tile_length, y3, j*tile_length + tile_length);
      r.endShape(CLOSE);
      s.addChild(r);
    }
  }
  
  return s;
}

void mouseClicked(){
  save("screenshot.png");
}