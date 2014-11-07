library webui.util.property.wrapper;

import 'package:polymer/polymer.dart';

@CustomTag('webui-property-wrapper')
class WebUiPropertyWrapper extends PolymerElement {
  @published String label;
  
  @published var model;
  
  @published String property;
  
  @published String type = "int";
  
  @published bool slider = false;
  
  @reflectable
  get value => model[property];
  
  @reflectable
  set value(v) => model[property] = v; 
  
  WebUiPropertyWrapper.created() : super.created() {
    
  }
  
  void domReady() {
    super.domReady();
    model.changes.listen((records) {
      notifyPropertyChange(#value, null, true);
    });
  }
}