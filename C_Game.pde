class Game {
  PGraphics canvas = createGraphics(G_SIZE, G_SIZE);
  Snake snake;
  Food food;
  GameThread thread;
  int score = 0, time = 0;

  Game() {
    canvas.noSmooth();
    snake = new Snake(canvas);
    food = new Food(canvas);
    food.reset();
    
    thread = new GameThread(this);
    thread.create();
  }

  void run() {
    time++;
    snake.run();
    if (food.eaten(snake)) {
      food.reset();
      score += 20/time;
    }
  }

  void display(int x, int y, int size) {
    canvas.beginDraw();
    food.display();
    snake.display();
    
    canvas.stroke(255);
    canvas.line(0, 0, canvas.width-1, 0);
    canvas.line(canvas.width-1, 0, canvas.width-1, canvas.height-1);
    canvas.line(canvas.width-1, canvas.height-1, 0, canvas.height-1);
    canvas.line(0, canvas.height-1, 0, 0);
    
    canvas.endDraw();
    image(canvas, x, y, size, size);
  }
}