library webui.layout.container;

import 'package:polymer/polymer.dart';

@CustomTag('webui-layout-container')
class WebUiLayoutContainer extends PolymerElement {
  @published bool horizontal = true;
  
  @published bool vertical = false;
  
  WebUiLayoutContainer.created() : super.created() {
    
  }
}