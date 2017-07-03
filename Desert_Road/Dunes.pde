class Dunes{
  
  int baseLength = 5000;
  int detail = 100;
  int numMountainsFirstRow = 1;
  int numMountainsSecondRow = 1;
  int mountainHeight = 100;
  int distance = 2000;
  
  ArrayList<PShape> dunesFirstRow;
  ArrayList<PShape> dunesSecondRow;
  
  public Dunes(){
    dunesFirstRow = new ArrayList();
    dunesSecondRow = new ArrayList();
    for (int i=0; i<numMountainsFirstRow; i++){
      PShape dune = createMountain(color(225, 211, 190), color(230, 225, 206), mountainHeight, 1, distance);
      dune.translate(0, 400, 0);
      dunesFirstRow.add(dune);
    }
    distance += 200;
    for (int i=0; i<numMountainsSecondRow; i++){
      PShape dune = createMountain(color(222, 232, 223), color(225, 211, 190), mountainHeight + 100, 2, distance + 2500);
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
  
  PShape createMountain(color c1, color c2, int mountainHeight, float scaleValue, float distance){
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
        //s.vertex( x, y, halfHeight + + sin(i/(22.5/TWO_PI))*mountainHeight + noise(i*0.05)*5*mountainHeight);
        s.vertex( x, y, -halfHeight*mountainHeight);    
    }
    s.endShape(CLOSE); 
    s.rotateX(PI/2);
    s.translate(0, 200, 0);
    s.scale(1, 1, 1);
    return s;
  }
}