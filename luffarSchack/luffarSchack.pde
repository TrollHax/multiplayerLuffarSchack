int[][] grid;
int gridSize, row, col;

void setup() {
  size(1920, 1080);

  grid = new int[48][27];
  gridSize = 40;
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
}

void draw() {
  background(0);
  noFill();
  for (int x = 0; x < width; x+=gridSize) {
    for (int y = 0; y < height; y+=gridSize) {
      stroke(125);
      rect(x, y, gridSize, gridSize);
    }
  }
  int row = 0;
  int col = 0;
  while (row < 48){
      drawXO(row, col);
      col++;
      if (col == 27){
          col = 0;
          row++;
      }
  }
}

void drawXO(int row, int col){
    pushMatrix();
    translate(row*40, col*40);
    if (grid[row][col] == 1) {
        fill(255);
        ellipse(20, 20, gridSize/2, gridSize/2);
    } else if (grid[row][col] == 2) {
        stroke(255);
        line(5, 5, 35, 35);
        line(5, 35, 35, 5);
    }
    popMatrix();
}

void mouseReleased() {
  //assign the clicked-on box with the current player's mark
  int row = mouseX/40;
  int col = mouseY/40;
  if (grid[row][col] == 0)
    grid[row][col] = 1;
}