var ChatView, ClientCountView, NodeChatView;
ChatView = Backbone.View.extend({
  tagName: 'li',
  initialize: function(options) {
    _.bindAll(this, 'render');
    return this.model.bind('all', this.render);
  },
  render: function() {
    $(this.el).html("" + (this.model.get('name')) + ": " + (this.model.get('text')));
    return this;
  }
});
ClientCountView = Backbone.View.extend({
  initialize: function(options) {
    _.bindAll(this, 'render');
    return this.model.bind('all', this.render);
  },
  render: function() {
    this.el.html(this.model.get("clients"));
    return this;
  }
});
NodeChatView = Backbone.View.extend({
  initialize: function(options) {
    this.model.chats.bind('add', this.addChat);
    this.socket = options.socket;
    return this.clientCountView = new ClientCountView({
      model: new models.ClientCountModel(),
      el: $('#client_count')
    });
  },
  events: {
    "submit #messageForm": "sendMessage"
  },
  addChat: function(chat) {
    var view;
    view = new ChatView({
      model: chat
    });
    return $('#chat_list').append(view.render().el);
  },
  msgReceived: function(message) {
    var newChatEntry;
    switch (message.event) {
      case 'initial':
        return this.model.mport(message.data);
      case 'update':
        return this.clientCountView.model.updateClients(message.clients);
      case 'chat':
        newChatEntry = new models.ChatEntry();
        newChatEntry.mport(message.data);
        return this.model.chats.add(newChatEntry);
    }
  },
  sendMessage: function() {
    var chatEntry, inputField;
    inputField = $('input[name=message]');
    chatEntry = new models.ChatEntry({
      text: inputField.val()
    });
    this.socket.send(chatEntry.xport());
    return inputField.val('');
  }
});