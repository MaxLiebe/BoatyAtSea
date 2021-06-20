class Flag {
    PImage flagImage;
    Segment[] segments = new Segment[5];
    float time = random(0, 100);
    float timeStep = 0.001;
    
    Flag(PImage flagImage) {
        //initialize all segments of the flag
        for(int i = 0; i < segments.length; i++) {
            segments[i] = new Segment();
        }

        //pass the given rotational velocity and torque to the first segment
        segments[0].torque = 0;
        segments[0].angularVelocity = 0;

        this.flagImage = flagImage;
    }

    void update() {
        int count = segments.length;
        
        //update first
        segments[0].update(0, segments[1].torque);

        //update all but first and last
        for(int i = 1; i < count - 1; i++) {
            segments[i].update(segments[i - 1].angularVelocity, segments[i + 1].torque);
        }

        //update last
        segments[count - 1].update(segments[count - 2].angularVelocity, 0);
        time += timeStep;
    }

    void show(){
        stroke(140, 140, 140);
        pushMatrix();

        //pole
        for(int i = 0; i < segments.length; i++) {
            strokeWeight(4);
            rotateZ(segments[i].totalRotation);
            line(0, 0, 0, 15);
            translate(0, 15);
        }

        //flag
        //randomly rotate the flag to make it "wave"
        rotateY(map(noise(time), 0, 1, -TWO_PI, TWO_PI));
        scale(1,-1);
        image(flagImage, 0, 0, 22, 15);
        popMatrix();
    }

    void addRotationalVelocity(float vel) {
        segments[segments.length - 1].angularVelocity += vel;
    }
}