/**
 * The menus class contains functions
 * for all of the menus used by the game
 *
 * @author  Reymond T
 * @version 1.3
 * @since   2022-04-10
 */

class Menu {

  String hostAdress;

  Menu() {
    hostAdress = "";
  }

  //Function for drawing main menu
  void drawMenu() {
    image(bg, 0, 0);
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    textSize(100);
    fill(255);
    text("Networked Luffarschack", width/2, 50);
    textSize(75);
    text("Select mode", width/2, 300);
    fill(125);
    strokeWeight(5);
    stroke(255);
    rect((width/2)-400, height/2, 400, 200);
    rect((width/2)+400, height/2, 400, 200);
    fill(255);
    text("HOST", (width/2)-400, height/2);
    text("CLIENT", (width/2)+400, height/2);
  }

  //Function for drawing host menu
  void drawHostMenu() {
    image(bg, 0, 0);
    textSize(100);
    fill(255);
    text("Waiting for player...", width/2, height/2);
    textSize(50);
    text("IP-Adress (Give to other player):" + network.getIP(), width/2, 1040);
    if (network.readData().equals("START") == true) {
      thisGame.hostTurn = true;
      state = "GAME";
    }
  }

  //Function for drawing client menu
  void drawClientMenu() {
    image(bg, 0, 0);
    textSize(100);
    fill(255);
    text("Type host IP-Adress", width/2, 50);
    fill(125);
    strokeWeight(5);
    stroke(255);
    rect(width/2, height/2, 1200, 200);
    fill(255);
    text(hostAdress, width/2, height/2);
  }

  //Function for drawing the win screen
  void drawWinnerScreen() {
    image(bg, 0, 0);
    textSize(200);
    fill(255);
    text(winner, width/2, height/2);
  }
}
