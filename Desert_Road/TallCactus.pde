class TallCactus implements Cactus{
  PVector position;
  PVector targetPosition;
  PShape cactus;
  float creationTime;
  
  public TallCactus(PVector position){
    this.position = position;
    targetPosition = position.copy();
    
    creationTime = millis();
    cactus = cactiMeshes.get(0);
    
    //cactus.setFill(color(100, 150, 100));
    //cactus.scale(50);
  }
  
  void display(){
    pushMatrix();
    translate(1800 + position.x, - 50 + position.y, 6000 + position.z);
    rotateX(PI);
    rotateY(HALF_PI);
    shape(cactus);
    popMatrix();
  }
  
  void update(){
    if (millis()-creationTime <= 800 && fallingItems){
      float cur_time = abs(millis()-creationTime);
      position.y = (targetPosition.y - 0.003125*pow(cur_time - 800, 2));
      //println(position.y + " " + targetPosition.y);
    } else position.y = targetPosition.y;
  }
  
  boolean removable(){
    if (abs(position.z - cameraOffsetZ) >=4000) return true;
    else return false;
  }
}