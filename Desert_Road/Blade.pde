class Blade{
  
  PShape b;
  PVector anchor;
  color green;
  float offset;
  
  ArrayList<PVector> segments = new ArrayList();
  
  Blade(PVector setAnchor, int setSegments) {
    this.anchor = setAnchor;
    green = color((int)random(100, 255), (int)random(100, 150), (int)random(0, 100));
    offset = random(50);

    for (int x = 0; x < setSegments; x++) {
      segments.add(new PVector(anchor.x, anchor.y+10*x));
    }
    
    segments.get(0).x = anchor.x;
    segments.get(0).y = anchor.y;
    segments.get(0).z = anchor.z;
    
    b = grassBlade_v2(segments);
  }
  
  void display(){
    pushMatrix();
    translate(offset, 0, 0);
    shape(b);
    popMatrix();
  }
  
  PShape grassBlade(){
    PShape p = createShape(RECT, 10, 10, 100, 100);
    p.setStroke(false);
    p.setFill(green);
    return p;
  }
  
  PShape grassBlade_v2(ArrayList<PVector> segments) { 
    int h = segments.size ()-2;
    PShape p = createShape();
    p.beginShape(); 
    p.fill(green);
    p.noStroke();
    for (int x = 0; x < segments.size ()-1; x++) {
      PVector segment = segments.get(x);
      p.vertex(segment.x+5*((h-x)/h), segment.y);
      p.vertex(segment.x-5*((h-x)/h), segment.y);
    } 
    p.endShape();
    p.rotateX(PI);
    return p;
  }
}