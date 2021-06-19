import peasy.*;
PeasyCam henk;
Fleet fleet;
Sea sea;
Ground ground;
PImage bg;
PImage flag;

void setup() {
  flag = loadImage("flag.jpg");
  float gravity=1;
  sea = new Sea(width, height);
  fleet = new Fleet(sea, gravity, flag);
  ground = new Ground(sea.getXSize(), sea.getZSize());
  bg = loadImage("background.png");

  size(1200, 800, P3D);
  henk = new PeasyCam(this, 100);
}

void draw() {
  background(bg);
  sea.processWaves();
  sea.show();
  fleet.update();
  fleet.show();
  ground.show();
}  
