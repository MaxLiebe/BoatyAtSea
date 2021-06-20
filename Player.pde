class Player extends PaperBoat{
    PVector dir; //moving direction
    static final float playerSpeed = 2; //speed at which the player moves
    static final float offScreenGravity = 10; //gravity the player experiences afte going offscreen

    float fallBuffer; //a "radius" around the boat for detecting when the boat is over the border
    int fallLifeTime = 200; //time we can spend falling before destruction, in frames
    boolean dead = false;

    Player(Sea sea, PVector pos, PImage flagImage, color c){
        super(sea, pos, new PVector(), flagImage, c);
        dir = new PVector();
        fallBuffer = 6 * scalar;
    }

    void update(){
        //if we're out of the sea, fall down and disable moving
        if(pos.x + fallBuffer < 0 || pos.x - fallBuffer > sea.getXSize() || pos.z + fallBuffer < 0 || pos.z - fallBuffer > sea.getZSize()) {
            pos.y -= offScreenGravity;
        }else{
            //calculate velocity based on the player's direction
            vel = dir.copy().normalize().mult(playerSpeed);
            pos.add(vel);
        }

        //if we're under the sea, we probably fell off, so count us out as dead
        if(pos.y < -sea.getMaxHeight()) {
            dead = true;
            fallLifeTime--;
        }

        //rotate the player to face the direction we're going in
        rotateToVelocity();

        if(vel.mag() > 0) waterParticles.hydroUpdate(pos.copy(), angle); //only spawn particles if we're moving
        else waterParticles.update();

        //add force to the flag based on our velocity
        flag.addRotationalVelocity(-abs(vel.mag()) * flagMultiplier);
        flag.update();

        //move to the target height
        pos.y += calculateStepToTarget();
    }

    void addNewDirection(PVector newDir) {
        dir.add(newDir);
    }

    PVector getCannonPosition() {
        return pos.copy().add(new PVector(0, 20, 0));
    }

    float getAngle() {
        return angle;
    }

    boolean isDead() {
        return dead;
    }

    //basically: have we fallen for long enough?
    boolean lifeTimeIsOver() {
        return fallLifeTime < 0;
    }
}