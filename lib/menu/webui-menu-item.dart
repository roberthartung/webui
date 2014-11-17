library webui.menu.item;

import 'package:polymer/polymer.dart';

@CustomTag('webui-menu-item')
class WebUiMenuItem extends PolymerElement {
  @published String text;
  
  @published bool icon = false;
  
  WebUiMenuItem.created() : super.created() {
    
  }
}