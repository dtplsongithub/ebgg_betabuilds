class AwtProgram1 {
  JFrame window2;
  public AwtProgram1() {
    window2 = new JFrame("ebgg");
    window2.setSize(800, 600);
    window2.setLocation(500, 100);
    window2.setResizable(false);
    window2.setAlwaysOnTop(true);

    JTabbedPane tabPanel = new JTabbedPane();

    JPanel page1 = new JPanel(new BorderLayout());
    page1.setBorder(BorderFactory.createEmptyBorder());

    JEditorPane textArea = new JEditorPane();
    textArea.setContentType("text/html");
    textArea.setText(whatsnew);
    textArea.setEditable(false);
    String cssRules = "body { font-family: "+ textArea.getFont().getFamily() +"; font-size: "+textArea.getFont().getSize()+"; background-color: #FFFFCC} "+
  "h1 {color: #440099}"+
  "strong {color: #330000}"+
  "a {color: #000077}";
    ((HTMLDocument)textArea.getDocument()).getStyleSheet().addRule(cssRules);

    textArea.addHyperlinkListener(new HyperlinkListener() {
      @Override
        public void hyperlinkUpdate(HyperlinkEvent hle) {
        if (HyperlinkEvent.EventType.ACTIVATED.equals(hle.getEventType())) {
          Desktop desktop = Desktop.getDesktop();
          try {
            desktop.browse(hle.getURL().toURI());
          }
          catch (Exception e) {
            showError(e+"", true);
          }
        }
      }
    }
    );

    JScrollPane scrollPane = new JScrollPane(textArea);
    page1.add(scrollPane, BorderLayout.CENTER);




    JPanel page2 = new JPanel(new BorderLayout());
    page2.setBorder(BorderFactory.createEmptyBorder());

    JTextPane textArea2 = new JTextPane();
    textArea2.setContentType("text/html");
    ((HTMLDocument)textArea2.getDocument()).getStyleSheet().addRule("body { font-family: "+ textArea.getFont().getFamily() +"; font-size: "+textArea.getFont().getSize()+"}");
    textArea2.setText(about);
    textArea2.setEditable(false);
    textArea2.setBackground(new Color(#FFEEFF));

    textArea2.addHyperlinkListener(new HyperlinkListener() {
      @Override
        public void hyperlinkUpdate(HyperlinkEvent hle) {
        if (HyperlinkEvent.EventType.ACTIVATED.equals(hle.getEventType())) {
          Desktop desktop = Desktop.getDesktop();
          try {
            desktop.browse(hle.getURL().toURI());
          }
          catch (Exception e) {
            showError(e+"", true);
          }
        }
      }
    }
    );

    JScrollPane scrollPane2 = new JScrollPane(textArea2);
    page2.add(scrollPane2, BorderLayout.CENTER);

    tabPanel.addTab("What's new", page1);
    tabPanel.addTab("About", page2);
    window2.add(tabPanel);


    window2.setVisible(false);
  }
}

class AwtProgramSettings {
  JFrame settings;
  Checkbox[] chset = new Checkbox[7];
  JSlider[] jsset = new JSlider[2];
  JLabel[] ttset = new JLabel[3];
  JLabel[] olset = new JLabel[1];
  JComboBox<String> o6set; // initialization is in constructor below
  public AwtProgramSettings() {
    settings = new JFrame("settings");
    settings.setSize(600, 450);
    settings.setLocation(500, 100);
    settings.setResizable(false);
    settings.setAlwaysOnTop(true);

    JPanel panel = new JPanel(new BorderLayout());
    panel.setBorder(BorderFactory.createEmptyBorder());

    int[] temporder = new int[4];
    int i = 0;
    int yoffset = 0;
    for (char s : settingsType.toCharArray()) {
      final int finali = i;
      switch (s) {
        case 'c':
          chset[temporder[0]] = new Checkbox(settingsDescription[i], boolean(config[i+1]));
          chset[temporder[0]].setBounds(30, 40+i*20+yoffset, 400, 20);
          chset[temporder[0]].addItemListener(new ItemListener() {
            public void itemStateChanged(ItemEvent e) {
              config[finali+1] = byte(int(e.getStateChange()==1));
            }
          });
          settings.add(chset[temporder[0]]);
          if (settingsHelp[i]!="") {
            ttset[temporder[2]] = new JLabel(settingsHelp[i].indexOf("!") == 0 ? "!" : "?");
            ttset[temporder[2]].setBounds(10, 40+i*20+yoffset, 200, 20);
            ttset[temporder[2]].setToolTipText(settingsHelp[i]);
            settings.add(ttset[temporder[2]]);
            temporder[2]++;
          };
          temporder[0]++;
          break;
        case 's':
          final int temporder1 = temporder[1];
          jsset[temporder[1]] = new JSlider(o5[0], o5[1], o5[2]);
          jsset[temporder[1]].setBounds(30, 60+i*20+yoffset, 300, 50);
          jsset[temporder[1]].setPaintTrack(true);
          jsset[temporder[1]].setPaintTicks(true);
          //jsset[temporder[1]].setPaintLabels(true);
          jsset[temporder[1]].setMajorTickSpacing(50);
          jsset[temporder[1]].setMinorTickSpacing(10);
          jsset[temporder[1]].addChangeListener(new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
              config[finali+1] = byte(jsset[temporder1].getValue());
            }
          });
          settings.add(jsset[temporder[1]]);
          olset[temporder[1]] = new JLabel(settingsDescription[i]);
          olset[temporder[1]].setBounds(30, 40+i*20+yoffset, 200, 20);
          settings.add(olset[temporder[1]]);
          temporder[1]++;
          yoffset+=50;
          break;
        case 'd':
          o6set = new JComboBox<String>(o6);
          o6set.setBounds(300, 40+i*20+yoffset, 100, 16);
          o6set.setVisible(true);
          if (settingsHelp[i]!="") {
            ttset[temporder[2]] = new JLabel(settingsHelp[i].indexOf("!") == 0 ? "!" : "?");
            ttset[temporder[2]].setBounds(10, 40+i*20+yoffset, 200, 20);
            ttset[temporder[2]].setToolTipText(settingsHelp[i]);
            settings.add(ttset[temporder[2]]);
            temporder[2]++;
          };
          settings.add(o6set);
          JLabel o6label = new JLabel(settingsDescription[6]);
          o6label.setBounds(30, 40+i*20+yoffset, 999, 16);
          settings.add(o6label);
      }
      i++;
    }
    
    JButton svset = new JButton("save");
    svset.setBounds(30, 350, 100, 20);
    svset.addActionListener(new ActionListener(){  
      public void actionPerformed(ActionEvent e){
        saveBytes("config.dat", config);
        settings.setVisible(false); 
      }  
    });  
    
    settings.add(svset);
    
    JScrollPane spset = new JScrollPane(panel);

    settings.add(spset, BorderLayout.CENTER);
    settings.setVisible(false);
  }
}

JFrame errhandler = new JFrame();
void showError(String error, boolean critical) {
  errhandler.setVisible(true);
  if (errorIsBeingShown) return;
  errorIsBeingShown = true;
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, error+(critical?". The application will now close.":""), "Error", JOptionPane.ERROR_MESSAGE);
      errhandler.setVisible(false);
      errorIsBeingShown = false;
      if (critical) logexit();
    }
  });
}
void showWarning(String error) {
  errhandler.setVisible(true);
  if (warnIsBeingShown) return;
  warnIsBeingShown = true;
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, error, "Warning", JOptionPane.WARNING_MESSAGE);
      errhandler.setVisible(false);
      warnIsBeingShown = false;
    }
  });
}
void showInfo(String info) {
  errhandler.setVisible(true);
  if (warnIsBeingShown) return;
  warnIsBeingShown = true;
  EventQueue.invokeLater(new Runnable() {
    @Override
    public void run() {
      JOptionPane.showMessageDialog(errhandler, info, "Message", JOptionPane.PLAIN_MESSAGE);
      errhandler.setVisible(false);
      warnIsBeingShown = false;
    }
  });
}
