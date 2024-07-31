float[][] edopset = {{1}, {2}, {1, 1, 999}, {0, 1, 1}, {0, 1, 1}, {0, 1, 999}, {-50, 0.05, 50}, {-50, 0.05, 50}, {3}, {1, 1, 16}, {0, 0.1, 40}, {-300, 0.1, 300}, {0, 1, 1}, {-400, 0.1, 400}, {-30, 0.1, 30}, {0, 1, 400}};
final String[] edopname = {
  "name",
  "palette",
  "switch pal colors every n frames",
  "switch pal colors?",
  "switch pal colors in reverse?",
  "dont switch the first n items",
  "camera x velocity",
  "camera y velocity",
  "pallete map (or ptm)",
  "scale",\
  "x wavyness frequency",
  "interleaved x wavyness?",
  "y wavyness scale",
  "y wavyness frequency",
  "x static effect"
};
Toolbox toolbox;

class Toolbox {
  ImageButton[] ib;
  Button[] b;
  int currentToolSelected = 0;
  public Toolbox() {
    ib = new ImageButton[7];
    b = new Button[1];
    ib[0] = new ImageButton("editorPencil", 30, 100, 7, "assets/pencil.png", 2);
    ib[1] = new ImageButton("editorLine", 30+32*1, 100, 7, "assets/line.png", 2);
    ib[2] = new ImageButton("editorRect", 30+32*2, 100, 7, "assets/rectangle.png", 2);
    ib[3] = new ImageButton("editorFillRect", 30+32*3, 100, 7, "assets/filledRectangle.png", 2);
    ib[4] = new ImageButton("editorCircle", 30+32*4, 100, 7, "assets/circle.png", 2);
    ib[5] = new ImageButton("editorFillCircle", 30+32*5, 100, 7, "assets/filledCircle.png", 2);
    ib[6] = new ImageButton("editorGrid", 30+32*6, 100, 7, "assets/grid.png", 2);
    b[0] = new Button("editorStatusBar", 30+32*7, 100, 33*7, 32, "Toggle status bar", 7);
  }
  public void render() {
    for (ImageButton i: ib) i.render();
    for (Button i: b) i.render();
    editor.text("current tool selected: "+this.currentToolSelected, 500, 100);
  }
  public void checkPress() {
    for (int i = 0; i<ib.length; i++) {
      ImageButton temp = ib[i];
      if (temp.activeMenu != menu || !temp.active) continue;
      if (!temp.checkIfHovered()) continue;
      if (i != 6) currentToolSelected = i;
    }
    for (int i = 0; i<b.length; i++) {
      Button temp = b[i];
      if (temp.activeMenu != menu || !temp.active) continue;
      if (!temp.checkIfHovered()) continue;
    }
  }
}
