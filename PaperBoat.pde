class PaperBoat {
  PVector pos, vel, acc; //position, velocity, acceleration
  static final float scalar = 4; //scale of the boat

  static final float maxHorVel = 0.8; //maximum horizontal velocity
  static final float maxVerVel = 1; //maximum vertical velocity
  static final float maxAcc = 2; //maximum acceleration

  float angle = 0; //angle the boat is facing
  static final float rotationSpeed = 0.1; //maximum speed the boat can turn at

  static final float flagMultiplier = 0.0005; //multiplier for passing the force of the boat onto the flag

  float damageRadius;

  Sea sea;
  ParticleSystem waterParticles; //splashes of water the boat produces
  Flag flag; //waving flag on top of boat
  color c; //color of the boat

  PaperBoat(Sea sea, PVector pos, PVector vel, PImage flagImage, color c) {
    this.sea = sea;
    this.pos = pos;
    this.vel = vel; 
    this.c = c;

    acc = new PVector();
    waterParticles = new ParticleSystem(new PVector(), ParticleSystem.HYDRO, 1);
    flag = new Flag(flagImage);

    damageRadius = 7 * scalar;
  }

  void show() {
    //water particles
    waterParticles.show();

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateY(angle);

    //the flag
    translate(20, 5, 0);
    flag.show();
    translate(-20, -5, 0);

    //the boat
    strokeWeight(1);
    rotateX(PI);
    stroke(1);
    fill(c);

    //middle triangle
    beginShape();
    vertex(-5 * scalar, 0 * scalar, 0 * scalar);
    vertex(5 * scalar, 0 * scalar, 0 * scalar);
    vertex(0 * scalar, -13 * scalar, 0 * scalar);
    endShape(CLOSE);

    //left left triangle
    beginShape();
    vertex(-15 * scalar, -10 * scalar, 0 * scalar);
    vertex(0 * scalar, -6 * scalar, 5 * scalar);
    vertex(-5 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //left middle triangle
    beginShape();
    vertex(-5 * scalar, 0 * scalar, 0 * scalar);
    vertex(0 * scalar, -6 * scalar, 5 * scalar);
    vertex(5 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //left right triangle
    beginShape();
    vertex(0 * scalar, -6 * scalar, 5 * scalar);
    vertex(15 * scalar, -10 * scalar, 0 * scalar);
    vertex(5 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //right left triangle
    beginShape();
    vertex(-15 * scalar, -10 * scalar, 0 * scalar);
    vertex(0 * scalar, -6 * scalar, -5 * scalar);
    vertex(-5 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //right middle triangle
    beginShape();
    vertex(-5 * scalar, 0 * scalar, 0 * scalar);
    vertex(0 * scalar, -6 * scalar, -5 * scalar);
    vertex(5 * scalar, 0 * scalar, 0 * scalar);
    endShape(CLOSE);

    //right right triangle
    beginShape();
    vertex(0 * scalar, -6 * scalar, -5 * scalar);
    vertex(5 * scalar, 0 * scalar, 0 * scalar);
    vertex(15 * scalar, -10 * scalar, 0 * scalar);
    endShape(CLOSE);
    popMatrix();
  }

  void update(){
      vel.add(acc);
      vel.limit(maxHorVel);
      pos.add(vel);

      rotateToVelocity();
      
      waterParticles.hydroUpdate(pos.copy(), angle);

      //add angular drag to the flag
      flag.addRotationalVelocity(-abs(vel.mag()) * flagMultiplier);
      flag.update();

      pos.y += calculateStepToTarget();
      acc.mult(0);
  }

  void rotateToVelocity() {
    //rotate to the desired angle with a rotation speed
    float desiredRotation = atan2(vel.x, vel.z) + HALF_PI;

    if(vel.mag() > 0 && angle != desiredRotation) { //don't rotate if we're stationary or already in the right angle
      //decide whether to rotate left or right by finding out what the shortest angle is
      if(angle > desiredRotation) {
        angle -= abs(angle - desiredRotation) > rotationSpeed ? rotationSpeed : angle - desiredRotation;
        if(angle - desiredRotation > PI) angle -= TWO_PI; //a fix for turning in the wrong direction
      }else{
        if(desiredRotation - angle > PI) angle += TWO_PI;
        angle += abs(desiredRotation - angle) > rotationSpeed ? rotationSpeed : desiredRotation - angle;
      }
    }
  }

  float calculateStepToTarget(){
      //get the sea's noise map (aka the height field)
      float[][] hf = sea.getNoiseField();

      //find the nearest position (array index) of the noise field compared to our current position
      float correctedX = pos.x / sea.getGridSize();
      float correctedZ = pos.z / sea.getGridSize();

      //get the coordinates of the quad
      int x1 = floor(correctedX);
      int x2 = ceil(correctedX);
      int z1 = floor(correctedZ);
      int z2 = ceil(correctedZ);

      //constrain our coordinates (again, array indices) to the bounds of the sea
      x1 = constrain(x1, 0, hf.length - 1);
      x2 = constrain(x2, 0, hf.length - 1);
      z1 = constrain(z1, 0, hf[0].length - 1);
      z2 = constrain(z2, 0, hf[0].length - 1);

      //find the target height by taking the average height of both extremes
      float targetHeight = ((hf[x2][z2] + hf[x1][z1]) / 2) * sea.getMaxHeight();

      //approach the target with a curve (speed decreases when nearing target height)
      return constrain(sqrt(abs(pos.y - targetHeight)), 0, maxVerVel) * (pos.y > targetHeight ? -1 : 1);
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

  PVector getPosition() {
    return pos.copy();
  }

  float getMaxAcceleration(){
      return maxAcc;
  }

  float getDamageRadius() {
    return damageRadius;
  }
}
