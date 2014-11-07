library webui.widgets.timeline.keyframe;

import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('webui-timeline-keyframe')
class WebUiTimelineKeyFrame extends PolymerElement {
  @published int frame = 0;
  
  @published int max;
  
  WebUiTimelineKeyFrame.created() : super.created() {
    onPropertyChange(this, #frame, () {
      _setPosition();
    });
    
    onPropertyChange(this, #max, () {
      _setPosition();
    });
    
    onClick.listen((MouseEvent ev) {
      ev.preventDefault();
      ev.stopPropagation();
      fire('keyframe-clicked', detail: {'keyframe': this, 'event': ev});
    });
  }
  
  void _setPosition() {
    //style.left = (frame/max*100).toString() + '%';
  }
  
  void domReady() {
    super.domReady();
    
    _setPosition();
  }
}