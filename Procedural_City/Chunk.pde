class Chunk{
  
  // CHUNK CHARACTERISTICS
  PVector chunkPosition;
  int numBuildings = 9;
  int buildingSpacing = 150; 
  int chunkSize = numBuildings*buildingSpacing;  
  int chunkType = (int) random(0, 3);
  
  // CHUNK CONTENT
  ArrayList<Building> buildings = new ArrayList();
  ArrayList<Road> roads = new ArrayList();
  ArrayList<PShape> accessories = new ArrayList();
  
  // randomly generate a general chunk
  public Chunk(PVector chunkPosition, int numBuildings, int buildingSpacing){
    this.chunkPosition = chunkPosition; this.numBuildings = numBuildings; this.buildingSpacing = buildingSpacing;
    this.chunkSize = (int)sqrt(numBuildings)*buildingSpacing;
    fillChunk();
  }
  
  // construct a chunk from a matrix of predefined contents
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
        if (chunkContent[i][j]=="b") {
          Building b = new Building(i*buildingSpacing, 0, j*buildingSpacing, chunkType);
          b.addBillboards();
          buildings.add(b);
        }
        else if (chunkContent[i][j]=="r") {
          roads.add(new Road(new PVector(i*buildingSpacing, j*buildingSpacing), new PVector(buildingSpacing, buildingSpacing)));
          if (accessories.size()==0 && random(0, 1)<.3){
            PShape billboard = loadShape("billboard.obj");
            billboard.scale(40);
            accessories.add(billboard);
          }  
        }
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
    pushMatrix();
    rotateZ(PI);
    rotateY(-PI/2);
    translate(100, 0, 120);
    for (int i=0; i<accessories.size(); i++){
      shape(accessories.get(i));
    }
    popMatrix();
    popMatrix();
  }
    
}