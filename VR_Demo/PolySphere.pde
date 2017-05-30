class PolySphere{
  
  PShape s;
  PVector center;
  int radius;
  float division;
  
  public PolySphere(int radius, String type){
    if (type=="pyramid") {
      s = createBasePyramid(20, 10);
      division = PI/(360/20) + 0.05;
    }
    if (type=="spike") {
      int size = 10;
      s = createBaseSpike(size);
      division = PI/(360/size) + 0.31;
    }
    
    center = new PVector(0, 0, 0);
    
    this.radius = radius;
  }
  
  void display(){
    for (float i=0; i<PI; i+=division){
      for (float j=0; j<TWO_PI; j+=division){
        pushMatrix();
        translate(radius*sin(i)*cos(j), -radius*cos(i), radius*sin(i)*sin(j));
        rotateY(PI/2-j);
        rotateX(PI/2-i);
        
        shape(s, 0, 0);
        popMatrix();
      }
    }
  }
  
  void update(){}
  
  PShape createBaseSpike(int size){
    PShape s = loadShape("spike.obj");
    s.rotateX(PI/2);
    s.scale(size);
    s.setStroke(true);
    s.setStroke(color(255, 255, 255));
    s.setStrokeWeight(0.1);        
                                               
    s.setFill(color(50, 50, 50));
    return s;
  }
  
  PShape createBasePyramid(int l, int h){
    PShape s = createShape();
    
    s.beginShape();
    s.fill(50);
    s.stroke(255);
    s.vertex(-l, -l, -h);
    s.vertex( l, -l, -h);
    s.vertex( 0, 0, h);
    
    s.vertex( l, -l, -h);
    s.vertex( l,  l, -h);
    s.vertex(   0,    0,  h);
    
    s.vertex( l, l, -h);
    s.vertex(-l, l, -h);
    s.vertex(   0,   0,  h);
    
    s.vertex(-l,  l, -h);
    s.vertex(-l, -l, -h);
    s.vertex(   0,    0,  h);
    
    s.vertex(l/2, l/2, 0);
    s.vertex(l/2, -l/2, 0);
    s.vertex(-l/2, -l/2, 0);
    s.vertex(-l/2, l/2, 0);
    s.vertex(l/2, l/2, 0);
    
    s.endShape();
    
    return s;
  }
}