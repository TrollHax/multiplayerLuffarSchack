import processing.net.*; //Enables networking
import java.net.InetAddress; //Provides function for getting server IP-adress

//Variables
int[][] grid;
int gridSize, row, col;
float hold;
boolean gameOn;
String state;
PImage bg;

void setup() {
  fullScreen();
  bg = loadImage("Images/gradientV2.png");
  grid = new int[48][27]; //Create and assign a 2D array corresponding to the amount of rows and columns in the grid
  gridSize = 40; //Assign the size of each clickable box of the grid (Has to be a multiple of 4. EX: 20 or 40)

  state = "MENU";
}

void draw() {
  switch (state) {
  case "MENU" :
    drawMenu();

    break;	

  case "SERVER" :

    break;

  case "CLIENT" :

    break;

  case "DEBUG" :
    drawGrid();

    if (millis() - hold > 500) { //Waits for 0.5 seconds before enabling placement of X's and O's
      gameOn = true;
    }

    int row = 0; 
    int col = 0;

    //Look through the grid and draw X's and O's
    while (row < 48) {
      if (keyPressed && key == ' ') {
        grid[row][col] = 0;
      }
      drawXO(row, col);
      col++;
      if (col == 27) {
        col = 0;
        row++;
      }
    }
    println(winCheck());

    break;
  }
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

//Function for drawing the grid
void drawGrid() {
  strokeWeight(3);
  rectMode(CORNER);
  image(bg, 0, 0);
  noFill();
  for (int x = 0; x < width; x+=gridSize) {
    for (int y = 0; y < height; y+=gridSize) {
      stroke(125);
      rect(x, y, gridSize, gridSize);
    }
  }
}

//Function for drawing the X's and O's
void drawXO(int row, int col) {
  pushMatrix();
  translate(row*40, col*40); //Change origo of the grid to the bottom-right corner of the box

  if (grid[row][col] == 1) { //Draw a circle if value is assigned to 1
    fill(255);
    noStroke();
    ellipse(20, 20, gridSize/2, gridSize/2);
  } else if (grid[row][col] == 2) { //Draw an 'X' if value is assigned to 2
    stroke(255);
    line(5, 5, 35, 35);
    line(5, 35, 35, 5);
  }
  popMatrix();
}

//Function for finding a winner
boolean winCheck() {

  for (int x = 0; x < 48; x++) {
    for (int y = 0; y < 23; y++) {
      if (grid[x][y] == grid[x][y+1] &&
        grid[x][y] == grid[x][y+2] &&
        grid[x][y] == grid[x][y+3] &&
        grid[x][y] == grid[x][y+4] &&
        grid[x][y] != 0) { //Check vertical win
        return true;
      }
    }
  }
  for (int x = 0; x < 44; x++) {
    for (int y = 0; y < 27; y++) {
      if (grid[x][y] == grid[x+1][y] &&
        grid[x][y] == grid[x+2][y] &&
        grid[x][y] == grid[x+3][y] &&
        grid[x][y] == grid[x+4][y] &&
        grid[x][y] != 0) { //Check horizontal win
        return true;
      }
    }
  }
  for (int x = 0; x < 44; x++) {
    for (int y = 0; y < 23; y++) {
      if (grid[x][y] == grid[x+1][y+1] &&
        grid[x][y] == grid[x+2][y+2] &&
        grid[x][y] == grid[x+3][y+3] &&
        grid[x][y] == grid[x+4][y+4] &&
        grid[x][y] != 0) { //Check diagonal-topLeft-bottomRight win
        return true;
      }
    }
  }
  for (int x = 47; x > 3; x--) {
    for (int y = 0; y < 23; y++) {
      if (grid[x][y] == grid[x-1][y+1] &&
        grid[x][y] == grid[x-2][y+2] &&
        grid[x][y] == grid[x-3][y+3] &&
        grid[x][y] == grid[x-4][y+4] &&
        grid[x][y] != 0) { //Check diagonal-topRight-bottomLeft win
        return true;
      }
    }
  }
  return false;
}

//Function for getting ip of host computer
String getIP() {
  InetAddress inet;
  String myIP;

  try {
    inet = InetAddress.getLocalHost();
    myIP = inet.getHostAddress();
  }
  catch (Exception e) {
    e.printStackTrace();
    myIP = "couldnt get IP";
  }
  return(myIP);
}

void mouseReleased() {
  if (state == "MENU") {
    if (mouseX <= (width/2-400)+200 &&
      mouseX >= (width/2-400)-200 &&
      mouseY <= (height/2)+100 &&
      mouseY >= (height/2)-100) {
      state = "DEBUG";
      hold = millis(); //To avoid accidental placement of X or O
    }
  }

  if (state == "DEBUG") {
    if (gameOn) {
      //assign the clicked-on box with the current player's mark
      int row = mouseX/40;
      int col = mouseY/40;
      if (grid[row][col] == 0) { //Checks if selected box is empty
        if (mouseButton == LEFT) {
          grid[row][col] = 1;
        } else if (mouseButton == RIGHT) {
          grid[row][col] = 2;
        }
      }
    }
  }
}
