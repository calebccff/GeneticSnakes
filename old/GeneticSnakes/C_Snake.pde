class Snake {
  ArrayList<PVector> pos = new ArrayList<PVector>();
  PVector dir = new PVector(0, -1); /*
   0, -1 - UP
   1,  0 - RIGHT
   0,  1 - DOWN
  -1,  0 - LEFT
   */

  PGraphics canvas;
  Brain brain;
  boolean add = false;

  Snake(PGraphics can) {
    this.canvas = can;
    pos.add(new PVector(int(random(G_SIZE)), int(random(G_SIZE))));
    pos.add(PVector.add(head(), dir));
    pos.add(PVector.add(head(), dir));
    pos.add(PVector.add(head(), dir));
    pos.add(PVector.add(head(), dir));

    brain = new Brain(4, new int[] {6, 3}, 1);
  }

  Snake(PGraphics can, Snake p) {
    this.canvas = can;
    pos.add(new PVector(int(random(G_SIZE)), int(random(G_SIZE))));

    brain = new Brain(p.brain);
  }

  boolean run(Food f) {
    float[] inputs = new float[4];
    PVector search = new PVector(0, 1);
    for(int i = 0; i < 3; i++){
      if(dist(0, search.heading(), 0, dir.heading()) == PI) continue;
      inputs[i] = wallDist(search);
      search.rotate(HALF_PI);
      search.x = round(search.x);
      search.y = round(search.y);
    }
    inputs[3] = map(dist(f.pos.x, f.pos.y, head().x, head().y), 0, dist(0, 0, G_SIZE, G_SIZE), 1, 0);

    float output = brain.propForward(inputs)[0];
    if(output < 0.45){
      dir.rotate(-HALF_PI); //Turn left
    }else if(output < 0.55){ //Keep going forward

    }else{
      dir.rotate(HALF_PI);
    }
    dir.x = round(dir.x);
    dir.y = round(dir.y);

    pos.add(PVector.add(head(), dir));
    roundAll();
    if(!f.eaten(this)){
      pos.remove(0);
      return false;
    }
    println("Eaten");
    return true;
  }

  void roundAll(){
    for(int i = 0; i < pos.size(); i++){
      pos.get(i).x = round(pos.get(i).x);
      pos.get(i).y = round(pos.get(i).y);
    }
  }

  boolean checkDead(){
    PVector head = head().copy();
    if(head.x < 0 || head.x > G_SIZE-1 || head.y < 0 || head.y > G_SIZE-1){
      return true;
    }

    for(int i = 0; i < pos.size()-1; i++){
      if(head.x == pos.get(i).x && head.y == pos.get(i).y){
        return true;
      }
    }
    return false;
  }
  PVector head(){
    return pos.get(pos.size()-1);
  }

  float wallDist(PVector dir){
    PVector trace = head().copy();
    boolean hit = false;
    while(trace.x >= 0 && trace.x < G_SIZE && trace.y >= 0 && trace.y < G_SIZE && !hit){
      trace.add(dir);
      for(int i = 0; i < pos.size()-1; i++){
        if(trace.x == pos.get(i).x && trace.y == pos.get(i).x) {
          hit = true;
        }
      }

    }
    return map(dist(trace.x, trace.y, head().x, head().y), 0, G_SIZE, 1, 0);
  }

  void display() {
    canvas.fill(25, 255, 25);
    canvas.noStroke();
    for (int i = 0; i < pos.size(); i++) {
      canvas.rect(pos.get(i).x, pos.get(i).y, 1, 1);
    }
  }
}

class Food {
  PVector pos;
  PGraphics canvas;

  Food(PGraphics can) {
    canvas = can;
    pos = new PVector(int(random(G_SIZE)), int(random(G_SIZE)));
  }

  void reset(Snake s) {
    boolean taken = true;
    while(taken){
      pos = new PVector(int(random(G_SIZE)), int(random(G_SIZE)));
      for(int i = 0; i < s.pos.size(); i++){
        PVector p = s.pos.get(i);
        if(p.x == pos.x && p.y == pos.y) taken = false;
      }
    }
  }

  void display() {
    canvas.stroke(255, 25, 25);
    canvas.point(pos.x, pos.y);
  }

  boolean eaten(Snake s) {
    return s.head().x==pos.x && s.head().y==pos.y;
  }
}
