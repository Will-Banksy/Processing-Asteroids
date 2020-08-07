class Dust
{
  float x, y;
  float velX, velY;
  
  int type;
  
  float angle, gyro;
  
  boolean active;
  
  int timeLeft;
  
  Dust(float x, float y, float velX, float velY, int type)
  {
    this.x = x;
    this.y = y;
    this.velX = velX;
    this.velY = velY;
    this.type = type;
    
    if(type == 1)
    {
      angle = random(TWO_PI);
      gyro = random(1);
      timeLeft = 90;
    }
    else
    {
      timeLeft = 30;
    }
    active = true;
  }
  
  void update()
  {
    if(active)
    {
      handleMovement();
      
      display();
      
      timeLeft--;
      if(timeLeft <= 0)
        active = false;
    }
  }
  
  void handleMovement() //Counting rotation as movement so the name of this method isn't wrong
  {
    x += velX;
    y += velY;
    angle += gyro;
  }
  
  void display()
  {
    switch(type)
    {
      case 0: //Particles
        ellipseMode(CENTER);
        noStroke();
        fill(255);
        ellipse(x, y, 4, 4);
        break;
      
      case 1: //Lines - Can use on player death to look like player's broken apart
        stroke(255);
        noFill();
        float[] pts = getPoints();
        line(pts[0], pts[1], pts[2], pts[3]);
        break;
    }
  }
  
  float[] getPoints()
  {
    float[] pts = new float[4];
    pts[0] = (20 * cos(angle)) + x; //x1
    pts[1] = (20 * sin(angle)) + y; //y1
    pts[2] = (-20 * cos(angle)) + x; //x2
    pts[3] = (-20 * sin(angle)) + y; //y2
    return pts;
  }
  
  void reset(float x, float y, float velX, float velY, int type)
  {
    this.x = x;
    this.y = y;
    this.velX = velX;
    this.velY = velY;
    this.type = type;
    
    if(type == 1)
    {
      angle = random(TWO_PI);
      gyro = random(1);
      timeLeft = 150;
    }
    
    timeLeft = 45;
    active = true;
  }
}
