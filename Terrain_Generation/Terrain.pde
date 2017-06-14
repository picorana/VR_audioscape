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

/*class Terrain{
  
  float noiseScale = 0.008;
  float y_scale = 200;
  int terrain_length = 250, tile_length = 7;
  int strips_num = 5;
  int strips_length = 50;
  int water_level = 0;  // it was -75
  int strip_counter = 0;
  ArrayList<PShape> strips = new ArrayList();
  PShape water;
  PShape planeUnderneath;
  
  public Terrain(int tile_length, int strips_length, int terrain_length){
    this.tile_length = tile_length; this.strips_length = strips_length; this.terrain_length = terrain_length;
    water = createWater();
    planeUnderneath = createPlaneUnderneath();
    for (int i=0; i<strips_num; i++){
      strips.add(createTerrainStrip(i*strips_length, strips_length));
      strip_counter++;
    }
  }
  
  void display(){
    // terrain strips
    translate(-tile_length*strips_length/2, 0, -strip_counter*tile_length*strips_length/2);
    for (int i=0; i<strips.size(); i++){
      shape(strips.get(i));
    }
    
    // other planes that need to move together with the terrain
    shape(planeUnderneath);

  }
  
  void addStrip(){
    strips.remove(0);
    strips.add(createTerrainStrip(strip_counter*strips_length, strips_length));
    strip_counter++;
  }
  
  void update(){
  }
  
  PShape createTerrainStrip(int index, int strips_length){
    PShape s = createShape(GROUP);
    
    for (int i=0; i<terrain_length; i++){
      for (int j=index; j<index+strips_length; j++){
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
    
    return s;
  }
  
  PShape createPlaneUnderneath(){
    PShape water_rect = createShape();
    water_rect.beginShape();
    water_rect.fill(color(50, 102, 153));
    water_rect.noStroke();
    water_rect.vertex(0, water_level + 20, 0);
    water_rect.vertex(terrain_length*tile_length, water_level + 20, 0);
    water_rect.vertex(terrain_length*tile_length, water_level + 20, terrain_length*tile_length);
    water_rect.vertex(0, water_level + 20, terrain_length*tile_length);
    water_rect.endShape(CLOSE);
    return water_rect;
  }
  
  PShape createWater(){
    PShape water_rect = createShape();
    water_rect.beginShape();
    water_rect.fill(color(0, 102, 153), 50);
    water_rect.noStroke();
    water_rect.vertex(0, water_level - 10, 0);
    water_rect.vertex(terrain_length*tile_length, water_level - 10, 0);
    water_rect.vertex(terrain_length*tile_length, water_level - 10, terrain_length*tile_length);
    water_rect.vertex(0, water_level - 10, terrain_length*tile_length);
    water_rect.endShape(CLOSE);
    return water_rect;
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
}*/