final String TIMESTAMP = ""+year()+nf(month(), 2)+nf(day(), 2)+"_"+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
// %yyyy-%mm-%dd %hh:%mm:%ss
LOGFILE log;

void logexit() {
  log.log("exiting...");
  saveStrings("log.log", log.logstrings);
  exit();
}

String CURRENT_TIMESTAMP() {
  return ""+year()+nf(month(), 2)+nf(day(), 2)+"_"+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
}

String TIMESTAMP_DETAIL() {
  return ""+year()+"/"+nf(month(), 2)+"/"+nf(day(), 2)+"\u0009"+nf(hour(), 2)+":"+nf(minute(), 2)+":"+nf(second(), 2);
}

class LOGFILE {
  String[] logstrings = {};
  public void log(String what) {
    logstrings = append(logstrings, "["+TIMESTAMP_DETAIL()+"\u0009frame "+realt+" \u0009\u0009"+millis()+" ms]\u0009"+" DEBUG:\u0009\u0009"+what);
  }
  public void error(String what, boolean critical) {
    logstrings = append(logstrings, "["+TIMESTAMP_DETAIL()+"\u0009frame "+realt+" \u0009\u0009"+millis()+" ms]\u0009"+" ERROR:\u0009\u0009"+what);
    showError(what, critical);
  }
  public void warn(String what) {
    logstrings = append(logstrings, "["+TIMESTAMP_DETAIL()+"\u0009frame "+realt+" \u0009\u0009"+millis()+" ms]\u0009"+" WARNING:\u0009"+what);
    showWarning(what);
  }
  public void created(String what) {
    logstrings = append(logstrings, "["+TIMESTAMP_DETAIL()+"\u0009frame "+realt+" \u0009\u0009"+millis()+" ms]\u0009"+" CREATED:\u0009"+what);
  }
  public void loaded(String what) {
    logstrings = append(logstrings, "["+TIMESTAMP_DETAIL()+"\u0009frame "+realt+" \u0009\u0009"+millis()+" ms]\u0009"+" LOADED:\u0009"+what);
  }
}
