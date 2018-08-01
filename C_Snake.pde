class Snake{
  ArrayList<Integer[]> pos = new ArrayList<Integer[]>();
  PVector dir = new PVector(0, -1); /*
   0, -1 - UP
   1,  0 - RIGHT
   0,  1 - DOWN
  -1,  0 - LEFT
   */

  Brain brain;

  Snake(){
    brain = new Brain(4, new int[] {3, 2}, 1);
    initSegments(3);
  }

  void initSegments(int count){
    Integer[] p = new Integer[2];
    PVector po = new PVector(int(random(GRID_SIZE)), int(random(GRID_SIZE)));
    p[0] = round(po.x);
    p[1] = round(po.y);
    pos.add(p);
    for(int i = 0; i < count-1; i++){
      moveSegment();
    }
  }

  Snake(Snake p){
    brain = new Brain(p.brain);
    initSegments(3);
  }

  void run(Food f){
    move(f);
  }

  void move(Food f){
    float[] inputs = new float[4]; //Obstacle in front, to left, to right AND food to left/right
    PVector search = PVector.fromAngle(dir.heading());
    search = rounded(search.rotate(-HALF_PI));
    for(int i = 0; i < inputs.length-1; i++){
      inputs[i] = findObstacle(head(), search);
    }
    inputs[3] = map(abs(head().mag()-f.pos.mag()), 0, GRID_SIZE, 1, 0);

    float output = brain.propForward(inputs)[0];
    println(output);
    if(output < 0.45){
      dir = rounded(dir.rotate(-HALF_PI));
    }else if(output > 0.55){
      dir = rounded(dir.rotate(HALF_PI));
    }
    moveSegment();
  }

  void moveSegment(){
    Integer[] newH = new Integer[2];
    PVector nh = rounded(PVector.add(head(), dir));
    newH[0] = round(nh.x);
    newH[1] = round(nh.y);
    pos.add(newH);
  }

  float findObstacle(PVector start, PVector dir){
    PVector trace = start.copy();
    boolean hit = false;
    while(trace.x == constrain(trace.x, 0, GRID_SIZE) && trace.y == constrain(trace.y, 0, GRID_SIZE) && !hit){
      trace = rounded(PVector.add(trace, dir));
      for(int i = 0; i < pos.size()-2; i++){ //All body segments excluding head and neck
        PVector seg = segment(i);
        if(trace.equals(seg)){
          hit = true;
          break;
        }
      }
    }
    return map(abs(start.mag()-trace.mag()), 0, GRID_SIZE, 1, 0);
  }

  boolean eatFood(Food f){
    return f.pos.equals(head());
  }

  PVector head(){
    Integer[] h = pos.get(pos.size()-1);
    return new PVector(h[0], h[1]);
  }

  PVector segment(int i){
    Integer[] h = pos.get(i);
    return new PVector(h[0], h[1]);
  }

  void display(PGraphics can){
    can.stroke(0, 255, 0);
    for(int i = 0; i < pos.size(); i++){
      Integer[] p = pos.get(i);
      can.point(p[0], p[1]);
    }
  }
}
