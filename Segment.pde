
class Segment {
    static final float SPRING_CONSTANT = 100;
    static final float DAMPING_CONSTANT = 0.05;
    // static final float MASS_CONSTANT = 1;

    float torque = 0;
    float angularVelocity = 0;
    float totalRotation = 0;

    //do da physcis
    void update(float incomingVelocity, float followingTorque) {
        float usedVelocity = angularVelocity - incomingVelocity;
        float friction = usedVelocity * DAMPING_CONSTANT;
        torque = (1 / SPRING_CONSTANT * totalRotation + friction);
        totalRotation += usedVelocity;
        angularVelocity += followingTorque - torque;
    }
}