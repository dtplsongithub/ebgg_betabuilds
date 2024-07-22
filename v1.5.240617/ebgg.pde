/*
DJV_EBG
 */
 
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.text.html.HTMLDocument;

ChildApplet editor;
AwtProgram1 awt;
AwtProgramSettings awt2;

boolean errorIsBeingShown = false;
boolean warnIsBeingShown = false;

// settings-related things
byte version = 15;
byte[] defaultSettings = {version, 1, 30, 0, 0, 0, 1};
byte[] config;
String settingsType = "csccccd";
String[] settingsDescription = {
  "show big steps tip",
  "scroll sensitivity",
  "enable beta buttons",
  "enable java default window look and feel (requires restart)",
  "expand color picker",
  "enable custom cursors (requires restart if disabling)",
  "background fps"
};
String[] settingsHelp = {
  "",
  "",
  "when hovered/selected button will turn gray instead of blue like in beta versions of v1.3.0",
  "",
  "will show 2 rows instead of 1 in the color picker menu.",
  "",
  "! anything over 50 fps is not recommended"
};
int[] o5 = {5, 255, 30};
String[] o6 = {"24", "25", "30", "custom"};

// variables
long t = 0;
long realt = 0;
int bgno = 0;
float Cx, Cy;
int paloffset = 0;
double Mytemp;
double Mxtemp;
int scrollY = 0;
int timeUntilMenuChange = 0;

// backgrouns settings
String backgroundName = "no background loaded...";
color[] pal;
int palf;
boolean palc, palcreverse;
int palssa;
float vCx, vCy;
int[][] ptm = new int[2][2];
int scale = 1;
float Mxscale, Mxfreq;
int Mxinterl;
float Myscale, Myfreq;
int staticx;

int inactive = 0;

// fonts
PFont MSGothic20;
PFont MSGothic32;

// assets
// MaskImage assets are defined in MaskImage

// other
int paletteIndexToEdit;
String paletteEditTemp = "";

void setup() {
  log = new LOGFILE();
  log.created("LOGFILE");
  
  size(960, 720, P2D);
  
  editor = new ChildApplet();
  progressBar = new ProgressBar(10,500, 380, 24);
  progressBar.text = "this is just a test... ";
  
  noStroke();
  frameRate(30);
  background(0);
  
  MSGothic32 = loadFont("MS-Gothic-32.vlw");
  log.loaded("font MSGothic32");
  MSGothic20 = loadFont("MS-Gothic-20.vlw");
  log.loaded("font MSGothic20");
  textFont(MSGothic20);
  
  loadbg();
  // this.setSize(960, 720);
  menu = 10;

  buttons[0] = new TextButton("01_name", 600, 75, 160, 30, "click to edit", 1);
  buttons[1] = new TextButton("01_pal", 600, 105, 160, 30, "click to edit", 1);
  buttons[2] = new TextButton("01_ptm", 600, 315, 160, 30, "click to edit", 1);
  buttons[3] = new TextButton("goToEditor", 30, 680, 100, 30, "go back", 5);
  buttons[4] = new TextButton("goToEditor", 30, 680, 100, 30, "go back", 6);
  buttons[5] = new TextButton("goToEditor", 30, 680, 100, 30, "go back", 7);
  
  buttons[6] = new TextButton("saveBackground", 30, 650, 100, 30, "save", 1);
  buttons[7] = new TextButton("cancelOverwrite", 600, 650, 100, 30, "cancel", 1);
  buttons[7].active = false;
  buttons[8] = new TextButton("cancelExit", 600, 650, 100, 30, "cancel", 1);
  buttons[8].active = false;
  
  buttons[9] = new TextButton("createPaletteColor", 600, 680, 260, 30, "create new palette color", 6);
  buttons[10] = new TextButton("savePaletteColor", 600, 680, 260, 30, "save palette color", 8);
  buttons[11] = new TextButton("deletePaletteColor", 600, 650, 260, 30, "delete this palette color", 6);
  buttons[12] = new TextButton("editPaletteColor", 600, 620, 260, 30, "edit this palette color", 6);
  
  buttons[13] = new TextButton("goToLoader", 105, 200, 190, 30,  "load a background", 10);
  buttons[14] = new TextButton("goToWindow2", 125, 250, 150, 30, "about & other", 10);
  buttons[15] = new TextButton("goToEditor", 160, 300, 80, 30,  "editor", 10);
  buttons[16] = new TextButton("goToTitlescreen", 30, 680, 100, 30, "back", 0);
  buttons[17] = new TextButton("goToTitlescreen", 30, 680, 100, 30, "back", 1);
  // buttons[18] = new TextButton("goToSettings", 30, 680, 100, 30, "settings", 10);
  // buttons[19] = new TextButton("goToTitlescreen", 30, 680, 100, 30, "back", 11);
  
  buttons[18] = new TextButton("applyResize", 30, 680, 80, 30, "resize", 14);
  buttons[19] = new TextButton("cancelResize", 110, 680, 80, 30, "cancel", 14);
  
  buttons[20] = new TextButton("goToSettings", 150, 350, 100, 30, "settings", 10);
  

  // load assets
  bigsteps = new MaskImage("assets/bigsteps", ".png");

  toolbox = new Toolbox();

  log.loaded("checking save...");

  config = loadBytes("config.dat");
  
  boolean isnotok = checkSave();
  if (isnotok) log.warn("config.dat problems were found and fixed.");
  log.log(isnotok?"config.dat problems were found and fixed.":"No config.dat problems found.");
  
  JFrame.setDefaultLookAndFeelDecorated(boolean(config[4]));
  
  awt = new AwtProgram1();
  awt2 = new AwtProgramSettings();
  errhandler.setLocation(-100, -100);

  log.loaded("finished loading");
}

