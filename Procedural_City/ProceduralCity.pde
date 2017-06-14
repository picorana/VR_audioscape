class ProceduralCity{
  
  ArrayList<Chunk> chunks;

  int numChunks = 3;
  int numChunksY = 5;
  int numBuildings = 9;
  int buildingSpacing = 150;
  
  int lastRow = numChunks - 1;
  
  public ProceduralCity(int numChunks, int numBuildings, int buildingSpacing){
    this.numChunks = numChunks; this.numBuildings = numBuildings; this.buildingSpacing = buildingSpacing;

    chunks = new ArrayList();
    for(int i=0; i<numChunks; i++){
      for (int j=0; j<numChunksY; j++){
        if (i!=numChunks/2) chunks.add(new Chunk(new PVector(i, j), numBuildings, buildingSpacing));
        else chunks.add(new Chunk(new PVector(i, j), new String[][]{{"b", "b", "b"}, {"r", "r", "r"}, {"b", "b", "b"}}, buildingSpacing));
      }
    }
    
  }
  
  void update(){}
  
  void display(){
    
    pushMatrix();
    
    for (int i=0; i<chunks.size(); i++){
      chunks.get(i).display();
    }
    
    popMatrix();
  }
  
  void addChunks(){
    lastRow++;
    for (int i=0; i<numChunks; i++){
      if (i!=numChunks/2) chunks.add(new Chunk(new PVector(i, lastRow), numBuildings, buildingSpacing));
      else chunks.add(new Chunk(new PVector(i, lastRow), new String[][]{{"b", "b", "b"}, {"r", "r", "r"}, {"b", "b", "b"}}, buildingSpacing));
    }
    
    for (int i=0; i<chunks.size(); i++){
      println(chunks.get(i).chunkPosition);
      if(chunks.get(i).chunkPosition.y <= (lastRow-numChunksY)) chunks.remove(chunks.get(i));
    }
  }
  
}