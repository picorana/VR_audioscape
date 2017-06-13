class Billboard{
  
  PShape bshape;
  int bheight;
  int posy;
  PImage texture;
  float rotationAngle;
  
  public Billboard(float rotationAngle, int posy){
    this.rotationAngle = rotationAngle; this.posy = posy;
    rectMode(CENTER);
    switch((int)random(0, 3)){
      case 0:
        bheight = 80;
        bshape = createShape(RECT, 0, 0, 80, bheight);
        texture = billboardTextures.get(0);
        bshape.setTexture(texture);
        break;
      case 1:
        bheight = 120;
        bshape = createShape(RECT, 0, 0, 80, bheight);
        texture = billboardTextures.get(1);
        bshape.setTexture(texture);
        break;
      case 2:
        bheight = 20;
        bshape = createShape(RECT, 0, 0, 80, bheight);
        texture = billboardTextures.get(2);
        bshape.setTexture(texture);
        break;
      default: 
        bheight = 80;
        bshape = createShape(RECT, 0, 0, 70, bheight);
        texture = billboardTextures.get(3);
        bshape.setTexture(texture);
        break;
    }
    bshape.setStroke(false);
  }
  
  void display(){
    pushMatrix();
    rotateY(rotationAngle);
    translate(0, -posy, 5*10 + 2);    
    shape(bshape);
    popMatrix();
  }
}