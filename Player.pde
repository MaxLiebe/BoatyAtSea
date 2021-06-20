class Player extends PaperBoat{
    Player(PVector pos, int gridSize, int maxHeight, int maxX, int maxZ, PImage flagImage, color c){
        super(pos, new PVector(), gridSize, maxHeight, maxX, maxZ, flagImage, c);
    }
}