class PaperBoat {
  PVector pos, vel, acc;
  float scalar=4;
  float angle;
  int gridSize;
  int maxHeight;
  int maxX;
  int maxZ;
  float gravity;
  float maxHorVel = 0.8;
  float maxVerVel = 0.4;
  float maxAcc = 2;
  float rangeInfluence;
  float r;

  ParticleSystem system;
  Flag flag;

  PaperBoat(PVector pos, int gridSize, int maxHeight, int maxX, int maxZ, float gravity, PImage flagImage) {
    this.pos = pos; 
    this.gridSize = gridSize;
    this.maxHeight = maxHeight;
    this.maxX =  maxZ;
    this.gravity = gravity;
    vel=new PVector(random(-1,1), 0, random(-1,1)); //gives the boat a random starting velocity
    acc=new PVector(0, 0);

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
    rotateZ(angle);
    translate(-5 * scalar, 0, 0);
    rotateX(PI);
    stroke(1);
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

    int xAft = (int)(pos.x / gridSize);
    int zAft = (int)(pos.z / gridSize);
    constrain(xAft, 0, noiseField[0].length);
    constrain(zAft, 0, noiseField.length);
    float aftHeight = noiseField[xAft][zAft] * maxHeight;

    PVector frontPos=PVector.add(pos.copy(), vel.copy().normalize().mult(15*scalar));
    int x = (int)(constrain((frontPos.x), 0, maxX) / gridSize);
    int z = (int)(constrain(frontPos.z,0,maxZ)/ gridSize);
    float frontHeight = noiseField[x][z] * maxHeight;
    angle=PVector.angleBetween(new PVector(frontPos.x, frontHeight), new PVector(pos.x, aftHeight));
    pos.y=(aftHeight+frontHeight)/2;

    acc.mult(0);
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
