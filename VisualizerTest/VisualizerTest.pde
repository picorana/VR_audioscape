
import android.media.MediaPlayer;
import android.media.audiofx.Visualizer;

Visualizer mVisualizer;
int status = -1;
int capSize;
byte[] mBytes;
byte[] mBytesFFT;

void setup(){
  requestPermission("android.permission.RECORD_AUDIO");
  requestPermission("android.permission.MODIFY_AUDIO_SETTINGS");
  init2();
}

void draw(){
  background(0);
  translate(0, 0);
  /*if (mBytes!=null){

    float rectSize = width/1024;
    fill(255);
    stroke(255);
    for (int i=0; i<mBytes.length; i++){
        line(i, 0, i + 1, mBytes[i]*3);
    }
  }*/
  if (mBytesFFT != null) drawRects(mBytesFFT);
  translate(0, height/2);
  if (mBytes != null) drawRects(mBytes);

}

void drawRects(byte[] mBytes){
  int mDivisions = 16; //?
  boolean mTop = true;
  float[] mFFTPoints = new float[mBytes.length * 4 + 3];
  
  for (int i = 0; i < mBytes.length / mDivisions; i++) {
      //mFFTPoints[i * 4] = i * 4 * mDivisions;
      //mFFTPoints[i * 4 + 2] = i * 4 * mDivisions;
      byte rfk = mBytes[mDivisions * i];
      byte ifk = mBytes[mDivisions * i + 1];
      float magnitude = (rfk * rfk + ifk * ifk);
      int dbValue = (int) (10 * Math.log10(magnitude));

      if(mTop)
      {
        mFFTPoints[i * 4 + 1] = 0;
        mFFTPoints[i * 4 + 3] = (dbValue * 2 - 10);
      }
      /*else
      {
        mFFTPoints[i * 4 + 1] = rect.height();
        mFFTPoints[i * 4 + 3] = rect.height() - (dbValue * 2 - 10);
      }*/
    }

  stroke(255);
  float linewidth = width/mFFTPoints.length;
  for (int i=0; i<mFFTPoints.length/4; i++){
    line(i, mFFTPoints[i * 4 + 3]*10, i, 0);
  }
    
}


public void init2(){
  mVisualizer = new Visualizer(0);
  mVisualizer.setEnabled(false);
  int capRate = Visualizer.getMaxCaptureRate();
  capSize = Visualizer.getCaptureSizeRange()[1];
  mVisualizer.setCaptureSize(capSize);
  Visualizer.OnDataCaptureListener captureListener = new Visualizer.OnDataCaptureListener() {
    public void onWaveFormDataCapture(Visualizer visualizer, byte[] bytes,
    int samplingRate) {   
      //println("a");
      mBytes = bytes;
      /*for (int i=0;i<bytes.length;i++) {
          if (bytes[i]!=-128) {
              print("Found Nonzero sample "+bytes[i]);
          }
      }*/                   
    }
  
    public void onFftDataCapture(Visualizer visualizer, byte[] bytes,
      int samplingRate) {
        mBytesFFT = bytes;
        //println("b");
    }       
  };
  
  status = mVisualizer.setDataCaptureListener(captureListener, capRate, true, true);
  mVisualizer.setEnabled(true);
}