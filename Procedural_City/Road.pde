class Road{
  
  PShape s;
  PVector roadPosition;
  PVector roadSize;
  
  public Road(){
    s = createShape(BOX, 1);
    s.scale(100, 1, 10);
    s.setStroke(false);
    s.setEmissive(color(250, 100, 50));
  }
  
  public Road(PVector roadPosition, PVector roadSize){
    this.roadPosition = roadPosition;
    s = createShape(BOX, 1);
    s.scale(roadSize.x, 1, roadSize.y);
    s.setStroke(false);
    s.setEmissive(color(250, 100, 50));
    
    PImage img = new PImage(10, 1);
    img.loadPixels();
    img.pixels[0] = color(255, 255, 255);
    for (int i=1; i<img.width - 1; i++){
      img.pixels[i] = color(100, 100, 100);
    }
    img.pixels[img.width-1] = color(255, 255, 255);
    img.pixels[img.width/2] = color(255, 255, 255);
    img.updatePixels();
    s.setTexture(img);
  }
  
  void update(){}
  
  void display(){
    pushMatrix();
    translate(roadPosition.x, 0, roadPosition.y);
    shape(s);
    popMatrix();
  }
}