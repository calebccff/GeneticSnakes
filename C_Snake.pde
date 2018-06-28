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

  Snake(PGraphics can) {
    this.canvas = can;
    pos.add(new PVector(int(random(G_SIZE)), int(random(G_SIZE))));
    
    brain = new Brain(4, new int[] {3, 2}, 1);
  }

  void run() {
    float[] inputs = new float[4];
    PVector search = new PVector(0, 1);
    for(int i = 0; i < 3; i++){
      if(dist(0, search.heading(), 0, dir.heading()) == PI) break;
      inputs[i] = wallDist(search);
      search.rotate(HALF_PI);
      println(search);
    }
    
    
    //PVector trace = pos.get(0).copy();
    //boolean hit = false;
    //while(trace.x >= 0 && trace.x < G_SIZE && trace.y >= 0 && trace.y < G_SIZE && !hit){
    //  trace.add(dir);
    //  for(int i = 1; i < pos.size(); i++){
    //    PVector p = pos.get(0);
    //    if(trace.x == p.x && trace.y == p.y){
    //      inputs[1] = map(dist(trace.x, trace.y, pos.get(0).x, pos.get(0).y), 0, G_SIZE, 1, 0.1);
    //      hit = true;
    //      break;
    //    }
    //  }
    //}
  }
  
  float wallDist(PVector dir){
    PVector trace = pos.get(0).copy();
    while(trace.x >= 0 && trace.x < G_SIZE && trace.y >= 0 && trace.y < G_SIZE){
      trace.add(dir);
    }
    return map(dist(trace.x, trace.y, pos.get(0).x, pos.get(0).y), 0, G_SIZE, 1, 0);
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

  void reset() {
    pos = new PVector(int(random(G_SIZE)), int(random(G_SIZE)));
  }

  void display() {
    canvas.stroke(255, 25, 25);
    canvas.point(pos.x, pos.y);
  }

  boolean eaten(Snake s) {
    return s.pos.get(0).x==pos.x && s.pos.get(0).y==pos.y;
  }
}