class Food{
  PVector pos;

  Food(){
    pos = new PVector(int(random(GRID_SIZE)), int(random(GRID_SIZE)));
  }

  void reset(Snake s){
    boolean taken = false;
    int count = 0;
    while(count < 20){ //Find an empty spot on the board
      pos = new PVector(int(random(GRID_SIZE)), int(random(GRID_SIZE)));
      for(int i = 0; i < s.pos.size(); i++){
        PVector seg = s.segment(i);
        if(pos.equals(seg)){
          taken = true;
        }
      }
      if(!taken){
        break;
      }else{
        count++;
      }
    }
  }

  void display(PGraphics can){
    can.stroke(255, 0, 0);
    can.point(pos.x, pos.y);
  }
}
