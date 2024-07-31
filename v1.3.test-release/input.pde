void keyboardDetection(int kc, char k) {
  switch (menu) {
    case 5: {
      if (((kc >= 48 && kc <= 57) || (kc >= 65 && kc <= 90) || kc == 32) && backgroundName.length() < 32) {
        backgroundName += k;
      }
      if (kc == BACKSPACE && backgroundName.length() > 0) {
        backgroundName = backgroundName.substring(0, backgroundName.length()-1);
      }
      break;
    }
    case 8: {
      if (((kc >= 48 && kc <= 57)|| (kc >= 65 && kc <= 70)) && paletteEditTemp.length() < 7) {
        paletteEditTemp += k;
      }
      if (kc == BACKSPACE && paletteEditTemp.length() > 1) {
        paletteEditTemp = paletteEditTemp.substring(0, paletteEditTemp.length()-1);
      }
      break;
    }
  }
}
