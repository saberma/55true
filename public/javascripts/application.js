// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var j = jQuery.noConflict();

j(document).ready(function(){
  //click a textarea box, highlight the tip
  j("textarea").focus(function(){
    var index = j("textarea").index(this);
    j(".tip li").eq(index).effect("highlight", {color:"#0078A7"}, 2000);
  });

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

});