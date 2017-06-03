class ProceduralCity{
  ArrayList<Building> buildings;
  Road r;
  int num_buildings = 10;
  
  public ProceduralCity(){
    r = new Road();
    buildings = new ArrayList();
    for (int i=0; i<num_buildings; i++){
      for (int j=0; j<num_buildings; j++){
        buildings.add(new Building(i*10, 0, j*10));
      }
    }
  }
  
  void update(){}
  
  void display(){
    r.display();
    for (int i=0; i<buildings.size(); i++){
      buildings.get(i).display();
    }
  }
}