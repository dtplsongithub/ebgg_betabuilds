void loadbg(String which){
  try {
    String[] values = loadStrings(which);
    backgroundName = values[0];
    pal = new color[values[1].split(",").length];
    for (int i = 0; i<pal.length; i++){
      pal[i] = unhex("ff"+values[1].split(",")[i].trim());
    }
    palf = int(values[2]);
    palc = boolean(int(values[3]));
    palcreverse = boolean(int(values[4]));
    palssa = int(values[5]);
    vCx = float(values[6]);
    vCy = float(values[7]);
    int ptmwidth = values[8].split(",").length-1;
    if (ptmwidth<1) throw new Error("Invalid pattern width "+ptmwidth);
    int ptmheight = 0;
    for (int i = 0; true; i++) {
      if(8+i>values.length-1)break;
      if(values[8+i].indexOf("-") >= 0)break;
      ptmheight = i+1;
    }
    ptm = new int[ptmheight][ptmwidth];
    for (int x = 0; x<ptmwidth; x++) {
      for (int y = 0; y<ptmheight; y++) {
        ptm[y] = int(values[8+y].split(","));
      }
    }
    scale = int(values[9+ptmheight]);
    Mxscale = float(values[10+ptmheight]);
    Mxfreq = float(values[11+ptmheight]);
    Mxinterl = int(values[12+ptmheight]);
    Myscale = float(values[13+ptmheight]);
    Myfreq = float(values[14+ptmheight]);
    staticx = int(values[15+ptmheight]);
  } catch (ArrayIndexOutOfBoundsException e) {
    log.warn(e+". Failed to fully load background. Potential wrong background format.");
  } catch (NumberFormatException e) {
    log.warn(e+". Failed to fully load background. Potential wrong background format.");
  } catch (Error e) {
    log.warn(e+". Failed to fully load background. Potential wrong background format.");
  }
}

void savebg() {
  
}

String[] bglist;
void loadbglist(){
  bglist = loadFilenames(sketchPath("")+"data/", "deb");
  log.log("succesfully loaded background list");
}

boolean fileExists(String filename) {
  byte[] file = loadBytes(filename);
  return file!=null;
}

String[] saveBackground() {
  String[] backgroundTemp = new String[15+ptm.length+1];
  backgroundTemp[0] = backgroundName;
  String[] paltemp = new String[0];
  for (int i = 0; i<pal.length; i++) {
    paltemp = append(paltemp, hex(pal[i],6));
  }
  backgroundTemp[1] = join(paltemp, ",");
  backgroundTemp[2] = palf+"";
  backgroundTemp[3] = int(palc)+"";
  backgroundTemp[4] = int(palcreverse)+"";
  backgroundTemp[5] = palssa+"";
  backgroundTemp[6] = vCx+"";
  backgroundTemp[7] = vCy+"";
  for (int i = 0; i<ptm.length; i++) {
    backgroundTemp[8+i] = join(nf(ptm[i], 0), ",");
  }
  backgroundTemp[8+ptm.length] = "-ptmend";
  backgroundTemp[9+ptm.length] = scale+"";
  backgroundTemp[10+ptm.length] = Mxscale+"";
  backgroundTemp[11+ptm.length] = Mxfreq+"";
  backgroundTemp[12+ptm.length] = Mxinterl+"";
  backgroundTemp[13+ptm.length] = Myscale+"";
  backgroundTemp[14+ptm.length] = Myfreq+"";
  backgroundTemp[15+ptm.length] = staticx+"";
  return backgroundTemp;
}

boolean checkSave() {
  boolean problem = false;
  if (!fileExists("config.dat")) {
    saveBytes("config.dat", defaultSettings);
    config = defaultSettings;
    problem = true;
  }
  
  if (config.length<defaultSettings.length) {
    int originalConfigLength = config.length;
    config = expand(config, defaultSettings.length);
    arrayCopy(defaultSettings, originalConfigLength, config, originalConfigLength, defaultSettings.length-originalConfigLength);
    problem = true;
  } else if (config[0] != version) {
    config[0] = version;
    problem = true;
  }
  if (config[1] > 1) { config[1] = 0; problem = true; }
  
  if (config[2] < 5) {
    config[2] = 30;
    problem = true;
  }
  
  if (config[3] > 1) { config[3] = 0; problem = true; }
  if (config[4] > 1) { config[4] = 0; problem = true; }
  if (config[5] > 1) { config[5] = 0; problem = true; }
  if (config[6] > 1) { config[6] = 0; problem = true; }
  
  saveBytes("config.dat", config);
  return problem;
}
