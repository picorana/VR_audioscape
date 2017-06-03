class ProceduralCity{
  ArrayList<Building> buildings;
  Road r;
  int num_buildings = 10;
  
  public ProceduralCity(){
    r = new Road();
    buildings = new ArrayList();
    for (int i=0; i<num_buildings; i++){
      buildings.add(new Building(i*6, 0, 0));
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