class Building{
  
  int posx, posy, posz;
  int type = 1;
  float building_height;
  float size;
  
  int res = 100;
  
  int chunkType = 0;
  
  Extrusion e;
  Path path;
  Contour contour;
  ContourScale conScale;
  
  PShape s;
  PShape foundation;
  
  ArrayList<Billboard> billboards = new ArrayList();
  
  public Building(int posx, int posy, int posz){
    this.posx = posx; this.posy = posy; this.posz = posz;
    
    if (random(0, 1)<.9) building_height = random(10, 20)*10;
    else building_height = random(20, 40)*10;
    size = 3*10;
    
    e = createBuildingStructure();
    
  }
  
  // this other constructor serves only for chunktype -- remove it
  public Building(int posx, int posy, int posz, int chunkType){
    this.posx = posx; this.posy = posy; this.posz = posz; this.chunkType = chunkType;
    
    if (random(0, 1)<.9) building_height = random(10, 20)*10;
    else building_height = random(20, 40)*10;
    size = 5*10;
    
    //e = createBuildingStructure();
    s = createShape(BOX, size*2);
    s.scale(1, building_height/size, 1);
    s.setStroke(false);
    s.setTexture(textures.get(chunkType));
    
    foundation = createShape(RECT, size*3, size*3, size*3, size*3);
    foundation.setStroke(false);
    foundation.setFill(color(100, 100, 100));
    
    /*
    for (float i=0; i<TWO_PI; i+=PI/2){
      for (int j=0; j<building_height - 10; j+=1){
        Billboard b = new Billboard(i, j);
        billboards.add(b);
        j += b.texture.height + (int)size + 5;
      }
    }*/
  }
  
  Extrusion createBuildingStructure(){
    
    path = new P_LinearPath(new PVector(0, building_height, 0), new PVector(0, 0, 0));
    contour = getBuildingContour();
    conScale = new CS_ConstantScale();
    
    // Create the texture coordinates for the end
    contour.make_u_Coordinates();
    
    // Create the extrusion
    e = new Extrusion(sketchPApplet, path, 1, contour, conScale);
    
    e.setTexture(textures.get(chunkType), 1, 1);
    e.drawMode(S3D.TEXTURE );
    // Extrusion end caps
    //e.setTexture("grass.jpg", S3D.E_CAP);
    //e.setTexture("sky.jpg", S3D.S_CAP);
    e.drawMode(S3D.TEXTURE, S3D.BOTH_CAP);
    return e;
  }
  
  public Contour getBuildingContour() {
      PVector[] c = new PVector[]{
        new PVector(-size, size),
        new PVector(size, size),
        new PVector(size, -size),
        new PVector(-size, -size)
      };
      return new Building_Contour(c);
  }
  
  
  
  void update(){}
  
  void display(){
    pushMatrix();
    translate(posx, posy - building_height, posz);
    shape(s);
    for (int i=0; i<billboards.size(); i++){
      billboards.get(i).display();
    }
    popMatrix();
   
  }
  
  void addBillboards(){
    // put i+=PI/2 back!!
    for (float i=PI/2; i<TWO_PI; i+=PI){
      if (random(0, 1)<.3){
        for (int j=20; j<building_height - 10; j+=1){
          Billboard b = new Billboard(i, j);
          billboards.add(b);
          j += b.texture.height + (int)size + 5;
        }
      }
    }
  }
}

public class Building_Contour extends Contour {
  public Building_Contour(PVector[] c) {
    this.contour = c;
  }
}