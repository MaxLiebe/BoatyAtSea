class ExplosionParticle extends Particle {
    static final float particleGravity = 0.1;

    ExplosionParticle(PVector pos, PVector vel, int lifeTime) {
        super(pos, vel, lifeTime);
    }

    void show() {
        //create a fiery particle
        noStroke();
        colorMode(HSB);
        fill(random(0, 38), 255, 255, lifeTime);
        colorMode(RGB);
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        box(6);
        popMatrix();
    }
    
    void update() {
        vel.y -= particleGravity; //make sure the particles fall down
        super.update();
    }
}