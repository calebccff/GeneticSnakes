final int TICKRATE = 4; //Ticks per second

class GameThread extends Thread { //A custom thread class to easily multithread
  private Thread t;
  String name = "GameThread";
  Game game;

  GameThread(Game g) {
    game = g;
  }

  public void run() { //Takes it's own section of the game array

    while(true){
      //Run game
      game.run();
      delay(1000/TICKRATE);
    }
  }

  public void create () {
    if (t == null) {
      t = new Thread (this, name);
      t.start();
    }
  }
}