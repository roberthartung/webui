library webui.menu.item;

import 'package:polymer/polymer.dart';

@CustomTag('webui-menu-item')
class WebUiMenuItem extends PolymerElement {
  @published String text;
  
  WebUiMenuItem.created() : super.created() {
    
  }
}