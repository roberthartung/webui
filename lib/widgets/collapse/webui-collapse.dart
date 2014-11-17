library webui.widgets.collapse;

import 'package:polymer/polymer.dart';

@CustomTag('webui-collapse')
class WebUiCollapse extends PolymerElement {
  @published String label;
  
  @published String icon;
  
  @published bool collapsed = true;
  
  WebUiCollapse.created() : super.created() {
    
  }
  
  @override
  void domReady() {
    super.domReady();
  }
  
  void toggle(event, _, element) {
    collapsed = !collapsed;
    event.preventDefault();
  }
}