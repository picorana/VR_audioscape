
/* TODO:
*  figure out clearly the camera position when starting the app
*  change distance at which details are removed according to tile number and size
*  color of the terrain could be managed slightly better
*  is the road not really centered?
*  move every util function into util class?
*  load configuration from json file?
*  there's a dark line appearing in the terrain when the app is started
* 
*  Terrain:
*    - are we wasting resources by keeping an arraylist of PShapes? Is there a better way to do this?
*    - better use a quad strip instead of custom PShapes?
*
*/

//import queasycam.*;
//import peasy.*;
import java.util.*;

import processing.vr.*;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;

//QueasyCam cam;
//PeasyCam cam;
PApplet sketchPApplet;
SplashScreen splashScreen;
boolean splashScreenOn = true;
boolean recording   = false;
boolean grassEnabled = false;
int colorScheme = 0;

// Shader data
PShader skyShader;
PShader fogShader;
boolean shaderEnabled = true;

// Terrain data
Terrain terrain;
int strips_length   = 1;
int tile_length     = 40;
int strips_width    = 60;
int strips_num      = 60;

// More details
TerrainDetails details;
Dunes dunes;

// Skybox data
PShape skybox;
boolean skyboxEnabled = true;
color skyboxColor   = color(200, 200, 255);

// Movement data
boolean moving = true;
float curveValue    = 0;
int cameraOffsetZ   = 2;

// Memory management
long freeMemory; 

// Music Analysis
MusicAnalyzer ma;
Visualizer mVisualizer;
boolean recordAudioPermission = false;

// Day/night cycle
boolean isDay = true;
boolean isNight = false;

boolean fallingItems = false;
ArrayList<PShape> cactiMeshes;

void settings(){
  fullScreen(STEREO);
}


void setup(){ 
  
  requestPermission("android.permission.RECORD_AUDIO", "permissionCallback");
  
  sketchPApplet = this;
  
  splashScreen = new SplashScreen();
  
  loadCactiMeshes();
  
  terrain = new Terrain(tile_length, strips_length, strips_width, strips_num);
  
  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  float fogDistance = min(tile_length*strips_width, tile_length*strips_num)/2 - 100;
  println(fogDistance);
  fogShader.set("fogMinDistance", fogDistance - 300);
  fogShader.set("fogMaxDistance", fogDistance);
  fogShader.set("fogLimit", fogDistance + 700);
  
  setColorScheme(colorScheme);
  
  terrain.startTerrain();
  details = new TerrainDetails();
  dunes = new Dunes();
  skybox = createSkybox();
  
}

void draw() {
  
  if (splashScreenOn) {
    terrain.dividing_space = 6;
    terrain.setColorScheme(color(255), color(255));
    terrain.road.visible = false;
    pushMatrix();
    cameraToOrigin();
    splashScreen.display();
    splashScreen.update();
    popMatrix();
    pushMatrix();
    cameraCenter();
    translate(tile_length*strips_num/2, 0, 0);
    //translate(- tile_length*strips_num, 750, -cameraOffsetZ - strips_num*tile_length*1.7);
    terrain.display();
    if (moving) cameraOffsetZ+=tile_length;
  
    if (recordAudioPermission) terrain.addMusicStrip(ma.analyze());
    else if (cameraOffsetZ%(strips_length*tile_length)<1) terrain.addStrip();
    popMatrix();

    return;
  }
  
  rotateY(PI);
  
  //println("framerate: " + frameRate);
  
  background(skyboxColor);
  if (skyboxEnabled) shape(skybox);
  
  dunes.update();
  dunes.display();
  
  cameraCenter();
  
  // move the curve of the road according to a sine wave
  curveValue += sin(frameCount/20.0)*.2; 
  
  terrain.display();
  details.update();
  details.display();

  cycleColorScheme();
  
  if (moving) cameraOffsetZ+=tile_length;
  
  if (recordAudioPermission) terrain.addMusicStrip(ma.analyze());
  else if (cameraOffsetZ%(strips_length*tile_length)<1) terrain.addStrip();
  
  if (shaderEnabled) shader(fogShader);
  
  if (recording && (frameCount%5)==0) saveFrame("line-######.png");
}


