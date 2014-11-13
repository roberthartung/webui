library webui.contextmenu.item;

import 'package:polymer/polymer.dart';

@CustomTag('webui-contextmenu-item')
class WebUiContextMenuItem extends PolymerElement {
  @published bool disabled = false;
  
  WebUiContextMenuItem.created() : super.created() {
    
  }
}