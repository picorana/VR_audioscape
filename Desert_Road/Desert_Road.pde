
/* TODO:
*  figure out clearly the camera position when starting the app
*  change distance at which details are removed according to tile number and size
*  color of the terrain could be managed slightly better
*  position of cacti is unnecessarily changed twice when it spawns and when it is drawn
*
*/

import java.util.*;
import processing.vr.*;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;

PApplet sketchPApplet;
SplashScreen splashScreen;
boolean splashScreenOn    = true;
boolean recording         = false;
boolean grassEnabled      = false;
int colorScheme = 0;

// Shader data
PShader skyShader;
PShader fogShader;
float fogDistance;
boolean shaderEnabled = true;

// Terrain data
Terrain terrain;
int strips_length   = 1;
int tile_length     = 50;
int strips_width    = 50;
int strips_num      = 90;

// More details
TerrainDetails details;
Dunes dunes;

// Skybox data
PShape skybox;
boolean skyboxEnabled   = true;
color skyboxColor       = color(200, 200, 255);

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
boolean isDay     = true;
boolean isNight   = false;
boolean isDusk    = false;
boolean isDawn    = false;
color curFogColor = color(0, 0, 0);

boolean fallingItems = false;
ArrayList<PShape> cactiMeshes;

PShape fadeOutScreen;
boolean fadingOut = false;
float fadingOutStart = 0;
float fadingOutDuration = 5000;
boolean displayFadeOutScreen = false;


void settings(){
  fullScreen(STEREO);
}


void setup(){ 
  requestPermission("android.permission.RECORD_AUDIO", "permissionCallback"); 
  sketchPApplet = this;
  
  ((PGraphicsOpenGL)g).pgl.enable(PGL.CULL_FACE);
  
  loadCactiMeshes();
  
  terrain = new Terrain(tile_length, strips_length, strips_width, strips_num);
  
  setupShader();
  
  setColorScheme(colorScheme);
  
  terrain.startTerrain();
  details = new TerrainDetails();
  dunes = new Dunes();
  skybox = createSkybox();
  
  splashScreen = new SplashScreen(terrain);
  if (splashScreenOn) terrain.dividing_space = 6;
  fadeOutScreen = createShape(BOX, 500);
  fadeOutScreen.setFill(color(0, 0));
  fadeOutScreen.setStroke(true);
}


void draw() {
  
  if (fadingOut) transition();
  
  if (splashScreenOn) {
    cameraToOrigin();
    terrain.setColorScheme(color(255), color(255));
    terrain.road.visible = false;
    splashScreen.display();
    splashScreen.update();
    pushMatrix();
    cameraCenter();
    translate(tile_length*strips_width/2, 500, 0);
    terrain.display();
    
    if (moving) cameraOffsetZ+=tile_length;
  
    if (recordAudioPermission) terrain.addMusicStrip(ma.analyze());
    else if (cameraOffsetZ%(strips_length*tile_length)<1) terrain.addStrip();
    popMatrix();
    shape(fadeOutScreen);

    return;
  }
  
  if (shaderEnabled) shader(fogShader);
  
  rotateY(PI);
  
  println("framerate: " + frameRate);
  
  background(skyboxColor);
  if (skyboxEnabled) shape(skybox);
  
  dunes.update();
  dunes.display();
  
  cameraToOrigin();
  if (displayFadeOutScreen) {
    pushMatrix();
    translate(-1000, -50, -700);
    shape(fadeOutScreen);
    popMatrix();
  }
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
  
  
  
  if (recording && (frameCount%5)==0) saveFrame("line-######.png");
}


