class Sea {
  static final int gridSize = 20;
  static final int maxHeight = 250;
  static final int seaDepth = 30;

  static final float noiseScale = 0.05;
  static final float noiseStep = 0.002;
  float elapsedTime = 0;
  float[][] noiseField;

  color blueSea;
  color seaReflection;

  int rows;
  int cols;

  Sea(int envWidth, int envHeight) {
    //calculate the amount of rows and collumns based on screen size
    rows = envHeight / gridSize;
    cols = envWidth / gridSize;
    noiseField = new float[cols][rows];
    blueSea = color(22, 68, 125, 160);
    seaReflection = color(130, 176, 232, 200);
  }

  void processWaves() {
    //move the wave by shifting the noise values
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        noiseField[x][y] = noise(x * noiseScale + elapsedTime, y * noiseScale + elapsedTime, elapsedTime);
      }
    }
  }

  void show() {
    //draw the sea
    noStroke();
    for (int x = 0; x < cols - 1; x++) {
      for (int y = 0; y < rows - 1; y++) {
        //fill with a color between blue and light blue according to the height on the noise field
        fill(lerpColor(blueSea, seaReflection, noiseField[x][y]));

        //draw a 3d quad from this x and y position to the next x and y
        beginShape();
        vertex(x * gridSize, noiseField[x][y] * maxHeight, y * gridSize);
        vertex((x + 1) * gridSize, noiseField[x + 1][y] * maxHeight, y * gridSize);
        vertex((x + 1) * gridSize, noiseField[x + 1][y + 1] * maxHeight, (y + 1) * gridSize);
        vertex(x * gridSize, noiseField[x][y + 1] * maxHeight, (y + 1) * gridSize);
        endShape();
      }
    }

    //draw the underside of the sea
    fill(blueSea);
    for (int z = 0; z < rows - 1; z++) {
      drawXWalls(cols - 1, z);
      drawXWalls(0, z);
    }
    for (int x = 0; x < cols - 1; x++) {
      drawZWalls(x, rows - 1);
      drawZWalls(x, 0);
    }

    elapsedTime += noiseStep;
  }

  void drawXWalls(int x, int z) {
    beginShape();
    vertex(x * gridSize, noiseField[x][z] * maxHeight, z * gridSize);
    vertex(x * gridSize, noiseField[x][z + 1] * maxHeight, (z + 1) * gridSize);
    vertex(x * gridSize, seaDepth, (z + 1) * gridSize);
    vertex(x * gridSize, seaDepth, z * gridSize);
    endShape();
  }

  void drawZWalls(int x, int z) {
    beginShape();
    vertex(x * gridSize, noiseField[x][z] * maxHeight, z * gridSize);
    vertex((x + 1) * gridSize, noiseField[x + 1][z] * maxHeight, z * gridSize);
    vertex((x + 1) * gridSize, seaDepth, z * gridSize);
    vertex(x * gridSize, seaDepth, z * gridSize);
    endShape();
  }

  int getGridSize() {
    return gridSize;
  }

  int getMaxHeight() {
    return maxHeight;
  }

  int getXSize() {
    return (cols - 1) * gridSize;
  }

  int getZSize() {
    return (rows - 1) * gridSize;
  }

  float[][] getNoiseField() {
    return noiseField;
  }

  //generate a normally distributed position on the sea
  PVector generateRandomPosition() {
    return new PVector(
        randomGaussian() * getXSize() / 8 + getXSize() / 2,
        maxHeight / 2, 
        randomGaussian() * getZSize() / 8 + getZSize() / 2);
  }
}
