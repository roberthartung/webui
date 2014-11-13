library webui.widgets.timeline;

import 'package:polymer/polymer.dart';
import '../panel/webui-panel.dart';
import '../contextmenu/webui-contextmenu.dart';
import '../contextmenu/webui-contextmenu-item.dart';
import 'webui-timeline-item.dart';
import 'webui-timeline-keyframe.dart';
import 'dart:html';
import 'dart:async';
import 'package:template_binding/template_binding.dart' as tb;

@CustomTag('webui-timeline')
class WebUiTimeline extends WebUiPanel {
  @published String zoom = "10";
  
  @published int max = 0;
  
  @published int cursor = 0;
  
  @published int fps = 60;
  
  @ComputedProperty('zoom')
  int get getZoom => int.parse(zoom);
  
  @ComputedProperty('zoom*max')
  int get timelineInnerWidth => max * getZoom;
  
  @ComputedProperty('(cursor)*getZoom - getZoom~/2')
  int get cursorPosition => getZoom * cursor - getZoom~/2;
  
  MutationObserver _observer;
  
  @observable String background;
  
  @observable String backgroundHeader;
  
  int stringToInt(s) => int.parse(s);
    
  var _dragTarget = null;
  
  /**
   * Created Constructor
   */
  
  WebUiTimeline.created() : super.created() {
    _observer = new MutationObserver(_onMutation);
    _observer.observe(this, childList: true, attributes: true, subtree: true);
    onPropertyChange(this, #zoom, _setTimelineBackground);

    on['keyframe-clicked'].listen(_onKeyFrameClicked);
  }
  
  /**
   * Called when the user clicks on a keyframe
   */
  
  _onKeyFrameClicked(CustomEvent ev) {
    int frame = ev.detail['keyframe'].frame;
    cursor = frame;
    Observable.dirtyCheck();
    deliverChanges();
    notifyPropertyChange(#cursor, null, cursor);
    print('set cursor: $frame');
    // TODO(rh) add actions
  }
  
  /**
   * Sets the background for the timeline
   */
  
  _setTimelineBackground() {
    int z = int.parse(zoom);
    CanvasElement canvas = new CanvasElement(width: z*5, height: 1);
    CanvasRenderingContext2D ctx = canvas.getContext('2d');
    
    ctx.fillStyle = '#999';
    ctx.fillRect(0, 0, z, 1);
    
    ctx.strokeStyle = '#333';
    for(int i=0;i<5;i++) {
      ctx.beginPath();
      double x = i*z+z-.5;
      ctx.moveTo(x, 0);
      ctx.lineTo(x, 1);
      ctx.closePath();
      ctx.stroke();
    }
    
    background = canvas.toDataUrl();
    
    CanvasElement canvasHeader = new CanvasElement(width: z*5, height:1);
    CanvasRenderingContext2D ctxHeader = canvasHeader.getContext('2d');
    ctxHeader.fillStyle = '#444';
    ctxHeader.fillRect(0, 0, z, 1);
        
    ctxHeader.strokeStyle = '#222';
    for(int i=0;i<5;i++) {
      ctxHeader.beginPath();
      double x = i*z+z-.5;
      ctxHeader.moveTo(x, 0);
      ctxHeader.lineTo(x, 1);
      ctxHeader.closePath();
      ctxHeader.stroke();
    }
    
    backgroundHeader = canvasHeader.toDataUrl();
  }
  
  _onMutation(List<MutationRecord> changes, MutationObserver) {
    changes.forEach((MutationRecord change) {
      notifyPropertyChange(#children, null, children);
    });
  }
  
  filterChildren(list) {
    return list.where((e) => e is WebUiTimelineItem).toList();
  }
  
  timelineIterator(m) {
    double endTime = m / fps;
    List times = [];
    double time = 0.0;
    while(time < endTime) {
      times.add((time*100.0).floor()/100.0);
      time += (5/fps);
    }
    return times;
  }
  
  /**
   * ##### Called when the element gets attached to the DOM
   */
  
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
    
    $['items'].onContextMenu.listen((MouseEvent e) {
      e.preventDefault();
      var items = e.path.where((e) => e is WebUiTimelineItem);
      if(items.length > 0) {
        Point offset = $['items'].offsetTo(document.body);
        Point diff = e.page - offset;
        num frame = ((diff.x + $['items'].scrollLeft) / getZoom).ceil();
        
        if(e.path.any((e) => e is WebUiTimelineKeyFrame)) {
          ($['contextmenu-keyframe-add'] as WebUiContextMenuItem).attributes['disabled'] = 'true';
          ($['contextmenu-keyframe-remove'] as WebUiContextMenuItem).attributes['disabled'] = 'false';
        } else {
          ($['contextmenu-keyframe-add'] as WebUiContextMenuItem).attributes['disabled'] = 'false';
          ($['contextmenu-keyframe-remove'] as WebUiContextMenuItem).attributes['disabled'] = 'true';
        }
        
        ($['contextmenu'] as WebUiContextMenu).show(e.page, {'frame':frame, 'timeline-item': items.first});
        // fire('webui-contextmenu', detail: );
      }
    });
  }
  
  /**
   * ##### Called when the dom is ready
   */
  
  @override
  void domReady() {
    super.domReady();
    
    $['list'].onScroll.listen((Event ev) {
      $['items'].scrollTop = $['list'].scrollTop;
    });
    
    $['items'].onScroll.listen((Event ev) {
      $['list'].scrollTop = $['items'].scrollTop;
      $['header'].scrollLeft = $['items'].scrollLeft;
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
    
    _setTimelineBackground();
  }
  
  double keyframeLeft(String zoom) {
    return int.parse(zoom) / -2.0;
  }
}