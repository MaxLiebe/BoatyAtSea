class PaperBoat{
    PVector pos; 
    float scalar=4;
    PaperBoat(PVector pos){
        this.pos=pos;        
    }
    void show(){
    stroke(1);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    rotateX(PI);
    fill(255);

    //middle triangle
    beginShape();
    vertex(0*scalar,0*scalar,0*scalar);
    vertex(10*scalar,0*scalar,0*scalar);
    vertex(5*scalar,-13*scalar,0*scalar);
    endShape(CLOSE);
    
    //left left triangle
    beginShape();
    vertex(-10*scalar,-10*scalar,0*scalar);
    vertex(5*scalar,-6*scalar,5*scalar);
    vertex(0*scalar,0*scalar,0*scalar);
    endShape();
    
    //left middle triangle
    beginShape();
    vertex(0*scalar,0*scalar,0*scalar);
    vertex(5*scalar,-6*scalar,5*scalar);
    vertex(10*scalar,0*scalar,0*scalar);
    endShape();
    
    //left right triangle
    beginShape();
    vertex(5*scalar,-6*scalar,5*scalar);
    vertex(20*scalar,-10*scalar,0*scalar);
    vertex(10*scalar,0*scalar,0*scalar);
    endShape();
    
    //right left triangle
    beginShape();
    vertex(-10*scalar,-10*scalar,0*scalar);
    vertex(5*scalar,-6*scalar,-5*scalar);
    vertex(0*scalar,0*scalar,0*scalar);
    endShape();
    
    //right middle triangle
    beginShape();
    vertex(0*scalar,0*scalar,0*scalar);
    vertex(5*scalar,-6*scalar,-5*scalar);
    vertex(10*scalar,0*scalar,0*scalar);
    endShape();
    
    //right right triangle
    beginShape();
    vertex(5*scalar,-6*scalar,-5*scalar);
    vertex(20*scalar,-10*scalar,0*scalar);
    vertex(10*scalar,0*scalar,0*scalar);
    endShape();
    popMatrix();
    }
}