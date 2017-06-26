class Terrain{
  
  ArrayList<PShape> strips = new ArrayList();
  ArrayList<PVector> prevVerts = new ArrayList();
  ArrayList<Blade> grass = new ArrayList();

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
  
  color to = color(204, 102, 0);
  color from = color(173, 152, 122);
  
  Road road;
  Blade blade;
  
  public Terrain(int tile_length, int strips_length, int strips_width, int strips_num){
    this.tile_length = tile_length; 
    this.strips_length = strips_length; 
    this.strips_width = strips_width; 
    this.strips_num = strips_num;
    
    road = new Road(strips_width);
    
    strips.add(createFlatStrip());
    for (int i=1; i<strips_num; i++){
      curveValue += sin(float(strip_index-strips_num/2)*.125);
      addStrip();
    }
    
  }
  
  
  void display(){
    // display the terrain strips
    for (int i=0; i<strips.size(); i++){
      pushMatrix();
      translate(0, 0, (tile_length)*i + strip_index*(tile_length));
      shape(strips.get(i));
      popMatrix();
    }
    
    // display the road
    road.display();

    
    if (grassEnabled){
      for (int i=0; i<grass.size(); i++){
        pushMatrix();
        translate(0, 0, grass.get(i).anchor.z + strips_num*tile_length);
        grass.get(i).display();
        popMatrix();
      }
    }

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
      
      r.endShape(CLOSE);
      s.addChild(r);
    }
    
    road.roadBorders.add(new PVector((strips_width/2 + curveValue - 5)*tile_length, (strips_width/2 + curveValue + 5)*tile_length));
    
    return s;
  }
  
  
  PShape createStrip(){
    colorMode(RGB, 255);
    
    ArrayList<PVector> tmpVerts = new ArrayList();
    
    PShape s = createShape(GROUP);
    for (int i=0; i<strips_width; i++){
      
      PShape r = createShape();
      r.beginShape();

      float dist = abs((strips_width/2 + curveValue)-i);
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
      
      if (grassEnabled){
        if (y2>-50 && random(0, 1)<.1 && (i<strips_width/2 +curveValue -5 || i> strips_width/2 +curveValue + 5)) {
          grass.add(new Blade(new PVector(i*tile_length, y2 - 5, strip_index*tile_length), 5));
          if (random(0, 1) < .1){
            for (int j=0; j<3; j++){
              grass.add(new Blade(new PVector(i*tile_length, y2 - 5, (strip_index + random(-.1, .1))*tile_length), 5));
            }
          }
        }
      }

    }
    
    prevVerts = tmpVerts;
    
    return s;
  }
  
}