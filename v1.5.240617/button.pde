TextButton[] buttons = new TextButton[21];

public class TextButton {
  public String id, text;
  private int x, y, w, h, activeMenu;
  public boolean active = true, toggle = false, toggler = false;
  public TextButton(String _id, int _x, int _y, int _w, int _h, String _text, int _menu) {
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.w = _w;
    this.h = _h;
    this.text = _text;
    this.activeMenu = _menu;
    log.created("button "+id);
  }
  public boolean checkIfHovered() {
    return editor.mouseX > this.x && editor.mouseX < this.x + this.w && editor.mouseY > this.y && editor.mouseY < this.y + this.h;
  }
  public void render() {
    if (this.activeMenu != menu || !this.active) return;
    editor.fill(255);
    editor.rect(this.x, this.y, this.w, this.h);
    editor.fill(0);
    editor.text(this.text, this.x+10, this.y+20);
    if (id == "editorPreviewMode" && toolbox.b[3].toggle) {
      editor.fill(0, 127);
      editor.rect(this.x, this.y, this.w, this.h);
      editor.fill(255);
      return;
    }
    if (this.checkIfHovered()) {
      editor.fill(0, 127, 255, 127);
      editor.rect(this.x, this.y, this.w, this.h);
    }
    if (toggler && toggle) {
      editor.fill(0, 127, 255, 64);
      editor.rect(this.x, this.y, this.w, this.h);
    }
    editor.fill(255);
  }
}

public class ImageButton {
  public String id;
  public PImage img;
  private int x, y, w, h, scale = 1;
  public int activeMenu;
  public boolean active = true;
  public ImageButton(String _id, int _x, int _y, int _menu, String imgLocation) {
    img = loadImage(imgLocation);
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.w = img.width;
    this.h = img.height;
    this.activeMenu = _menu;
    log.loaded("asset for imageButton "+imgLocation);
    log.created("imageButton "+id);
  }
  public ImageButton(String _id, int _x, int _y, int _menu, String imgLocation, int imageScale) {
    img = loadImage(imgLocation);
    log.loaded("asset for imageButton "+imgLocation);
    this.id = _id;
    this.x = _x;
    this.y = _y;
    this.w = img.width;
    this.h = img.height;
    this.activeMenu = _menu;
    this.scale = imageScale;
    log.created("imageButton "+id);
  }
  public boolean checkIfHovered() {
    return editor.mouseX > this.x && editor.mouseX < this.x + this.w*scale && editor.mouseY > this.y && editor.mouseY < this.y + this.h*scale;
  }
  public void render() {
    if (this.activeMenu != menu || !this.active) return;
    editor.pushMatrix();
    editor.scale(this.scale);
    editor.image(this.img, x/scale, y/scale);
    if (this.checkIfHovered()) {
      editor.fill(0, 127, 255, 127);
      editor.rect(x/scale, y/scale, w, h);
    }
    editor.fill(255);
    editor.popMatrix();
  }
}

void renderButtons() {
  for (TextButton i: buttons) {
    try {
      i.render();
    } catch (NullPointerException e) {
      log.error(e+" on renderButtons()", true);
    }
  }
}

void checkButtons() {
  for (TextButton i: buttons) {
    if (i.activeMenu != menu || !i.active) continue; // god i love continue
    if (!i.checkIfHovered()) continue;
    switch (i.id) {
      case "01_name": menu = 5; break;
      case "01_pal": menu = 6; break;
      case "01_ptm": menu = 7; break;
      case "save": menu = 1; break;
      case "saveBackground": {
        if (fileExists(backgroundName+".deb")) {
          buttons[6].id = "confirmOverwrite";
          buttons[6].text = backgroundName+".deb already exists. overwrite?";
          buttons[6].w = ceil(textWidth(backgroundName+".deb already exists. overwrite?"))+30;
          buttons[7].active = true;
        } else {
          saveStrings("data/"+backgroundName+".deb", saveBackground());
          loadbglist();
        }
        break;
      }
      case "confirmOverwrite": {
        saveStrings("data/"+backgroundName+".deb", saveBackground());
        buttons[6].id = "saveBackground";
        buttons[6].text = "save";
        buttons[6].w = 100;
        buttons[7].active = false;
        loadbglist();
        break;
      }
      case "cancelOverwrite": {
        buttons[6].id = "saveBackground";
        buttons[6].text = "save";
        buttons[6].w = 100;
        buttons[7].active = false;
        break;
      }
      case "createPaletteColor": {
        menuselect = pal.length;
        pal = append(pal, 0xFFFFFFFF);
        scrollY = -menuselect*40+height/2-100;
        break;
      }
      case "savePaletteColor": {
        if (paletteEditTemp.length() != 7) {
          showInfo("please input a valid hex color. (#RRGGBB)");
        } else {
          menu = 6;
          pal[paletteIndexToEdit] = unhex(paletteEditTemp.substring(1, paletteEditTemp.length()))|0xFF000000;
        }
        break;
      }
      case "editPaletteColor": {
        menu = 8;
        paletteIndexToEdit = menuselect;
        paletteEditTemp = "#"+hex(pal[menuselect], 6);
        break;
      }
      case "deletePaletteColor": {
        if (pal.length>max(palssa, 2)) {
          arrayCopy(pal, menuselect+1, pal, menuselect, pal.length-menuselect-1);
          pal = shorten(pal);
        };
        if (menuselect>0)menuselect--;
        break;
      }
      case "goToLoader": menu=3;break;
      case "goToWindow2": awt.window2.setVisible(true);break;
      case "goToSettings": awt2.settings.setVisible(true);break;
      case "goToEditor": menu=2;break;
      case "goToTitlescreen": menu=13;break;
      case "applyResize": ptm = new int[menu14tempValues[0]][menu14tempValues[1]]; menu=7;break;
      case "cancelResize": menu=7;break;
    }
  }
  toolbox.checkPress();
}

boolean isButtonHovered() {
  for (TextButton i: buttons) {
    if (i.activeMenu != menu || !i.active) continue;
    if (i.checkIfHovered()) return true;
  }
  for (TextButton i: toolbox.b) {
    if (i.activeMenu != menu || !i.active) continue;
    if (i.checkIfHovered()) return true;
  }
  for (ImageButton i: toolbox.ib) {
    if (i.activeMenu != menu || !i.active) continue;
    if (i.checkIfHovered()) return true;
  }
  return false;
}
