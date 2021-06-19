class Particle {
    PVector pos;
    PVector vel;
    int lifeTime;

    Particle(PVector pos, PVector vel, int lifeTime) {
        this.pos = pos;
        this.vel = vel;
        this.lifeTime = lifeTime;
    }

    void update() {
        pos.add(vel);
        lifeTime--;
    }

    void show() {}

    boolean isAlive() {
        return lifeTime > 0;
    }
}