class SplashScreen{
  
  PShape s;
  PShape loadingIcon;
  PImage img;
  PGraphics loadingImage;
  
  boolean counting = false;
  float countingTimestamp = 0;
  
  
  public SplashScreen(){
    img = loadImage("splashtexture.png");
    s = createCylinder(20, 1000, 1000);
    loadingIcon = createLoadingIcon();
    loadingImage = createGraphics(200, 200);
  }
  
  void display(){
    background(0);
    shape(s);
    pushMatrix();
    translate(0, 0, -150);
    shape(loadingIcon);
    
    popMatrix();
  }
  
  void startSketch(){
    splashScreenOn = false;
  }
  
  
  PShape createLoadingIcon(){
    PShape s = createShape(BOX, 30);
    s.setFill(color(255, 0, 0));
    return s;
  }
  
  
  PShape createCylinder(int sides, float r, float h){
    PShape s = createShape();
    float angle = 360 / sides;
    float halfHeight = h / 2;

    s.beginShape(QUAD_STRIP);
    s.textureMode(IMAGE);
    s.texture(img);
    for (int i = 0; i < sides + 1; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
       
        s.vertex( x, y, halfHeight, i*img.width/sides, 0);
        s.vertex( x, y, -halfHeight, i*img.width/sides, img.height);    
    }
    s.endShape(CLOSE); 
    s.rotateX(HALF_PI);
    s.rotateY(PI);
    return s;
  }
  
  void update(){
    println("x: " + ((PGraphicsVR)g).forwardX + " y: " + ((PGraphicsVR)g).forwardY + " z: " + ((PGraphicsVR)g).forwardZ);
    if (counting){
      if (0<((PGraphicsVR)g).forwardZ || ((PGraphicsVR)g).forwardZ<-.5) counting = false;
      else if (0>((PGraphicsVR)g).forwardZ && ((PGraphicsVR)g).forwardZ>-.5 && millis()-countingTimestamp > 3000){
        startSketch();
      } else {
        loadingIcon.rotateY((millis()-countingTimestamp)/5000.0);
      }
    } else {
      if (0>((PGraphicsVR)g).forwardZ && ((PGraphicsVR)g).forwardZ>-.5){
        countingTimestamp = millis();
        counting = true;
        println("in");
      } else counting = false;
    }
  }
}