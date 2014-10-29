library webui.widgets.tabs.item;

import 'package:polymer/polymer.dart';

@CustomTag('webui-tabs-item')
class WebUiTabsItem extends PolymerElement {
  @published String label = "Default";
  
  @published bool active = false;
  
  WebUiTabsItem.created() : super.created() {
    
  }
  
  @override
  void domReady() {
    super.domReady();
  }
}