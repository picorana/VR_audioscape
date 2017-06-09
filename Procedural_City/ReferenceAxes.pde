class ReferenceAxes {
  
  public ReferenceAxes () {}
  
  public void display(){
    
    strokeWeight(10);
    
    // red --> x axis
    stroke(255, 0, 0);
    line(0, 0, 0, 5000, 0, 0);
    
    // green --> y axis
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 5000, 0);
    
    // blue --> z axis
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 5000);
    
  }
}