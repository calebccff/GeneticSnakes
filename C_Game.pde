int TICKRATE = 300;

class Game extends Thread implements Comparable<Game>{
  // Threading stuff
  private Thread t;
  String id;

  //Parts of the game
  Snake snake;
  Food food;

  // Scoring stuff
  float score, timeAlive, timeSinceEat;
  float fitnessBonus = 0;
  boolean alive = true;

  //Rendering stuff
  PGraphics canvas = createGraphics(GRID_SIZE, GRID_SIZE);

  Game(int id){ //New random game
    this.id = str(id);
    //canvas.noSmooth();
    food = new Food();
    snake = new Snake();
  }

  Game(int id, Game a, Game b){ //new game with parent
    this(id);
    snake = new Snake(a.snake, b.snake);
  }

  void display(int x, int y, int size){
    canvas.beginDraw();
    canvas.background(0);
    snake.display(canvas);
    food.display(canvas);
    canvas.endDraw();
    image(canvas, x, y, size, size);
  }

  void runLoop(){
    snake.run(food, int(id)*1000);
    alive = !checkDead();
    if(!alive){
      return;
    }
    if(snake.eatFood(food)){
      score += 1;
      timeSinceEat = 0;
      food.reset(snake);

    }else{
      snake.pos.remove(0);
    }
    timeSinceEat++;
    timeAlive++;
  }

  float fitness(){
    return
    sq(score+1)
    +constrain(timeAlive/40, 0, 20)
    +map(snake.maxDisplacement, 0, dist(0, 0, GRID_SIZE, GRID_SIZE), 0, 10)
    +fitnessBonus

    ;
  }

  void finish(){
    fitnessBonus = fitness()*0.2;
    alive = false;
  }

  @Override
  public int compareTo(Game g){
    float f = fitness();
    float fo = g.fitness();

    if(alive && !g.alive){
      return -1;
    }else if(!alive && g.alive){
      return 1;
    }else if(!alive && !g.alive){
      return 0;
    }
    if(snake.pos.size() > g.snake.pos.size()){
      return -1;
    }
    return round(fo-f); //Descending by fitness
  }

  boolean checkDead(){ //TODO
    PVector head = snake.head();
    for(int i = 0; i < snake.pos.size()-1; i++){ //Check if snake eats itself
      PVector seg = snake.segment(i);
      if(dist(head.x, head.y, seg.x, seg.y) < 0.5){ //Both in same square, should use == 0 but don't trust myself
        return true;
      }
    }
    if(head.x < 0 || head.x > GRID_SIZE-1 || head.y < 0 || head.y > GRID_SIZE-1){ //Snake hits the edge
      return true;
    }
    if(timeSinceEat > 1200){ //Alive for more than 500 ticks without eating
      finish();
      return true;
    }
    return false;
  }

  public void run(){ //Overrides super.run(), is called by the thread;
    while(alive){
      int startTime = millis();
      try{
        runLoop();
        delay(constrain(1000/TICKRATE-(millis()-startTime), 0, 1000));
      }catch(ThreadDeath e){
        println("Something happened");
        alive = !checkDead();
      }
    }
  }

  public void create(){ //Overrides super.create(), makes everything GO
    if(t == null){
      t = new Thread(this, id);
      t.start();
    }
  }
}
