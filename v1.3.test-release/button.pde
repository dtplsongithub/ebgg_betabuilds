Button[] buttons = new Button[12];

class Button {
  String id, text;
  int x, y, w, h, activeMenu;
  boolean active = true;
  public Button(String _id, int _x, int _y, int _w, int _h, String _text, int _menu) {
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
    if (this.checkIfHovered()) {
      editor.fill(0, 127, 255, 127);
      editor.rect(this.x, this.y, this.w, this.h);
    }
    editor.fill(255);
  }
}

class ImageButton {
  String id;
  PImage img;
  int x, y, w, h, activeMenu, scale = 1;
  boolean active = true;
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
    editor.scale(2);
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
  for (Button i: buttons) {
    i.render();
  }
}

void checkButtons() {
  for (Button i: buttons) {
    if (i.activeMenu != menu || !i.active) continue;
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
          menutitle[8] = "please input a valid hex color. (#RRGGBB)";
        } else {
          menu = 6;
          pal[paletteIndexToEdit] = unhex(paletteEditTemp.substring(1, paletteEditTemp.length()))|0xFF000000;
          menutitle[8] = "edit palette color";
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
    }
  }
  toolbox.checkPress();
}
