class ParticleSystem {
    PVector pos;
    ArrayList<Particle> particles;

    static final int HYDRO = 0;
    static final int SPLASH = 1;

    int type;
    int amount;

    ParticleSystem(PVector pos, int type, int amount) {
        this.pos = pos;
        this.type = type;
        this.amount = amount;
        particles = new ArrayList<Particle>();
    }

    void update() {
        switch(type) {
            case HYDRO:
                for(int i = 0; i < amount; i++) {
                    PVector pos = new PVector(10, 4, 0);
                    PVector vel = new PVector(1, random(-0.2, 0.2), random(-0.8, 0.8));
                    particles.add(new HydroParticle(pos.copy(), vel.copy(), 120));
                }
                break;
            case SPLASH:
                break;
        }
    }

    void show() {
        for(int i = particles.size() - 1; i > 0; i--) {
            Particle p = particles.get(i);
            if(p.isAlive()) {
                p.update();
                p.show();
            }else{
                particles.remove(i);
            }
        }
    }
}