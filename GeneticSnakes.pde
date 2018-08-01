import java.util.*;

final int GRID_SIZE = 32;
final int GAME_COUNT = 100;
/*final*/ int TILEWIDTH, TILEHEIGHT;
final int GRIDWIDTH = 8; //Number of games to display on the screen
final int GRIDHEIGHT = 5;

ArrayList<Game> games = new ArrayList<Game>();

final boolean FULLSCREEN = true;
final int WIDTH = 1280, HEIGHT = 720;

int generation = 0;

void settings(){
  if(FULLSCREEN){
    fullScreen();
  }else{
    size(WIDTH, HEIGHT);
  }
  noSmooth();
}

void setup(){
  for(int i = 0; i < GAME_COUNT; i++){
    Game g = new Game(i);
    g.create();
    games.add(g);
  }

  TILEWIDTH = round(width/GRIDWIDTH);
  TILEHEIGHT = round(height/GRIDHEIGHT);

}

void draw(){
  if(countAlive() < GAME_COUNT*0.1){
    nextGeneration();
  }

  display();
  fill(100, 100, 25);
  text(generation, 10, 20);
}

int countAlive(){
  int count = 0;
  for(int i = 0; i < games.size(); i++){
    count += games.get(i).alive?1:0;
  }
  return count;
}

void nextGeneration(){
  ++generation;
  for(int i = 0; i < games.size(); i++){
    games.get(i).stop();
  }
  breed();
}

void breed(){
  ArrayList<Game> pool = new ArrayList<Game>();
  ArrayList<Game> newGen = new ArrayList<Game>();

  for(int i = 0; i < games.size(); i++){ //Add to breed pool
    for(int j = 0; j < games.get(i).fitness()*10; j++){
      pool.add(games.get(i));
    }
  }
  for(int i = 0; i < GAME_COUNT; i++){
    Game g = new Game(i, pool.get(int(random(pool.size()))));
    g.start(); //Start the run loop
    newGen.add(g);
  }

  games = new ArrayList(newGen);
}

void display(){
  background(0);
  fill(255, 0, 0);
  textSize(12);
  for(int i = 0; i < min(games.size(), (GRIDWIDTH*GRIDHEIGHT)-1); i++){
    Game g = games.get(i);
    if(!g.alive) continue;
    int x = (i*TILEWIDTH)%width;
    int y = int((i*TILEWIDTH)/width)*TILEHEIGHT;
    int size = min(TILEWIDTH, TILEHEIGHT);
    g.display(x, y, size);
    stroke(255);
    line(x, y, x+size, y);
    line(x+size, y, x+size, y+size);
    line(x+size, y+size, x, y+size);
    line(x, y+size, x, y);
    text(g.fitness()+"\n"+g.snake.pos.size()+"\n"+g.snake.dir, x, y+10);
  }
  textSize(16);
  //text(generation+" - "+games.size()+"\n"+frameRate, 10, 80);
}

PVector rounded(PVector p){
  return new PVector(round(p.x), round(p.y));
}
