class Building{
  
  int posx, posy, posz;
  float building_height;
  float size;
  PShape s;
  
  public Building(){
    s = createShape(BOX, 100);
  }
  
  public Building(int posx, int posy, int posz){
    this.posx = posx; this.posy = posy; this.posz = posz;
    
    building_height = random(1, 5);
    size = 5;
    
    if (random(0, 1)<.5) s = loadShape("models/building2.obj");
    else s = createBuildingShape();
    s.setStroke(false);
    s.setEmissive(color(150, 150, 150));
  }
  
  PShape createBuildingShape(){
    
    /*
    PImage img = createImage(100, (int)(size*building_height*10), ARGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      
      // LOCATION = X + Y*WIDTH
      // X = LOCATION - Y*WIDTH, Y = (LOCATION - X)/WIDTH
      
      if ((i/100)%10 < 5 && i%100>10 && i%100<90) img.pixels[i] = color(200 + i/100, 200, 200);
      else img.pixels[i] = color(50 + i/100, 50, 50);
    }
    img.updatePixels();*/
    
    PImage img = loadImage("models/berlin-1.jpg");
    
    PShape s = createShape(GROUP);
    
    PShape zplus = createShape();
    // +Z "front" face
    zplus.beginShape();
    zplus.texture(img);
    zplus.vertex(-1, -1,  1, 0, 0);
    zplus.vertex( 1, -1,  1, 1, 0);
    zplus.vertex( 1,  1,  1, 1, 1);
    zplus.vertex(-1,  1,  1, 0, 1);
    zplus.endShape();
    s.addChild(zplus);
  
    
    // -Z "back" face
    PShape zminus = createShape();
    zminus.beginShape();
    zminus.texture(img);
    zminus.vertex( 1, -1, -1, 0, 0);
    zminus.vertex(-1, -1, -1, 1, 0);
    zminus.vertex(-1,  1, -1, 1, 1);
    zminus.vertex( 1,  1, -1, 0, 1);
    zminus.endShape();
    s.addChild(zminus);
  
    /*
    // +Y "bottom" face
    vertex(-1,  1,  1, 0, 0);
    vertex( 1,  1,  1, 1, 0);
    vertex( 1,  1, -1, 1, 1);
    vertex(-1,  1, -1, 0, 1);
  
    // -Y "top" face
    vertex(-1, -1, -1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1, -1,  1, 1, 1);
    vertex(-1, -1,  1, 0, 1);
  
    // +X "right" face
    vertex( 1, -1,  1, 0, 0);
    vertex( 1, -1, -1, 1, 0);
    vertex( 1,  1, -1, 1, 1);
    vertex( 1,  1,  1, 0, 1);
  
    // -X "left" face
    vertex(-1, -1, -1, 0, 0);
    vertex(-1, -1,  1, 1, 0);
    vertex(-1,  1,  1, 1, 1);
    vertex(-1,  1, -1, 0, 1);
  
    endShape();*/
    s.texture(img);
    return s;
  }
  
  void update(){}
  
  void display(){
    pushMatrix();
    translate(posx, posy, posz);
    rotateX(PI);
    shape(s, 0, 0);
    popMatrix();
  }
}