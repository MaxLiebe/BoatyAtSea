//Flocking explanation from voorbeeld van https://gamedevelopment.tutsplus.com/tutorials/3-simple-rules-of-flocking-behaviors-alignment-cohesion-and-separation--gamedev-3444
class Fleet {
  ArrayList<PaperBoat> boaties;
  Sea sea;
  Player player;
  int maxX;
  int maxZ;
  Fleet(Sea sea, PImage flag, Player player) {
    boaties = new ArrayList<PaperBoat>();
    int gridSize = sea.getGridSize();
    int maxHeight = sea.getMaxHeight();
    maxX = sea.getXSize();
    maxZ = sea.getZSize();
    for (int i = 0; i < 20; i++) {
      boaties.add(new PaperBoat(new PVector(
        randomGaussian() * maxX / 8 + maxX / 2, 
        100,  
        randomGaussian() * maxZ / 8 + maxZ / 2), 
        new PVector(random(-1, 1), 0, random(-1, 1)), //gives the boat a random starting velocity)
        gridSize, maxHeight, maxX, maxZ, flag,
        color(255)));
    }
    this.sea = sea;
    this.player = player;
  }

  void show() {
    for (PaperBoat boat : boaties) {
      boat.show();
    }
  }

  void update() {
    float noiseField[][] = sea.getNoiseField();
    for (PaperBoat boat : boaties) {
      boat.applyHorizontalForce(seperate(boat).mult(2.5));
      boat.applyHorizontalForce(align(boat).mult(0.1));
      boat.applyHorizontalForce(cohesion(boat).mult(0.001));
      boat.applyHorizontalForce(avoidPlayer(boat, player));
      boat.applyHorizontalForce(borders(boat).mult(5));
      boat.update(noiseField);
    }
  }

  //calculate a seperation force between the boat and every other bord if in range
  PVector seperate(PaperBoat boat) {
    int counter = 0;
    PVector average = new PVector(0, 0);
    for (PaperBoat other : boaties) {
      float distance = PVector.dist(boat.getHorizontalPosition(), other.getHorizontalPosition());
      if (distance > 0 && distance < 250) {
        counter++;
        PVector difference = PVector.sub(boat.getHorizontalPosition(), other.getHorizontalPosition());
        difference.normalize();
        difference.div(distance);
        average.add(difference);
      }
    }
    if (counter > 0) {
      average.div(counter);
    }
    return average;
  }

  //calculate an alignment vector for every boat in range
  PVector align(PaperBoat boat) {
    int counter = 0;
    PVector average = new PVector(0, 0);
    for (PaperBoat other : boaties) {
      //for every boat in range calculate the total velocity vector
      float distance = PVector.dist(boat.getHorizontalPosition(), other.getHorizontalPosition());
      if (distance > 0 && distance < 100) {
        counter++;
        average.add(other.getHorizontalVelocity());
      }
    }
    if (counter > 0) {
      //divide the total velocity vector by the amount of boats in range to get the average heading
      average.div(counter);
    }
    return average;
  }

  //calculate an average position for every boat in range and steer towards that
  PVector cohesion(PaperBoat boat) {
    int counter = 0;
    PVector average = new PVector(0, 0);
    //for every boat thats in range add the position for the average position
    for (PaperBoat other : boaties) {
      float distance = PVector.dist(boat.getHorizontalPosition(), other.getHorizontalPosition());
      if (distance > 0 && distance < 130) {
        counter++;
        average.add(other.getHorizontalPosition());
      }
    }
    //divide the sumposition of all boats by the amount of boats in range
    if (counter > 0) {
      average.div(counter);
    }
    average = PVector.sub(average, boat.getHorizontalPosition());
    if (average.mag() > 0) {
      average.normalize();
      average.mult(boat.getMaxAcceleration());
      average.sub(boat.getHorizontalVelocity());
      average.limit(boat.getMaxAcceleration());
    }
    //inverse the vector
    return average;
  }

  //Behaviour in relation to the borders of the map steer away when getting close
  PVector borders(PaperBoat boat) {
    PVector keepFromCrashing = new PVector(0, 0, 0); //has a vector that is edited when a boat nearly hits the border

    //right border
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, maxX, boat.getHorizontalPosition().y) < 100) {
      PVector diff = PVector.sub(boat.getHorizontalPosition(), new PVector(maxX, boat.getHorizontalPosition().y));
      diff.normalize();
      diff.div(dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, maxX, boat.getHorizontalPosition().y));        // Weight by distance
      keepFromCrashing.add(diff);
    }
    //left border
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, 0, boat.getHorizontalPosition().y) < 100) {
      PVector diff = PVector.sub(boat.getHorizontalPosition(), new PVector(0, boat.getHorizontalPosition().y));
      diff.normalize();
      diff.div(dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, 0, boat.getHorizontalPosition().y));        // Weight by distance
      keepFromCrashing.add(diff);
    }

    //lowerborder
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, boat.getHorizontalPosition().x, maxZ) < 100) {
      PVector diff = PVector.sub(boat.getHorizontalPosition(), new PVector(boat.getHorizontalPosition().x, maxZ));
      diff.normalize();
      diff.div(dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, boat.getHorizontalPosition().x, maxZ));        // Weight by distance
      keepFromCrashing.add(diff);
    }

    //upperborder
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, boat.getHorizontalPosition().x, 0) < 100) {
      PVector diff = PVector.sub(boat.getHorizontalPosition(), new PVector( boat.getHorizontalPosition().x, 0));
      diff.normalize();
      diff.div(dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, boat.getHorizontalPosition().x, 0));        // Weight by distance
      keepFromCrashing.add(diff);
    }
    return keepFromCrashing;
  }

  PVector avoidPlayer(PaperBoat boat, Player player) {
    PVector difference= new PVector(0, 0);
    float distance = PVector.dist(boat.getHorizontalPosition(), player.getHorizontalPosition());
    if (distance > 0 && distance < 2000) {
      difference = PVector.sub(boat.getHorizontalPosition(), player.getHorizontalPosition());
      difference.normalize();
      difference.div(distance);
    }
    return difference;
  }
}
