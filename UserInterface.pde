class UserInterface
{
  int score;
  int lives;
  PImage plrImg;
  
  float startGX, startGY, startGWidth, startGHeight;
  
  boolean titleScreen, gamePlaying;
  
  UserInterface()
  {
    plrImg = constructPlayer(30, 20);
  }
  
  void update(int score, int lives)
  {
    this.score = score;
    this.lives = lives;
    
    if(titleScreen)
    {
      displayTitleScreen();
    }
    else if(gamePlaying)
    {
      displayScore();
      displayLives();
    }
    
    textSize(50);
    startGWidth = textWidth("START GAME");
    startGHeight = (textAscent() + textDescent()) * 0.67;
    startGX = (width / 2) - (startGWidth / 2);
    startGY = ((height / 3) * 2) - (startGHeight / 3);
  }
  
  void displayTitleScreen()
  {
    // TITLE
    float x = width / 2;
    float y = height / 3;
    textSize(150);
    noStroke();
    fill(255);
    textAlign(CENTER, CENTER);
    text("ASTEROIDS", x, y);
    
    // START GAME
    y = (height / 3) * 2;
    textSize(50);
    fill(255);
    text("START GAME", x, y);
  }
  
  void displayLives() //Display little ships, one for each life
  {
    float offX = width - 200;
    float offY = 60;
    float spacing = 50;
    imageMode(CORNER);
    for(int i = 0; i < lives; i++)
    {
      float x = offX  + (spacing * i);
      pushMatrix();
      translate(x, offY);
      rotate(-PI / 2);
      image(plrImg, 0, 0);
      popMatrix();
    }
  }
  
  void displayScore()
  {
    String scr = "SCORE: " + score;
    textSize(40);
    textAlign(LEFT, TOP);
    noStroke();
    fill(255);
    float padding = 20;
    text(scr, padding, padding, width - padding, height - padding);
  }
  
  PImage constructPlayer(int sizeX, int sizeY)
  {
    PGraphics canvas = createGraphics(sizeX, sizeY);

    canvas.beginDraw();
    canvas.stroke(255);
    canvas.noFill();
    canvas.line(0, 0, canvas.width, canvas.height / 2);
    canvas.line(0, canvas.height, canvas.width, canvas.height / 2);
    canvas.line(canvas.width / 3, canvas.height / 6, canvas.width / 3, ((canvas.height / 6) * 5) + 2);
    canvas.endDraw();

    PImage img = canvas.get();
    
    return img;
  }
  
  void setTitleScreen()
  {
    titleScreen = true;
    gamePlaying = false;
  }
  
  void setGamePlaying()
  {
    titleScreen = false;
    gamePlaying = true;
  }
  
  void onMousePress()
  {
    // CHECK START GAME CLICKED
    float x = startGX;
    float y = startGY;
    float w = startGWidth;
    float h = startGHeight;
    if(pointInRect(mouseX, mouseY, x, y, w, h))
    {
      gamePlaying = true;
      titleScreen = false;
      println("Clicked");
    }
  }
  
  void onMouseRelease()
  {
  }
  
  boolean pointInRect(float px, float py, float rx, float ry, float rWidth, float rHeight)
  {
    return (px > rx && px < rx + rWidth && py > ry && py < ry + rHeight);
  }
}
