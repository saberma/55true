// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var j = jQuery.noConflict();

j(document).ready(function(){

  //focus
  j("textarea[is_focus]").focus();

  //facebox lightbox
  j('a[rel*=facebox]').facebox();

  //answer timer
  j(document).bind('reveal.facebox', function(){
    j('a[rel*=facebox]').facebox();
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

    //tip
    j('#answer_content, #question_content')
      .attr('tip',function(){return j(this).val()})
      .focus(function(){
        if(j(this).val()==j(this).attr("tip"))
          j(this).val("");
      });

    j('#commit').click(function(){
      j('#answer_content, #question_content').each(function(){
        if(j(this).val()==j(this).attr("tip"))
          j(this).val("");
      });
    });
  });
});
