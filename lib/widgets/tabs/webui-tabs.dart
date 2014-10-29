library webui.widgets.tabs;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'webui-tabs-item.dart';
import 'package:template_binding/template_binding.dart' as tb;
// for streams
import 'dart:async';

@CustomTag('webui-tabs')
class WebUiTabs extends PolymerElement { 
  Iterable<Element> get widgets => children.where((Element e) => (e is WebUiTabsItem)); 
  // Iterable<Element> get widgets => children.where((Element e) => !(e is TemplateElement)).map((Element e) => e is ContentElement ? (e.getDistributedNodes().length > 0 ? e.getDistributedNodes().first : e) : e);
  
  StreamController<WebUiTabsItem> _onActiveTabChangedController = new StreamController<WebUiTabsItem>.broadcast();
  
  Stream<WebUiTabsItem> get onActiveTabChanged =>  _onActiveTabChangedController.stream;
  
  MutationObserver _observer;
  
  WebUiTabsItem activeItem = null;
  
  WebUiTabs.created() : super.created() {
    _observer = new MutationObserver(_onMutation);
    _observer.observe(this, childList: true);
  }
  
  _onMutation(List<MutationRecord> changes, MutationObserver) {
    changes.forEach((MutationRecord change) {
      notifyPropertyChange(#widgets, change.oldValue, widgets);
    });
    //deliverChanges();
    //Observable.dirtyCheck();
  }
  
  void _setActiveTab(WebUiTabsItem item) {
    if(activeItem != null) {
      if(activeItem == item) {
         return;
      }
      activeItem.active = false;
    }
    activeItem = item;
    activeItem.active = true;
    _onActiveTabChangedController.add(activeItem);
    fire('active-tab-changed', detail: {'item': activeItem});
  }
  
  @override
  void attached() {
    super.attached();
  }
  
  @override
  void domReady() {
    super.domReady();
    
    var activeItems = widgets.where((WebUiTabsItem item) => item.active == true);
    if(activeItems.length == 0) {
      if(widgets.length > 0) {
        _setActiveTab(widgets.first as WebUiTabsItem);
      }
    } else {
      _setActiveTab(activeItems.first);
    }
  }
  
  void showTab(MouseEvent ev, x, AnchorElement el) {
    ev.preventDefault();
    tb.TemplateInstance ti = tb.nodeBind(ev.target).templateInstance;
    _setActiveTab(ti.model.value as WebUiTabsItem);
  }
}