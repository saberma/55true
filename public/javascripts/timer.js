// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var j = jQuery.noConflict();

j(document).ready(function(){
  j("textarea").focus(function(){
    var index = j("textarea").index(this);
    j(".tip li").eq(index).effect("highlight", {color:"#0078A7"}, 2000);
  });
  j("textarea[is_focus]").focus();
});