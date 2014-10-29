library webui.layout.dock;

import 'package:polymer/polymer.dart';
import 'dart:html';
//import '../widgets/panel/webui-panel.dart';
import '../widgets/tabs/webui-tabs-item.dart';
import '../util.dart';

@CustomTag('webui-dock')
class WebUiDock extends PolymerElement with NthChildSelector {
  @published bool tabbed = false;
  
  //@ComputedProperty('filterChildren(children)')
  //get widgets => readValue(#widgets);
  get widgets => children.where((e) => (!(e is TemplateElement))).toList();
  
  MutationObserver _observer;
  
  WebUiDock.created() : super.created() {
    _observer = new MutationObserver(_onMutation);
    _observer.observe(this, childList: true, attributes: true, subtree: false);
  }
  
  //filterChildren(list) {
  //  return list.where((e) => (!(e is TemplateElement)));
  //}
  
  _onMutation(List<MutationRecord> changes, MutationObserver) {
    changes.forEach((MutationRecord change) {
      notifyPropertyChange(#widgets, null, children);
    });
    // Observable.dirtyCheck
     
    removeClasses(children);
    addClasses(children);
    // Might not be needed...
    //deliverChanges();
  }
  
  isTabItem(item) {
    return item is WebUiTabsItem;
  }
  
  void domReady() {
    super.domReady();
    
    addClasses(children);
    
    if(tabbed)
      classes.add('tabbed');
  }
}