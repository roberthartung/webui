library webui.layout;

import 'package:polymer/polymer.dart';
import 'dart:html';
//import 'package:template_binding/template_binding.dart' as tb;
//import 'webui-dock.dart';

@CustomTag('webui-layout')
class WebUiLayout extends PolymerElement {
  WebUiLayout.created() : super.created() {
    //Element dragTarget = null;
    this.onDragStart.listen((MouseEvent ev) {
      // print(ev.path.first.href);
      // tb.TemplateInstance ti = tb.nodeBind(ev.path.first).templateInstance;
      // dragTarget = ti.model.value.clone(true);
      // tb.TemplateInstance ti2 = tb.nodeBind(ti.model.value).templateInstance;
      // print(ti.model.value.runtimeType);
      // ti2.model.value.value
    });
    /*
    this.onDragEnter.listen((MouseEvent ev) {
      if(ev.target is WebUiDock && dragTarget != null) {
        WebUiDock dock = ev.target as WebUiDock;
        print('onDragEnter ${dock.id}');
        dock.append(dragTarget);
        dock.deliverChanges();
      }
    });
    
    this.onDragLeave.listen((MouseEvent ev) {
      if(ev.target is WebUiDock && dragTarget != null) {
        WebUiDock dock = ev.target as WebUiDock;
        print('onDragLeave ${dock.id}');
        dragTarget.remove();
      }
    });
    
    this.onDrop.listen((Event ev) {
      if(ev.target is WebUiDock) {
        print('drop');
      } else {
        dragTarget.remove();
      }
      dragTarget = null;
    });
     */
  }
}