class Terrain{
  
  ArrayList<PShape> strips = new ArrayList();
  PShape planeUnderneath;
  float noiseScale = 0.003, y_scale = 300;
  int tile_length, strips_length, strips_width, strips_num;
  int strip_index = 0;
  int steps = 0;
  
  color to = color(204, 102, 0);
  color from = color(50, 102, 153);
  
  public Terrain(int tile_length, int strips_length, int strips_width, int strips_num){
    this.tile_length = tile_length; this.strips_length = strips_length; this.strips_width = strips_width; this.strips_num = strips_num;
    for (int i=0; i<strips_num; i++){
      addStrip();
    }
    planeUnderneath = createPlaneUnderneath();
  }
  
  void display(){
    for (int i=0; i<strips.size(); i++){
      pushMatrix();
      translate(0, 0, (tile_length)*i + strip_index*(tile_length));
      shape(strips.get(i));
      popMatrix();
    }
    //shape(planeUnderneath);
  }
  
  void addStrip(){
    strips.add(createStrip());
    strip_index++;
    if (strips.size()>strips_num) strips.remove(0);
  }
  
  PShape createStrip(){
    colorMode(RGB, 255);
    PShape s = createShape(GROUP);
    for (int i=0; i<strips_width; i++){
      
      PShape r = createShape();
      r.beginShape();
      
      float y0 = -noise(i*tile_length*noiseScale, strip_index*tile_length*noiseScale)*y_scale;
      float y1 = -noise((i*tile_length+tile_length)*noiseScale, strip_index*tile_length*noiseScale)*y_scale;
      float y2 = -noise((i*tile_length+tile_length)*noiseScale, (strip_index*tile_length+tile_length)*noiseScale)*y_scale;
      float y3 = -noise((i*tile_length)*noiseScale, (strip_index*tile_length+tile_length)*noiseScale)*y_scale;
      
      r.noStroke();   
      r.fill(lerpColor(from, to, -y0/y_scale), 255);
      
      r.vertex(i*tile_length, y0, 0);
      r.vertex(i*tile_length + tile_length, y1, 0);
      r.vertex(i*tile_length + tile_length, y2, tile_length);
      r.vertex(i*tile_length, y3, tile_length);
      r.endShape(CLOSE);
      s.addChild(r);
    }
    return s;
  }
  
  PShape createPlaneUnderneath(){
    int water_level = -10;
    PShape water_rect = createShape();
    water_rect.beginShape();
    water_rect.fill(color(50, 102, 153));
    water_rect.noStroke();
    water_rect.vertex(0, water_level + 20, 0);
    water_rect.vertex(strips_width*strips_num*tile_length, water_level + 20, 0);
    water_rect.vertex(strips_width*strips_num*tile_length, water_level + 20, strips_width*strips_num*tile_length);
    water_rect.vertex(0, water_level + 20, strips_width*strips_num*tile_length);
    water_rect.endShape(CLOSE);
    return water_rect;
  }
}