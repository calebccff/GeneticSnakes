import java.util.*;

final int G_SIZE = 32;
final int GAMESIZE = 100;
int TILEWIDTH, TILEHEIGHT;
int GRIDWIDTH = 8;
int GRIDHEIGHT = 5;
ArrayList<Game> games = new ArrayList<Game>();

int generation = 0;

void setup(){
  size(1280, 720);//fullScreen();
  for(int i = 0; i < GAMESIZE; i++){
    games.add(new Game());
  }
  noSmooth();

  TILEWIDTH = int(width/GRIDWIDTH);
  TILEHEIGHT = int(height/GRIDHEIGHT);
}

void draw(){
  if(countAlive() < GAMESIZE*0.1){
    nextGeneration();
  }


  display();
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
  for(int i = 0; i < GAMESIZE; i++){
    newGen.add(new Game(pool.get(int(random(pool.size())))));
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
