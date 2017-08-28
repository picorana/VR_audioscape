/*
 * Music visualization for Google Cardboard
 * by @picorana as part of GSoC 2017
 * latest version: http://github.com/picorana/VR_Demo_GSoC17
 */

import java.util.*;
import processing.vr.*;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;

PApplet sketchPApplet;
SplashScreen splashScreen;
boolean splashScreenOn = true;
boolean recording = false;
boolean grassEnabled = false;
int colorScheme = 0;

// Shader data
PShader skyShader;
PShader fogShader;
float fogDistance;
boolean shaderEnabled = true;

// Terrain data
Terrain terrain;
int strips_length = 1;
int tile_length = 60;
int strips_width = 50;
int strips_num = 90;

// Other details in the scene
ArrayList<PShape> cactiMeshes;
boolean fallingItems = false;
TerrainDetails details;
Dunes dunes;

// Skybox data
PShape skybox;
boolean skyboxEnabled = true;
color skyboxColor = color(200, 200, 255);
color curSkyboxColor = skyboxColor;

// Movement data
boolean moving = true;
float curveValue = 0;
int cameraOffsetZ = 2;

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

// Transition between splash screen and desert scene
PShape fadeOutScreen;
boolean displayFadeOutScreen = false;
boolean fadingOut = false;
float fadingOutStart = 0;
float fadingOutDuration = 5000;


void settings() {
  fullScreen(STEREO);
}


void setup() {
  requestPermission("android.permission.RECORD_AUDIO", "permissionCallback");
  sketchPApplet = this;

  // init everything
  loadCactiMeshes();
  terrain = new Terrain(tile_length, strips_length, strips_width, strips_num);
  terrain.startTerrain();
  details = new TerrainDetails();
  dunes = new Dunes();
  skybox = createSkybox();
  splashScreen = new SplashScreen(terrain);

  // Shader
  ((PGraphicsOpenGL)g).pgl.enable(PGL.CULL_FACE);
  setupShader();
}


void draw() {
  frameRate(60);

  println("framerate: " + frameRate);
  if (fadingOut) transition();

  if (splashScreenOn) {
    cameraToOrigin();

    splashScreen.display();
    splashScreen.update();

    pushMatrix();
    cameraCenter();
    translate(tile_length*strips_width/2, 500, 0);
    terrain.display();
    popMatrix();

    shape(fadeOutScreen);

  } else {

    if (shaderEnabled) shader(fogShader);

    rotateY(PI);

    background(curSkyboxColor);
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
    curveValue += (sin(frameCount/20.0))*.2;

    terrain.display();
    details.update();
    details.display();

    cycleColorScheme();
  }

  if (moving) cameraOffsetZ+=tile_length*.5;

  if (recordAudioPermission && frameCount%2==0) terrain.addMusicStrip(ma.analyze());
  else if (cameraOffsetZ%(strips_length*tile_length)<1 && frameCount%2==0) terrain.addStrip();

  if (recording && (frameCount%5)==0) saveFrame("line-######.png");
}

// at the end of splash screen, this function is used to have a gradual transition between one scene to another
void transition() {

  float timeDiff = millis() - fadingOutStart;

  // first part: it makes fadeOutScreen (a box in front of the camera) go darker and darker until it's black
  if (timeDiff < fadingOutDuration*.25) {
    fadeOutScreen.setFill(color(0, map(timeDiff, 0, fadingOutDuration*.25, 0, 300)));
    fogShader.set("fogMaxDistance", 0.0);
    fogShader.set("fogColor", 0.0, 0.0, 0.0);
    fogShader.set("fogLimit", 50000);

  // second part: it makes the fog gradually disappear in order to reveal the scene underneath
  } else if (timeDiff < fadingOutDuration) {
    splashScreenOn = false;
    terrain.road.visible = true;
    terrain.dividing_space = 1;

    float thisFogDistance = map(timeDiff, fadingOutDuration*.25, fadingOutDuration, 0, fogDistance);

    fogShader.set("fogMinDistance", thisFogDistance - 1000);
    fogShader.set("fogMaxDistance", thisFogDistance);
    fogShader.set("fogLimit", thisFogDistance + 50000 - map(timeDiff, fadingOutDuration*.25, fadingOutDuration, 0, 50000 - 600));
    color thisCurFogColor = lerpColor(color(0, 0, 0), curFogColor, map(timeDiff, fadingOutDuration*.25, fadingOutDuration, 0, 1));
    fogShader.set("fogColor", red(thisCurFogColor)/255.0, green(thisCurFogColor)/255.0, blue(thisCurFogColor)/255.0);

  // end: fadingOut boolean is used to figure out if this function needs to be called or not.
  } else fadingOut = false;
}

