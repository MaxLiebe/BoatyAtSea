class Ground {
  int layers = 7;
  float xSize;
  float zSize;

  color ground = color(79, 48, 4);
  color lightGround = color(158, 129, 89);

  Ground(float xSize, float zSize) {
    this.xSize = xSize;
    this.zSize = zSize;
  }

  void show() {
    //draw the ground part below the island
    pushMatrix();
    translate(xSize / 2, -15, zSize / 2);
    for (int i = 0; i < layers; i++) {
      fill(lerpColor(ground, lightGround, (float)i / (float)layers));
      box(xSize, 90, zSize);
      scale(0.8, 1, 0.8);
      translate(0, -90, 0);
    }
    popMatrix();
  }
}