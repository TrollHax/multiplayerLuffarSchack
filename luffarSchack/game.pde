/**
 * The game class contains functions
 * for all actions and events in the game
 *
 * @author  Reymond T
 * @version 1.0
 * @since   2022-04-10
 */

class Game {

  int[][] grid;
  int gridSize;
  String gameState;
  Server gameServer;
  Client gameClient;


  Game() {
    grid = new int[48][27]; //Create and assign a 2D array corresponding to the amount of rows and columns in the grid
    gridSize = 40; //Assign the size of each clickable box of the grid (Has to be a multiple of 4. EX: 20 or 40)
  }

  void run() {
    render();
    update();
  }

  void render() {
    drawGrid();
  }

  void update() {
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

    if (gameState == "HOST") {
      stroke(255, 0, 0);
      pushMatrix();
      translate(mouseX, mouseY);
      ellipseMode(CENTER);
      noStroke();
      ellipse(0, 0, (gridSize/2)+10, (gridSize/2)+10);
      popMatrix();
      Client thisPc = gameServer.available();
      if (thisPc != null) {
        String incoming = thisPc.readString();
        int r = 0;
        int c = 0;
        boolean read = false;
        if (incoming.length() == 3) {
          r = int(incoming.substring(0, 1));
          c = int(incoming.substring(2, 3));
          read = true;
        }
        if (incoming.length() == 4) {
          if (incoming.indexOf(',') == 1) {
            r = int(incoming.substring(0, 1));
            c = int(incoming.substring(2));
            read = true;
          } else if (incoming.indexOf(',') == 2) {
            r = int(incoming.substring(0, 2));
            c = int(incoming.substring(4));
            read = true;
          }
        }
        if (incoming.length() == 5) {
          r = int(incoming.substring(0, 2));
          c = int(incoming.substring(3));
          read = true;
        }
        if (read) {
          grid[r][c] = 2;
          println(grid[r][c]);
          read = false;
        }
      }
    }

    if (gameState == "CLIENT") {
      stroke(0, 0, 255);
      pushMatrix();
      translate(mouseX, mouseY);
      line(-15, -15, 15, 15);
      line(-15, 15, 15, -15);
      popMatrix();
      if (gameClient.available() > 0) { 
        String incoming = gameClient.readString();
        int r = 0;
        int c = 0;
        if (incoming.length() == 3) {
          r = int(incoming.substring(0, 1));
          c = int(incoming.substring(2, 3));
        }
        if (incoming.length() == 4) {
          if (incoming.indexOf(',') == 1) {
            r = int(incoming.substring(0, 1));
            c = int(incoming.substring(2));
          } else if (incoming.indexOf(',') == 2) {
            r = int(incoming.substring(0, 2));
            c = int(incoming.substring(4));
          }
        }
        if (incoming.length() == 5) {
          r = int(incoming.substring(0, 2));
          c = int(incoming.substring(3));
        }
        grid[r][c] = 1;
        println(grid[r][c]);
      }
    }

    println(winCheck());
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
      fill(255, 0, 0);
      noStroke();
      ellipse(20, 20, (gridSize/2)+10, (gridSize/2)+10);
    } else if (grid[row][col] == 2) { //Draw an 'X' if value is assigned to 2
      stroke(0, 0, 255);
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
}
