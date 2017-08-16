class SplashScreen{
  
  PShape s;
  PShape loadingIcon;
  PVector loadingIconPosition;
  PImage img;
  PImage loadingImage;
  Terrain t;
  
  boolean counting = false;
  float countingTimestamp = 0;
  
  
  public SplashScreen(Terrain t){
    this.t = t;
    img = loadImage("splashtexture.png");
    s = createCylinder(20, 1000, 1000);
    loadingIcon = createLoadingIcon();
    loadingIcon.scale(3, 3, 0.1);
    loadingIconPosition = new PVector(0, 0, -150);
    loadingImage = loadImage("loadingImage.png");
    loadingIcon.setTexture(loadingImage);
  }
  
  
  void display(){
    background(0);
    shape(s);
    pushMatrix();
    translate(loadingIconPosition.x, loadingIconPosition.y, loadingIconPosition.z);
    shape(loadingIcon);
    popMatrix();
  }
  
  
  void startSketch(){   
    splashScreenOn = false;
  }
  
  
  PShape createLoadingIcon(){
    PShape s = createShape(BOX, 30);
    s.setFill(color(255, 255, 255));
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
    boolean looking = lookingAtButton();
    if (counting){
      if (!looking) counting = false;
      else if (looking && millis()-countingTimestamp > 3000){
        if (!fadingOut){
          fadingOut = true;
          fadingOutStart = millis();
          loadingIcon.tint(255 - (millis()-fadingOutStart) );
        }
      } else {
        loadingIcon.rotateZ((millis()-countingTimestamp)/100000.0);
      }
    } else {
      if (looking){
        countingTimestamp = millis();
        counting = true;
      } else counting = false;
    }
  }
  
  
  boolean lookingAtButton(){
    PVector tmpPVector = loadingIconPosition.copy().normalize();
    float distanceX = abs(tmpPVector.x - ((PGraphicsVR)g).forwardX);
    float distanceY = abs(tmpPVector.y - ((PGraphicsVR)g).forwardY);
    float distanceZ = abs(tmpPVector.z - ((PGraphicsVR)g).forwardZ);
    float totalDistance = distanceX + distanceY + distanceZ;
    if (totalDistance < .5) return true;
    else return false;
  }

}