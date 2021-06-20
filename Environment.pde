class Environment {
    ArrayList<CannonBall> cannonBalls;
    ArrayList<ParticleSystem> explosions;
    PMatrix baseMatrix; //used for drawing UI text
    Fleet fleet;
    Sea sea;
    Ground ground;
    Player player;

    int envWidth;
    int envHeight;

    Environment(PMatrix baseMatrix, int envWidth, int envHeight) {
        this.envWidth = envWidth;
        this.envHeight = envHeight;
        this.baseMatrix = baseMatrix;
        sea = new Sea(envWidth, envHeight);
        ground = new Ground(sea.getXSize(), sea.getZSize());
        player = new Player(sea, sea.generateRandomPosition(), playerFlag, color(100));
        fleet = new Fleet(sea, player, enemyFlag, color(255));
        cannonBalls = new ArrayList<CannonBall>();
        explosions = new ArrayList<ParticleSystem>();
    }

    void update() {
        sea.processWaves();
        fleet.update();
        player.update();

        //update the cannonballs and destroy them if they have existed for too long
        for(int i = cannonBalls.size() - 1; i >= 0; i--) {
            CannonBall ball = cannonBalls.get(i);
            if(ball.isAlive()) {
                ball.update();
                checkForGroundCollision(ball);
                checkForFleetCollision(ball);
            }else{
                cannonBalls.remove(i);
            }
        }

        for(ParticleSystem system : explosions) {
            system.update();
        }

        if(player.lifeTimeIsOver()) {
            //reset the player and update the fleet about the new player
            player = new Player(sea, sea.generateRandomPosition(), playerFlag, color(100));
            fleet.setPlayer(player);
        }
    }

    void show() {
        //draw cannonballs
        for(CannonBall ball : cannonBalls) {
            ball.show();
        }

        //draw 3d objects
        ground.show();
        sea.show();
        fleet.show();
        player.show();

        //draw explosion particle systems
        for(ParticleSystem system: explosions) {
            system.show();
        }

        //draw ui text
        pushMatrix();
        fill(255);
        setMatrix(baseMatrix);
        textSize(32);
        textAlign(CENTER);
        text("Move with WASD, press SPACE to shoot", envWidth / 2, 60);

        //display a nagging text if the player is dead
        if(player.isDead()) {
            text("WHAT ARE YA DOING?!", envWidth / 2, 120);
        }

        //display a victory text if all the enemies are dead
        if(fleet.getBoaties().size() == 0) {
            fill(255, 179, 0);
            textSize(64);
            text("You did it!", envWidth / 2, envHeight / 2);
        }
        popMatrix();
    }

    void keyEvent(int key, boolean pressed) {
        //create a "new direction" that adds onto the current direction based on the keys pressed
        PVector newDir = new PVector();
        switch(key) {
            case 'w': newDir.z = 1; break;
            case 's': newDir.z = -1; break;
            case 'a': newDir.x = -1; break;
            case 'd': newDir.x = 1; break;
            case ' ': {
                if(pressed) {
                    spawnCannonBall(player.getCannonPosition(), player.getAngle());
                } 
                break;
            }
        }
        newDir.mult(pressed ? 1 : -1); //invert the direction if this was a key release
        player.addNewDirection(newDir);
    }

    //shoot a cannonball!
    void spawnCannonBall(PVector pos, float angle) {
        CannonBall ball = new CannonBall(pos, angle);
        cannonBalls.add(ball);
    }

    //check if a cannonball is hitting the ground; if so, bounce
    void checkForGroundCollision(CannonBall ball) {
        PVector pos = ball.getPosition();
        float r = ball.getBallRadius();
        if((pos.x - r > 0 && pos.x + r < sea.getXSize() && pos.z - r > 0 && pos.z + r < sea.getXSize()) //check if we're inside the sea/ground area
        && pos.y + r <= ground.getGroundHeight()) { //check if we're at ground height
            ball.bounce();
        }
    }

    //check if a cannonball hit a boat
    void checkForFleetCollision(CannonBall ball) {
        ArrayList<PaperBoat> boaties = fleet.getBoaties();
        for(int i = boaties.size() - 1; i >= 0; i--) {
            PaperBoat boat = boaties.get(i);
            //check if cannonball is within the boat's damage radius
            if(ball.getPosition().dist(boat.getPosition()) < boat.getDamageRadius()) {
                //hit! destroy the boat and play some explosion particles
                explosions.add(new ParticleSystem(boat.getPosition(), ParticleSystem.EXPLOSION, 50));
                boaties.remove(i);
            }
        }
    }
}