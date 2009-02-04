// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var j = jQuery.noConflict();

j(document).ready(function(){

  //focus
  j("textarea[is_focus]").focus();

  //answer timer
  if(j("#time_remain").size() > 0){
    var showTime = Math.floor((j("#time_remain").attr("max_answer_time")/3));
    j("#time_remain").everyTime(1000, function(){
      var time_eclipsed = j(this).text() - 1;
      j(this).text(time_eclipsed);
      if(time_eclipsed==showTime)
        j("#time_warning").show();
      if(time_eclipsed==0)
        j(this).stopTime();
    });
  }

  //facebox lightbox
  j('a[rel*=facebox]').facebox();
});
