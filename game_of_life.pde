// A simple implementation of Conway's Game of Life 
// ************************************************
// Key bindings:
// "r" - runs the "simulation", the speed is determined by the "genTriggerTime" variable, pressing "r" again will stop it
// "c" - clears the whole screen
// "g" - if the simulation is stopped, then the next generation will be evaluated (step-bystep)
// "h" - show indicators for next cell states
// "0" ... "9" - increase or decrease grid size
//
// When the simulation is not running, you can draw new cells with the left mouse button and delete cells with the right mouse button.



boolean[][] grid;

int cols;
int rows;
int margin = 10;
float cellWidth;
float cellHeight;

int currentGen = 0;
int prevMillis = 0;
int genCounter = 0;
int genTriggerTime = 30;
boolean isRunning = false;
boolean showHelp = false;

void setup() 
{
  size(800, 800);
  init(50);
}

void init(int size)
{
  cols = size;
  rows = size;
  
  currentGen = 0;
  cellWidth = (width - margin - margin) / (float)cols;
  cellHeight = (height - margin - margin) / (float)cols;
  
  grid = new boolean[cols][rows];
  for (int y = 0; y < rows; ++y)
  for (int x = 0; x < cols; ++x)
  {
    grid[x][y] = int(random(0, 2)) > 0 ? false : true;
  } 
  println("Creating Grid with size: " + size);
  println("Generation: " + currentGen);
  prevMillis = millis();
}

void keyPressed()
{
  if (key == 'r')
    isRunning = !isRunning;
  else if (key == 'c')
  {      
    for (int y = 0; y < rows; ++y)
    for (int x = 0; x < cols; ++x)
    {
      grid[x][y] = false;
    }
  }
  else if (key == 'g' && !isRunning)
    nextGen();
  else if (key == 'h')
    showHelp = !showHelp;
  else if (!isRunning && key == '0')
    init(100);
  else if (!isRunning && (key == '1' || key == '2' || key == '3' || key == '4' || key == '5' || key == '6' || key == '7' || key == '8' || key == '9'))
    init((key - '0') * 10);
}

void draw() {
  background(45, 45, 48);
  
  if (isRunning)
  {
    genCounter += millis() - prevMillis;
    prevMillis = millis();
    if (genCounter > genTriggerTime)
    {
      genCounter -= genTriggerTime;
      nextGen();
    }
  }
  else if (mousePressed)
  {
     switchStateByMouseClick(mouseX, mouseY);
  }
  
  
  for (int y = 0; y < rows; ++y)
  for (int x = 0; x < cols; ++x)
  {
    if (grid[x][y])    
      fill(241);
    else
      fill(30);
    stroke(45, 45, 48);
    rect(x * cellWidth + margin, y * cellHeight + margin, cellWidth, cellHeight);
    
    
    if (showHelp)
    {
      boolean nextState = nextStateForCell(x, y);
      if (nextState == grid[x][y])
        continue;
      if (nextState)
        fill(255, 255, 255, 200);
      else        
        fill(0, 0, 0, 200);
      stroke(0, 0, 0, 0);
      rect(x * cellWidth + margin + (cellWidth * 0.25), y * cellHeight + margin + (cellHeight * 0.25), cellWidth * 0.5, cellHeight * 0.5);      
    }
  }
  
}


void nextGen()
{
  ++currentGen;
  println("Generation: " + currentGen); 
  boolean[][] next = new boolean[cols][rows];
  for (int y = 0; y < rows; ++y)
  for (int x = 0; x < cols; ++x)
  {
    next[x][y] = nextStateForCell(x, y);
  }
  grid = next;
}

int getNeighbourCount(int posX, int posY)
{
  int sum = 0;
  for (int y = -1; y < 2; ++y)
  for (int x = -1; x < 2; ++x)
  {
    int col = (posX + x + cols) % cols;
    int row = (posY + y + rows) % rows;
    sum += grid[col][row] ? 1 : 0;
  }
  sum -= grid[posX][posY] ? 1 : 0;
  return sum;
}

void switchStateByMouseClick(int mX, int mY)
{
  int x = floor((mX - margin) / cellWidth);
  int y = floor((mY - margin) / cellHeight);
  if (x < 0 || x >= cols || y < 0 || y >= rows)
    return;
  grid[x][y] =  (mouseButton == LEFT);
}

boolean nextStateForCell(int x, int y)
{  
  int nbCount = getNeighbourCount(x, y);
  boolean iAmAlive = grid[x][y];
  if (!iAmAlive && nbCount == 3)
    return true; 
  else if (iAmAlive && (nbCount < 2 || nbCount > 3))
    return false; 
  return iAmAlive;
}
