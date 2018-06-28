final int G_SIZE = 16;
final int GAMESIZE = 100;
int TILEWIDTH, TILEHEIGHT;
ArrayList<Game> games = new ArrayList<Game>();

void setup(){
  fullScreen();
  for(int i = 0; i < GAMESIZE; i++){
    games.add(new Game());
  }
  noSmooth();
  
  TILEWIDTH = int(width/3);
  TILEHEIGHT = int(height/3);
  println(TILEWIDTH);
}

void draw(){
  background(0);
  for(int i = 0; i < 9; i++){
    int x = (i*TILEWIDTH)%width;
    int y = int((i*TILEWIDTH)/width)*TILEHEIGHT;
    games.get(i).display(x, y, min(TILEWIDTH, TILEHEIGHT));
  }
}