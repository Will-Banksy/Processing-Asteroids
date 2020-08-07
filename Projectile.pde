class Projectile
{
  float x, y;
  float velX, velY;
  boolean active;
  int timeLeft;
  
  Projectile(float x, float y, float angle)
  {
    this.x = x;
    this.y = y;
    
    //Polar to cartesian
    velX = 12 * cos(angle);
    velY = 12 * sin(angle);
    
    timeLeft = 60;
    active = true;
  }
  
  void update()
  {
    if(active)
    {
      display();
      timeLeft--;
      if(timeLeft <= 0)
      {
        active = false;
      }
      
      handleMovement();
      display();
    }
  }
  
  void handleMovement()
  {
    x += velX;
    y += velY;
    
    //Looping - go off one side then reappear the other
    if(x < -30)
      x = width + 30;
    if(x > width + 30)
      x = -30;
    if(y < -30)
      y = height + 30;
    if(y > height + 30)
      y = -30;
  }
  
  void display()
  {
    ellipseMode(CENTER);
    noStroke();
    fill(255);
    circle(x, y, 4);
  }
  
  void reset(float x, float y, float angle)
  {
    this.x = x;
    this.y = y;
    
    //Polar to cartesian
    velX = 12 * cos(angle);
    velY = 12 * sin(angle);
    
    timeLeft = 60;
    active = true;
  }
}
