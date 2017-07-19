import processing.vr.*;
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;

Terrain terrain;
int strips_length   = 1;
int tile_length     = 30;
int strips_width    = 100;
int strips_num      = 100;

// Movement data
boolean moving = true;
float curveValue    = 0;
int cameraOffsetZ   = 2;

Visualizer mVisualizer;
int status = -1;
int capSize;
int capRate;
byte[] mBytes;
byte[] mBytesFFT;

PApplet sketchPApplet;
MusicAnalyzer ma;
boolean record_audio_permission = false;

ArrayList<Cactus> cacti;

void settings(){
  smooth();
  fullScreen(STEREO);
}


void setup(){
  sketchPApplet = this;
  requestPermission("android.permission.RECORD_AUDIO", "permissionCallback");

  terrain = new Terrain(tile_length, strips_length, strips_width, strips_num);
  terrain.startTerrain();
  
  
  cacti = new ArrayList();
  cacti.add(new Cactus(new PVector(0, 0, 0)));
}

void draw(){
  background(0);
  
  cameraCenter();
  
  for (int i=0; i<cacti.size(); i++){
    cacti.get(i).display();
    if (abs(cacti.get(i).position.z - cameraOffsetZ) >=10000) {
      println("removing cactus");
      cacti.remove(i);
    }
  }

  if (record_audio_permission) terrain.addMusicStrip(ma.analyze());
  terrain.display();
  
  if (moving) cameraOffsetZ+=tile_length;
}

// sets the camera to terrain center
void cameraCenter(){
  cameraToOrigin();
  translate(- tile_length*strips_num*.5, 350, -cameraOffsetZ - strips_num*tile_length*0.5);
}


// sets the camera position to [0, 0, 0]
void cameraToOrigin(){
  translate(((PGraphicsOpenGL)sketchPApplet.g).cameraX, ((PGraphicsOpenGL)sketchPApplet.g).cameraY, ((PGraphicsOpenGL)sketchPApplet.g).cameraZ);
}


float[] drawRects(byte[] mBytes){
  int mDivisions = 3; //?
  float[] mFFTPoints = new float[mBytes.length * 4 + 3];
  
  println("rate: " + capRate + " size: " + capSize);
  
  for (int i = 0; i < mBytes.length / mDivisions; i++) {
      //mFFTPoints[i * 4] = i * 4 * mDivisions;
      //mFFTPoints[i * 4 + 2] = i * 4 * mDivisions;
      byte rfk = mBytes[mDivisions * i];
      byte ifk = mBytes[mDivisions * i + 1];
      float magnitude = (rfk * rfk + ifk * ifk);
      int dbValue = (int) (10 * Math.log10(magnitude));


      mFFTPoints[i * 4 + 1] = 0;
      mFFTPoints[i * 4 + 3] = (dbValue * 2 - 10);

    }
    
  return mFFTPoints;

  /*
  stroke(255);
  for (int i=0; i<mFFTPoints.length; i++){
    line(i, mFFTPoints[i]*10, i, 0);
  }*/
    
}

void permissionCallback(boolean granted){
  if (granted){
    ma = new MusicAnalyzer();
    record_audio_permission = true;
  }
}

public void init2(){
  mVisualizer = new Visualizer(0);
  mVisualizer.setEnabled(false);
  capRate = Visualizer.getMaxCaptureRate();
  capSize = Visualizer.getCaptureSizeRange()[1];
  mVisualizer.setCaptureSize(capSize);
  Visualizer.OnDataCaptureListener captureListener = new Visualizer.OnDataCaptureListener() {
    public void onWaveFormDataCapture(Visualizer visualizer, byte[] bytes, int samplingRate) {   
      mBytes = bytes;                 
    }
  
    public void onFftDataCapture(Visualizer visualizer, byte[] bytes, int samplingRate) {
      mBytesFFT = bytes;
    }       
  };
  
  status = mVisualizer.setDataCaptureListener(captureListener, capRate, true, true);
  mVisualizer.setEnabled(true);
}