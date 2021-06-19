class PaperBoat {
  PVector pos, vel, acc;
  float scalar=4;
  float angle;
  int gridSize;
  int maxHeight;
  int maxX;
  int maxZ;
  float gravity;
  float maxVel;
  float maxAcc;
  float rangeInfluence;
  float r;

  PaperBoat(PVector pos, int gridSize, int maxHeight, int maxX, int maxZ, float gravity) {
    this.pos = pos; 
    this.gridSize = gridSize;
    this.maxHeight = maxHeight;
    this.maxX =  maxZ;
    this.gravity = gravity;
    vel=new PVector(random(-1,1), 0, random(-1,1)); //gives the bird a random starting velocity
    acc=new PVector(0, 0);
    maxVel= 0.8; 
    maxAcc=2;
  }
  void show() {
    stroke(1);
    pushMatrix();
    translate(pos.x+5*scalar, pos.y, pos.z);
    rotateY(atan2(vel.x,vel.z)+HALF_PI);
    translate(-5 * scalar, 0, 0);
    rotateX(PI);

    fill(255);

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
    endShape();

    //left middle triangle
    beginShape();
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    vertex(5 * scalar, -6 * scalar, 5 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    endShape();

    //left right triangle
    beginShape();
    vertex(5 * scalar, -6 * scalar, 5 * scalar);
    vertex(20 * scalar, -10 * scalar, 0 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    endShape();

    //right left triangle
    beginShape();
    vertex(-10 * scalar, -10 * scalar, 0 * scalar);
    vertex(5 * scalar, -6 * scalar, -5 * scalar);
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    endShape();

    //right middle triangle
    beginShape();
    vertex(0 * scalar, 0 * scalar, 0 * scalar);
    vertex(5 * scalar, -6 * scalar, -5 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    endShape();

    //right right triangle
    beginShape();
    vertex(5 * scalar, -6 * scalar, -5 * scalar);
    vertex(20 * scalar, -10 * scalar, 0 * scalar);
    vertex(10 * scalar, 0 * scalar, 0 * scalar);
    endShape();
    popMatrix();
  }

void update(float[][] noiseField){
    vel.add(acc);
    vel.limit(maxVel);
    pos.add(vel);
    acc.mult(0);

    int xAft = (int)(pos.x / gridSize);
    int zAft = (int)(pos.z / gridSize);
    float aftHeight = noiseField[xAft][zAft] * maxHeight;

    int x = (int)((pos.x + 20 * scalar) / gridSize);
    int z = (int)(pos.z / gridSize);
    float frontHeight = noiseField[x][z] * maxHeight;
    angle = PVector.angleBetween(new PVector(pos.x, aftHeight), new PVector(pos.x + 20 * scalar, frontHeight));
    pos.y = aftHeight;
}
//apply a force to the acceleration
  void applyForce(PVector force) {
    acc.add(new PVector(force.x, 0, force.y));
  }

float calculateBuoyancyForce(){
    return 1;
}

PVector getHorizontalPosition() {
    return new PVector(pos.x, pos.z);
}
PVector getHorizontalVelocity() {
    return new PVector(vel.x, vel.z);
}
void addHorizontalVelocity(PVector newVel){
    vel.add(new PVector(newVel.x, 0, newVel.y));
}
void addVerticalVelocity(float newVel){
    vel.add(new PVector(0, newVel, 0));
}

float getMaxAcceleration(){
    return maxAcc;
}

}
