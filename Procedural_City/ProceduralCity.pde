class ProceduralCity{
  ArrayList<Building> buildings;
  int num_buildings = 10;
  
  public ProceduralCity(){
    buildings = new ArrayList();
    for (int i=0; i<num_buildings; i++){
      buildings.add(new Building(i*12, 0, 0));
    }
  }
  
  void update(){}
  
  void display(){
    for (int i=0; i<buildings.size(); i++){
      buildings.get(i).display();
    }
  }
}