import java.util.*;

final int GRID_SIZE = 32;
final int GAME_COUNT = 500;
/*final*/ int TILEWIDTH, TILEHEIGHT;
final int GRIDWIDTH = 7; //Number of games to display on the screen
final int GRIDHEIGHT = 4;

ArrayList<Game> games = new ArrayList<Game>();

final boolean FULLSCREEN = true;
final int WIDTH = 1280, HEIGHT = 720;

int generation = 0;
int genTime = millis();
int sortTime;
int numAlive = GAME_COUNT;
float bestFitness = 0;

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
  frameRate(120);

}

void draw(){

  gameSort();
  numAlive = countAlive();
  if(numAlive == 0){
    nextGeneration();
  }


  display();
  fill(100, 100, 25);
  text(generation+" / "+countAlive()+"\n"+nfc(MUTATION_RATE, 3)+" / "+bestFitness+"\n"+TICKRATE, 10, 20);
}

void gameSort(){
  if(numAlive > 1 && millis()-sortTime > 100){
    try{
      Collections.sort(games);
      //println("Sorted - "+frameCount);
      sortTime = millis();
    }catch(IllegalArgumentException e){ //this is bad, exception shouldn't be thrown
      //println("Couldn't sort - "+frameCount);
    }
  }
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
  genTime = millis();

  for(int i = 0; i < games.size(); i++){
    if(games.get(i).alive){
      games.get(i).finish();
    }

  }
  gameSort();
  if(games.get(0).fitness() > bestFitness){
    bestFitness = games.get(0).fitness();
  }
  //delay(50); //Wait for all threads to finish
  //MUTATION_RATE = constrain(0.2-1/(games.get(0).fitness()*30), 0.003, 1);
  breed();
}

void breed(){
  ArrayList<Game> pool = new ArrayList<Game>();
  ArrayList<Game> newGen = new ArrayList<Game>();

  for(int i = 0; i < games.size(); i++){ //Add to breed pool
    for(int j = 0; j < constrain(games.get(i).fitness(), 1, 100); j++){
      pool.add(games.get(i));
    }
  }
  for(int i = 0; i < GAME_COUNT; i++){
    Game g = new Game(i, pool.get(int(random(pool.size()))), pool.get(int(random(pool.size()))));
    g.start(); //Start the run loop
    newGen.add(g);
  }
  games = new ArrayList(newGen);
}

void display(){
  background(0);
  fill(255, 0, 0);
  textSize(12);
  for(int i = 1; i < min(games.size()+1, (GRIDWIDTH*GRIDHEIGHT)); i++){
    Game g = games.get(i-1);

    int xg = i%GRIDWIDTH; //x/y in a grid based system
    int yg = int((float)i/GRIDWIDTH);
    int x = xg*TILEWIDTH;
    int y = yg*TILEHEIGHT;
    int size = min(TILEWIDTH, TILEHEIGHT);
    try{
      g.display(x, y, size);
    }catch(Exception e){
      println("Failed to draw game");
    }
    stroke(255);
    line(x, y, x+size, y);
    line(x+size, y, x+size, y+size);
    line(x+size, y+size, x, y+size);
    line(x, y+size, x, y);
    text(nfc(g.fitness(), 1)+" / "+nfc(g.score, 1)+"\n"+g.snake.pos.size(), x, y+10);
    if(!g.alive){
      text("DEAD!", x+size/2, y+size/2);
    }
  }
  textSize(16);
  //text(generation+" - "+games.size()+"\n"+frameRate, 10, 80);
}

PVector rounded(PVector p){
  return new PVector(round(p.x), round(p.y));
}

void mousePressed(){
  TICKRATE = 20;
}

void mouseReleased(){
  TICKRATE = 600;
}