void transition(){
  float timeDiff = millis() - fadingOutStart; 
  if (timeDiff < fadingOutDuration*.25){
    fadeOutScreen.setFill(color(0, map(timeDiff, 0, fadingOutDuration*.25, 0, 300)));
    fogShader.set("fogMaxDistance", 0.0);
    fogShader.set("fogColor", 0.0, 0.0, 0.0);
    fogShader.set("fogLimit", 50000);
    
  } else if (timeDiff < fadingOutDuration) {
    splashScreenOn = false;
    terrain.road.visible = true;
    terrain.dividing_space = 1;
    //fadeOutScreen.setFill(color(0, map(timeDiff, fadingOutDuration/2, fadingOutDuration, 300, 0)));
    
    float thisFogDistance = map(timeDiff, fadingOutDuration*.25, fadingOutDuration, 0, fogDistance);
    
    fogShader.set("fogMinDistance", thisFogDistance - 600);
    fogShader.set("fogMaxDistance", thisFogDistance);
    fogShader.set("fogLimit", thisFogDistance + 50000 - map(timeDiff, fadingOutDuration*.25, fadingOutDuration, 0, 50000 - 200));
    color thisCurFogColor = lerpColor(color(0, 0, 0), curFogColor, map(timeDiff, fadingOutDuration*.25, fadingOutDuration, 0, 1));
    fogShader.set("fogColor", red(thisCurFogColor)/255.0, green(thisCurFogColor)/255.0, blue(thisCurFogColor)/255.0);
  } else fadingOut = false;
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
  
  float cycleDuration = 40000;
  float transitionDuration = 1000;
  float dayDuration = cycleDuration/4 - transitionDuration;
  float dawnDuration = cycleDuration/4 - transitionDuration;
  float nightDuration = cycleDuration/4 - transitionDuration;
  float duskDuration = cycleDuration/4 - transitionDuration;
  float [] timePeriods = new float[]{
    dayDuration, 
    dayDuration + transitionDuration, 
    dayDuration + transitionDuration + dawnDuration,
    dayDuration + transitionDuration + dawnDuration + transitionDuration,
    dayDuration + transitionDuration + dawnDuration + transitionDuration + nightDuration,
    dayDuration + transitionDuration + dawnDuration + transitionDuration + nightDuration + transitionDuration,
    dayDuration + transitionDuration + dawnDuration + transitionDuration + nightDuration + transitionDuration + duskDuration
  };
  
  color terrainColorDayA = color(204, 102, 0);
  color terrainColorDayB = color(173, 152, 122);
  color terrainColorNightA = color(#185768);
  color terrainColorNightB = color(#4090A6);
  color terrainColorDawnA = color(#4D2E36);
  color terrainColorDawnB = color(#6A3B43);
  color terrainColorDuskA = color(#354356);
  color terrainColorDuskB = color(#916D6F);
  
  color skyboxColorDay = color(#7EB583);
  color skyboxColorDawn = color(#FFE3BC);
  color skyboxColorNight = color(30, 53, 70);
  color skyboxColorDusk = color(#BCC4C4);
  
  color dunesFirstRowDay = color(225, 211, 190);
  color dunesSecondRowDay = color(222, 232, 223 );
  color dunesFirstRowNight = color(#325d66);
  color dunesSecondRowNight = color(222, 232, 223);
  color dunesFirstRowDawn = color(#6A4954);
  color dunesSecondRowDawn = color(#BC846D);
  color dunesFirstRowDusk = color(#C97642);
  color dunesSecondRowDusk = color(#FFC576);
  
  color fogColorDay = color(225, 211, 190);
  color fogColorNight = color(50, 93, 102);
  color fogColorDusk = dunesFirstRowDusk;
  color fogColorDawn = dunesFirstRowDawn;
  
  float cur_time = millis() % cycleDuration;
  
  if (cur_time <= timePeriods[0] && !isDay) {
    // DAY
    terrain.setColorScheme(terrainColorDayA, terrainColorDayB);
    skybox.setFill(skyboxColorDay);
    dunes.setColorScheme(dunesFirstRowDay, dunesSecondRowDay);
    fogShader.set("fogColor", red(fogColorDay)/255.0, green(fogColorDay)/255.0, blue(fogColorDay)/255.0);
    curFogColor = fogColorDay;
    
    isDay = true;
    
  } else if (cur_time > timePeriods[0] && cur_time <= timePeriods[1]) {
    // TRANSITION DAY TO DUSK
    color A = lerpColor(terrainColorDayA, terrainColorDuskA, (cur_time - timePeriods[0])/transitionDuration);
    color B = lerpColor(terrainColorDayB, terrainColorDuskB, (cur_time - timePeriods[0])/transitionDuration);
    terrain.setColorScheme(A, B);
    
    A = lerpColor(dunesFirstRowDay, dunesFirstRowDusk, (cur_time - timePeriods[0])/transitionDuration);
    B = lerpColor(dunesSecondRowDay, dunesSecondRowDusk, (cur_time - timePeriods[0])/transitionDuration);
    dunes.setColorScheme(A, B);
    
    color skyboxColor = lerpColor(skyboxColorDay, skyboxColorDusk, (cur_time - timePeriods[0])/transitionDuration);
    skybox.setFill(skyboxColor);
    
    color fogColor = lerpColor(fogColorDay, fogColorDusk, (cur_time - timePeriods[0])/transitionDuration);
    fogShader.set("fogColor", red(fogColor)/255.0, green(fogColor)/255.0, blue(fogColor)/255.0);
    curFogColor = fogColor;
    
    isDay = false;
    
  } else if (cur_time > timePeriods[1] && cur_time <= timePeriods[2] && !isDusk) {
    // DUSK
    terrain.setColorScheme(terrainColorDuskA, terrainColorDuskB);
    dunes.setColorScheme(dunesFirstRowDusk, dunesSecondRowDusk);
    fogShader.set("fogColor", red(fogColorDusk)/255.0, green(fogColorDusk)/255.0, blue(fogColorDusk)/255.0);
    skybox.setFill(skyboxColorDusk);
    curFogColor = fogColorDusk;
    
    isDusk = true;
    
  } else if (cur_time > timePeriods[2] && cur_time <= timePeriods[3]){
    // TRANSITION DUSK TO NIGHT
    color A = lerpColor(terrainColorDuskA, terrainColorNightA, (cur_time - timePeriods[2])/transitionDuration);
    color B = lerpColor(terrainColorDuskB, terrainColorNightB, (cur_time - timePeriods[2])/transitionDuration);
    terrain.setColorScheme(A, B);
    
    A = lerpColor(dunesFirstRowDusk, dunesFirstRowNight, (cur_time - timePeriods[2])/transitionDuration);
    B = lerpColor(dunesSecondRowDusk, dunesSecondRowNight, (cur_time - timePeriods[2])/transitionDuration);
    dunes.setColorScheme(A, B);
    
    color skyboxColor = lerpColor(skyboxColorDusk, skyboxColorNight, (cur_time - timePeriods[2])/transitionDuration);
    skybox.setFill(skyboxColor);
    
    color fogColor = lerpColor(fogColorDusk, fogColorNight, (cur_time - timePeriods[2])/transitionDuration);
    fogShader.set("fogColor", red(fogColor)/255.0, green(fogColor)/255.0, blue(fogColor)/255.0);
    curFogColor = fogColor;
    
    isDusk = false;
    
  } else if (cur_time > timePeriods[3] && cur_time <= timePeriods[4] && !isNight) {
    // NIGHT
    terrain.setColorScheme(terrainColorNightA, terrainColorNightB);
    dunes.setColorScheme(dunesFirstRowNight, dunesSecondRowNight);
    fogShader.set("fogColor", red(fogColorNight)/255.0, green(fogColorNight)/255.0, blue(fogColorNight)/255.0);
    skybox.setFill(skyboxColorNight);
    curFogColor = fogColorNight;
    
    isNight = true;
    
  } else if (cur_time > timePeriods[4] && cur_time <= timePeriods[5]){
    // TRANSITION NIGHT TO DAWN
    color A = lerpColor(terrainColorNightA, terrainColorDawnA, (cur_time - timePeriods[4])/transitionDuration);
    color B = lerpColor(terrainColorNightB, terrainColorDawnB, (cur_time - timePeriods[4])/transitionDuration);
    terrain.setColorScheme(A, B);
    
    A = lerpColor(dunesFirstRowNight, dunesFirstRowDawn, (cur_time - timePeriods[4])/transitionDuration);
    B = lerpColor(dunesSecondRowNight, dunesSecondRowDawn, (cur_time - timePeriods[4])/transitionDuration);
    dunes.setColorScheme(A, B);
    
    color skyboxColor = lerpColor(skyboxColorNight, skyboxColorDawn, (cur_time - timePeriods[4])/transitionDuration);
    skybox.setFill(skyboxColor);
    
    color fogColor = lerpColor(fogColorNight, fogColorDawn, (cur_time - timePeriods[4])/transitionDuration);
    fogShader.set("fogColor", red(fogColor)/255.0, green(fogColor)/255.0, blue(fogColor)/255.0);
    curFogColor = fogColor;
    
    isNight = false;
    
  } else if (cur_time > timePeriods[5] && cur_time <= timePeriods[6] && !isDawn) {
    // DAWN
    terrain.setColorScheme(terrainColorDawnA, terrainColorDawnB);
    dunes.setColorScheme(dunesFirstRowDawn, dunesSecondRowDawn);
    fogShader.set("fogColor", red(fogColorDawn)/255.0, green(fogColorDawn)/255.0, blue(fogColorDawn)/255.0);
    skybox.setFill(skyboxColorDawn);
    
    isDawn = true;
    
  } else if (cur_time > timePeriods[6]){
    // TRANSITION DAWN TO DAY
    color A = lerpColor(terrainColorDawnA, terrainColorDayA, (cur_time - timePeriods[6])/transitionDuration);
    color B = lerpColor(terrainColorDawnB, terrainColorDayB, (cur_time - timePeriods[6])/transitionDuration);
    terrain.setColorScheme(A, B);
    
    A = lerpColor(dunesFirstRowDawn, dunesFirstRowDay, (cur_time - timePeriods[6])/transitionDuration);
    B = lerpColor(dunesSecondRowDawn, dunesSecondRowDay, (cur_time - timePeriods[6])/transitionDuration);
    dunes.setColorScheme(A, B);
    
    color skyboxColor = lerpColor(skyboxColorDawn, skyboxColorDay, (cur_time - timePeriods[6])/transitionDuration);
    skybox.setFill(skyboxColor);
    
    color fogColor = lerpColor(fogColorDawn, fogColorDay, (cur_time - timePeriods[6])/transitionDuration);
    fogShader.set("fogColor", red(fogColor)/255.0, green(fogColor)/255.0, blue(fogColor)/255.0);
    curFogColor = fogColor;
    
    isDawn = false;
  }
}


PShape createSkybox(){
  PShape p = createShape(BOX, 10000);
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
  //cameraToOrigin();
  translate(- tile_length*strips_width, 500, -cameraOffsetZ - strips_num*tile_length*1.5 - 100);
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

void setupShader(){
  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  fogDistance = min(10000, tile_length*strips_num)/2 + 200;
  /*fogShader.set("fogMinDistance", fogDistance - 600);
  fogShader.set("fogMaxDistance", fogDistance);
  fogShader.set("fogLimit", fogDistance + 400);*/
  fogShader.set("fogMaxDistance", 0.0);
  fogShader.set("fogColor", 0.0, 0.0, 0.0);
  fogShader.set("fogLimit", 50000);
}