
class Segment {
    static final float SPRING_CONSTANT = 300;
    static final float DAMPING_CONSTANT = 0.2;
    // static final float MASS_CONSTANT = 1;

    float torque = 0;
    float angularVelocity = 0;
    float totalRotation = 0;

    //apply mass system damper system physics
    void update(float incomingVelocity, float followingTorque) {
        float usedVelocity = angularVelocity - incomingVelocity;
        float friction = usedVelocity * DAMPING_CONSTANT;
        torque = (1 / SPRING_CONSTANT * totalRotation + friction);
        totalRotation += usedVelocity;
        angularVelocity += followingTorque - torque;
    }
}