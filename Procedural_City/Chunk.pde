class Chunk{
  
  ArrayList<Building> buildings = new ArrayList();
  PVector chunkPosition;
  int numBuildings = 5;
  int buildingSpacing = 150;
  int chunkSize = numBuildings*buildingSpacing;
  
  int chunkType = (int) random(0, 3);
  
  public Chunk(){
    fillChunk();
  }
  
  public Chunk(PVector chunkPosition){
    this.chunkPosition = chunkPosition;
    fillChunk();
  }
  
  void fillChunk(){
    for (int i=0; i<numBuildings; i++){
      for (int j=0; j<numBuildings; j++){
        buildings.add(new Building(i*buildingSpacing, 0, j*buildingSpacing, chunkType));
      }
    }
  }
  
  void update(){}
  
  void display(){
    pushMatrix();
    translate(chunkPosition.x * chunkSize, 0, chunkPosition.y * chunkSize);
    for (int i=0; i<buildings.size(); i++){
        buildings.get(i).display();
      }
    popMatrix();
  }
    
}