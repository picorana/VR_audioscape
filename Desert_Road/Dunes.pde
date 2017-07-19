class Dunes{
  
  int baseLength = 5000;
  int detail = 100;
  int numMountainsFirstRow = 1;
  int numMountainsSecondRow = 1;
  int mountainHeight = 100;
  int distance = 3000;
  
  color c1, c2;
  
  ArrayList<PShape> dunesFirstRow;
  ArrayList<PShape> dunesSecondRow;
  
  public Dunes(){
    
    if (colorScheme == 0){
      c1 = color(225, 211, 190);
      c2 = color(222, 232, 223);
    } else if (colorScheme == 1){
      c1 = color(#325d66);
      c2 = color(222, 232, 223);
    }
    
    dunesFirstRow = new ArrayList();
    dunesSecondRow = new ArrayList();
    for (int i=0; i<numMountainsFirstRow; i++){
      PShape dune = createMountain(c1, mountainHeight, 1, distance);
      dune.translate(0, 0, 0);
      dunesFirstRow.add(dune);
    }
    for (int i=0; i<numMountainsSecondRow; i++){
      PShape dune = createMountain(c2, mountainHeight + 100, 2, distance + 1700);
      dune.translate(0, -300, 0);
      dune.rotateY(1);
      dunesSecondRow.add(dune);
    }
  }
  
  void display(){
    for (int i=0; i<dunesSecondRow.size(); i++){
      shape(dunesSecondRow.get(i));
    }
    for (int i=0; i<dunesFirstRow.size(); i++){
      shape(dunesFirstRow.get(i));
    }
  }
  
  PShape createMountain(color c1, int mountainHeight, float scaleValue, float distance){
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
    s.scale(1, 1, 1);
    return s;
  }
}