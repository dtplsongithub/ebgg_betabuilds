class MaskImage {
  PImage image, mask;
  public MaskImage(String filename, String extension) {
    this.image = loadImage(filename+extension);
    log.loaded("asset "+filename+extension);
    this.mask = loadImage(filename+"_"+extension);
    log.loaded("asset "+filename+"_"+extension);
    try {
      image.mask(mask);
    } catch (NullPointerException e) {
      log.error("No file "+filename+extension+" or "+filename+"_"+extension+" was found", true);
      return;
    }
  }
}

MaskImage bigsteps;
boolean bigstepsappear = true;
