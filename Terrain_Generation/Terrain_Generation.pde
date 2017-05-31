import queasycam.*;

QueasyCam cam;

float noiseScale = 0.008;
float y_scale = 200;
int terrain_length = 200, tile_length = 2;
int water_level = -75;
PShape s;

void setup(){
  size(600, 600, P3D);
  cam = new QueasyCam(this);
  s = createTerrain();
}

void draw() {
  background(255);
  lights();
  ambientLight(102, 102, 102);
  translate(-200, 500, -200);
  shape(s, 0, 0);
}

PShape createTerrain(){
  PShape s = createShape(GROUP);
  
  for (int i=0; i<terrain_length; i++){
    for (int j=0; j<terrain_length; j++){
      PShape r = createShape();
      r.beginShape();
      
      float y0 = min(-noise(i*tile_length*noiseScale, j*tile_length*noiseScale)*y_scale, water_level);
      float y1 = min(-noise((i*tile_length+tile_length)*noiseScale, j*tile_length*noiseScale)*y_scale, water_level);
      float y2 = min(-noise((i*tile_length+tile_length)*noiseScale, (j*tile_length+tile_length)*noiseScale)*y_scale, water_level);
      float y3 = min(-noise((i*tile_length)*noiseScale, (j*tile_length+tile_length)*noiseScale)*y_scale, water_level);
      
      color to = color(204, 102, 0);
      color from = color(50, 102, 153);
      
      r.noStroke();   
      r.fill(lerpColor(from, to, -y0/y_scale));
      
      
      r.vertex(i*tile_length, y0, j*tile_length);
      r.vertex(i*tile_length + tile_length, y1, j*tile_length);
      r.vertex(i*tile_length + tile_length, y2, j*tile_length + tile_length);
      r.vertex(i*tile_length, y3, j*tile_length + tile_length);
      r.endShape(CLOSE);
      s.addChild(r);
    }
  }

  PShape water_rect = createShape();
  water_rect.beginShape();
  water_rect.fill(color(0, 102, 153), 50);
  water_rect.noStroke();
  water_rect.vertex(0, water_level - 10, 0);
  water_rect.vertex(terrain_length*tile_length, water_level - 10, 0);
  water_rect.vertex(terrain_length*tile_length, water_level - 10, terrain_length*tile_length);
  water_rect.vertex(0, water_level - 10, terrain_length*tile_length);
  water_rect.endShape(CLOSE);
  s.addChild(water_rect);
  
  
  return s;
}

void mouseClicked(){
  save("screenshot.png");
}