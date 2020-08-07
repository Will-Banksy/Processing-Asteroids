class Player
{
  PImage[] plrImg;
  float x, y;
  float velX, velY;
  float accelX, accelY;
  float angle;
  float sizeX, sizeY;
  
  boolean wPressed;
  boolean aPressed;
  boolean dPressed;
  boolean spacePressed;
  
  float shootDelay;
  int index;
  Projectile[] projectile;
  
  int[] ptsX;
  int[] ptsY;
  
  boolean active;
  boolean invincible;
  
  int invinciTimer;
  int blinkTimer;

  Player()
  {
    sizeX = 60;
    sizeY = 40;
    plrImg = constructPlayer(int(sizeX), int(sizeY));

    x = width / 2;
    y = height / 2;
    velX = 0;
    velY = 0;
    accelX = 0;
    accelY = 0;
    angle = 0;
    shootDelay = 0;
    index = 0;
    active = true;
    invincible = true;
    invinciTimer = 150;
    
    projectile = new Projectile[10];
    
    ptsX = new int[3];
    ptsY = new int[3];
    
    getPoints();
  }

  void update()
  {
    if(active)
    {
      if(invinciTimer <= 0)
      {
        invincible = false;
      }
      else
      {
        invinciTimer--;
      }
      
      handleMovement();
      handleShooting();
      display();
      getPoints();
      //displayPoints();
    }
  }
  
  void getPoints()
  {
    //Uses polar to cartesian coordinate conversion to get points of the corners of the ship
    float fptX = ((sizeX / 2) * cos(angle)) + x;
    float fptY = ((sizeX / 2) * sin(angle)) + y;
    
    float distToCorner = dist(0, 0, sizeX / 2, sizeY / 2);
    float angToCornerOff = radians(145); //radians(123.6901); // Worked out this by hand, using trigonometry. Unfortunately it didn't work out so I ended up estimating
    float ucptX = (distToCorner * cos(angle - angToCornerOff)) + x;
    float ucptY = (distToCorner * sin(angle - angToCornerOff)) + y;
    
    float dcptX = (distToCorner * cos(angle + angToCornerOff)) + x;
    float dcptY = (distToCorner * sin(angle + angToCornerOff)) + y;
    
    //Assigns the worked out positions to the integer array
    ptsX[0] = int(fptX);
    ptsY[0] = int(fptY);
    ptsX[1] = int(ucptX);
    ptsY[1] = int(ucptY);
    ptsX[2] = int(dcptX);
    ptsY[2] = int(dcptY);
  }
  
  void displayPoints()
  {
    noStroke();
    fill(255, 0, 0);
    ellipseMode(CENTER);
    for(int i = 0; i < 3; i++)
    {
      ellipse(ptsX[i], ptsY[i], 5, 5);
    }
    //println("X: " + x + " Y: " + y);
  }
  
  void handleShooting()
  {
    if(shootDelay <= 0)
    {
      //Then if spacebar is pressed shoot
      if(spacePressed)
      {
        if(projectile[index] == null)
        {
          projectile[index] = new Projectile(x, y, angle);
        }
        else if(projectile[index] != null)
        {
          projectile[index].reset(x, y, angle); // Re-use projectile
        }
        shootDelay = 20;
        index++;
        if(index >= projectile.length)
        {
          index = 0;
        }
      }
    }
    
    for(int i = 0; i < projectile.length; i++)
    {
      if(projectile[i] != null)
      {
        projectile[i].update();
      }
    }
    
    if(shootDelay > 0)
      shootDelay--;
  }
  
  void handleMovement()
  {
    //Turn
    if(aPressed)
    {
      angle -= 0.1;
    }
    if(dPressed)
    {
      angle += 0.1;
    }
    //Accelerate in direction player is facing
    if(wPressed)
    {
      PVector newAccel = PVector.fromAngle(angle);
      newAccel.mult(0.1);
      velX += newAccel.x;
      velY += newAccel.y;
      PVector limVel = new PVector(velX, velY);
      limVel.limit(5);
      velX = limVel.x;
      velY = limVel.y;
    }
    else //Decrease the velocity
    {
      velX *= 0.99;
      velY *= 0.99;
    }
    
    //Actually move - add to the position
    x += velX;
    y += velY;
    
    //Looping - go off one side then reappear the other
    if(x < -30)
      x = width + 30;
    if(x > width + 30)
      x = -30;
    if(y < -30)
      y = height +  30;
    if(y > height + 30)
      y = -30;
  }

  void display()
  {
    imageMode(CENTER);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    if(blinkTimer > 0 && invincible)
    {
      popMatrix();
      blinkTimer--;
      return;
    }
    if(wPressed)
    {
      image(plrImg[1], 0, 0);
    }
    else
    {
      image(plrImg[0], 0, 0);
    }
    blinkTimer--;
    if(blinkTimer < -10)
      blinkTimer = 10;
    popMatrix();
  }
  
  void onKeyPress()
  {
    switch(key)
    {
      case 'w':
        wPressed = true;
        break;
      
      case 'a':
        aPressed = true;
        break;
      
      case 'd':
        dPressed = true;
        break;
      
      case 32: //Spacebar
        spacePressed = true;
        break;
    }
  }
  
  void onKeyRelease()
  {
    switch(key)
    {
      case 'w':
        wPressed = false;
        break;
      
      case 'a':
        aPressed = false;
        break;
      
      case 'd':
        dPressed = false;
        break;
      
      case 32: //Spacebar
        spacePressed = false;
        break;
    }
  }

  PImage[] constructPlayer(int sizeX, int sizeY)
  {
    PGraphics canvas = createGraphics(sizeX, sizeY);

    canvas.beginDraw();
    canvas.stroke(255);
    canvas.noFill();
    canvas.line(0, 0, canvas.width, canvas.height / 2);
    canvas.line(0, canvas.height, canvas.width, canvas.height / 2);
    canvas.line(canvas.width / 3, canvas.height / 6, canvas.width / 3, ((canvas.height / 6) * 5) + 2);
    canvas.endDraw();

    PImage[] img = { canvas.get(), null };

    canvas.beginDraw();
    canvas.stroke(255);
    canvas.noFill();
    canvas.line(canvas.width / 3, (canvas.height / 6) * 2, 0, canvas.height / 2);
    canvas.line(canvas.width / 3, ((canvas.height / 6) * 4) + 2, 0, canvas.height / 2);
    canvas.endDraw();

    img[1] = canvas.get();
    
    return img;
  }
  
  void reset()
  {
    sizeX = 60;
    sizeY = 40;
    plrImg = constructPlayer(int(sizeX), int(sizeY));

    x = width / 2;
    y = height / 2;
    velX = 0;
    velY = 0;
    accelX = 0;
    accelY = 0;
    angle = 0;
    shootDelay = 0;
    index = 0;
    active = true;
    invincible = true;
    invinciTimer = 150;
    
    projectile = new Projectile[10];
    
    ptsX = new int[3];
    ptsY = new int[3];
    
    getPoints();
  }
}
