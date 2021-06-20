class Ground {
  int layers = 7;
  float xSize;
  float zSize;

  color darkGround;
  color lightGround;

  static final float groundYSize = 90;
  static final float groundPosition = -15;

  Ground(float xSize, float zSize) {
    this.xSize = xSize;
    this.zSize = zSize;
    darkGround = color(79, 48, 4);
    lightGround = color(158, 129, 89);
  }

  void show() {
    //draw the ground part below the island
    pushMatrix();
    translate(xSize / 2, groundPosition, zSize / 2);
    for (int i = 0; i < layers; i++) {
      fill(lerpColor(darkGround, lightGround, (float)i / (float)layers));
      box(xSize, groundYSize, zSize);
      scale(0.8, 1, 0.8);
      translate(0, -90, 0);
    }
    popMatrix();
  }

  float getGroundHeight() {
    return groundPosition + groundYSize / 2;
  }
}