import queasycam.*;
import java.util.*;

QueasyCam cam;
Terrain t;

void setup(){
  size(600, 600, P3D);
  cam = new QueasyCam(this);
  t = new Terrain();
}

void draw() {
  background(255);
  lights();
  ambientLight(102, 102, 102);
 
  translate(-200, 500, -200);
  t.display();
  t.update();
}

void mouseClicked(){
  save("screenshot.png");
}