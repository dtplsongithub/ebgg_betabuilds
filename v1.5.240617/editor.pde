float[][] edopset = {
  {1},
  {2},
  {1, 1, 999},
  {0, 1, 1},
  {0, 1, 1},
  {0, 1, 999},
  {-50, 0.05, 50},
  {-50, 0.05, 50},
  {3},
  {1, 1, 16},
  {-400, 0.1, 400},
  {-400, 0.1, 400},
  {0, 1, 1},
  {-300, 0.1, 300},
  {-400, 0.1, 400},
  {-30, 0.1, 30},
  {0, 1, 100}
};
final String[] edopname = {
  "name",
  "palette",
  "switch pal colors every n frames",
  "switch pal colors?",
  "switch pal colors in reverse?",
  "dont switch the first n items",
  "camera x velocity",
  "camera y velocity",
  "pattern",
  "scale",
  "x wavyness scale",
  "x wavyness frequency",
  "interleaved x wavyness?",
  "y wavyness scale",
  "y wavyness frequency",
  "x static effect"
};
Toolbox toolbox;

class Toolbox {
  ImageButton[] ib;
  TextButton[] b;
  int currentToolSelected = 0, zoom = 0, scrollX=0, scrollY=0, currentColorSelected = 0;
  boolean CANDRAW=false;
  public Toolbox() {
    ib = new ImageButton[12];
    b = new TextButton[4];
    ib[0] = new ImageButton("editorPencil", 30, 68, 70, "assets/pencil.png", 2);
    ib[1] = new ImageButton("editorLine", 62, 68, 70, "assets/line.png", 2);
    ib[2] = new ImageButton("editorRect", 94, 68, 70, "assets/rectangle.png", 2);
    ib[3] = new ImageButton("editorFillRect", 126, 68, 70, "assets/filledRectangle.png", 2);
    ib[4] = new ImageButton("editorCircle", 158, 68, 70, "assets/circle.png", 2);
    ib[5] = new ImageButton("editorFillCircle", 190, 68, 70, "assets/filledCircle.png", 2);
    b[0] = new TextButton("editorGrid", 30, 100, 110, 32, "Show grid", 7);
    b[0].toggler = true;
    b[1] = new TextButton("editorResizePtm", 140, 100, 170, 32, "resize pattern", 7);
    b[2] = new TextButton("editorPreviewMode", 310, 100, 200, 32, "Don't use palette", 7);
    b[2].toggler = true;
    b[3] = new TextButton("editorUsePaloffset", 510, 100, 160, 32, "Use paloffset", 7);
    b[3].toggler = true;
    ib[6] = new ImageButton("editorZoomIn", 872, 100, 7, "assets/zoomin.png", 2);
    ib[7] = new ImageButton("editorZoomOut", 904, 100, 7, "assets/zoomout.png", 2);
    ib[8] = new ImageButton("editorMoveL", 750, 100, 7, "assets/left.png", 2);
    ib[8].active = false;
    ib[9] = new ImageButton("editorMoveU", 782, 84, 7, "assets/up.png", 2);
    ib[9].active = false;
    ib[10] = new ImageButton("editorMoveD", 782, 116, 7, "assets/down.png", 2);
    ib[10].active = false;
    ib[11] = new ImageButton("editorMoveR", 814, 100, 7, "assets/right.png", 2);
    ib[11].active = false;
  }
  public void render() {
    // editor.fill(0, 127, 255, 64);
    // editor.rect(this.currentToolSelected*32+30, 68, 32, 32);
    int rs = floor(min(900/ptm[0].length, 400/ptm.length))+zoom;
    editor.noStroke();
    for (int y = 0; y<ptm.length; y++) {
      for (int x = 0; x<ptm[0].length; x++) {
        this.getColor(ptm[y][x]);
        editor.rect(x*rs+30+scrollX, y*rs+150+scrollY, rs-int(b[0].toggle), rs-int(b[0].toggle));
      }
    }
    editor.fill(0);
    editor.rect(0, 600, 999, 999);
    editor.fill(255);
    editor.text("Color picker", 30, 620-32*config[5]);
    int rp = 900/pal.length*(int(config[5])+1);

    if (rp<2) {
      fill(255);
      text("Too many colors!!!!! :(", 660, 30);
    } else {
      if (config[5]==1) {
        
      } else {
        for (int i = 0; i<pal.length; i++) {
          this.getColor(i);
          editor.rect(30+i*rp, 648, rp, 32);
          if (i == this.currentColorSelected) {
            editor.fill(0, 127, 255, 64);
            editor.rect(30+i*rp, 648-(32*int(boolean(config[5])&&i<pal.length/2)), rp, 32);
          }
        }
      }
    }
    editor.fill(0, 127, 255, 64);
    if (editor.mouseX>30 && editor.mouseX<900 && editor.mouseY>650 && editor.mouseY<680) editor.rect(floor((editor.mouseX-30)/rp)*rp+30, 648, rp, 32);
    editor.stroke(0);
    for (ImageButton i : ib) i.render();
    for (TextButton i : b) i.render();
  }
  public void checkPress() {
    for (int i = 0; i<ib.length; i++) {
      ImageButton temp = ib[i];
      if (temp.activeMenu != menu || !temp.active) continue;
      if (!temp.checkIfHovered()) continue;
      if (i < 6) currentToolSelected = i;
      else {
        switch (i) {
        case 6:
          this.zoom = 20;
          for (int j=8; j<12; j++) {
            ib[j].active=true;
          }
          break;
        case 7:
          this.zoom = 0;
          for (int j=8; j<12; j++) {
            ib[j].active=false;
          }
          scrollX=0;
          scrollY=0;
          break;
        case +9:
        case 10:
          scrollY+=300*(int(i==10)*2-1);
          break;
        case +8:
        case 11:
          scrollX+=300*(int(i==11)*2-1);
          break;
        default:
          log.error("Unknown toolbox imagebutton type "+i, false);
        }
      }
    }
    for (int i = 0; i<b.length; i++) {
      TextButton temp = b[i];
      if (temp.activeMenu != menu || !temp.active) continue;
      if (!temp.checkIfHovered()) continue;
      if (b[i].toggler) b[i].toggle=!b[i].toggle;
      if (i==1) menu = 14;
    }
  }
  public void checkDraw() {
    int rs = floor(min(900/ptm[0].length, 400/ptm.length))+zoom;
    int rp = 900/pal.length;
    if (rp<2) return;
    if (editor.mousePressed) {
      if (editor.mouseX >30+scrollX && editor.mouseX < ptm[0].length*rs+30+scrollX && editor.mouseY > 150+scrollY && editor.mouseY < ptm.length*rs+150+scrollY && CANDRAW) {
        ptm[(editor.mouseY-150-scrollY)/rs][(editor.mouseX-30-scrollX)/rs] = this.currentColorSelected;
      } else if (editor.mouseX>30 && editor.mouseX<900 && editor.mouseY>650 && editor.mouseY<680 && CANDRAW) {
        this.currentColorSelected = (editor.mouseX-30)/rp;
      }
    } else CANDRAW = true;
  }
  private void getColor(int i) {
    if (b[3].toggle) {
      if (i < palssa) {
        editor.fill(pal[i]);
      } else {
        editor.fill(pal[rem(i+paloffset, pal.length-palssa)+palssa]);
      }
    } else if (!b[2].toggle) {
      editor.fill(pal[i]);
    } else {
      editor.colorMode(HSB, 100);
      editor.fill(i*4%100, 100, 70);
      editor.colorMode(RGB, 255);
    }
  }
}