// transition between day, dusk, night, dawn
void cycleColorScheme() {

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
    curSkyboxColor = skyboxColorDay;
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
    curSkyboxColor = skyboxColor;

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
    curSkyboxColor = skyboxColorDusk;
    curFogColor = fogColorDusk;

    isDusk = true;

  } else if (cur_time > timePeriods[2] && cur_time <= timePeriods[3]) {
    // TRANSITION DUSK TO NIGHT
    color A = lerpColor(terrainColorDuskA, terrainColorNightA, (cur_time - timePeriods[2])/transitionDuration);
    color B = lerpColor(terrainColorDuskB, terrainColorNightB, (cur_time - timePeriods[2])/transitionDuration);
    terrain.setColorScheme(A, B);

    A = lerpColor(dunesFirstRowDusk, dunesFirstRowNight, (cur_time - timePeriods[2])/transitionDuration);
    B = lerpColor(dunesSecondRowDusk, dunesSecondRowNight, (cur_time - timePeriods[2])/transitionDuration);
    dunes.setColorScheme(A, B);

    color skyboxColor = lerpColor(skyboxColorDusk, skyboxColorNight, (cur_time - timePeriods[2])/transitionDuration);
    skybox.setFill(skyboxColor);
    curSkyboxColor = skyboxColor;

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
    curSkyboxColor = skyboxColorNight;
    curFogColor = fogColorNight;

    isNight = true;

  } else if (cur_time > timePeriods[4] && cur_time <= timePeriods[5]) {
    // TRANSITION NIGHT TO DAWN
    color A = lerpColor(terrainColorNightA, terrainColorDawnA, (cur_time - timePeriods[4])/transitionDuration);
    color B = lerpColor(terrainColorNightB, terrainColorDawnB, (cur_time - timePeriods[4])/transitionDuration);
    terrain.setColorScheme(A, B);

    A = lerpColor(dunesFirstRowNight, dunesFirstRowDawn, (cur_time - timePeriods[4])/transitionDuration);
    B = lerpColor(dunesSecondRowNight, dunesSecondRowDawn, (cur_time - timePeriods[4])/transitionDuration);
    dunes.setColorScheme(A, B);

    color skyboxColor = lerpColor(skyboxColorNight, skyboxColorDawn, (cur_time - timePeriods[4])/transitionDuration);
    skybox.setFill(skyboxColor);
    curSkyboxColor = skyboxColor;

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
    curSkyboxColor = skyboxColorDawn;

    isDawn = true;

  } else if (cur_time > timePeriods[6]) {
    // TRANSITION DAWN TO DAY
    color A = lerpColor(terrainColorDawnA, terrainColorDayA, (cur_time - timePeriods[6])/transitionDuration);
    color B = lerpColor(terrainColorDawnB, terrainColorDayB, (cur_time - timePeriods[6])/transitionDuration);
    terrain.setColorScheme(A, B);

    A = lerpColor(dunesFirstRowDawn, dunesFirstRowDay, (cur_time - timePeriods[6])/transitionDuration);
    B = lerpColor(dunesSecondRowDawn, dunesSecondRowDay, (cur_time - timePeriods[6])/transitionDuration);
    dunes.setColorScheme(A, B);

    color skyboxColor = lerpColor(skyboxColorDawn, skyboxColorDay, (cur_time - timePeriods[6])/transitionDuration);
    skybox.setFill(skyboxColor);
    curSkyboxColor = skyboxColor;

    color fogColor = lerpColor(fogColorDawn, fogColorDay, (cur_time - timePeriods[6])/transitionDuration);
    fogShader.set("fogColor", red(fogColor)/255.0, green(fogColor)/255.0, blue(fogColor)/255.0);
    curFogColor = fogColor;

    isDawn = false;
  }
}


