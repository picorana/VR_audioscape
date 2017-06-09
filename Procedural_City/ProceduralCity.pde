class ProceduralCity{
  
  ArrayList<Chunk> chunks;

  int numChunks = 4;
  int num_buildings = 20;
  int lastRow = numChunks/2 - 1;
  
  public ProceduralCity(){

    chunks = new ArrayList();
    for(int i=-numChunks/2; i<numChunks/2; i++){
      for (int j=-numChunks/2; j<numChunks/2; j++){
        chunks.add(new Chunk(new PVector(i, j)));
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
    for (int i=-numChunks/2; i<numChunks/2; i++){
      chunks.add(new Chunk(new PVector(i, lastRow)));
    }
    
    for (int i=0; i<chunks.size(); i++){
      println(chunks.get(i).chunkPosition);
      if(chunks.get(i).chunkPosition.y <= (lastRow-numChunks)) chunks.remove(chunks.get(i));
    }
  }
  
}