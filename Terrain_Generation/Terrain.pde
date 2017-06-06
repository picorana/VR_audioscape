class Terrain{
  
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
  
  public Terrain(){
    water = createWater();
    planeUnderneath = createPlaneUnderneath();
    for (int i=0; i<strips_num; i++){
      strips.add(createTerrainStrip(i*strips_length, strips_length));
      strip_counter++;
    }
  }
  
  void display(){
    // terrain strips
    pushMatrix();
    translate(0, 0, -strip_counter*tile_length*strips_length);
    for (int i=0; i<strips.size(); i++){
      shape(strips.get(i));
    }
    popMatrix();
    
    // other planes that need to move together with the terrain
    pushMatrix();
    translate(0, 0, -terrain_length*tile_length);
    shape(planeUnderneath);
    popMatrix();
  }
  
  void update(){
    /*
   if ((terrain_offset/tile_length)%50>2){
      strips.remove(0);
      strips.add(createTerrainStrip(strip_counter*strips_length, strips_length));
      strip_counter++;
      terrain_offset = 0;
    }*/
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
}