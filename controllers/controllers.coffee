# Controllers
NodeChatController =
  init: ->
    this.socket = new io.Socket null, port: 3000

    this.model = new models.NodeChatModel()
    this.view = new NodeChatView model: this.model, socket: this.socket, el: $('#main')
    view = this.view

    this.socket.on 'message', (msg) -> view.msgReceived msg
    this.socket.connect()

    this.view.render()
    return this

# Bootstrap the app
$(document).ready -> window.app = NodeChatController.init({})
