import processing.opengl.*;
import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import processing.sound.*;

//heloo world!
SoundFile s1;

PeasyCam cam;


int cols,rows;
int scl=30;
int w=4840;
int h=1600;
float flying=0;
float[][] terrain;
int amount=300;


PImage photo;//
PGraphics fog;//
float x1, y1;//
float count=0;
int rainNum = 100;
ArrayList rain = new ArrayList();
ArrayList splash = new ArrayList();
float current;
float reseed = random(0, .2);



void setup()
{  
    


//cam=new PeasyCam(this,1800);
  size(3840, 768, P3D);
  
   s1 = new SoundFile(this, "rugla.mp3");
   s1.loop();
   
  colorMode(RGB, 100);
  background(0);
  rain.add(new Rain());
  current = millis();
  /*
  // from the side
   camera( 3*width, height/2.0, 0,
   width/2.0, height/2.0, 0,
   0, 1, 0);*/
cols = w/scl;
rows= h/scl;
terrain= new float[cols][rows];
   
   
   
  camera( width/2.0, height/2.0, -400,
  width/2.0, height/2.0, 0,
  0, 1, 0);
  
  beginCamera();
camera();
rotateX(-PI/3);
//rotateY(2*PI);
rotateZ(-6*PI);
endCamera();
}
void draw()
{count+=0.03;

 background (0,0,0,1);

//pushMatrix();
//pushStyle();
//rectMode(CENTER);
//noFill();
//stroke(51,0,0,225);
////stroke(255);
//translate(750, 300, 0);
//rotateY(count);
////rotateX(count);
//rect(0, 0, 100, 100);
//popStyle();
//popMatrix();
float mouseControlX=map(mouseX,0,width,-1.5,1.5);
float mouseControlY=map(mouseY,0,height,0,1.5);

pushMatrix();

rotateX(-11*PI/6);
rotateZ(PI/18*mouseControlX);
  //println(rain.size());
  
  if ((millis()-current)/1>reseed &&
    rain.size()<amount)
  {
    rain.add(new Rain());
    float reseed = random(0, .2);
    current = millis();
  }
  for (int i=0 ; i<rain.size() ; i++)
  {
    Rain rainT = (Rain) rain.get(i);
    rainT.calculate();
    rainT.draw();
    if (rainT.position.y>height)
    {
      for (int k = 0 ; k<random(5,10) ; k++)
      {
        splash.add(new Splash(rainT.position.x, height, rainT.position.z));
      }
      rain.remove(i);
      float rand = random(0, 100);
      if (rand>10&&rain.size()<amount)
        rain.add(new Rain());
    }
  }
  for (int i=0 ; i<splash.size() ; i++)
  {
    Splash spl = (Splash) splash.get(i);
    spl.calculate();
    spl.draw();
    if (spl.position.y>height)
      splash.remove(i);
  }
  
   flying-=0.01; 
  
float yoff=flying;
for(int y =0;y<rows;y++){
    float xoff=0;
    for(int x=0; x<cols;x++){
    terrain[x][y]=map(noise(xoff,yoff),0,1,-350,350);
    xoff+=0.05;
    }
    yoff+=0.05;
  }  
  
popMatrix();


//pushStyle();
//background(0);
stroke(100,5);
//noFill();
fill(0,0,50,24);
noFill();
//blendMode(SCREEN);

translate(width/2,height/2);
rotateX(-4*PI/3);
 //rotateZ(-PI/3*mouseControlX);
 rotateZ(PI/18*mouseControlX);
translate(-w/2,-h/2);


print("\n");

for(int y=0;y<rows-1;y++){
  
    //beginShape(LINES);
for(int x=0; x<cols;x++){
  
  pushMatrix();
  bezier(x*scl,(y+1)*scl,terrain[x][y+1],x*scl/4,(y+1)*scl,terrain[x][y+1],x*scl,(y+1)*scl,terrain[x][y+1],x*scl,(y+1)*scl,-100);  
  //vertex(x*scl,y*scl,terrain[x][y]);
  //vertex(x*scl,(y+1)*scl,terrain[x][y+1]);
   popMatrix();
  }
  
 


  
  
}
  
  
  
}
void blur(float trans)
{
  noStroke();
  fill(0, trans);
  //rect(0, 0, width, height);
}
// ==========================================
public class Rain
{
  PVector position, pposition, speed;
  float col;
  public Rain()
  {
    position = new PVector(random(0, width), -500, random(-800, 800));
    pposition = position;
    speed = new PVector(0, 0);
    col = random(30, 60);
  }
  void draw()
  {pushStyle();
    stroke(100,100,100, col);
    strokeWeight(0.5);
    line(position.x, position.y, position.z, pposition.x, pposition.y, position.z);
    //ellipse(position.x,position.y,5,5);
    
    popStyle();
  }
  void calculate()
  {
    pposition = new PVector(position.x, position.y);
    gravity();
  }
  void gravity()
  {
    speed.y += .2;
    speed.x += .01;
    position.add(speed);
  }
}
public class Splash
{
  PVector position, speed;
  public Splash(float x, float y, float z)
  {
    float angle = random(PI, TWO_PI);
    float distance = random(1, 5);
    float xx = cos(angle)*distance;
    float yy = sin(angle)*distance;
    position = new PVector(x, y, z);
    speed = new PVector(xx, yy);
  }
  public void draw()
  {
    strokeWeight(1);
    stroke(100,100,100, 50);
    fill(100, 100);
    // ellipse(position.x, position.y, 2, 2 );
    point(position.x, position.y, position.z );
  }
  void calculate()
  {
    gravity();
    speed.x*=0.98;
    speed.y*=0.98;
    position.add(speed);
  }
  void gravity()
  {
    speed.y+=.2;
  }
}