final int TICKRATE = 60;

class Game extends Thread{
  // Threading stuff
  private Thread t;
  String id;

  //Parts of the game
  Snake snake;
  Food food;

  // Scoring stuff
  float score, timeAlive, timeSinceEat;
  boolean alive = true;

  //Rendering stuff
  PGraphics canvas = createGraphics(GRID_SIZE, GRID_SIZE);

  Game(int id){ //New random game
    this.id = str(id);
    canvas.noSmooth();
    food = new Food();
    snake = new Snake();
  }

  Game(int id, Game p){ //new game with parent
    this(id);
    snake = new Snake(p.snake);
  }

  void display(int x, int y, int size){
    canvas.beginDraw();
    snake.display(canvas);
    food.display(canvas);
    canvas.endDraw();
    image(canvas, x, y, size, size);
  }

  void runLoop(){
    snake.run(food);
    alive = !checkDead();
    if(!alive){
      t.stop();
      return;
    }
    if(snake.eatFood(food)){
      score += 20f/timeSinceEat;
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
    score*5
    +timeAlive*0.003
    +snake.pos.size()*2;

  }

  boolean checkDead(){
    return false;
  }

  public void run(){ //Overrides super.run(), is called by the thread;
    while(true){
      int startTime = millis();
      runLoop();
      delay(constrain(1000/TICKRATE-(millis()-startTime), 0, 1000));
    }
  }

  public void create(){ //Overrides super.create(), makes everything GO
    if(t == null){
      t = new Thread(this, id);
      t.start();
    }
  }
}
