import java.util.*;
import queasycam.*;

QueasyCam cam;
ProceduralCity pc;

void setup(){
  size(700, 700, P3D);
  cam = new QueasyCam(this);
  
  pc = new ProceduralCity();
}

void draw(){
  background(0);
  lights();
  pc.update();
  pc.display();
}