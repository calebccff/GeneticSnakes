import java.util.*;

final int GRID_SIZE = 32;
final int GAME_COUNT = 100;
/*final*/ int TILEWIDTH, TILEHEIGHT;
final int GRIDWIDTH = 8; //Number of games to display on the screen
final int GRIDHEIGHT = 5;

ArrayList<Game> games = new ArrayList<Game>();

final boolean FULLSCREEN = true;
final int WIDTH = 1280, HEIGHT = 720;

void settings(){
  if(FULLSCREEN){
    fullScreen();
  }else{
    size(WIDTH, HEIGHT);
  }
}

void setup(){


}

void draw(){


}
