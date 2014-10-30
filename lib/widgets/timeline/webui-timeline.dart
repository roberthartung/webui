library webui.widgets.timeline;

import 'package:polymer/polymer.dart';
import '../panel/webui-panel.dart';
import 'webui-timeline-item.dart';
import 'dart:html';

@CustomTag('webui-timeline')
class WebUiTimeline extends WebUiPanel {
  @published String zoom = "1";
  
  @published int max = 0;
  
  @ComputedProperty('zoom')
  int get getZoom => int.parse(zoom);
  
  @ComputedProperty('zoom,max')
  int get timelineInnerWidth => max * getZoom;
  
  MutationObserver _observer;
    
  WebUiTimeline.created() : super.created() {
    _observer = new MutationObserver(_onMutation);
     _observer.observe(this, childList: true, attributes: true, subtree: true);
     
     onPropertyChange(this, #zoom, () {
       notifyPropertyChange(#getZoom, null, zoom);
     });
     
     on['keyframe-clicked'].listen((CustomEvent ev) {
       print(ev.detail);
     });
  }
  
  _onMutation(List<MutationRecord> changes, MutationObserver) {
    changes.forEach((MutationRecord change) {
      notifyPropertyChange(#children, null, children);
    });
  }
  
  filterChildren(list) {
    return list.where((e) => e is WebUiTimelineItem).toList();
  }
}