import processing.video.*;
Capture mov;

int mov_w = 320*16/9;
int mov_h = 320*2;
int fps;
color[][] centerColors;
float movieLength_sec;
int num_frames;
int tempFrameIndex;

int scanLineX;
void setup() {
  fps = 24;
  frameRate(fps);

  String[] cameras = Capture.list();
  mov = new Capture(this, cameras[0]);
  mov.start();

  num_frames = 1000;
  centerColors = new color[num_frames][mov_h];
  tempFrameIndex = 0;
  
  size(mov_w+num_frames+60, 320);
  background(255);
}

void draw() {
  updateScanLine();
  println("frameRate", frameRate);
  if (mov.available() == true) {
    mov.read();
  }

  pushMatrix();
  translate(mov_w,0);
  scale(-1, 1);
  image(mov, 0, 0, mov_w, mov_h);
  popMatrix();
  strokeWeight(1);
  stroke(#ff0000);
  line(scanLineX, 0, scanLineX, height);
  
  mov.loadPixels();
  
  getCenterPixels();
  drawLines(mov_w+50);

  tempFrameIndex++;
  tempFrameIndex %= num_frames;
}

void getCenterPixels() {
  if (tempFrameIndex >= num_frames)return;
  for (int i = 0; i < mov_h; i++) {
    if(mov.width == 0)continue;
    centerColors[tempFrameIndex][i] = mov.get(mov.width-(int)map(scanLineX, 0, mov_w, 0, mov.width), i*mov.height/mov_h);
  }
}

void drawLines(int leftX) {
  if (tempFrameIndex >= num_frames)return;
  for (int i = 0; i < mov_h; i++) {
    fill(centerColors[tempFrameIndex][i]);
    noStroke();
    rect(tempFrameIndex+leftX, i, 1, 1);
  }
}

void updateScanLine(){
  if(mouseX <= mov_w)scanLineX = mouseX;
  else if(mov_w < mouseX)scanLineX = mov_w;
  else mov_w = 0;
}
