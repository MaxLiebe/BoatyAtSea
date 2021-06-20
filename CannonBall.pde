class CannonBall {
    PVector pos;
    PVector vel;
    float angle;
    
    static final float ballGravity = 0.2; //gravity with which the ball falls down
    static final float ballRadius = 5; //radius of the ball
    
    int lifeTime = 120;

    CannonBall(PVector pos, float angle) {
        this.pos = pos;
        this.angle = angle;

        PVector horizontalVel = new PVector(10, 0).rotate(angle);
        vel = new PVector(-horizontalVel.x, 4, horizontalVel.y);
    }

    void update() {
        vel.y -= ballGravity;
        pos.add(vel); //update the position with the velocity
        lifeTime--; //decrease the lifeTime
    }

    void show() {
        //draw the cannonball
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        fill(70);
        sphere(ballRadius);
        popMatrix();
    }

    PVector getPosition() {
        return pos.copy();
    }

    boolean isAlive() {
        return lifeTime > 0;
    }

    float getBallRadius() {
        return ballRadius;
    }
    
    void bounce() {
        vel.y = abs(vel.y);
    }
}