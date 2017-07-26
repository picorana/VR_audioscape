class TerrainDetails{
  
  ArrayList items;
  ArrayList<Cactus> cacti;
  
  public TerrainDetails(){
    cacti = new ArrayList();
  }
  
  void display(){
    for (int i=0; i<cacti.size(); i++){
      cacti.get(i).display();
    }
  }
  
  void update(){
    for (int i=0; i<cacti.size(); i++){
      cacti.get(i).update();
      if (cacti.get(i).removable()) cacti.remove(i);
    }
  }
  
  
  void addCactus(PVector position){
    addCactus(position, (int) random(0, 2));
  }
  
  
  void addCactus(PVector position, int type){
    switch(type){
      case 0: cacti.add(new RoundCactus(position)); break;
      case 1: cacti.add(new FlatLeafCactus(position)); break;
    }
  }
}

  //if (random(0, 1)<.015) cacti.add(new Cactus(new PVector(-curveValue*tile_length, 0, cameraOffsetZ)));
  //if (random(0, 1)<.005) cacti.add(new Cactus(new PVector(-curveValue*tile_length + 600, 0, cameraOffsetZ)));