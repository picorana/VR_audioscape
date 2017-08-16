class RoundCactus implements Cactus{
  PVector position;
  PVector targetPosition;
  PShape cactus;
  float creationTime;
  
  public RoundCactus(PVector position){
    this.position = position;
    targetPosition = position.copy();
    
    creationTime = millis();
    cactus = createCactus();
    cactus.scale(0.7);
  }
  
  void display(){
    pushMatrix();
    translate(1800 + position.x, - 50 + position.y, 9000 + position.z);
    rotateX(-HALF_PI);
    shape(cactus);
    popMatrix();
  }
  
  void update(){
    if (millis()-creationTime <= 800 && fallingItems){
      float cur_time = abs(millis()-creationTime);
      position.y = (targetPosition.y - 0.003125*pow(cur_time - 800, 2));
    } else position.y = targetPosition.y;
  }
  
  boolean removable(){
    if (abs(position.z - cameraOffsetZ) >=6000) return true;
    else return false;
  }
  
  PShape createCactus(){
    
    PShape g = createShape(GROUP);
    g.addChild(createHemisphere(g));
    
    return g;
  }
  
  PShape createHemisphere(PShape group){
  float radius = random(20, 80.0);
  float tallness = random(1, 4);
  float rho = radius;
  float factor = TWO_PI/20.0;
  float x, y, z;
  
  int type = 0;
  
  float green_r_component = random(100, 150);
  float green_g_component = 150;
  float green_b_component = random(100, 150);
  
  float yellow_r_component = random(200, 255);
  float yellow_g_component = random(200, 255);
  float yellow_b_component = random(120, 170);

  PShape s = createShape();
    for(float phi = 0.0; phi < PI; phi += factor) {
      s.beginShape(QUAD_STRIP);
      s.noStroke();
      
      for(float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
        
        if (theta%.6<.3) {
          rho = radius + 5;
          s.fill(color(yellow_r_component, yellow_g_component, yellow_b_component));
          /*if (random(0, 1)<.5){
            sphereDetail(1);
            PShape r = createShape(SPHERE, 3);
            r.setFill(color(150, 150, 150));
            r.setStroke(false);
            //r.scale(sin(phi)*cos(theta)*5, sin(phi)*sin(theta)*5, cos(phi)*5);
            r.translate(rho * sin(phi) * cos(theta), rho * sin(phi) * sin(theta), rho * cos(phi)*tallness*phi*.25);
            group.addChild(r);
          }*/
          
        } else {
          rho = radius;
          s.fill(color(green_r_component, green_g_component, green_b_component));
        }
        
        x = rho * sin(phi) * cos(theta);
        y = rho * sin(phi) * sin(theta);
        z = rho * cos(phi)* tallness*abs(phi*.5)*.5;
        //else z = rho * cos(phi)* tallness;
        s.vertex(x, y, z);
        
        x = rho * sin(phi + factor) * cos(theta);
        y = rho * sin(phi + factor) * sin(theta);
        z = rho * cos(phi + factor) * tallness*abs((phi+factor)*.5)*.5;
        //else z = rho * cos(phi + factor) * tallness;
        s.vertex(x, y, z);
      }
      s.rotateZ(HALF_PI);
      s.endShape(CLOSE); 
    }
    return s;
  }
}