void draw() {
  inactive++;
  realt++;
  background(0);
  try {
    for (int y = 0; y < height/scale; y++) {
      Mxtemp = Math.sin(Math.toRadians((y+t))*Mxfreq)*Mxscale*((int(y%2==0)*-Mxinterl*2+1));
      Mytemp = Math.sin(Math.toRadians((y+t))*Myfreq)*Myscale;
      for (int x = 0; x < width/scale; x++) {
        int ptmy = rem(Math.round(y+Cy+(int)(Math.round(Mytemp))), ptm.length);
        int ptmx = rem(Math.round(x+Cx+(int)(Math.round(Mxtemp))+random(0, staticx)), ptm[0].length);
        if (ptm[ptmy][ptmx] < palssa) {
          fill(pal[ptm[ptmy][ptmx]]);
        } else {
          fill(pal[rem(ptm[ptmy][ptmx]+paloffset, pal.length-palssa)+palssa]);
        }
        rect(x*scale, y*scale, scale, scale);
      }
    }
  } catch (ArithmeticException e) {
    log.error(e+"", true);
  }
  Cx += vCx;
  Cy += vCy;
  t++;
  if (t%palf == 0 && palc) {
    paloffset += int(!palcreverse)*2-1;
    paloffset = rem(paloffset, pal.length - 1);
  }
  if (!palc) paloffset = 0;
  if (inactive<100) {
    fill(0, (100-Math.max(inactive, 90))*25.5);
    rect(0, 0, textWidth(backgroundName) + 30, 30);
    fill(255, (100-Math.max(inactive, 90))*25.5);
    text(backgroundName, 10, 25);
  }
}

void mouseMoved() {
  inactive = 0;
}
void keyPressed() {
  if (key == ENTER && menu == 0) {
    loadbg();
  }
  inactive = 0;
  optionsCheckKeyPress(keyCode);
  if (menu == 5 || menu == 8 ) keyboardDetection(keyCode, key);
  if (key == ESC) logexit();
}

int rem(int x, int n) {
  if (x>0) return (int)(x%n);
  return (int)(Math.floor(x + (Math.ceil(Math.abs(x)/n+1)*n))%n);
}

