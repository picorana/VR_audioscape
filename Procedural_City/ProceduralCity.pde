class ProceduralCity{
  
  ArrayList<Chunk> chunks;
  int numChunks = 3;
  
  ArrayList<Building> buildings;

  int num_buildings = 15;
  
  public ProceduralCity(){

    chunks = new ArrayList();
    for(int i=0; i<numChunks; i++){
      for (int j=0; j<numChunks; j++){
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
  
}