class HydroParticle extends Particle {
    HydroParticle(PVector pos, PVector vel, int lifeTime) {
        super(pos, vel, lifeTime);
    }

    void show() {
        noStroke();
        fill(97, 177, 242, lifeTime);
        pushMatrix();
        translate(pos.x, pos.y, pos.z);
        box(4);
        popMatrix();
    }
}