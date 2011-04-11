ChatView = Backbone.View.extend
  tagName: 'li'
  initialize: (options) ->
    _.bindAll this, 'render'
    # 关联的model变化时调用render渲染视图
    this.model.bind 'all', this.render
  render: ->
    $(this.el).html "#{this.model.get('name')}: #{this.model.get('text')}"
    return this

ClientCountView = Backbone.View.extend
  initialize: (options) ->
    _.bindAll this, 'render'
    this.model.bind 'all', this.render
  render: ->
    this.el.html this.model.get("clients")
    return this

NodeChatView = Backbone.View.extend
  initialize: (options) ->
    this.model.chats.bind 'add', this.addChat
    this.socket = options.socket
    this.clientCountView = new ClientCountView(model: new models.ClientCountModel(), el: $('#client_count'))

  events:
    "submit #messageForm" : "sendMessage"

  addChat: (chat) ->
    view = new ChatView(model: chat)
    $('#chat_list').append view.render().el

  msgReceived: (message) ->
    switch message.event
      when 'initial' then this.model.mport message.data
      when 'update' then this.clientCountView.model.updateClients message.clients
      when 'chat'
        newChatEntry = new models.ChatEntry()
        newChatEntry.mport message.data
        this.model.chats.add newChatEntry

  sendMessage: ->
    inputField = $('input[name=message]')
    chatEntry = new models.ChatEntry(text: inputField.val())
    this.socket.send chatEntry.xport()
    inputField.val ''
