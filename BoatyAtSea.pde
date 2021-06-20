/*
 Algorithms in Create Final Assignment
 By Ysbrand Burgstede (s2580829) & Max Liebe (s2506890)
 
 Flocking explanation example from https://gamedevelopment.tutsplus.com/tutorials/3-simple-rules-of-flocking-behaviors-alignment-cohesion-and-separation--gamedev-3444

 Image resources:
 background: https://assetstore.unity.com/packages/2d/textures-materials/sky/farland-skies-low-poly-64604
 flag of Achterhoek: https://nl.wikipedia.org/wiki/Vlag_van_de_Achterhoek
 pirate flag: https://wereldvlaggen.nl/product/vlag-pirate-flag-with-2-swords/

 DISCLAIMER: Both flags were chosen arbitrarily without any malicious intentions
 */

PImage bg;
PImage playerFlag;
PImage enemyFlag;

Environment env; //environment that holds the sea and all the objects

void setup() {
  bg = loadImage("background.png");
  playerFlag = loadImage("arr.png");
  enemyFlag = loadImage("flag.jpg");

  env = new Environment(getMatrix(), width, height);

  camera(626, 556, -618, 607, 157, 289, 0, -1, 0); //orient the camera
  size(1200, 800, P3D);
  sphereDetail(10);
}

void draw() {
  background(bg);
  env.update();
  env.show();
}  

void keyPressed() {
  env.keyEvent(key, true);
}
void keyReleased() {
  env.keyEvent(key, false);
}