# li
ChatView = Backbone.View.extend

  tagName: 'li'

  initialize: (options) ->
    _.bindAll this, 'render'

  render: ->
    $(this.el).html "#{this.model.get('name')}: #{this.model.get('text')}"
    return this

# ul
ChatsView = Backbone.View.extend

  initialize: (options) ->
    this.model.bind 'add', this.addOne
    this.socket = options.socket

  events:
    "submit #messageForm" : "sendMessage"

  addOne: (chat) ->
    view = new ChatView(model: chat)
    $('#chat_list').prepend view.render().el

  received: (message) ->
    switch message.event
      when 'initial' 
        chats = this.model
        _.each message.data, (chat) ->
          unless chats.get(chat.id)?
            chats.add chat
      #when 'update' then this.clientCountView.model.updateClients message.clients
      when 'chat'
        chat = new models.Chat message.data
        this.model.add chat

  sendMessage: ->
    inputField = $('input[name=message]')
    chat = new models.Chat(text: inputField.val())
    this.socket.send chat.toJSON()
    inputField.val ''
