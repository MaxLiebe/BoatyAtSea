
class Fleet {
  ArrayList<PaperBoat> boaties; //all boats in the fleet
  Sea sea;
  Player player;

  //flocking weights
  static final float separationWeight = 10;
  static final float alignWeight = 0.1;
  static final float cohesionWeight = 0.001;
  static final float avoidanceWeight = 10.0;
  static final float borderWeight = 5.0;

  //flocking ranges
  static final float separationRange = 100;
  static final float alignRange = 100;
  static final float cohesionRange = 250;
  static final float avoidanceRange = 250;
  static final float borderRange = 100;

  Fleet(Sea sea, Player player, PImage flag, color c) {
    boaties = new ArrayList<PaperBoat>();

    //spawn new boats at random position and with a random velocity
    for (int i = 0; i < 20; i++) {
      PaperBoat boat = new PaperBoat(
        sea, 
        sea.generateRandomPosition(),
        new PVector(random(-1, 1), 0, random(-1, 1)), //gives the boat a random starting velocity
        flag,
        color(255));
      boaties.add(boat);
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
    for (PaperBoat boat : boaties) {
      boat.applyHorizontalForce(separate(boat).mult(separationWeight));
      boat.applyHorizontalForce(align(boat).mult(alignWeight));
      boat.applyHorizontalForce(cohesion(boat).mult(cohesionWeight));
      boat.applyHorizontalForce(avoidPlayer(boat, player).mult(avoidanceWeight));
      boat.applyHorizontalForce(borders(boat).mult(borderWeight));
      boat.update();
    }
  }

  //calculate a separation force between the boat and every other boat if in range
  PVector separate(PaperBoat boat) {
    int counter = 0;
    PVector average = new PVector(0, 0);
    for (PaperBoat other : boaties) {
      float distance = PVector.dist(boat.getHorizontalPosition(), other.getHorizontalPosition());
      if (distance > 0 && distance < separationRange) {
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
      if (distance > 0 && distance < alignRange) {
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
      if (distance > 0 && distance < cohesionRange) {
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
    return average;
  }

  //Behaviour in relation to the borders of the map steer away when getting close
  PVector borders(PaperBoat boat) {
    PVector keepFromCrashing = new PVector(0, 0, 0); //has a vector that is edited when a boat nearly hits the border
    int maxX = sea.getXSize();
    int maxZ = sea.getZSize();

    //right border
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, maxX, boat.getHorizontalPosition().y) < borderRange) {
      PVector diff = PVector.sub(boat.getHorizontalPosition(), new PVector(maxX, boat.getHorizontalPosition().y));
      diff.normalize();
      diff.div(dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, maxX, boat.getHorizontalPosition().y));        // Weight by distance
      keepFromCrashing.add(diff);
    }
    //left border
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, 0, boat.getHorizontalPosition().y) < borderRange) {
      PVector diff = PVector.sub(boat.getHorizontalPosition(), new PVector(0, boat.getHorizontalPosition().y));
      diff.normalize();
      diff.div(dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, 0, boat.getHorizontalPosition().y));        // Weight by distance
      keepFromCrashing.add(diff);
    }

    //lowerborder
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, boat.getHorizontalPosition().x, maxZ) < borderRange) {
      PVector diff = PVector.sub(boat.getHorizontalPosition(), new PVector(boat.getHorizontalPosition().x, maxZ));
      diff.normalize();
      diff.div(dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, boat.getHorizontalPosition().x, maxZ));        // Weight by distance
      keepFromCrashing.add(diff);
    }

    //upperborder
    if (dist(boat.getHorizontalPosition().x, boat.getHorizontalPosition().y, boat.getHorizontalPosition().x, 0) < borderRange) {
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
    if (distance > 0 && distance < avoidanceRange) {
      difference = PVector.sub(boat.getHorizontalPosition(), player.getHorizontalPosition());
      difference.normalize();
      difference.div(distance);
    }
    return difference;
  }

  void setPlayer(Player player) {
    this.player = player;
  }

  ArrayList<PaperBoat> getBoaties() {
    return boaties;
  }
}
