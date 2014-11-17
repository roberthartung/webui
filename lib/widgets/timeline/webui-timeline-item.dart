library webui.widgets.timeline.item;

import 'package:polymer/polymer.dart';
import 'webui-timeline-keyframe.dart';

@CustomTag('webui-timeline-item')
class WebUiTimelineItem extends PolymerElement {
  @published String name;
  
  @published var model;
  
  @published Object properties;
  
  @published bool collapsed = true;
  
  @observable ObservableMap spans;
  
  @published int max = 0;
  
  WebUiTimelineItem.created() : super.created() {
    /*onPropertyChange(this, #properties, () {
      // notifyPropertyChange(#animationSpans, null, animationSpans);
    });
    */
  }
  
  int maxKeyFrame() {
    int max = 0;
    filterChildren(children).forEach((WebUiTimelineKeyFrame keyFrame) {
      if(keyFrame.frame > max) {
        max = keyFrame.frame;
      }
    });
    return max;
  }
  
  List filterChildren(List list) {
    return list.where((item) => item is WebUiTimelineKeyFrame).toList();
  }
  
  void domReady() {
    super.domReady();
  }
}