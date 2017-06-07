class Road{
  
  PShape s;
  
  public Road(){
    s = createShape(BOX, 1);
    s.scale(100, 1, 10);
    s.setStroke(false);
    s.setEmissive(color(250, 100, 50));
    
  }
  
  void update(){}
  
  void display(){
    pushMatrix();
    translate(50, 0, 10);
    shape(s, 0, 0);
    popMatrix();
  }
}