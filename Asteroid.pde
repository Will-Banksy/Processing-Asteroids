class Asteroid
{
  float x, y;
  float velX, velY;
  int size;
  float radius;
  boolean active;
  
  PImage asterImg;
  
  int[] ptsXFromZero; // Vertices of shape from zero. Will translate these points to get the correct values
  int[] ptsYFromZero;
  int[] ptsX;
  int[] ptsY;
  
  Asteroid(float x, float y, int size) //size - 0 = small, 1 = medium, 2 = large
  {
    this.x = x;
    this.y = y;
    this.size = size;
    float angle = random(TWO_PI);
    float speed = random(1, size + 2);
    velX = speed * cos(angle);
    velY = speed * sin(angle);
    active = true;
    
    switch(size)
    {
      case 0:
       radius = 15;
        break;
      
      case 1:
        radius = 35;
        break;
      
      case 2:
        radius = 55;
        break;
    }
    
    asterImg = constructAsteroid();
  }
  
  void update()
  {
    if(active)
    {
      handleMovement();
      display();
      getPoints();
      //displayPoints();
    }
  }
  
  void getPoints()
  {
    for(int i = 0; i < 12; i++)
    {
      ptsX[i] = ptsXFromZero[i] + int(x);
      ptsY[i] = ptsYFromZero[i] + int(y);
    }
  }
  
  void displayPoints()
  {
    noStroke();
    fill(255, 0, 0);
    ellipseMode(CENTER);
    for(int i = 0; i < 12; i++)
    {
      ellipse(ptsX[i], ptsY[i], 5, 5);
    }
  }
  
  void handleMovement()
  {
    x += velX;
    y += velY;
    
    //Looping - go off one side then reappear the other
    if(x < -radius)
      x = width + radius;
    if(x > width + radius)
      x = -radius;
    if(y < -radius)
      y = height + radius;
    if(y > height + radius)
      y = -radius;
  }
  
  void display()
  {
    imageMode(CENTER);
    image(asterImg, x, y);
  }
  
  PImage constructAsteroid()
  {
    PGraphics canvas = createGraphics(int(radius * 4), int(radius * 4));
    canvas.beginDraw();
    canvas.pushMatrix();
    canvas.translate(canvas.height / 2, canvas.width / 2);
    canvas.noFill();
    canvas.stroke(255);
    canvas.beginShape();
    float inc = PI / 6;
    int num = ceil(TWO_PI / inc);
    ptsXFromZero = new int[num];
    ptsYFromZero = new int[num];
    ptsX = new int[num];
    ptsY = new int[num];
    for(int i = 0; i < num; i++)
    {
      float theta = inc * i;
      //float tempX = radius * cos(theta) * random(radius / 2);
      //float tempY = radius * sin(theta) * random(radius / 2);
      PVector v = PVector.fromAngle(theta).mult(radius + random(-radius / 3, 0));//constrain(randomGaussian() * radius, 0, radius));//random(radius * 1.5));
      //println("tempX: " + tempX + " tempY: " + tempY);
      //canvas.vertex(tempX, tempY);
      ptsXFromZero[i] = int(v.x);
      ptsYFromZero[i] = int(v.y);
      ptsX[i] = int(v.x);
      ptsY[i] = int(v.y);
      canvas.vertex(v.x, v.y);
    }
    canvas.endShape(CLOSE);
    canvas.popMatrix();
    canvas.endDraw();
    
    return canvas.get();
  }
  
  void reset(float x, float y, int size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
    float angle = random(TWO_PI);
    float speed = random(1, 6);
    velX = speed * cos(angle);
    velY = speed * sin(angle);
    active = true;
    
    switch(size)
    {
      case 0:
       radius = 10;
        break;
      
      case 1:
        radius = 30;
        break;
      
      case 2:
        radius = 50;
        break;
    }
    
    asterImg = constructAsteroid();
  }
}
