import processing.net.*; //Enables networking
import java.net.InetAddress; //Provides function for getting server IP-adress

//Variables
String state;
PImage bg;
Menu gameMenu;
Game thisGame;
Networking network;


void setup() {
  fullScreen();
  bg = loadImage("Data/Images/gradientV2.png");
  gameMenu = new Menu();
  thisGame = new Game();
  network = new Networking();

  state = "MENU";
}

void draw() {
  switch (state) {
  case "MENU" :
    gameMenu.drawMenu();
    break;	

  case "SERVER" :
    gameMenu.drawHostMenu();
    break;

  case "CLIENT" :
    gameMenu.drawClientMenu();
    break;

  case "DEBUG" :
    thisGame.run();
    break;
  }
}

void keyPressed() {
  if (state == "CLIENT") {
    String valid = "1234567890."; //A list of valid characters

    if (valid.contains(""+key)) {
      gameMenu.hostAdress = gameMenu.hostAdress + key;
    } else if (key == BACKSPACE && gameMenu.hostAdress.length() > 0) { //Removes characters if backspace is pressed
      gameMenu.hostAdress = gameMenu.hostAdress.substring(0, gameMenu.hostAdress.length()-1);
    } else if (key == ENTER) {
      network.createClient(gameMenu.hostAdress);
      thisGame.gameState = "CLIENT";
      thisGame.gameClient.write(1);
      state = "DEBUG";
    }
  }
}

void mouseReleased() {
  if (state == "MENU") {
    if (mouseX <= (width/2-400)+200 &&
      mouseX >= (width/2-400)-200 &&
      mouseY <= (height/2)+100 &&
      mouseY >= (height/2)-100) {
      network.createHost();
      state = "SERVER";
      thisGame.gameState = "HOST";
      //hold = millis(); //To avoid accidental placement of X or O
    }
    if (mouseX <= (width/2+400)+200 &&
      mouseX >= (width/2+400)-200 &&
      mouseY <= (height/2)+100 &&
      mouseY >= (height/2)-100) {
      state = "CLIENT";
      //hold = millis(); //To avoid accidental placement of X or O
    }
  }

  if (state == "DEBUG") {
    //assign the clicked-on box with the current player's mark
    int row = mouseX/40;
    int col = mouseY/40;
    if (thisGame.grid[row][col] == 0) { //Checks if selected box is empty
      if (mouseButton == LEFT && thisGame.gameState == "HOST") {
        thisGame.grid[row][col] = 1;
        network.thisPc.write(row + "," + col);
      } else if (mouseButton == LEFT && thisGame.gameState == "CLIENT") {
        thisGame.grid[row][col] = 2;
        network.clientPc.write(row + "," + col);
      }
    }
  }
}
