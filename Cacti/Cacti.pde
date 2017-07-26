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
      cacti[i][j] = createMickeyCactus();
    }
  }

  cam = new PeasyCam(this, 500);
  //cam2 = new QueasyCam(this);
}

void draw(){
  //lights();
  background(255);
  rotateX(PI);
  for (int i=0; i<1; i++){
    for (int j=0; j<1; j++){
      pushMatrix();
      translate(i*150, j*150, 0);
      shape(cacti[i][j]);
      popMatrix();
    }
  }
}

PShape createCactus(){
  int sides = 101;
  float h = 100;
  float radius = 10;
  float angle = 360 / sides;
  float halfHeight = h / 2;
  
  PShape g = createShape(GROUP);
  
  // CACTUS BODY
  PShape r = createShape();
  r.beginShape(QUAD_STRIP);
  r.noStroke();
  for (int i = 0; i < sides + 1; i++) {
      float this_radius = radius;
      r.fill(color(0, 150, 0));
      if (i%3==0){
        this_radius += 5;
        r.fill(color(255, 200, 0));
      }
      float x = cos( radians( i * angle ) ) * this_radius;
      float y = sin( radians( i * angle ) ) * this_radius;
      r.vertex( x, y, halfHeight);
      r.vertex( x, y, -halfHeight);    
  }
  r.endShape(CLOSE);
  //g.addChild(r);
  
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

PShape createMickeyCactus(){
  PShape g = createShape(GROUP);
  float radius = random(20, 60.0);
  float tallness = random(1, 2.5);
  float rotationX = random(-0.0, 0.0);
  g.addChild(createMickeyPart(radius, tallness, rotationX, new PVector(0, 0, 0)));
  recursiveMickey(g, (int)random(1, 1), new PVector(0, 0, tallness*radius/8), radius, tallness);
  return g;}

void recursiveMickey(PShape group, int n, PVector prev_translation, float prev_radius, float prev_tallness){
  if (n==0) return;
  int num_children = 3;
  for (int i=0; i<num_children; i++){
      float radius = random(20, prev_radius/2);
      float tallness = random(1, prev_tallness);
      float rotationX = random(-0.0, 0.0);
      float angle = PI/(num_children-1);
      PVector translation_vector = new PVector(prev_translation.x , cos(i*angle)*radius/4, abs(cos(i*angle)*radius/4));
      group.addChild(createMickeyPart(radius, tallness, rotationX, translation_vector));
      recursiveMickey(group, n-1, new PVector(prev_translation.x + prev_translation.x*i*2, 0, prev_translation.z + tallness*radius/8), radius, tallness);
  }

}

PShape createMickeyPart(float radius, float tallness, float rotationX, PVector position){
  float rho = radius;
  float factor = TWO_PI/20.0;
  float x, y, z;

  PShape s = createShape();
  for(float phi = 0.0; phi < PI; phi += factor) {
    s.beginShape(QUAD_STRIP);
    s.noStroke();
    s.fill(150, 200, 0);
    
    for(float theta = 0.0; theta < TWO_PI + factor; theta += factor) {
      
      x = rho * sin(phi) * cos(theta)*.5;
      y = rho * sin(phi) * sin(theta);
      z = rho * cos(phi)* tallness;
      s.vertex(x, y, z);
      
      x = rho * sin(phi + factor) * cos(theta)*.5;
      y = rho * sin(phi + factor) * sin(theta);
      z = rho * cos(phi + factor) * tallness;
      s.vertex(x, y, z);
    }
    s.endShape(CLOSE);
    s.rotateX(rotationX);
    s.translate(position.x, position.y, position.z);
    
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