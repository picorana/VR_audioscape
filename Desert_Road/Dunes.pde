class Dunes{
  
  // looks like items at a distance >5000 from the camera aren't rendered
  
  int baseLength = 5000;
  int detail = 100;
  int numMountainsFirstRow = 1;
  int numMountainsSecondRow = 0;
  int mountainHeight = 100;
  int distance = 3000;
  
  color c1, c2;
  
  PShape dunesFirstRow;
  PShape dunesSecondRow;
  
  public Dunes() {
    
    if (colorScheme == 0) {
      c1 = color(225, 211, 190);
      c2 = color(222, 232, 223);
    } else if (colorScheme == 1) {
      c1 = color(#325d66);
      c2 = color(222, 232, 223);
    }
    
    dunesFirstRow = createMountain(c1, mountainHeight, 1, distance);
    dunesSecondRow = createMountain(c2, mountainHeight, 1, distance + 400);
    dunesFirstRow.translate(0, -100, 0);
    dunesSecondRow.scale(1.1);
    dunesSecondRow.translate(0, -200, 0);
  }
  
  void display() {
    shape(dunesFirstRow);
    shape(dunesSecondRow);
  }
  
  void update() {
    dunesFirstRow.rotateY(cos(millis()/2000)*.005);
    dunesSecondRow.rotateY(sin(millis()/2000)*.005);
    dunesFirstRow.translate(0, sin(millis()/2000)*2, 0);
    dunesSecondRow.translate(0, cos(millis()/2000)*3, 0);
  }
  
  
  void setColorScheme(color c1, color c2) {
    dunesFirstRow.setFill(c1);
    dunesSecondRow.setFill(c2);
  }  
  
  PShape createMountain(color c1, int mountainHeight, float scaleValue, float distance) {
    float halfHeight = 30*scaleValue;
    float sides = 180;
    float r = distance;
    float angle = 360 / sides;
    PShape s = createShape();
    s.beginShape(QUAD_STRIP);
    s.fill(c1);
    s.noStroke();
    for (int i = 0; i <= sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        s.vertex( x, y, halfHeight + sin(i/(22.5/TWO_PI))*mountainHeight);
        s.vertex( x, y, -halfHeight*mountainHeight);    
    }
    s.endShape(CLOSE); 
    s.rotateX(PI/2);
    s.translate(0, 200, 0);
    return s;
  }
}