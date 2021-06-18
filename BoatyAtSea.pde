import peasy.*;

PeasyCam henk;
int gridSize = 20; //size of each individual cell
int maxHeight = 250; //maximum height of the landscape
float noiseScale = 0.05; //multiplier for the difference in noise (higher = steeper terrain)
float timeNoiseStep = 0.002;
float elapsedTime = 0;
int rows;
int cols;
float[][] noiseField;

color blueSea = color(22, 68, 125);
color seaReflection = color(130, 176, 232);
color ground = color(79, 48, 4);
color lightGround = color(158, 129, 89);

ArrayList<PaperBoat> boaties;

PImage bg;

void setup() {
  bg = loadImage("background.png");
  boaties = new ArrayList<PaperBoat>();
  for(int i = 0; i < 10; i++){
    boaties.add(new PaperBoat(new PVector(0+i*100, 200,random(0,400))));
  }

  size(1200,800,P3D);
  henk = new PeasyCam(this, 100);
  noStroke();
  
  //calculate the amount of rows and collumns based on screen size
  rows = height / gridSize;
  cols = width / gridSize;
  noiseField = new float[cols][rows];
  for(int x = 0; x < cols; x++) {
    for(int y = 0; y < rows; y++) {
      noiseField[x][y] = noise(x * noiseScale, y * noiseScale);
    }
  }
}

void draw(){
  background(bg);
  for(PaperBoat boat : boaties) {
    boat.show();
  }
  noStroke();
  
  //shift all the noise values
  for(int x = 0; x < cols; x++) {
    for(int y = 0; y < rows; y++) {
      noiseField[x][y] = noise(x * noiseScale + elapsedTime, y * noiseScale + elapsedTime, elapsedTime);
    }
  }

  //draw the sea
  for(int x = 0; x < cols - 1; x++) {
    for(int y = 0; y < rows - 1; y++) {
      fill(lerpColor(blueSea, seaReflection, noiseField[x][y]));
      //draw a 3d quad from this x and y position to the next x and y
      beginShape();
      vertex(x * gridSize, noiseField[x][y] * maxHeight, y * gridSize);
      vertex((x + 1) * gridSize, noiseField[x + 1][y] * maxHeight, y * gridSize);
      vertex((x + 1) * gridSize, noiseField[x + 1][y + 1] * maxHeight, (y + 1) * gridSize);
      vertex(x * gridSize,noiseField[x][y + 1] * maxHeight,  (y + 1) * gridSize);
      endShape();
    }
  }

  //draw the underside of the sea
  int seaDepth = 30;
  fill(blueSea);
  for(int x = 0; x < cols - 1; x++) {
    beginShape();
    vertex(x * gridSize, noiseField[x][rows - 1] * maxHeight, (rows - 1) * gridSize);
    vertex((x + 1) * gridSize, noiseField[x + 1][rows - 1] * maxHeight, (rows - 1) * gridSize);
    vertex((x + 1) * gridSize, seaDepth, (rows - 1) * gridSize);
    vertex(x * gridSize, seaDepth, (rows - 1) * gridSize);
    endShape();

    beginShape();
    vertex(x * gridSize, noiseField[x][0] * maxHeight,0);
    vertex((x + 1) * gridSize, noiseField[x + 1][0] * maxHeight,0);
    vertex((x + 1) * gridSize, seaDepth,0);
    vertex(x * gridSize, seaDepth,0);
    endShape();
  }

  for(int y = 0; y < rows - 1; y++) {
    beginShape();
    vertex((cols - 1) * gridSize, noiseField[cols - 1][y] * maxHeight, y * gridSize);
    vertex((cols - 1) * gridSize, noiseField[cols - 1][y + 1] * maxHeight, (y + 1) * gridSize);
    vertex((cols - 1) * gridSize, seaDepth, (y + 1) * gridSize);
    vertex((cols - 1) * gridSize, seaDepth, y * gridSize);
    endShape();

    beginShape();
    vertex(0, noiseField[0][y] * maxHeight, y * gridSize);
    vertex(0, noiseField[0][y + 1] * maxHeight, (y + 1) * gridSize);
    vertex(0, seaDepth,  (y + 1) * gridSize);
    vertex(0, seaDepth, y * gridSize);
    endShape();
  }

  //draw the ground part below the island
  int layers = 7;
  pushMatrix();
  translate((cols - 1) * gridSize / 2, -15, (rows - 1) * gridSize / 2);
  for(int i = 0; i < layers; i++) {
    fill(lerpColor(ground, lightGround, (float)i / (float)layers));
    box((cols - 1) * gridSize, 90,  (rows - 1) * gridSize);
    scale(0.8, 1, 0.8);
    translate(0, -90, 0);
  }
  popMatrix();
  elapsedTime += timeNoiseStep;
}  