String[] loadFilenames(String path, String filename) {
  File folder = new File(path);
  String[] files = folder.list();
  String[] filteredfiles = {};
  for (int i = 0; i<files.length; i++) {
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
  loadbglist();
  loadbg(bglist[menuselect]);
  inactive = 0;
  bgno = menuselect;
}

void optionsCheckKeyPress(int kc) {
  switch (kc) {
  case UP:
    {
      menuselect--;
      switch (menu) {
      case 0:
        if (menuselect<0) menuselect=bglist.length-1;
        break;
      case 1:
        if (menuselect<0) menuselect=edopname.length-1;
        break;
      case 6: // palette editor
        if (menuselect<0) menuselect=pal.length-1;
        scrollY = -menuselect*40+height/2-100;
        break;
      case 14:
        if (menuselect<0) menuselect=menu14.length-1;
        break;
      }
      break;
    }
  case DOWN:
    {
      menuselect++;
      switch (menu) {
      case 0:
        if (menuselect>bglist.length-1) menuselect=0;
        break;
      case 1:
        if (menuselect>edopname.length-1) menuselect=0;
        break;
      case 6: // palette editor
        if (menuselect>pal.length-1) menuselect=0;
        scrollY = -menuselect*40+height/2-100;
        break;
      case 14:
        if (menuselect>menu14.length-1) menuselect=0;
        break;
      }
      break;
    }
  case +RIGHT:
  case +65:
  case +68:
  case LEFT:
    {
      if (menu == 1) {
        if (kc>60)bigstepsappear=false;
        switch (menuselect) {
        case 2:
          if (kc>60)return;
          if ((palf<=edopset[menuselect][0] && kc==LEFT) || (palf>=edopset[menuselect][2] && kc==RIGHT)) return;
          palf += edopset[2][1]*((kc==LEFT)?-1 :1);
          break;
        case 3:
          if (kc>60)return;
          palc = kc==RIGHT;
          break;
        case 4:
          if (kc>60)return;
          palcreverse = kc==RIGHT;
          break;
        case 5:
          if (kc>60)return;
          if ((palssa<=edopset[menuselect][0] && kc==LEFT) || (palssa>=edopset[menuselect][2] && kc==RIGHT)) return;
          palssa += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        case 6:
          if ((vCx<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (vCx>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          vCx += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (vCx<=edopset[menuselect][0]) vCx=(edopset[menuselect][0]);
          if (vCx>=edopset[menuselect][2]) vCx=(edopset[menuselect][2]);
          break;
        case 7:
          if ((vCy<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (vCy>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          vCy += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (vCy<=edopset[menuselect][0]) vCy=(edopset[menuselect][0]);
          if (vCy>=edopset[menuselect][2]) vCy=(edopset[menuselect][2]);
          break;
        case 9:
          if (kc>60)return;
          if ((scale<=edopset[menuselect][0] && kc==LEFT) || (scale>=edopset[menuselect][2] && kc==RIGHT)) return;
          scale += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        case 10:
          if ((Mxscale<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Mxscale>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Mxscale += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Mxscale<=edopset[menuselect][0]) Mxscale=(edopset[menuselect][0]);
          if (Mxscale>=edopset[menuselect][2]) Mxscale=(edopset[menuselect][2]);
          break;
        case 11:
          if ((Mxfreq<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Mxfreq>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Mxfreq += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Mxscale<=edopset[menuselect][0]) Mxscale=(edopset[menuselect][0]);
          if (Mxscale>=edopset[menuselect][2]) Mxscale=(edopset[menuselect][2]);
          break;
        case 12:
          if (kc>60)return;
          if ((Mxinterl<=edopset[menuselect][0] && kc==LEFT) || (Mxinterl>=edopset[menuselect][2] && kc==RIGHT)) return;
          Mxinterl += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        case 13:
          if ((Myscale<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Myscale>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Myscale += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Myscale<=edopset[menuselect][0]) Myscale=(edopset[menuselect][0]);
          if (Myscale>=edopset[menuselect][2]) Myscale=(edopset[menuselect][2]);
          break;
        case 14:
          if ((Myfreq<=edopset[menuselect][0] && (kc==LEFT || kc==65)) || (Myfreq>=edopset[menuselect][2] && (kc==RIGHT || kc==68))) return;
          Myfreq += edopset[menuselect][1]*(kc>60?10:1)*((kc==LEFT||kc==65)?-1 :1);
          if (Myfreq<=edopset[menuselect][0]) Myfreq=(edopset[menuselect][0]);
          if (Myfreq>=edopset[menuselect][2]) Myfreq=(edopset[menuselect][2]);
          break;
        case 15:
          if (kc>60)return;
          if ((staticx<=edopset[menuselect][0] && kc==LEFT) || (staticx>=edopset[menuselect][2] && kc==RIGHT)) return;
          staticx += edopset[menuselect][1]*((kc==LEFT)?-1 :1);
          break;
        default:
          menuselect = 0;
        }
      }
      if (menu==14) {
        if (menu14tempValues[menuselect]<=1 && kc==LEFT) return;
        menu14tempValues[menuselect] += ((kc==LEFT)?-1 :1);
      }
      break;
    }
  case ENTER:
    {
      if (menu == 6) {
        menu = 8;
        paletteIndexToEdit = menuselect;
        paletteEditTemp = "#"+hex(pal[menuselect], 6);
      }
      break;
    }
  }
}
