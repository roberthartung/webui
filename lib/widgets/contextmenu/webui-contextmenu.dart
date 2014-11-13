library webui.contextmenu;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'webui-contextmenu-item.dart';

@CustomTag('webui-contextmenu')
class WebUiContextMenu extends PolymerElement {
  WebUiContextMenu.created() : super.created() {
    
  }
  
  var _detail;
  
  void show(Point p, [detail]) {
    style.left = '${p.x}px';
    style.top = '${p.y}px';
    style.display = 'block';
    _detail = detail;
    if(_detail == null) {
      _detail = {};
    }
    document.onClick.first.then((MouseEvent ev) {
      Element target = ev.path.first;
      if(target is WebUiContextMenuItem) {
        if(target.disabled == true) {
          ev.stopPropagation();
        } else {
          _detail['item'] = target;
          fire('webui-contextmenu', detail: _detail);
        }
      }
      hide();
    });
  }
  
  void hide() {
    style.display = 'none';
  }
}