var Msg = {
  receive:function(data){
    //var type = data['type'];
    if(data['system'])
      this.show_system(data);
    else
      this.show(data);
  },

  show_system:function(data){
    var content = data['system'];
    $('<li class="system"/>').html(content).appendTo('#chats > ul');
    $('#chats').scrollTop($('#chats').height());
  },

  show:function(data){
    var content = data['content'];
    $("#chats > ul").append(content);
    $('#chats').scrollTop($('#chats').height());
  },

  send:function(){
    var text = $("#entry > :text");
    if (text.val() != ''){ 
      $.post('/publish', {content: text.val()});
    }
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
