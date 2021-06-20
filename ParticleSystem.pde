class ParticleSystem {
    PVector pos;
    ArrayList<Particle> particles;

    static final int HYDRO = 0;
    static final int EXPLOSION = 1;

    int type;
    int amount; //particles per frame for HYDRO, total particles for EXPLOSION

    ParticleSystem(PVector pos, int type, int amount) {
        this.pos = pos;
        this.type = type;
        this.amount = amount;
        particles = new ArrayList<Particle>();
        if(type == EXPLOSION) {
            for(int i = 0; i < amount; i++) {
                PVector vel = new PVector(random(-1, 1), 0, random(-1, 1)).normalize();
                vel.y = random(3, 5);
                particles.add(new ExplosionParticle(pos.copy(), vel.copy(), 120));
            }
        }
    }

    void hydroUpdate(PVector pos, float angle) {
        for(int i = 0; i < amount; i++) {
            PVector horizontalPos = new PVector(pos.x, pos.z);
            horizontalPos.add(new PVector(20, 0).rotate(angle));
            pos.x = horizontalPos.x;
            pos.z = horizontalPos.y;

            PVector horizontalVel = new PVector(1, random(-0.8, 0.8));
            horizontalVel.rotate(angle);
            PVector vel = new PVector(horizontalVel.x, random(-0.2, 0.2), -horizontalVel.y);
            particles.add(new HydroParticle(pos.copy(), vel.copy(), 120));
        }
        update();
    }

    void update() {
        for(int i = particles.size() - 1; i >= 0; i--) {
            Particle p = particles.get(i);
            if(p.isAlive()) {
                p.update();
            }else{
                particles.remove(i);
            }
        }
    }

    void show() {
        for(Particle p : particles) {
            p.show();
        }
    }
}