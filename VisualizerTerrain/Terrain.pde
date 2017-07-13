class Terrain{
  
  ArrayList<PShape> strips = new ArrayList();
  ArrayList<PVector> prevVerts = new ArrayList();

  // Terrain size data
  int tile_length;
  int strips_length;
  int strips_width;
  int strips_num;

  // Road height control values
  float noiseScale     = 0.003; 
  float y_scale        = 300;
  float orig_y_scale   = 200;
  
  // Variables to keep track of the evolution of the terrain
  int strip_index = 0;
  float prev_y1 = 0, prev_y2 = 0;
  PShape lastStrip;
  PVector prevFaceNormal = new PVector(0, 0, 0);
  ArrayList<PVector> prevFaceNormals = new ArrayList();
  
  color to = color(255);
  color from = color(255);
  
  Road road;
  int road_width = 5;
  
  public Terrain(int tile_length, int strips_length, int strips_width, int strips_num){
    this.tile_length = tile_length; 
    this.strips_length = strips_length; 
    this.strips_width = strips_width; 
    this.strips_num = strips_num;
    
    road = new Road(strips_width, road_width);
  }
  
  
  void display(){
    // display the terrain strips
    for (int i=0; i<strips.size(); i++){
      pushMatrix();
      translate(0, 0, (tile_length)*i + strip_index*(tile_length));
      
      PShape strip = strips.get(i);
      shape(strip);
      //displayNormals(strip);

      popMatrix();
    }
    
    // display the road
    road.display();

  }
  
  
  void startTerrain(){
    // first strip is flat
    for (int i=0; i<strips_num; i++){
      strips.add(createFlatStrip());
    }
    // build following strips
    /*for (int i=1; i<strips_num; i++){
      curveValue += sin(float(strip_index-strips_num/2)*.125);
      addStrip();
    }*/
  }
  
  
  void addMusicStrip(float[] mBytes){
    strips.add(createMusicStrip(mBytes));
    strip_index++;
    if (strips.size()>strips_num){
      strips.remove(0);
    }
  }
  
  PShape createMusicStrip(float[] mBytes){
    colorMode(RGB, 255);
    
    ArrayList<PVector> tmpVerts = new ArrayList();
    
    PShape s = createShape(GROUP);
    for (int i=0; i<strips_width; i++){
      
      PShape r = createShape();
      r.beginShape();

      float road_center = strips_width/2 + curveValue;
      float dist = abs(road_center - i);
      y_scale =  300/(1+pow((float)Math.E, -dist*0.5 + 10)); // sigmoid equation
      
      float y0 = prevVerts.get(i).x;
      float y1 = prevVerts.get(i).y;
      int mBytesIndex = (int) map(i, 0, strips_width, 0, mBytes.length);
      float y2 = mBytes[mBytesIndex] + 300/**abs(strips_width/2 - i)*0.1*/;
      float y3 = prev_y2;

      r.noStroke();   

      r.fill(lerpColor(from, to, -y2/y_scale), 255);   
      
      r.vertex(i*tile_length, y0, 0); // 0
      r.vertex(i*tile_length + tile_length, y1, 0); // 1
      r.vertex(i*tile_length + tile_length, y2, tile_length/4); // 2
      r.vertex(i*tile_length, y3, tile_length/4); // 3

      r.endShape(CLOSE);
      s.addChild(r);
      
      tmpVerts.add(new PVector(y3, y2));
      
      prev_y1 = y1;
      prev_y2 = y2;

    }
    
    prevVerts = tmpVerts;
    
    return s;
  }
  
  
  void addStrip(){
    strips.add(createStrip());
    road.update();
    strip_index++;
    if (strips.size()>strips_num) {
      strips.remove(0);
      road.road.remove(0);
      road.roadBorders.remove(0);
    }
  }
  
  
  // the first strip of the road is a flat strip
  PShape createFlatStrip(){
    colorMode(RGB, 255);
    PShape s = createShape(GROUP);
    for (int i=0; i<strips_width; i++){
      
      PShape r = createShape();
      r.beginShape();
      
      r.noStroke();   
      r.fill(to, 255);
      
      r.vertex(i*tile_length, 0, 0); // 0
      r.vertex(i*tile_length + tile_length, 0, 0); // 1
      r.vertex(i*tile_length + tile_length, 0, tile_length); // 2
      r.vertex(i*tile_length, 0, tile_length); // 3
      prevVerts.add(new PVector(0, 0));
      prevFaceNormals.add(new PVector(0, 0, 0));
      
      r.endShape(CLOSE);
      s.addChild(r);
    }
    
    road.roadBorders.add(new PVector((strips_width/2 + curveValue - road_width)*tile_length, (strips_width/2 + curveValue + road_width)*tile_length));
    
    return s;
  }
  
  
  PShape createStrip(){
    colorMode(RGB, 255);
    
    ArrayList<PVector> tmpVerts = new ArrayList();
    
    PShape s = createShape(GROUP);
    for (int i=0; i<strips_width; i++){
      
      PShape r = createShape();
      r.beginShape();

      float road_center = strips_width/2 + curveValue;
      float dist = abs(road_center - i);
      y_scale =  300/(1+pow((float)Math.E, -dist*0.5 + 10)); // sigmoid equation
      
      float y0 = prevVerts.get(i).x;
      float y1 = prevVerts.get(i).y;
      float y2 = -noise((i*tile_length+tile_length)*noiseScale, (strip_index*tile_length+tile_length)*noiseScale)*y_scale;
      float y3 = prev_y2;

      r.noStroke();   

      r.fill(lerpColor(from, to, -y2/y_scale), 255);   
      
      r.vertex(i*tile_length, y0, 0); // 0
      r.vertex(i*tile_length + tile_length, y1, 0); // 1
      r.vertex(i*tile_length + tile_length, y2, tile_length); // 2
      r.vertex(i*tile_length, y3, tile_length); // 3

      r.endShape(CLOSE);
      s.addChild(r);
      
      tmpVerts.add(new PVector(y3, y2));
      
      prev_y1 = y1;
      prev_y2 = y2;

    }
    
    prevVerts = tmpVerts;
    
    //recalculateNormals();
    
    return s;
  }
  
  
  void recalculateNormals(){
    /* ---
        +--+--+--+
        |f0|f1|f2|
        +--+--+--+
        |f3|f4|f5|
        +--+--+--+
        
        y2--y3
        |    |
        y1--y0
    --- */ 
    
    if (strips.size()==1) return;
    PShape s0 = strips.get(strips.size()-1);
    PShape s1 = strips.get(strips.size()-2);
    for (int i=1; i<strips_width-1; i++){
      PShape f0 = s0.getChild(i-1);
      PVector f0Normal = PVector.sub(f0.getVertex(1), f0.getVertex(0)).cross(PVector.sub(f0.getVertex(2), f0.getVertex(0)));
      PShape f1 = s0.getChild(i);
      PVector f1Normal = PVector.sub(f1.getVertex(1), f1.getVertex(0)).cross(PVector.sub(f1.getVertex(2), f1.getVertex(0)));
      PShape f2 = s0.getChild(i+1);
      PVector f2Normal = PVector.sub(f2.getVertex(1), f2.getVertex(0)).cross(PVector.sub(f2.getVertex(2), f2.getVertex(0)));
      PShape f3 = s1.getChild(i-1);
      PVector f3Normal = PVector.sub(f3.getVertex(1), f3.getVertex(0)).cross(PVector.sub(f3.getVertex(2), f3.getVertex(0)));
      PShape f4 = s1.getChild(i);
      PVector f4Normal = PVector.sub(f4.getVertex(1), f4.getVertex(0)).cross(PVector.sub(f4.getVertex(2), f4.getVertex(0)));
      PShape f5 = s1.getChild(i+1);
      PVector f5Normal = PVector.sub(f5.getVertex(1), f5.getVertex(0)).cross(PVector.sub(f5.getVertex(2), f5.getVertex(0)));

      PVector y1Normal = f1Normal.add(f0Normal).add(f3Normal).add(f4Normal).normalize();
      f0.setNormal(1, y1Normal.x, y1Normal.y, y1Normal.z);
      f1.setNormal(0, y1Normal.x, y1Normal.y, y1Normal.z);
      f3.setNormal(2, y1Normal.x, y1Normal.y, y1Normal.z);
      f4.setNormal(3, y1Normal.x, y1Normal.y, y1Normal.z);
    }
  }
  
  void setColorScheme(color color_A, color color_B){
    to = color_A;
    from = color_B;
  }
  
  void displayNormals(PShape strip){
    for (int j=0; j<strips_width; j++){
      for (int k=0; k<4; k++){
        if (true /*j%3==0 && strips.indexOf(strip)%3==0*/){
          if (k==0) stroke(255, 0, 0);
          if (k==1) stroke(0, 255, 0);
          if (k==2) stroke(0, 0, 255);
          if (k==3) stroke(255, 255, 255);
        } else noStroke();
        PVector norm = strip.getChild(j).getNormal(k).normalize();
        PVector vert = strip.getChild(j).getVertex(k);
        line(vert.x, vert.y, vert.z, vert.x + norm.x*10, vert.y + norm.y*10, vert.z + norm.z*10);
      }
    }
  }
  
}