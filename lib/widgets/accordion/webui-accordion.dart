library webui.widgets.accordion;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'webui-accordion-item.dart';
//import 'package:template_binding/template_binding.dart' as tb;

@CustomTag('webui-accordion')
class WebUiAccordion extends PolymerElement {
  @observable Iterable<Element> get widgets => children.where((e) => (e is WebUiAccordionItem));
  
  WebUiAccordion.created() : super.created() {
    
  }
  
  @override
  void domReady() {
    super.domReady();
  }
}