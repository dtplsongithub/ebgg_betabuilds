/*
DJV_EBG
*/

ChildApplet editor;

// variables
long t = 0;
int bgno = 0;
float Cx, Cy;
int paloffset = 0;
double Mytemp;
double Mxtemp;

// backgrouns settings
String bgname = "no background loaded...";
color[] pal;
int palf;
boolean palc;
boolean palcreverse;
int palssa;
float vCx, vCy;
int[][] ptm;
int scale; // why would there be a different scale on each axis?
float Mxscale;
float Mxfreq;
int Mxinterl;
float Myscale;
float Myfreq;
int staticx;

int inactive = 0;

// fonts
PFont MSG20;

void setup() {
  size(960, 720, P2D);
  noStroke();
  frameRate(30);
  MSG20 = loadFont("MS-Gothic-20.vlw");
  textFont(MSG20);
  loadbg();
  editor = new ChildApplet();
  
  windowMove(600, 200);
  windowResizable(false);
}

void draw() {
  inactive++;
  background(0);
  for (int y = 0; y < height/scale; y++){
    Mxtemp = Math.sin(Math.toRadians((y+t))*Mxfreq)*Mxscale*((int(y%2==0)*-Mxinterl*2+1));
    Mytemp = Math.sin(Math.toRadians((y+t))*Myfreq)*Myscale;
    for (int x = 0; x < width/scale; x++){
      int ptmy = rem(Math.round(y+Cy+(int)(Math.round(Mytemp))),ptm.length);
      int ptmx = rem(Math.round(x+Cx+(int)(Math.round(Mxtemp))+random(0, staticx)),ptm[0].length);
      if (ptm[ptmy][ptmx] < palssa) {
        fill(pal[ptm[ptmy][ptmx]]);
      } else {
        fill(pal[rem(ptm[ptmy][ptmx]+paloffset,pal.length-palssa)+palssa]);
      }
      rect(x*scale, y*scale, scale, scale);
    }
  }
  Cx += vCx;
  Cy += vCy;
  t++;
  if(t%palf == 0){
    paloffset++;
    paloffset %= pal.length -1;
  }
  if (inactive<100){
    fill(0, (100-Math.max(inactive, 90))*25.5);
    rect(0, 0, textWidth(bgname) + 30, 30);
    fill(255, (100-Math.max(inactive, 90))*25.5);
    text(bgname, 10, 25); 
  }
}

void mouseMoved() {
  inactive = 0;
}
void keyPressed() {
  inactive = 0;
}

int rem(int x, int n) {
  if (x>0) return (int)(x%n);
  return (int)(Math.floor(x + (Math.ceil(Math.abs(x)/n+1)*n))%n);
}
 
String[] loadFilenames(String path, String filename) {
  File folder = new File(path);
  String[] files = folder.list();
  String[] filteredfiles = {};
  for (int i = 0; i<files.length; i++){
    if (files[i].toLowerCase().endsWith("."+filename)) filteredfiles = append(filteredfiles, files[i]);
  }
  return filteredfiles;
}

void loadbg() {
  menu = 0;
  t = 0;
  Cx = 0;
  Cy = 0;
  paloffset = 0;
  bglist = loadFilenames(sketchPath("")+"data/", "deb");
  loadbg(bglist[menuselect]);
  inactive = 0;
  bgno = menuselect;
}
