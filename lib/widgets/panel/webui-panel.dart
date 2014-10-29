library webui.widgets.panel;

import 'package:polymer/polymer.dart';

@CustomTag('webui-panel')
class WebUiPanel extends PolymerElement {
  @published String label = "";
  
  WebUiPanel.created() : super.created() {
    
  }
  
  @override
  void domReady() {
    super.domReady();
  }
}