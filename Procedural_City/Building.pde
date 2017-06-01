class Building{
  
  int posx, posy, posz;
  PShape s;
  
  public Building(){
    s = createShape(BOX, 100);
  }
  
  public Building(int posx, int posy, int posz){
    s = createShape(BOX, 10);
    this.posx = posx; this.posy = posy; this.posz = posz;
  }
  
  void update(){}
  
  void display(){
    pushMatrix();
    translate(posx, posy, posz);
    shape(s, 0, 0);
    popMatrix();
  }
}