class RoundCactus implements Cactus{
  PVector position;
  PVector targetPosition;
  PShape cactus;
  float creationTime;
  
  public RoundCactus(PVector position){
    this.position = position;
    targetPosition = position;
    creationTime = millis();
    cactus = createCactus();
    cactus.scale(2);
  }
  
  void display(){
    pushMatrix();
    translate(1800 + position.x, -20 + position.y, 5300 + position.z);
    rotateX(-HALF_PI);
    shape(cactus);
    popMatrix();
  }
  
  void update(){
    if (abs(millis()-creationTime) < 5000){
      position.y = targetPosition.y - abs(millis() - creationTime);
    }
  }
  
  boolean removable(){
    if (abs(position.z - cameraOffsetZ) >=2000) return true;
    else return false;
  }
  
  PShape createCactus(){
    
    PShape g = createShape(GROUP);
    g.addChild(createHemisphere(g));
  
    return g;
  }
  
  PShape createHemisphere(PShape group){
  float radius = random(20, 50.0);
  float tallness = random(1, 3);
  float rho = radius;
  float factor = TWO_PI/40.0;
  float x, y, z;
  
  float green_r_component = random(50, 150);
  float green_g_component = random(150, 200);
  float green_b_component = random(50, 150);

  PShape s = createShape();
    for(float phi = 0.0; phi < PI; phi += factor) {
      s.beginShape(QUAD_STRIP);
      s.noStroke();
      
      for(float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
        
        if (theta%.1<.05) {
          rho = radius + 5;
          s.fill(color(255, 255, 150));
          if (random(0, 1)<.5){
            sphereDetail(1);
            PShape r = createShape(SPHERE, 1.5);
            r.setFill(color(150, 150, 150));
            r.setStroke(false);
            //r.scale(sin(phi)*cos(theta)*5, sin(phi)*sin(theta)*5, cos(phi)*5);
            r.translate(rho * sin(phi) * cos(theta), rho * sin(phi) * sin(theta), rho * cos(phi)*tallness*phi*.25);
            group.addChild(r);
          }
          
        } else {
          rho = radius;
          s.fill(color(green_r_component, green_g_component, green_b_component));
        }
        
        x = rho * sin(phi) * cos(theta);
        y = rho * sin(phi) * sin(theta);
        z = rho * cos(phi)* tallness*abs(phi*.5)*.5;
        s.vertex(x, y, z);
        
        x = rho * sin(phi + factor) * cos(theta);
        y = rho * sin(phi + factor) * sin(theta);
        z = rho * cos(phi + factor) * tallness*abs((phi+factor)*.5)*.5;
        s.vertex(x, y, z);
      }
      s.endShape(CLOSE);
    }
    return s;
  }
}