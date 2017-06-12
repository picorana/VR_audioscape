class Chunk{
  
  ArrayList<Building> buildings = new ArrayList();
  ArrayList<Road> roads = new ArrayList();
  PVector chunkPosition;
  int numBuildings = 9;
  int buildingSpacing = 150; 
  int chunkSize = numBuildings*buildingSpacing;
  
  int chunkType = (int) random(0, 3);
  
  public Chunk(){
    fillChunk();
  }
  
  public Chunk(PVector chunkPosition, int numBuildings, int buildingSpacing){
    this.chunkPosition = chunkPosition; this.numBuildings = numBuildings; this.buildingSpacing = buildingSpacing;
    this.chunkSize = (int)sqrt(numBuildings)*buildingSpacing;
    fillChunk();
  }
  
  public Chunk(PVector chunkPosition, String[][] chunkContent, int buildingSpacing){
    this.chunkPosition = chunkPosition; this.buildingSpacing = buildingSpacing;
    this.chunkSize = (int)sqrt(numBuildings)*buildingSpacing;
    fillChunk(chunkContent);
  }
  
  void fillChunk(){
    for (int i=0; i<sqrt(numBuildings); i++){
      for (int j=0; j<sqrt(numBuildings); j++){
        buildings.add(new Building(i*buildingSpacing, 0, j*buildingSpacing, chunkType));
      }
    }
  }
  
  void fillChunk(String[][] chunkContent){
    for (int i=0; i<chunkContent.length; i++){
      for (int j=0; j<chunkContent[0].length; j++){
        if (chunkContent[i][j]=="b") buildings.add(new Building(i*buildingSpacing, 0, j*buildingSpacing, chunkType));
        else if (chunkContent[i][j]=="r") roads.add(new Road(new PVector(i*buildingSpacing, j*buildingSpacing), new PVector(buildingSpacing, buildingSpacing)));
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
    for (int i=0; i<roads.size(); i++){
      roads.get(i).display();
    }
    popMatrix();
  }
    
}