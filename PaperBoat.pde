class PaperBoat {
  PVector pos, vel, acc;
  float scalar=4;
  float pitch;
  float yaw;
  int gridSize;
  int maxHeight;
  int maxX;
  int maxZ;
  float gravity;
  float maxHorVel = 0.8;
  float maxVerVel = 1;
  float maxAcc = 2;
  float rangeInfluence;
  float r;

  ParticleSystem system;
  Flag flag;
  color c;

  PaperBoat(PVector pos, PVector vel, int gridSize, int maxHeight, int maxX, int maxZ, PImage flagImage, color c) {
    this.pos = pos;
    this.vel = vel; 
    this.gridSize = gridSize;
    this.maxHeight = maxHeight;
    this.maxX = maxZ;
    this.c = c;
    acc = new PVector(0, 0);
    system = new ParticleSystem(new PVector(0,0,0), ParticleSystem.HYDRO, 1);
    flag = new Flag(flagImage, 0.2, 0);
  }

  void show() {
    pushMatrix();
    translate(pos.x+5*scalar, pos.y, pos.z);
    rotateY(atan2(vel.x,vel.z)+HALF_PI);
    system.show();
    flag.show();
    strokeWeight(1);
    rotateX(PI);
    // rotateX(PI + pitch);
    // rotateZ(yaw);
    translate(-5 * scalar, 0, 0);
    stroke(1);
    fill(c);

    //middle triangle
    beginShape();
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    vertex(5 * scalar, -13 * scalar, 0 * scalar);
    endShape(CLOSE);

    //left left triangle
    beginShape();
    vertex(-10 * scalar, -10 * scalar, 0 * scalar);
    vertex(5 * scalar, -6 * scalar, 5 * scalar);
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //left middle triangle
    beginShape();
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    vertex(5 * scalar, -6 * scalar, 5 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //left right triangle
    beginShape();
    vertex(5 * scalar, -6 * scalar, 5 * scalar);
    vertex(20 * scalar, -10 * scalar, 0 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //right left triangle
    beginShape();
    vertex(-10 * scalar, -10 * scalar, 0 * scalar);
    vertex(5 * scalar, -6 * scalar, -5 * scalar);
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //right middle triangle
    beginShape();
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    vertex(5 * scalar, -6 * scalar, -5 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //right right triangle
    beginShape();
    vertex(5 * scalar, -6 * scalar, -5 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    vertex(20 * scalar, -10 * scalar, 0 * scalar);
    endShape(CLOSE);
    popMatrix();
  }

void update(float[][] noiseField){
    vel.add(acc);
    vel.limit(maxHorVel);
    pos.add(vel);
    
    system.update();
    flag.update();

    pos.y += calculateStepToTarget(noiseField);
    acc.mult(0);
}

float calculateStepToTarget(float[][] noiseField){
    float correctedX = pos.x / gridSize;
    float correctedZ = pos.z / gridSize;
    int x1 = floor(correctedX);
    int x2 = ceil(correctedX);
    int z1 = floor(correctedZ);
    int z2 = ceil(correctedZ);
    if(x1 > noiseField[0].length || x2 > noiseField[0].length) {
      x1 = noiseField[0].length;
      x2 = noiseField[0].length;
    }
    if(z1 > noiseField.length || z2 > noiseField.length) {
      z1 = noiseField.length;
      z2 = noiseField.length;
    }
    float targetHeight = ((noiseField[x2][z2] + noiseField[x1][z1]) / 2) * maxHeight;
    PVector fromPos = new PVector(x2, noiseField[x2][z2], z2);
    PVector toPos = new PVector(x1, noiseField[x1][z1], z1);
    PVector direction = fromPos.copy().sub(toPos);

  return sqrt(abs(pos.y - targetHeight)) * (pos.y > targetHeight ? -1 : 1);
}
//apply a force to the acceleration
  void applyHorizontalForce(PVector force) {
    acc.add(new PVector(force.x, 0, force.y));
  }

  PVector getHorizontalPosition() {
      return new PVector(pos.x, pos.z);
  }
  PVector getHorizontalVelocity() {
      return new PVector(vel.x, vel.z);
  }

  float getMaxAcceleration(){
      return maxAcc;
  }
}