// function used to change the colors
// 0 --> day, 1 --> night
void setColorScheme(int colorScheme){
  
  color terrainColorA, terrainColorB;
  
  if (colorScheme == 0){
    
    terrainColorA = color(204, 102, 0);
    terrainColorB = color(173, 152, 122);
    
    fogShader.set("fogColor", 225/255.0, 211/255.0, 190/255.0);
    fogShader.set("lightingEnabled", false);
    
  } else {
    
    terrainColorA = color(#185768);
    terrainColorB = color(#308096);
    
    fogShader.set("fogColor", 50.0/255, 93.0/255, 102.0/255);
    fogShader.set("lightingEnabled", true);
    
  }
  
  terrain.setColorScheme(terrainColorA, terrainColorB);
}


void cycleColorScheme(){
  
  float cycleDuration = 20000;
  float transitionDuration = 1000;
  float dayDuration = cycleDuration/2 - transitionDuration;
  float nightDuration = cycleDuration/2 - transitionDuration;
  float [] timePeriods = new float[]{
    dayDuration, 
    dayDuration + transitionDuration, 
    dayDuration + transitionDuration + nightDuration
  };
  
  color terrainColorDayA = color(204, 102, 0);
  color terrainColorDayB = color(173, 152, 122);
  color terrainColorNightA = color(#185768);
  color terrainColorNightB = color(#4090A6);
  
  color skyboxColorDay = color(#7EB583);
  color skyboxColorNight = color(30, 53, 70);
  
  color dunesFirstRowDay = color(225, 211, 190);
  color dunesSecondRowDay = color(222, 232, 223 );
  color dunesFirstRowNight = color(#325d66);
  color dunesSecondRowNight = color(222, 232, 223);
  
  color fogColorDay = color(225, 211, 190);
  color fogColorNight = color(50, 93, 102);
  
  float cur_time = millis() % cycleDuration;
  
  if (cur_time <= timePeriods[0] && !isDay) {
    // DAY
    terrain.setColorScheme(terrainColorDayA, terrainColorDayB);
    skybox.setFill(skyboxColorDay);
    dunes.setColorScheme(dunesFirstRowDay, dunesSecondRowDay);
    fogShader.set("fogColor", red(fogColorDay)/255.0, green(fogColorDay)/255.0, blue(fogColorDay)/255.0);
    
    isDay = true;
    
  } else if (cur_time > timePeriods[0] && cur_time <= timePeriods[1]) {
    // SUNSET
    color A = lerpColor(terrainColorDayA, terrainColorNightA, (cur_time - timePeriods[0])/transitionDuration);
    color B = lerpColor(terrainColorDayB, terrainColorNightB, (cur_time - timePeriods[0])/transitionDuration);
    terrain.setColorScheme(A, B);
    
    A = lerpColor(dunesFirstRowDay, dunesFirstRowNight, (cur_time - timePeriods[0])/transitionDuration);
    B = lerpColor(dunesSecondRowDay, dunesSecondRowNight, (cur_time - timePeriods[0])/transitionDuration);
    dunes.setColorScheme(A, B);
    
    color skyboxColor = lerpColor(skyboxColorDay, skyboxColorNight, (cur_time - timePeriods[0])/transitionDuration);
    skybox.setFill(skyboxColor);
    
    color fogColor = lerpColor(fogColorDay, fogColorNight, (cur_time - timePeriods[0])/transitionDuration);
    fogShader.set("fogColor", red(fogColor)/255.0, green(fogColor)/255.0, blue(fogColor)/255.0);
    
    isDay = false;
    
  } else if (cur_time > timePeriods[1] && cur_time <= timePeriods[2] && !isNight) {
    // NIGHT
    terrain.setColorScheme(terrainColorNightA, terrainColorNightB);
    dunes.setColorScheme(dunesFirstRowNight, dunesSecondRowNight);
    fogShader.set("fogColor", red(fogColorNight)/255.0, green(fogColorNight)/255.0, blue(fogColorNight)/255.0);
    skybox.setFill(skyboxColorNight);
    
    isNight = true;
    
  } else if (cur_time > timePeriods[2]){
    // DAWN
    color A = lerpColor(terrainColorNightA, terrainColorDayA, (cur_time - timePeriods[2])/transitionDuration);
    color B = lerpColor(terrainColorNightB, terrainColorDayB, (cur_time - timePeriods[2])/transitionDuration);
    terrain.setColorScheme(A, B);
    
    A = lerpColor(dunesFirstRowNight, dunesFirstRowDay, (cur_time - timePeriods[2])/transitionDuration);
    B = lerpColor(dunesSecondRowNight, dunesSecondRowDay, (cur_time - timePeriods[2])/transitionDuration);
    dunes.setColorScheme(A, B);
    
    color skyboxColor = lerpColor(skyboxColorNight, skyboxColorDay, (cur_time - timePeriods[2])/transitionDuration);
    skybox.setFill(skyboxColor);
    
    color fogColor = lerpColor(fogColorNight, fogColorDay, (cur_time - timePeriods[2])/transitionDuration);
    fogShader.set("fogColor", red(fogColor)/255.0, green(fogColor)/255.0, blue(fogColor)/255.0);
    
    isNight = false;
    
  }
}


PShape createSkybox(){
  PShape p = createShape(BOX, 9000);
  PShape s = createShape();

  s.beginShape(QUADS);
  s.noStroke();
  s.translate(0, -200);
  
  for (int i=0; i<p.getVertexCount(); i++){
    PVector v = p.getVertex(i);
    if (v.y<100) s.fill(color(#7EB583));
    else s.fill(color(255, 255, 255));
    s.vertex(v.x, v.y, v.z);
  }
  
  s.scale(1, 0.8, 1);
  s.endShape();
  return s;
}


void mouseClicked(){
  save("screenshot.png");
}


void keyPressed(){
  if (key == 'c'){
    if (recording == false) recording = true;
    else recording = false;
  } 
  if (key == 'v'){
    if (shaderEnabled) shaderEnabled = false;
    else shaderEnabled = true;
  }
}


// sets the camera to terrain center
void cameraCenter(){
  cameraToOrigin();
  translate(- tile_length*strips_num, 750, -cameraOffsetZ - strips_num*tile_length*1.7);
}


// sets the camera position to [0, 0, 0]
void cameraToOrigin(){
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
}


// queries the memory of the phone to understand how much memory is the app using
long getMemorySize() {
  long freeSize = 0L;
  long totalSize = 0L;
  long usedSize = -1L;
  try {
    Runtime info = Runtime.getRuntime();
    freeSize = info.freeMemory();
    totalSize = info.totalMemory();
    usedSize = totalSize - freeSize;
    println("free memory: " + freeSize);
    println("total memory: " + totalSize);
    println("used memory: " + usedSize);
  } catch (Exception e) {
    e.printStackTrace();
  }
  return freeSize;
}


void permissionCallback(boolean granted){
  if (granted){
    ma = new MusicAnalyzer();
    recordAudioPermission = true;
  }
}

void loadCactiMeshes(){
  cactiMeshes = new ArrayList();
  PShape s;
  for (int i=1; i<4; i++){
    if (i==1) s = loadShape("cactus.obj");
    else s = loadShape("cactus" + i + ".obj");
    s.scale(50);
    s.setFill(color(random(100, 150), 150, random(100, 150)));
    cactiMeshes.add(s);
  }
}