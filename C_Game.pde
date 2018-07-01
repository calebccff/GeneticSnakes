final int TICKRATE = 60;

class Game extends Thread{
  // Threading stuff
  Private Thread t;
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
    id = str(id);
    canvas.noSmooth();
    food = new Food();
    snake = new Snake();
  }

  Game(int id, Game p){ //new game with parent
    this(id);
    snake = new Snake(p.snake);
  }

  void runLoop(){
    
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
