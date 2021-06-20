import peasy.*;
Fleet fleet;
Sea sea;
Ground ground;
PImage bg;
PImage playerFlag;
PImage enemyFlag;
PeasyCam henk;
Player player;
void setup() {
  enemyFlag = loadImage("flag.jpg");
  playerFlag = loadImage("arr.png");
  float gravity=1;
  sea = new Sea(width, height);
  int maxX = sea.getXSize();
  int maxZ = sea.getZSize();
  player = new Player(new PVector(
        randomGaussian() * maxX / 8 + maxX / 2, 
        100,  
        randomGaussian() * maxZ / 8 + maxZ / 2), 
        sea.getGridSize(), sea.getMaxHeight(), maxX, maxZ, playerFlag,
        color(100));
  fleet = new Fleet(sea, enemyFlag, player);
  ground = new Ground(maxX, maxZ);
  bg = loadImage("background.png");
  henk= new PeasyCam(this, 0, 0, 0, 50);
  //camera(626.2602, 556.6528, -618.7975, 607.8652, 157.90466, 289.3832, 0, -1, 0);
  size(1200, 800, P3D);
}

void draw() {
  background(bg);
  sea.processWaves();
  sea.show();
  fleet.update();
  fleet.show();
  ground.show();
  player.update(sea.getNoiseField());
  player.show();
}  
