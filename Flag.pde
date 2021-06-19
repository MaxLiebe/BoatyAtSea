class Flag {
    PImage flagImage;
    Segment[] segments = new Segment[5];
    
    Flag(PImage flagImage, float angularVelocity, float torque) {
        //initialize all segments of the flower
        for(int i = 0; i < segments.length; i++) {
            segments[i] = new Segment();
        }
        //pass the given rotational velocity and torque to the first segment
        segments[0].torque = torque;
        segments[0].angularVelocity = angularVelocity;

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
    }

    void show(){
        stroke(140, 140, 140);
        pushMatrix();

        //stem + leaves
        for(int i = 0; i < segments.length; i++) {
            strokeWeight(4);
            rotate(segments[i].totalRotation);
            line(0, 0, 0, 10);
            translate(0, 10);
        }

        image(flagImage, 0, 0, 22, 15);
        popMatrix();
    }
}