class Road{
  
  ArrayList <PVector> roadBorders = new ArrayList();
  ArrayList <PShape> road = new ArrayList();
  
  PImage roadTexture;
  float road_height = -10;
  float road_width = 5;
  
  int strips_width;
  
  public Road(int strips_width){
    this.strips_width = strips_width;
    
    roadTexture = loadImage("roadtexture.png");
  }
  
  void display(){}
  
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
}