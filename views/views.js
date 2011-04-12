var ChatView, ChatsView;
ChatView = Backbone.View.extend({
  tagName: 'li',
  initialize: function(options) {
    return _.bindAll(this, 'render');
  },
  render: function() {
    $(this.el).html("" + (this.model.get('name')) + ": " + (this.model.get('text')));
    return this;
  }
});
ChatsView = Backbone.View.extend({
  initialize: function(options) {
    this.model.bind('add', this.addOne);
    return this.socket = options.socket;
  },
  events: {
    "submit #messageForm": "sendMessage"
  },
  addOne: function(chat) {
    var view;
    view = new ChatView({
      model: chat
    });
    return $('#chat_list').append(view.render().el);
  },
  received: function(message) {
    var chat;
    switch (message.event) {
      case 'initial':
        return this.model.add(message.data);
      case 'chat':
        chat = new models.Chat(message.data);
        return this.model.add(chat);
    }
  },
  sendMessage: function() {
    var chat, inputField;
    inputField = $('input[name=message]');
    chat = new models.Chat({
      text: inputField.val()
    });
    this.socket.send(chat.toJSON());
    return inputField.val('');
  }
});