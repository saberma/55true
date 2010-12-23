var Msg = {
  receive:function(data){
    //var type = data['type'];
    if(data['system'])
      this.show_system(data);
    else if(data['question'])
      this.show_question(data);
    else
      this.show(data);
    $('#chats').scrollTop($('#chats')[0].scrollHeight);
  },

  show_question:function(data){
    this.show(data);
    if(current_user_id == data['a_user_id'])
      $('#notice').text('请回答问题:' + data['question']).show();
  },

  show_system:function(data){
    var content = data['system'];
    $('<li class="system"/>').html(content).appendTo('#chats > ul');
  },

  show:function(data){
    var content = data['content'];
    $("#chats > ul").append(content);
  },

  send:function(){
    var text = $("#entry > :text");
    if (text.val() != ''){ 
      $.post('/publish', {content: text.val()});
    }
    $('#notice').hide();
    text.focus().val('');
  }
};

var jug = new Juggernaut();

jug.on("connect", function(){ Msg.receive({system:"已连接服务器."}) });
jug.on("disconnect", function(){ Msg.receive({system:"已与服务器断开连接."}) });

jug.subscribe("chat", function(data){ Msg.receive(data); });

$('#entry :text').keypress(function(e){
  if(e.which == 13) Msg.send();
});

$('#msg').focus();
