class Game{
  PGraphics canvas = createGraphics(G_SIZE, G_SIZE);
  Snake snake;
  Food food;
  GameThread thread;
  float score = 0;
  int time = 0;
  int timeAlive = 0;
  boolean alive = true;

  Game() {
    canvas.noSmooth();
    snake = new Snake(canvas);
    food = new Food(canvas);
    food.reset(snake);

    thread = new GameThread(this);
    thread.create();
  }

  Game(Game p){
    canvas.noSmooth();
    snake = new Snake(canvas, p.snake);
    food = new Food(canvas);
    food.reset(snake);

    thread = new GameThread(this);
    thread.create();
  }

  boolean run() {
    time++;
    timeAlive++;
    boolean eaten = snake.run(food);
    if (eaten) {
      food.reset(snake);
      score += 20f/float(time);
      time = 0;
    }
    if(!alive || (snake.checkDead() && timeAlive > 5) || time > 8000){
      alive = false;
      return false;
    }
    return true;
  }

  float fitness(){
    return
    score*5
    +timeAlive*0.003
    +snake.pos.size()*2;

  }

  void stop(){
    alive = false;
  }

  void display(int x, int y, int size) {
    canvas.beginDraw();
    canvas.background(0);
    try{
      food.display();
      snake.display();
    }catch(Exception e){ //Can crash cuz threading :/ I'm not gonna synchronize this....
      e.printStackTrace();
    }

    // canvas.stroke(255);
    // canvas.line(0, 0, canvas.width-1, 0);
    // canvas.line(canvas.width-1, 0, canvas.width-1, canvas.height-1);
    // canvas.line(canvas.width-1, canvas.height-1, 0, canvas.height-1);
    // canvas.line(0, canvas.height-1, 0, 0);

    canvas.endDraw();
    image(canvas, x, y, size, size);
  }
}
