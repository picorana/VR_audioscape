class ProceduralCity{
  ArrayList<Building> buildings;
  Road r;
  int num_buildings = 15;
  PShape plane;
  
  public ProceduralCity(){
    r = new Road();
    // is the camera moved according to how big are the shapes that I use into a scene?
    plane = createShape(RECT, 0, 0, 100, 100);
    plane.setFill(color(50, 50, 50));
    buildings = new ArrayList();
    for (int i=0; i<num_buildings; i++){
      for (int j=0; j<num_buildings; j++){
        buildings.add(new Building(i*10*5, 0, j*10*5));
      }
    }
  }
  
  void update(){}
  
  void display(){
    //r.display();
    pushMatrix();
    //translate(-500, 1000, -500);
    //translate(0, 500, 0);
    rotateX(PI/2);
    //shape(plane);
    popMatrix();
    
    pushMatrix();
    translate(0, 750, 0);
    //translate(-num_buildings*5 + 5, 1000, -num_buildings*5 + 5);
    for (int i=0; i<buildings.size(); i++){
      buildings.get(i).display();
    }
    popMatrix();
  }
  
}