import peasy.*;
import queasycam.*;


int leaf_number = 4;
PShape[][] cacti = new PShape[10][10];

int leaf_length = 20;
int leaf_noise_scale = 30;
float leaf_noise_scale_internal = 1;
int leaf_step_size = 20;
PShape leaf;
PShape curve;
PShape cactus;
PeasyCam cam;
QueasyCam cam2;

void setup(){
  size(600, 600, P3D);
  for (int i=0; i<3; i++){
    for (int j=0; j<3; j++){
      cacti[i][j] = createCactus();
    }
  }

  cam = new PeasyCam(this, 500);
  //cam2 = new QueasyCam(this);
}

void draw(){
  background(255);
  rotateX(PI);
  for (int i=0; i<3; i++){
    for (int j=0; j<3; j++){
      pushMatrix();
      translate(i*150, j*150, 0);
      shape(cacti[i][j]);
      popMatrix();
    }
  }
}

PShape createCactus(){
  int sides = 51;
  float h = 100;
  float radius = 10;
  float angle = 360 / sides;
  float halfHeight = h / 2;
  int topNumComponents = 4;
  
  PShape g = createShape(GROUP);
  
  // CACTUS BODY
  PShape r = createShape();
  r.beginShape(QUAD_STRIP);
  r.noStroke();
  for (int i = 0; i < sides + 1; i++) {
      float this_radius = radius;
      r.fill(color(0, 150, 0));
      if (i%3==0){
        this_radius += 10;
        r.fill(color(255, 200, 0));
      }
      float x = cos( radians( i * angle ) ) * this_radius;
      float y = sin( radians( i * angle ) ) * this_radius;
      r.vertex( x, y, halfHeight);
      r.vertex( x, y, -halfHeight);    
  }
  r.endShape(CLOSE);
  //g.addChild(r);
  
  //CACTUS TOP
  /*float last_h = 0;
  int b = 50;
  for (int i=0; i<topNumComponents; i++){
    g.addChild(createCutCone(sides, b, radius*.25, radius, (last_h-10*i)*i));
    last_h = b;
    b = b-10;
    radius = radius*.25;
  }*/
  g.addChild(createHemisphere(g));

  return g;
}

PShape createHemisphere(PShape group){
  float radius = random(20, 50.0);
  float rho = radius;
  float factor = TWO_PI/20.0;
  float x, y, z;

  PShape s = createShape();
  for(float phi = 0.0; phi < PI; phi += factor) {
    s.beginShape(QUAD_STRIP);
    s.noStroke();
    for(float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
      if (theta%.2<.1) {
        rho = radius + 10;
        s.fill(color(255, 255, 0));
        if (random(0, 1)<.5){
          PShape r = createShape(SPHERE, 1);
          r.setFill(255);
          r.translate(rho * sin(phi) * cos(theta), rho * sin(phi) * sin(theta), rho * cos(phi));
          group.addChild(r);
        }
        
      }
      else {
        rho = radius;
        s.fill(color(100, 200, 100));
      }
      x = rho * sin(phi) * cos(theta);
      y = rho * sin(phi) * sin(theta);
      z = rho * cos(phi);
      s.vertex(x, y, z);
      
      x = rho * sin(phi + factor) * cos(theta);
      y = rho * sin(phi + factor) * sin(theta);
      z = rho * cos(phi + factor);
      s.vertex(x, y, z);
    }
    s.endShape(CLOSE);
  }
  return s;
}

