int oldmenu = -1;
class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(400, 720, P3D);
  }
  public void setup() { 
    windowTitle("editor");
    windowMove(150, 200);
    windowResizable(false);
    textFont(MSG20);
  }

  public void draw() {
    if (oldmenu != menu) 
      windowTitle(menutitle[menu]);
    background(0);
    switch (menu) {
      case+0:
      case 1: {
        textSize(32);
        fill(255);
        text(menutitle[menu], 20, 20, 380, 999);
        textSize(20);
        for (int i = 0; i<bglist.length; i++){
          if (i==menuselect) {
            fill(0, 255, 0);
          } else {
            fill(255);
          }
          if (i == bgno) {
            text(">", 10, i*30+100, 380, 999);
          }
          text(bglist[i], 30, i*30+100, 380, 999);
        }
        break;
      }
      case 2: {
        editor();
        break;
      }
    }
  }
  public void keyPressed() {
    if (key == ENTER && menu == 0) {
      loadbg();
    }
    switch (keyCode) {
      case 38: {
        menuselect--;
        if (menuselect<0) menuselect=bglist.length-1;
        break;
      }
      case 40: {
        menuselect++;
        if (menuselect>bglist.length-1) menuselect=0;
        break;
      }
    }
  }
}
