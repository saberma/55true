// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var j = $;                                                                                                                                                                       
if($ != jQuery)
  j = jQuery.noConflict();

tooltip_setting = {
  tip: '#tooltip',
  position: ['center','right'],
  offset: [0, 0],
  effect: 'toggle',
  delay: 0,
  opacity: 0.9,
  onBeforeShow: function(){
    j('#tooltip').html('正在处理...');
    var url = this.getTrigger().parent().attr('href') + '/panel';
    j.get(url, function(body){
      j('#tooltip').html(body);
      j('#tooltip a[rel*=facebox]').facebox();
    });
  }
};

//获取最新记录
var interval = '8s';
var hits = 0;
var completed = true;
//get new answer
var getLatest = function(){
  if(!completed){
    return true;
  }else{
    completed = false;
  }
  var current_li = j('li:first',j('#all'));
  var last_id = current_li.attr('last_id')
  var odd = current_li.attr('class') == 'even' ? 'odd':'even';
  var url = '/answers/' + last_id + '.js?cycle=' + odd + '&pv=f&time=' + new Date().getTime();
  j.get(url, function(js){eval(js)});
}

//get new msg
var getMsg = function(){
  if(j('.message').size()==0)
    j.get('/messages', function(js){eval(js)});
}

//顶
var populate = function(obj){
  $(obj).text('=已顶=').removeAttr('onclick');
}

j(document).ready(function(){
  //facebox lightbox(avoid enter key triggle another facebox)
  j('a[rel*=facebox]').focus(function(){j(this).blur();});

  j(document).bind('reveal.facebox', function(){
    //focus
    j(":input[is_focus]").focus();

    //can switch to register
    j('#facebox a[rel*=facebox]').facebox();
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

    //enter2tab
    var input = j(':input');
    input.keypress(function(e){
        if(e.keyCode==13){
          var index = input.index(this);
          //it's a button, stop focus to next
          if(index!=(input.size()-1) && this.type!="submit"){
            input.eq(index+1).focus();
            return false;
          }
        }
    });

    //timer
    j("#time_remain").everyTime(10000, function(){
      var time_eclipsed = j(this).text() - 1;
      j(this).text(time_eclipsed);
      if(time_eclipsed==showTime)
        j("#time_warning").show();
      if(time_eclipsed==0)
        j(this).stopTime();
    });
  });

  //show user's panel
  j('.head,.mini_head').tooltip(tooltip_setting);
});