PShape createCutCone(int sides, float h, float r1, float r2, float y_translation){
  PShape r = createShape();
  float angle = 360 / sides;
  float halfHeight = h / 2;

  r.beginShape(QUAD_STRIP);
  //r.noStroke();
  
  for (int i = 0; i < sides + 1; i++) {

    float this_radius1 = r1;
    float this_radius2 = r2;
    
      r.fill(color(0, 150, 0));
      if (i%3==0){
        this_radius1 += 10;
        this_radius2 += 10;
        r.fill(color(255, 200, 0));
      }
      
      float x1 = cos( radians( i * angle ) ) * this_radius1;
      float y1 = sin( radians( i * angle ) ) * this_radius1;
      float x2 = cos( radians( i * angle ) ) * this_radius2;
      float y2 = sin( radians( i * angle ) ) * this_radius2;
      r.vertex( x1, y1, -halfHeight - y_translation);
      r.vertex( x2, y2, halfHeight - y_translation);
  }
  r.endShape(CLOSE);
    
  return r;
}

PShape createCactus1(){
  PShape cactus = createShape(GROUP);
  for (int i=0; i<leaf_number; i++){
    PShape leaf = createLeaf(new PVector(random(-10, 10), 0), (int)random(10, 30), (int)random(0, 100));
    leaf.rotateY(PI/2*i);
    cactus.addChild(leaf);
  }
  for (int i=0; i<leaf_number*2; i++){
    PShape leaf = createLeaf(new PVector(10 + random(-10, 10), 0), (int)random(5, 8), (int)random(0, 100));
    leaf.rotateY(PI/4*i + 2);
    cactus.addChild(leaf);
  }
  return cactus;
}

PShape createCurve(PVector origin, int leaf_length){
  PShape s = createShape();
  s.beginShape();
  s.stroke(0);
  s.noFill();
  s.curveVertex(origin.x - 200, -5);
  s.curveVertex(origin.x + 10, 0.2);
  s.curveVertex(origin.x + 80, leaf_length * .8);
  s.curveVertex(origin.x + 50, leaf_length * 1.2);
  s.endShape();
  return s;
}

PShape createLeaf(PVector origin, int leaf_length, int random_seed){
  PShape leaf = createShape();
  int leaf_height = leaf_step_size * leaf_length;
  PShape curve = createCurve(origin, leaf_height);
  color green = color(random(50, 150), 200, random(50, 150));
  
  leaf.beginShape();
  leaf.fill(green);
  //leaf.noStroke();
  
  leaf.vertex(origin.x, 0);
  
  for (int i=0; i<leaf_length; i++){
    float t = i/float(leaf_length);
    float point_x = curvePoint(curve.getVertex(0).x, curve.getVertex(1).x, curve.getVertex(2).x, curve.getVertex(3).x, t);
    float point_y = curvePoint(curve.getVertex(0).y, curve.getVertex(1).y, curve.getVertex(2).y, curve.getVertex(3).y, t);
    float this_noise_scale = leaf_noise_scale - abs(i-leaf_length/2);
    float rand_val = random(-10, 10);
    leaf.vertex(noise(i*leaf_noise_scale_internal + random_seed)*this_noise_scale + point_x + 10, point_y, rand_val);
  }
  
  leaf.vertex(curvePoint(curve.getVertex(0).x, curve.getVertex(1).x, curve.getVertex(2).x, curve.getVertex(3).x, 1),  
      curvePoint(curve.getVertex(0).y, curve.getVertex(1).y, curve.getVertex(2).y, curve.getVertex(3).y, 1));
  
  for (int i=leaf_length; i>0; i--){
    float t = i/float(leaf_length);
    float point_x = curvePoint(curve.getVertex(0).x, curve.getVertex(1).x, curve.getVertex(2).x, curve.getVertex(3).x, t);
    float point_y = curvePoint(curve.getVertex(0).y, curve.getVertex(1).y, curve.getVertex(2).y, curve.getVertex(3).y, t);
    float this_noise_scale = leaf_noise_scale - abs(i-leaf_length/2);
    float rand_val = random(-5, 5);
    leaf.vertex(-noise(i*leaf_noise_scale_internal + random_seed)*this_noise_scale + point_x - 10, point_y, rand_val);
  }
  
  leaf.endShape(CLOSE);
  return leaf;
}