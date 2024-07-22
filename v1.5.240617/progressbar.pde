class ProgressBar {
  public int x, y, w, h, borderColor = 0xFF00FF00, progressColor = 0xFF00FF00, interiorColor = 0xFF003300;
  public boolean visible = true, appendProgressToText = true;
  public byte progress = 0, indentation = 2, borderSize = 1;
  public String text = "";
  private int interiorW, interiorH;
  public ProgressBar(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  public void render() {
    if (!visible) return;
    this.interiorW = this.w-this.indentation*2;
    this.interiorH = this.h-this.indentation*2;
    editor.fill(0, 0);
    editor.stroke(this.borderColor);
    editor.strokeWeight(this.borderSize);
    editor.rect(this.x, this.y, this.w, this.h);
    editor.noStroke();
    editor.fill(this.interiorColor);
    editor.rect(this.x+this.indentation, this.y+this.indentation, this.w-this.indentation*2, this.h-this.indentation*2);
    editor.textAlign(CENTER, CENTER);
    editor.fill(this.progressColor);
    editor.text(this.text + (this.appendProgressToText ? + this.progress + "%" : ""), this.w/2+this.x, this.h/2+this.y);
    editor.loadPixels();
    try { 
      for (int y = 0; y < this.interiorH; y++) {
        for (int x = 0; x < int(lerp(0, this.interiorW, float(this.progress)/100)); x++) {
          int i = x+this.x+this.indentation+(y+this.y+this.indentation)*editor.width;
          if (editor.pixels[i] == this.progressColor) editor.pixels[i] = this.interiorColor;
          else if (editor.pixels[i] == this.interiorColor) editor.pixels[i] = this.progressColor;
        }
      }
    } catch (ArrayIndexOutOfBoundsException e) {
      log.error(e+" on rendering progressBar", false);
    }
    editor.updatePixels();
    editor.textAlign(LEFT, BOTTOM);
    editor.stroke(0);
  }
}

ProgressBar progressBar;
