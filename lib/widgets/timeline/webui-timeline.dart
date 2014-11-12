library webui.widgets.timeline;

import 'package:polymer/polymer.dart';
import '../panel/webui-panel.dart';
import 'webui-timeline-item.dart';
import 'dart:html';
import 'dart:async';
import 'package:template_binding/template_binding.dart' as tb;

@CustomTag('webui-timeline')
class WebUiTimeline extends WebUiPanel {
  @published String zoom = "10";
  
  @published int max = 0;
  
  @published int cursor = 0;
  
  @ComputedProperty('zoom')
  int get getZoom => int.parse(zoom);
  
  @ComputedProperty('zoom*max')
  int get timelineInnerWidth => max * getZoom;
  
  @ComputedProperty('cursor*getZoom')
  int get cursorPosition => getZoom * cursor;
  
  MutationObserver _observer;
  
  @observable String background;
    
  WebUiTimeline.created() : super.created() {
    _observer = new MutationObserver(_onMutation);
    _observer.observe(this, childList: true, attributes: true, subtree: true);
    onPropertyChange(this, #zoom, () {
      CanvasElement canvas = new CanvasElement(width: int.parse(zoom), height: 1);
      CanvasRenderingContext2D ctx = canvas.getContext('2d');
      ctx.strokeStyle = 'white';
      ctx.beginPath();
      ctx.moveTo(int.parse(zoom)-.5, 0);
      ctx.lineTo(int.parse(zoom)-.5, 1);
      ctx.closePath();
      ctx.stroke();
      background = canvas.toDataUrl();
    });
    /*
    onPropertyChange(this, #zoom, () {
      notifyPropertyChange(#getZoom, null, zoom);
    });
     
    onPropertyChange(this, #max, () {
      notifyPropertyChange(#getZoom, null, zoom);
    });
    */
    on['keyframe-clicked'].listen((CustomEvent ev) {
      int frame = ev.detail['keyframe'].frame;
      cursor = frame;
      Observable.dirtyCheck();
      deliverChanges();
      notifyPropertyChange(#cursor, null, cursor);
      print('set cursor: $frame');
      // TODO(rh) add actions
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
  
  int stringToInt(s) => int.parse(s);
  
  var _dragTarget = null;
  
  void attached() {
    super.attached();
    
    $['items-names'].onDragStart.listen((MouseEvent ev) {
      _dragTarget = ev.target;
    });
    
    $['items-names'].onDragEnd.listen((MouseEvent ev) {
      _dragTarget = null;
    });
    
    $['items-names'].onDragEnter.listen((MouseEvent ev) {
    });
    
    $['items-names'].onDragLeave.listen((MouseEvent ev) {
    });
    
    $['items-names'].onDragOver.listen((MouseEvent ev) {
      ev.preventDefault();
      return false;
    });
    
    $['items-names'].onDrop.listen((MouseEvent ev) {
      ev.stopPropagation();
      
      fire('webui-timeline-drop', detail: {'draggedNode': tb.nodeBind(_dragTarget).templateInstance.model.value as WebUiTimelineItem, 'dropTarget': tb.nodeBind(ev.target).templateInstance.model.value as WebUiTimelineItem});
      return false;
    });
  }
  
  @override
  void domReady() {
    super.domReady();
    
    $['list'].onScroll.listen((Event ev) {
      $['items'].scrollTop = $['list'].scrollTop;
    });
    
    $['items'].onScroll.listen((Event ev) {
      $['list'].scrollTop = $['items'].scrollTop;
    });
    
    $['cursor'].onMouseDown.listen((MouseEvent ev) {
      Point start = ev.page;
      int left = $['cursor'].offsetLeft;
      
      StreamSubscription stream = document.onMouseMove.listen((MouseEvent ev) {
        Point delta = ev.page - start;
        // $['cursor'].style.left = '${delta}px';
        // TODO(rh) cursor should never be < 1!
        cursor = (left + delta.x) ~/ getZoom;
        //p = ev.page;
      });
      
      document.onMouseUp.first.then((MouseEvent ev) {
        stream.cancel();
        start = null;
      });
    });
  }
  
  double keyframeLeft(String zoom) {
    return int.parse(zoom) / -2.0;
  }
}