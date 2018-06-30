final int TICKRATE = 60; //Ticks per second

class GameThread extends Thread { //A custom thread class to easily multithread
  private Thread t;
  String name = "GameThread";
  Game game;

  GameThread(Game g) {
    game = g;
  }

  public void run() { //Takes it's own section of the game array
    while(true){
      int startTime = millis();
      //Run game
      boolean run = game.run();
      if(!run){
        break;
      }
      delay(constrain(1000/TICKRATE-(millis()-startTime), 0, 1000));
    }
  }

  public void create () {
    if (t == null) {
      t = new Thread (this, name);
      t.start();
    }
  }
}
