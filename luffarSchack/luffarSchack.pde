import processing.net.*; //Enables networking
import java.net.InetAddress; //Provides function for getting server IP-adress

//Variables
String state, winner;
PImage bg;
Menu gameMenu;
Game thisGame;
Networking network;
boolean initializedHost, initializedClient;


void setup() {
  size(1280, 720);
  bg = loadImage("Data/Images/gradientV2.png");
  gameMenu = new Menu();
  thisGame = new Game();
  initializedHost = false;
  initializedClient = false;

  state = "MENU";
}

void draw() {
  switch (state) {
  case "MENU" :
    gameMenu.drawMenu();
    break;	

  case "SERVER" :
    if (!initializedHost) {
      network = new Networking("Host");
      initializedHost = true;
    }
    gameMenu.drawHostMenu();
    break;

  case "CLIENT" :
    if (!initializedClient) {
      network = new Networking("Client");
      initializedClient = true;
    }
    gameMenu.drawClientMenu();
    break;

  case "GAME" :
    thisGame.run();
    break;

  case "WINNER" :
  gameMenu.drawWinnerScreen();
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
      network.sendData("START");
      state = "GAME";
    }
  }
}

void mouseReleased() {
  if (state == "MENU") {
    if (mouseX <= (width/2-400)+200 &&
      mouseX >= (width/2-400)-200 &&
      mouseY <= (height/2)+100 &&
      mouseY >= (height/2)-100) {
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

  if (state == "GAME") {
    //assign the clicked-on box with the current player's mark
    int row = mouseX/40;
    int col = mouseY/40;
    if (thisGame.grid[row][col] == 0) { //Checks if selected box is empty
      if (mouseButton == LEFT && thisGame.gameState == "HOST" && thisGame.hostTurn) {
        thisGame.grid[row][col] = 1;
        thisGame.hostTurn = false;
        thisGame.sentData = false;
        network.sendData(row + "," + col);
      } else if (mouseButton == LEFT && thisGame.gameState == "CLIENT" && thisGame.clientTurn) {
        thisGame.grid[row][col] = 2;
        thisGame.clientTurn = false;
        thisGame.sentData = false;
        network.sendData(row + "," + col);
      }
    }
  }
}
