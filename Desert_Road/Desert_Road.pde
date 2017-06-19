import queasycam.*;
import java.util.*;

QueasyCam cam;
ArrayList<PVector> pathBuffer = new ArrayList();

void setup(){
  size(600, 600);
  
  for (int i=0; i<10; i++){
    pathBuffer.add(new PVector(width/2 + noise(i), i*10));  
  }
}

void draw(){
  for (int i=0; i<pathBuffer.size(); i++){
    point(pathBuffer.get(i).x, pathBuffer.get(i).y);
  }
}