PShape createSkybox() {
  PShape p = createShape(BOX, 11000);
  PShape s = createShape();

  s.beginShape(QUADS);
  s.noStroke();
  s.translate(0, -200);

  for (int i=0; i<p.getVertexCount(); i++) {
    PVector v = p.getVertex(i);
    if (v.y<100) s.fill(color(#7EB583));
    else s.fill(color(255, 255, 255));
    s.vertex(v.x, v.y, v.z);
  }

  //s.scale(1, 1, 1);
  s.endShape();
  return s;
}


void mouseClicked() {
  save("screenshot.png");
}


void keyPressed() {
  if (key == 'c') {
    if (recording == false) recording = true;
    else recording = false;
  }
  if (key == 'v') {
    if (shaderEnabled) shaderEnabled = false;
    else shaderEnabled = true;
  }
}


// sets the camera to terrain center
void cameraCenter() {
  translate(- tile_length*strips_width + 200, 400, -cameraOffsetZ - strips_num*tile_length*1.5 - 200);
}


// sets the camera position to [0, 0, 0]
void cameraToOrigin() {
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


// transition between day, dusk, night, dawn
void fixOfCycleColorSchemeThatStillNeedsToBeFinished() {

  int numSteps = 4;
  float cycleDuration = 40000;
  float transitionDuration = 1000;
  float stepDuration = cycleDuration/numSteps - transitionDuration;
  float [] timePeriods = new float[numSteps*2 - 1];

  for (int i=0; i<numSteps*2-1; i++) {
    if (i%2==0) timePeriods[i] = (i/2+1)*stepDuration + (i/2)*transitionDuration;
    else timePeriods[i] = ((i+1)/2)*stepDuration + ((i+1)/2)*transitionDuration;
  }

                //terrainColorA      //terrainColorB          //skybox            //dunesFirstRow       //dunesSecondRow      //fog
  color[] t0 = {color(204, 102, 0),   color(173, 152, 122),   color(#7EB583),     color(225, 211, 190), color(222, 232, 223), color(225, 211, 190)}; // day
  color[] t1 = {color(#354356),       color(#916D6F),         color(#BCC4C4),     color(#C97642),       color(#FFC576),       color(#C97642)};       // dusk
  color[] t2 = {color(#185768),       color(#4090A6),         color(30, 53, 70),  color(#325d66),       color(222, 232, 223), color(#325d66)};       // night
  color[] t3 = {color(#4D2E36),       color(#6A3B43),         color(#FFE3BC),     color(#6A4954),       color(#BC846D),       color(#6A4954)};       // dawn

  color[][] timeColors = {t0, t1, t2, t3};

  float cur_time = millis() % cycleDuration;
  int this_step = 0;
  for (int i=0; i<timePeriods.length; i++) {
    if (cur_time < timePeriods[i + 1] && cur_time > timePeriods[i]) this_step = i;
  }

  println(this_step);

  if (this_step%2!=0) {

    terrain.setColorScheme(timeColors[this_step/2][0], timeColors[this_step/2][1]);
    skybox.setFill(timeColors[this_step/2][2]);
    dunes.setColorScheme(timeColors[this_step/2][3], timeColors[this_step/2][4]);
    curFogColor = timeColors[this_step/2][5];
    fogShader.set("fogColor", red(curFogColor)/255.0, green(curFogColor)/255.0, blue(curFogColor)/255.0);

  } else {

    float percentageCompleted = 0;
    percentageCompleted = (cur_time%transitionDuration)/transitionDuration;
    println(cur_time);
    println(cur_time%transitionDuration);
    println(percentageCompleted);

    println(" ");

    color A = lerpColor(timeColors[this_step/2][0], timeColors[((this_step/2)+1)%4][0], percentageCompleted);
    color B = lerpColor(timeColors[this_step/2][1], timeColors[((this_step/2)+1)%4][1], percentageCompleted);
    terrain.setColorScheme(A, B);

    color skyboxColor = lerpColor(timeColors[this_step/2][2], timeColors[((this_step/2)+1)%4][2], percentageCompleted);
    skybox.setFill(skyboxColor);

    A = lerpColor(timeColors[this_step/2][3], timeColors[((this_step/2)+1)%4][3], percentageCompleted);
    B = lerpColor(timeColors[this_step/2][4], timeColors[((this_step/2)+1)%4][4], percentageCompleted);
    dunes.setColorScheme(A, B);

    curFogColor = lerpColor(timeColors[this_step/2][5], timeColors[((this_step/2)+1)%4][5], percentageCompleted);
    fogShader.set("fogColor", red(curFogColor)/255.0, green(curFogColor)/255.0, blue(curFogColor)/255.0);
  }
}


void permissionCallback(boolean granted) {
  if (granted) {
    ma = new MusicAnalyzer();
    recordAudioPermission = true;
  }
}

void loadCactiMeshes() {
  cactiMeshes = new ArrayList();
  PShape s;
  for (int i=1; i<6; i++) {
    s = loadShape("cactus" + i + ".obj");
    s.scale(50);
    s.setFill(color(random(100, 150), 150, random(100, 150)));
    cactiMeshes.add(s);
  }
}

void setupShader() {
  fogShader = loadShader("fogfrag.glsl", "fogvert.glsl");
  fogDistance = min(10000, tile_length*strips_num)/2 - 300;
  fogShader.set("fogMaxDistance", 0.0);
  fogShader.set("fogColor", 0.0, 0.0, 0.0);
  fogShader.set("fogLimit", 50000);
}