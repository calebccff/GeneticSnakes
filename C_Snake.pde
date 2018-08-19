class Snake{
  ArrayList<Integer[]> pos = new ArrayList<Integer[]>();
  PVector dir = new PVector(0, -1); /*
   0, -1 - UP
   1,  0 - RIGHT
   0,  1 - DOWN
  -1,  0 - LEFT
   */

  Brain brain;
  float maxDisplacement;
  PVector startPos;

  Snake(){
    brain = new Brain(6, new int[] {5, 3}, 1);
    config();
  }

  Snake(Snake a, Snake b){
    brain = new Brain(a.brain, b.brain);
    config();
  }

  void config(){
    for(int i = 0; i < random(5); i++){
      dir.rotate(HALF_PI);
    }
    dir = rounded(dir);
    initSegments(4);
    startPos = head();

  }
  void initSegments(int count){
    Integer[] p = new Integer[2];
    PVector po = new PVector(int(GRID_SIZE/2), int(GRID_SIZE/2));
    p[0] = round(po.x);
    p[1] = round(po.y);
    pos.add(p);
    for(int i = 0; i < count-1; i++){
      moveSegment();
    }
  }

  void run(Food f, int n){
    move(f, n);
  }

  void move(Food f, int n){
    float[] inputs = new float[6]; //Obstacle in front, to left, to right AND dist to food
    PVector search = PVector.fromAngle(dir.heading());
    search = rounded(search.rotate(-HALF_PI)); //LEFT, FRONT, RIGHT
    for(int i = 0; i < 3; i++){
      inputs[i] = findObstacle(head(), search);
      search = rounded(search.rotate(HALF_PI)); //Rotate 90 degrees to search in each direction
    }
    search = PVector.fromAngle(dir.heading());
    search = rounded(search.rotate(-HALF_PI)); //LEFT, FRONT, RIGHT
    for(int i = 3; i < inputs.length-1; i++){
      inputs[i] = findObstacle(head(), search, f);
      search = rounded(search.rotate(HALF_PI)); //Rotate 90 degrees to search in each direction
    }
    // try{
    //   inputs[inputs.length-1] = noise(n+millis()/100*0.01);
    // }catch(ArithmeticException e){
    //   inputs[inputs.length-1] = 0.5;
    // }

    float output = brain.propForward(inputs)[0];
    //println(Arrays.toString(inputs)+"\n - "+output);
    if(output < 0.45){
      dir = rounded(dir.rotate(-HALF_PI));
    }else if(output > 0.55){
      dir = rounded(dir.rotate(HALF_PI));
    }
    moveSegment();
    maxDisplacement = constrain(abs(head().mag()-startPos.mag()), maxDisplacement, dist(0, 0, GRID_SIZE, GRID_SIZE));
  }

  void moveSegment(){
    Integer[] newH = new Integer[2];
    PVector nh = rounded(PVector.add(head(), dir));
    newH[0] = round(nh.x);
    newH[1] = round(nh.y);
    pos.add(newH);
  }

  float findObstacle(PVector start, PVector dir){ //Closests object, segment of snake or wall
    PVector trace = start.copy();
    boolean hit = false;
    while(trace.x == constrain(trace.x, 0, GRID_SIZE) && trace.y == constrain(trace.y, 0, GRID_SIZE) && !hit){
      trace = rounded(PVector.add(trace, dir));
      for(int i = 0; i < pos.size()-1; i++){ //All body segments excluding head
        PVector seg = segment(i);
        if(trace.equals(seg)){
          hit = true;
          break;
        }
      }
    }
    return map(abs(start.mag()-trace.mag()), 0, GRID_SIZE, 1, 0);
  }

  float findObstacle(PVector start, PVector dir, Food f){ //dist to food in each direction
    PVector trace = start.copy();
    boolean hit = false;
    while(trace.x == constrain(trace.x, 0, GRID_SIZE) && trace.y == constrain(trace.y, 0, GRID_SIZE) && !hit){
      trace = rounded(PVector.add(trace, dir));
      if(trace.equals(rounded(f.pos))){
        hit = true;
        break;
      }
    }
    return map(abs(start.mag()-trace.mag()), 0, GRID_SIZE, 0, 1);
  }

  boolean eatFood(Food f){
    return rounded(f.pos).equals(rounded(head()));
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
