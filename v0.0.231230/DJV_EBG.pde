void setup () {
  size(480, 360);
  background(127);
  noStroke();
} 

void draw () {
  for (int y = 0; y < 480; y+=2) {
    for (int x = 0; x < 360; x+=2) {
      fill(255, x%255, y%255);
      rect(x, y, 2, 2);
    }
  }
}
