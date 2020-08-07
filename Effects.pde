class Effects
{
  Dust[] dust;
  int index;
  
  Effects()
  {
    dust = new Dust[20];
  }
  
  void update()
  {
    for(int i = 0; i < dust.length; i++)
    {
      if(dust[i] != null)
        dust[i].update();
    }
  }
  
  void makeDust(float x, float y, int type, int amount)
  {
    amount = constrain(amount, 0, 20);
    for(int i = 0; i < amount; i++)
    {
      if(dust[index] == null)
      {
        float ang = random(TWO_PI);
        float spd = random(6);
        dust[index] = new Dust(x, y, spd * cos(ang), spd * sin(ang), type);
        index++;
        if(index >= dust.length)
          index = 0;
      }
      else
      {
        float ang = random(TWO_PI);
        float spd = random(6);
        dust[index].reset(x, y, spd * cos(ang), spd * sin(ang), type);
        index++;
        if(index >= dust.length)
          index = 0;
      }
    }
  }
  
  void killAllDust()
  {
    for(int i = 0; i < dust.length; i++)
    {
      dust[i].active = false;
    }
  }
}
