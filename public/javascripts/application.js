// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var j = jQuery.noConflict();

j(document).ready(function(){

  //facebox lightbox(avoid enter key triggle another facebox):w
  j('a[rel*=facebox]').focus(function(){j(this).blur();});

  j(document).bind('reveal.facebox', function(){
    //focus
    j(":input[is_focus]").focus();

    //answer timer
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

    //clear default tip
    j('#commit').click(function(){
      j('#answer_content, #question_content').each(function(){
        if(j(this).val()==j(this).attr("tip"))
          j(this).val("");
      });
    });

    //enter as tab
    var input = j(':input');
    input.keypress(function(e){
        if(e.keyCode==13){
          var index = input.index(this);
          if(index!=(input.size()-1)){
            input.eq(index+1).focus();
            return false;
          }
        }
    });
  });
});
