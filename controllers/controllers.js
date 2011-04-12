var NodeChatController;
NodeChatController = {
  init: function() {
    var view;
    this.socket = new io.Socket(null, {
      port: 3000
    });
    this.model = new models.Chats();
    this.view = new ChatsView({
      model: this.model,
      socket: this.socket,
      el: $('#main')
    });
    view = this.view;
    this.socket.on('message', function(msg) {
      return view.received(msg);
    });
    this.socket.connect();
    this.view.render();
    return this;
  }
};
$(document).ready(function() {
  return window.app = NodeChatController.init({});
});