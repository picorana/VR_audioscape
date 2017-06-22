class Terrain{
  
  ArrayList<PShape> strips = new ArrayList();
  ArrayList<PVector> prevVerts = new ArrayList();
  ArrayList <PVector> roadBorders = new ArrayList();
  ArrayList <PShape> road = new ArrayList();
  PShape lastStrip;
  PImage roadTexture;
  float noiseScale = 0.003, y_scale = 300, orig_y_scale = 200, prev_y1 = 0, prev_y2 = 0;
  int tile_length, strips_length, strips_width, strips_num;
  int strip_index = 0;
  int steps = 0;
  
  float road_height = -10;
  float road_width = 5;
  
  color to = color(204, 102, 0);
  color from = color(173, 152, 122);
  
  public Terrain(int tile_length, int strips_length, int strips_width, int strips_num){
    this.tile_length = tile_length; this.strips_length = strips_length; this.strips_width = strips_width; this.strips_num = strips_num;
    strips.add(createFlatStrip());
    for (int i=1; i<strips_num; i++){
      addStrip();
    }
    roadTexture = loadImage("roadtexture.png");
  }
  
  void display(){
    for (int i=0; i<strips.size(); i++){
      pushMatrix();
      translate(0, 0, (tile_length)*i + strip_index*(tile_length));
      shape(strips.get(i));
      popMatrix();
    }
    for (int i=0; i<road.size(); i++){
      pushMatrix();
      translate(0, 0, (tile_length)*i + strip_index*(tile_length));
      shape(road.get(i));
      popMatrix();
    }
  }
  
  void addStrip(){
    strips.add(createStrip());
    road.add(createRoadStrip());
    strip_index++;
    if (strips.size()>strips_num) {
      strips.remove(0);
      road.remove(0);
      roadBorders.remove(0);
    }
  }
  
  PShape createRoadStrip(){
    
    PShape s = createShape();
    s.beginShape();
    s.noStroke();
    s.fill(color(#554040));
    
    float this_road_height = road_height;
    s.vertex(roadBorders.get(roadBorders.size()-1).y, this_road_height, 0);
    s.vertex(roadBorders.get(roadBorders.size()-1).x, this_road_height, 0);
    s.vertex(((strips_width/2 + curveValue)-road_width)*tile_length, this_road_height, tile_length);
    s.vertex(((strips_width/2 + curveValue)+road_width)*tile_length, this_road_height, tile_length);
    
    s.normal(0, -1, 0);
    roadBorders.add(new PVector((strips_width/2 + curveValue - 5)*tile_length, (strips_width/2 + curveValue + 5)*tile_length));
    s.endShape();
    //s.setTexture(roadTexture);
    return s;
  }
  
  PShape createFlatStrip(){
    colorMode(RGB, 255);
    PShape s = createShape(GROUP);
    for (int i=0; i<strips_width; i++){
      
      PShape r = createShape();
      r.beginShape();
      
      r.noStroke();   
      if (i<(strips_width/2 + curveValue)-5 || i>(strips_width/2 + curveValue)+5) r.fill(to, 255);
      else r.fill(color(50, 50, 50));
      
      r.vertex(i*tile_length, 0, 0); // 0
      r.vertex(i*tile_length + tile_length, 0, 0); // 1
      r.vertex(i*tile_length + tile_length, 0, tile_length); // 2
      r.vertex(i*tile_length, 0, tile_length); // 3
      prevVerts.add(new PVector(0, 0));
      roadBorders.add(new PVector((strips_width/2 + curveValue - 5)*tile_length, (strips_width/2 + curveValue + 5)*tile_length));
      r.endShape(CLOSE);
      s.addChild(r);
    }
    
    return s;
  }
  
  PShape createStrip(){
    colorMode(RGB, 255);
    
    ArrayList<PVector> tmpVerts = new ArrayList();
    
    PShape s = createShape(GROUP);
    for (int i=0; i<strips_width; i++){
      
      PShape r = createShape();
      r.beginShape();
      
      //if (i<(strips_width/2 + curveValue)-7 || i>(strips_width/2 + curveValue)+7) y_scale = orig_y_scale*abs((strips_width/2 + curveValue)-i)*0.04;
      //else y_scale = orig_y_scale*0.03 + 80;

      float dist = abs((strips_width/2 + curveValue)-i);
      y_scale =  250/(1+pow((float)Math.E, -dist*0.5 + 10));
      
      
      //float y0 = -noise(i*tile_length*noiseScale, strip_index*tile_length*noiseScale)*y_scale;
      //float y0 = prev_y1;
      float y0 = prevVerts.get(i).x;
      //float y1 = -noise((i*tile_length+tile_length)*noiseScale, strip_index*tile_length*noiseScale)*y_scale;
      float y1 = prevVerts.get(i).y;
      float y2 = -noise((i*tile_length+tile_length)*noiseScale, (strip_index*tile_length+tile_length)*noiseScale)*y_scale;
      //float y2 = prevVerts.get(i).y;
      //float y3 = -noise((i*tile_length)*noiseScale, (strip_index*tile_length+tile_length)*noiseScale)*y_scale;
      float y3 = prev_y2;
      //float y3 = prevVerts.get(i).x;
      
      r.noStroke();   
      //if (i<(strips_width/2 + curveValue)-5 || i>(strips_width/2 + curveValue)+5) r.fill(lerpColor(from, to, -y0/y_scale), 255);
      //else if (i == (strips_width/2 + curveValue)-4 || i==strips_width/2+4) r.fill(color(150, 150, 150));
      //else r.fill(color(50, 50, 50));
      r.fill(lerpColor(from, to, -y0/y_scale), 255);
      
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
    
    return s;
  }
  
}