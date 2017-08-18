class FlatLeafCactus implements Cactus{
  
  PVector position;
  
  int leaf_number = 4;
  int leaf_length = 20;
  int leaf_noise_scale = 30;
  float leaf_noise_scale_internal = 1;
  int leaf_step_size = 20;
  
  PVector targetPosition;
  float creationTime;
  
  PShape cactus;
  
  public FlatLeafCactus(PVector position) {
    this.position = position;
    targetPosition = position.copy();
    creationTime = millis();
    
    cactus = createCactus();
    cactus.scale(0.7);
  }
  
  void display() {
    pushMatrix();
    translate(1800 + position.x, -50 + position.y, 9000 + position.z);
    rotateX(PI);
    shape(cactus);
    popMatrix();
  }
  
  void update() {
    if (millis()-creationTime <= 800 && fallingItems) {
      float cur_time = abs(millis()-creationTime);
      position.y = (targetPosition.y - 0.003125*pow(cur_time - 800, 2));
      //println(position.y + " " + targetPosition.y);
    } else position.y = targetPosition.y;
  }
  
  boolean removable() {
    if (abs(position.z - cameraOffsetZ) >=6000) return true;
    else return false;
  }
  
  PShape createCactus() {
    PShape cactus = createShape(GROUP);
    for (int i=0; i<leaf_number; i++) {
      PShape leaf = createLeaf(new PVector(random(-10, 10), 0), (int)random(10, 25), (int)random(0, 100));
      leaf.rotateY(PI/2*i);
      cactus.addChild(leaf);
    }
    for (int i=0; i<leaf_number*2; i++) {
      PShape leaf = createLeaf(new PVector(10 + random(-10, 10), 0), (int)random(5, 8), (int)random(0, 100));
      leaf.rotateY(PI/4*i + 2);
      cactus.addChild(leaf);
    }
    return cactus;
  }
  
  PShape createCurve(PVector origin, int leaf_length) {
    PShape s = createShape();
    s.beginShape();    
    s.noStroke();
    s.noFill();
    s.curveVertex(origin.x - 200, -5);
    s.curveVertex(origin.x + 10, 0.2);
    s.curveVertex(origin.x + 80, leaf_length * .8);
    s.curveVertex(origin.x + 50, leaf_length * 1.2);
    s.endShape();
    return s;
  }
  
  PShape createLeaf(PVector origin, int leaf_length, int random_seed) {
    PShape leaf = createShape();
    int leaf_height = leaf_step_size * leaf_length;
    PShape curve = createCurve(origin, leaf_height);
    color green = color(random(100, 150), 150, random(100, 150));
    
    leaf.beginShape();
    leaf.fill(green);
    leaf.noStroke();
    
    leaf.vertex(origin.x, 0);
    
    for (int i=0; i<leaf_length; i++) {
      float t = i/float(leaf_length);
      float point_x = curvePoint(curve.getVertex(0).x, curve.getVertex(1).x, curve.getVertex(2).x, curve.getVertex(3).x, t);
      float point_y = curvePoint(curve.getVertex(0).y, curve.getVertex(1).y, curve.getVertex(2).y, curve.getVertex(3).y, t);
      float this_noise_scale = leaf_noise_scale - abs(i-leaf_length/2);
      float rand_val = random(-10, 10);
      leaf.normal(-1, 0, 0);
      leaf.vertex(noise(i*leaf_noise_scale_internal + random_seed)*this_noise_scale + point_x + 10, point_y, rand_val);
    }
    
    leaf.vertex(curvePoint(curve.getVertex(0).x, curve.getVertex(1).x, curve.getVertex(2).x, curve.getVertex(3).x, 1),  
        curvePoint(curve.getVertex(0).y, curve.getVertex(1).y, curve.getVertex(2).y, curve.getVertex(3).y, 1));
    
    for (int i=leaf_length; i>0; i--) {
      float t = i/float(leaf_length);
      float point_x = curvePoint(curve.getVertex(0).x, curve.getVertex(1).x, curve.getVertex(2).x, curve.getVertex(3).x, t);
      float point_y = curvePoint(curve.getVertex(0).y, curve.getVertex(1).y, curve.getVertex(2).y, curve.getVertex(3).y, t);
      float this_noise_scale = leaf_noise_scale - abs(i-leaf_length/2);
      float rand_val = random(-5, 5);
      leaf.normal(-1, 0, 0);
      leaf.vertex(-noise(i*leaf_noise_scale_internal + random_seed)*this_noise_scale + point_x - 10, point_y, rand_val);
    }
    
    leaf.endShape(CLOSE);
    return leaf;
  }
}