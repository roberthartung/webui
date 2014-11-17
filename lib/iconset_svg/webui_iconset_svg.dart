library webui.iconset.svg;

import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('webui-iconset-svg')
class WebUiIconSetSvg extends PolymerElement {
  @published String width;
  
  @published String height;
  
  WebUiIconSetSvg.created() : super.created() {
    
  }
  
  Element cloneIcon() {
    Element svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    // TODO(rh) 
    return svg;
  }
}