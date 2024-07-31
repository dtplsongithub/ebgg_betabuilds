int oldmenu = -1;
class ChildApplet extends PApplet {
  public ChildApplet() {
    super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    log.created("childapplet");
  }

  public void settings() {
    size(400, 720, P3D);
  }
  public void setup() { 
    windowTitle("editor");
    windowMove(150, 200);
    windowResizable(false);
    textFont(MSGothic20);
    log.loaded("configured childapplet");
  }

  public void draw() {
    if (oldmenu != menu) {
      windowTitle(menutitle[menu]);
      log.log("switched to menu "+menu);
      oldmenu = menu;
    }
    background(0);
    renderButtons();
    switch (menu) {
      case 0: {
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
        fill(255);
        text("press e to go to the editor", 30, 700 ,380, 999);
        break;
      }
      case 1: {
        text("press backspace to go to the background selector menu", 30, 700);
        
        // EDITOR MENU
        
        fill(255);
        for (int i = 0; i<edopname.length; i++) {
          int y = 100+i*30;
          if (i==menuselect) {
            fill(0, 255, 0);
          } else {
            fill(255);
          }
          text(edopname[i], 30, y);
          fill(255);
          if (edopset[i].length != 1) {
            switch (i) {
              case 2:
                option(int(palf), i, y);
                break;
              case 3: 
                option(int(palc), i, y);
                break;
              case 4: 
                option(int(palcreverse), i, y);
                break;
              case 5: 
                option(palssa, i, y);
                break;
              case 6: 
                option(vCx, i, y, true);
                break;
              case 7: 
                option(vCy, i, y, true);
                break;
              case 9: 
                option(scale, i, y);
                break;
              case 10: 
                option(Mxscale, i, y, true);
                break;
              case 11: 
                option(Mxfreq, i, y, true);
                break;
              case 12: 
                option(Mxinterl, i, y);
                break;
              case 13: 
                option(Myscale, i, y, true);
                break;
              case 14: 
                option(Myfreq, i, y, true);
                break;
              case 15: 
                option(staticx, i, y);
                break;
              default: {
                log.warn("unknown editor option "+i);
              }
            }
          } else {
            switch (floor(edopset[i][0])) {
              default: {
                //log.error("unknown special editor option "+i);
                //logexit();
              }
            }
          }
        }
        
        // that little speech bubble thing
        
        if (bigstepsappear) image(bigsteps.image, 717, 148);
        
        break;
      }
      case 2: {
        surface.setSize(960, 720);
        windowMove(0, 200);
        break;
      }
      case 3: {
        surface.setSize(400, 720);
        windowMove(150, 200);
        break;
      }
      case 5: {
        pushStyle();
        text(backgroundName, 30, 100);
        strokeWeight(2);
        stroke(255);
        if ( realt % 60 < 30 ) line(textWidth(backgroundName)+30, 100, textWidth(backgroundName)+30, 80);
        line(0, 101, width, 101);
        popStyle();
        break;
      }
      case 6: {
        noStroke();
        for (int i = 0; i<pal.length; i++) {
          if (i == menuselect) {
            fill(0x77FFFFFF);
            rect(170, 100+i*40+scrollY, 800, 40);
          }
          fill(pal[i]);
          rect(170, 100+i*40+scrollY, 40, 40);
          fill(255);
          text("#"+hex(pal[i], 6), 220, 130+i*40+scrollY);
        }
        text("paloffset >", 20, 130+(paloffset+palssa)*40+scrollY);
        break;
      }
      case 7: {
        toolbox.render();
        break;
      }
      case 8: {
        pushStyle();
        text(paletteEditTemp, 30, 100);
        strokeWeight(2);
        stroke(255);
        if ( realt % 60 < 30 ) line(textWidth(paletteEditTemp)+30, 100, textWidth(paletteEditTemp)+30, 80);
        line(0, 101, width, 101);
        popStyle();
        break;
      }
      default: {
        text("the chances of you seeing this is very low and if you CAN see this please make a github issue and also tell me this: \nmenu:" + menu, 30, 100);
      }
    }
    textSize(32);
    fill(0);
    rect(0, 0, 999, 50);
    fill(255);
    text(menutitle[menu], 20, 20, this.width, 999);
    textSize(20);
  }
  public void keyPressed() {
  if (menu == 5 || menu == 8 ) keyboardDetection(editor.keyCode, editor.key);
    if (key == ENTER && menu == 0) {
      loadbg();
    }
    if ((key == 'e'||key=='E') && menu == 0) {
      menu = 2;
      menuselect = 0;
        surface.setSize(960, 720);
        windowMove(0, 200);
    }
    if ((key == BACKSPACE) && menu == 1) {
      menu = 3;
      menuselect = 0;
        surface.setSize(400, 720);
        windowMove(150, 200);
    }
    optionsCheckKeyPress(editor.keyCode);
  }
  void option(float what, int i, int y) {
    if (!(what <= edopset[i][0])) text("<", 600, y);
    String[] bool = {"no", "yes"};
    if (edopset[i][0] == 0 && edopset[i][2] == 1) {
      text(bool[int(what)], 620, y);
    } else {
      text(nf(what, 1, 0), 620, y);
    }
    if (!(what >= edopset[i][2])) text(">", 700, y);
  }
  void option(float what, int i, int y, boolean hasBigSteps) { // hasBigSteps isnt actually used. only the number of arguments count.
    fill(255, 255, 0);
    if (!(what <= edopset[i][0]) && hasBigSteps) text("<<", 570, y);
    fill(255);
    if (!(what <= edopset[i][0])) text("<", 600, y);
    String[] bool = {"no", "yes"};
    if (edopset[i][0] == 0 && edopset[i][2] == 1) {
      text(bool[int(what)], 620, y);
    } else {
      text(nf(what, 1, 0), 620, y);
    }
    if (!(what >= edopset[i][2])) text(">", 700, y);
    fill(255, 255, 0);
    if (!(what >= edopset[i][2]) && hasBigSteps) text(">>", 720, y);
    fill(255);
  }
  public void mousePressed() {
    checkButtons();
    // println(mouseX, mouseY);
  }
  public void mouseWheel(MouseEvent e) {
    scrollY -= e.getCount()*config[2];
  }
}
