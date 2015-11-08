
int window_height = 600;
int window_width  = 1200;
int ballRadius = 15;
int score = 0;
int game_status;
int pillarSpace = 150;
int n_pillars = window_width/pillarSpace;
Circle player = new Circle();
Pillar[] pillar = new Pillar[n_pillars];

void settings(){
  //fullScreen();
  size(window_width,window_height);
}
void setup() {
  for (int i =0; i < n_pillars; i++) {
    pillar[i] = new Pillar(i);
  }
  game_status = 0;
}

void draw() {
  background(#2980b9);
  switch(game_status) {
  case 0:
    initialScreen();
    break; 
  case 1:
    gameRun();
    break;
  case 2:
    gameOver();
    break;
  }
}

void initialScreen() {
  textSize(60);
  text("Flappy Ball", width/3, height/2-100);
  textSize(30);
  text("Press <SPACE> to play!", width/3, height/2+100);
  
}

void gameOver() {
  textSize(32);
  fill(#ecf0f1);
  text("Game Over", (window_width/2)-80, (window_height/2)-70);
  textSize(16);
  text("Score", (window_width/2)-15, (window_height/2)-25);
  ellipse((window_width/2)+8, (window_height/2)+30,50, 50);
  fill(#2c3e50);
  textSize(20);
  if(score < 10){
    text(score, (window_width/2)+2, (window_height/2)+38);
  } else {
    text(score, (window_width/2)-4, (window_height/2)+38);
  }
}

void gameRun() {
  player.move();
  player.render();
  player.collisionListener();
  for (int i = 0; i < n_pillars; i++) {
    pillar[i].checkLimits();
    pillar[i].render(); 
    pillar[i].setPoints();
  }
  renderScore();
}

void renderScore() {
  strokeWeight(2);
  stroke(#ecf0f1);
  fill(#2c3e50);
  ellipse(70, 70, 80, 80);
  stroke(#2c3e50);
  fill(#ecf0f1);
  ellipse(40, 35, 60, 60);
  textSize(18);
  fill(#2c3e50);
  text("Score", 17, 40);
  fill(#ecf0f1);
  textSize(24);
  text(score, 65, 85);
}

void again(){
  score = 0;
  player.yCoord = (window_height/2);
  player.yTemp = 0;
  for(int i = 0; i < n_pillars; i++){
      pillar[i] = new Pillar(i);
  }
  game_status--;
}

class Circle {
  float xCoord, yCoord, yTemp;

  Circle() {
    xCoord = window_width/4;
    yCoord = window_height/2;
  } 

  void render() {
    gravity();
    stroke(#2c3e50);
    fill(#ecf0f1);
    strokeWeight(3);
    ellipse(xCoord, yCoord, ballRadius*2, ballRadius*2);
  }

  void jump() {
    yTemp = -10;
  }

  void gravity() {
    yTemp += 0.45;
  }

  void move() {
    yCoord += yTemp;
    for (int i = 0; i < n_pillars; i++) {
      pillar[i].xCoord -= 3.25;
    }
  }

  void collisionListener() {
    if (yCoord > window_height||yCoord < 0) {
      game_status++;
    }
    for(int i = 0; i < n_pillars; i++){
      if((xCoord < pillar[i].xCoord+ballRadius && xCoord > pillar[i].xCoord-ballRadius) && (yCoord < pillar[i].fissureTop+ballRadius || yCoord > pillar[i].fissureBottom-ballRadius)){
        game_status++;
      } 
    }
  }
}

class Pillar {
  float xCoord, fissureTop,fissureBottom,fissureMiddle;         
  boolean validate = false;
  Pillar(int i) {
    xCoord = 600+(i*pillarSpace);
    generateFissure(window_height/2);
  }

  void render() {
    line(xCoord, 0, xCoord, fissureTop);
    line(xCoord, fissureBottom, xCoord, window_height);
  }

  void checkLimits() {
    if (xCoord < 0) {
      xCoord += pillarSpace*n_pillars;
      generateFissure(window_height/2); 
      validate = !validate;
    }
  }

  void setPoints() {
    if (xCoord < window_width/4 && !validate) {
      score++; 
      validate = !validate;
    }
  }

  void generateFissure(int i) {
    fissureMiddle = random(i)+100;
    fissureTop = fissureMiddle - 80;
    fissureBottom = fissureMiddle + 80;
  }
}

void keyPressed() {
  if (game_status == 0) {
    game_status++;
  } else if(game_status == 2) {
    again();
  } else {
    player.jump();
  }
}
void mousePressed(){
  if (game_status == 0) {
    game_status++;
  } else if(game_status == 2) {
    again();
  } else {
    player.jump();
  }
}