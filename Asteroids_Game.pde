import java.awt.geom.*;
import java.awt.*;

Player player;
ArrayList<Asteroid> asteroid;
UserInterface ui;
Effects effects;

PFont font;

int score;
int lives;

int respawnTimer;

boolean titleScreen, gamePlaying;

int numAsters;

void setup()
{
  size(1000, 700, P2D);
  background(0);
  
  titleScreen = true;
  gamePlaying = false;
  
  player = new Player();
  asteroid = new ArrayList<Asteroid>();
  asteroid.add(new Asteroid(width / 4, height / 4, 2));
  ui = new UserInterface();
  effects = new Effects();
  
  font = createFont("sarpanch_regular.ttf", 100);
  textFont(font);
  
  score = 0;
  lives = 3;
  
  respawnTimer = 0;
  
  numAsters = 1;
  
  setTitleScreen();
}

void draw()
{
  background(0);
  player.update();
  for(Asteroid a : asteroid)
  {
    a.update();
  }
  effects.update();
  
  if(ui.gamePlaying != gamePlaying && ui.titleScreen != titleScreen)
  {
    gamePlaying = ui.gamePlaying;
    titleScreen = ui.titleScreen;
    if(gamePlaying && !titleScreen)
    {
      setGamePlaying();
    }
    if(!gamePlaying && titleScreen)
    {
      setTitleScreen();
    }
  }
  
  if(gamePlaying)
  {
    checkCollisions();
  
    tryPlayerRespawn();
  }
  
  if(asteroid.isEmpty())
  {
    numAsters++;
    
    spawnAsteroids();
  }
  
  if(lives == 0 && !player.active && respawnTimer <= 0)
  {
    setup();
  }
  
  ui.update(score, lives);
}

void spawnAsteroids()
{
  for(int i = 0; i < numAsters; i++)
  {
    int x;
    int y;
    if((int)random(2) == 0)
    {
      x = (int)random(2) == 0 ? -55 : width + 55;
      y = (int)random(height);
    }
    else
    {
      x = (int)random(width);
      y = (int)random(2) == 0 ? -55 : height + 55;
    }
    Asteroid a = new Asteroid(x, y, 2);
    asteroid.add(a);
  }
}

void keyPressed()
{
  player.onKeyPress();
}

void keyReleased()
{
  player.onKeyRelease();
}

void mousePressed()
{
  ui.onMousePress();
}

void mouseReleased()
{
  ui.onMouseRelease();
}

void tryPlayerRespawn()
{
  if(respawnTimer <= 0 && !player.active && lives > 0)
  {
    lives--;
    player.reset();
  }
  else
  {
    respawnTimer--;
  }
}


void checkCollisions()
{
  if(player.active)
  {
    checkProjectileAsteroidCollisions(player.projectile);
    checkPlayerAsteroidCollisions();
  }
}

void checkPlayerAsteroidCollisions()
{
  for(Asteroid a : asteroid)
  {
    if(a.active && !player.invincible)
    {
      //Using a little trick I got from StackOverflow - Make Area objects out of the Polygon Shapes of the player and asteroid, set one to the intersection of them both, and if it's NOT empty, then they intersect :)
      //Polygon aster = new Polygon(a.shape.xpoints, a.shape.ypoints, a.shape.npoints);
      //aster.translate((int)a.x, (int)a.y);
      Polygon aster = new Polygon(a.ptsX, a.ptsY, 12);
      Polygon plr = new Polygon(player.ptsX, player.ptsY, 3);
      Area asterA = new Area(aster);
      Area plrA = new Area(plr);
      asterA.intersect(plrA);
      if(!asterA.isEmpty()) //Check it is NOT empty
      {
        //Colliding
        println("Colliding");
        player.active = false;
        effects.makeDust(player.x, player.y, 1, 3);
        effects.makeDust(player.x, player.y, 0, 4);
        respawnTimer = 60;
      }
    }
  }
}

void checkProjectileAsteroidCollisions(Projectile[] proj)
{
  for(Projectile p : proj)
  {
    if(p != null)
    {
      if(p.active)
      {
        for(int i = 0; i < asteroid.size(); i++)
        {
          Polygon poly = new Polygon(asteroid.get(i).ptsX, asteroid.get(i).ptsY, 12);
          if(poly.contains(p.x, p.y))//asteroid.get(i).shape.contains(p.x, p.y))
          {
            effects.makeDust(asteroid.get(i).x, asteroid.get(i).y, 0, 3);
            destroyAsteroid(asteroid.get(i));
            p.active = false;
          }
        }
      }
    }
  }
}

void destroyAsteroid(Asteroid a)
{
  a.active = false;
  int points = (a.size + 1) * 10;
  score += points;
  asteroid.remove(a);
  if(a.size != 0)
  {
    asteroid.add(new Asteroid(a.x, a.y, a.size - 1));
    asteroid.add(new Asteroid(a.x, a.y, a.size - 1));
  }
}

void setTitleScreen()
{
  player.active = false;
  for(Projectile p : player.projectile)
  {
    if(p != null)
      p.active = false;
  }
  for(Asteroid a : asteroid)
  {
    a.active = false;
  }
  
  ui.setTitleScreen();
}

void setGamePlaying()
{
  player.active = true;
  for(Projectile p : player.projectile)
  {
    if(p != null)
      p.active = true;
  }
  for(Asteroid a : asteroid)
  {
    a.active = true;
  }
  
  ui.setGamePlaying();
}
