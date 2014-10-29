library webui.widgets.accordion.item;

import 'package:polymer/polymer.dart';

@CustomTag('webui-accordion-item')
class WebUiAccordionItem extends PolymerElement {
  @published String label = "";
  
  WebUiAccordionItem.created() : super.created() {
    
  }
}