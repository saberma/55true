###
~/redis-2.2.4/src/redis-server ~/redis-2.2.4/redis.conf
coffee --bare --compile --watch *.coffee *\/*.coffee
nodemon server.js
###

###
npm install express jade stylus
npm install socket.io underscore backbone redis
npm install connect-redis hash joose joosex-namespace-depended
***** development *****
npm install nodemon coffee-script
###

###
http://fzysqr.com/2011/02/28/nodechat-js-using-node-js-backbone-js-socket-io-and-redis-to-make-a-real-time-chat-app/
http://fzysqr.com/2011/03/27/nodechat-js-continued-authentication-profiles-ponies-and-a-meaner-socket-io/
http://joyeur.com/2010/09/15/installing-a-node-service-on-a-joyent-smartmachine/
###

###
https://my.joyent.com/smartmachines
ssh node@64.30.137.17
git push node master
###

# Module dependencies.

express = require 'express'

app = module.exports = express.createServer()
socket = require('socket.io').listen app
redis = require 'redis'
rc = redis.createClient()
_ = require('underscore')._
models = require './models/models'

# Configuration

app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.set 'view options', layout: false
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session secret: 'secret 55true'
  app.use require("stylus").middleware(src: "#{__dirname}/public", compress: true)
  app.use app.router
  app.use express.static "#{__dirname}/public"

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

#访问modes,controllers,views目录
app.get '/*.(js|css)', (req, res) ->
  res.sendfile "./#{req.url}"

# Socket
activeClients = 0
chats = new models.Chats()

# 从redis中获取前10条消息
#rc.del 'chatentries'
rc.lrange 'chatentries', -10, -1, (err, data) ->
  if err
    console.log "Error: #{err}"
  else if data
    _.each data, (jsonChat) ->
      chat = new models.Chat(JSON.parse(jsonChat))
      chats.add chat
    console.log "Revived #{chats.length} chats"
  else
    console.log 'No data returned for key'

#连接
socket.on 'connection', (client) ->
  activeClients += 1
  client.on 'disconnect', ->
    activeClients -= 1
    client.broadcast event: 'update', clients:activeClients
  client.on 'message', (msg) ->
    chatMessage client, socket, msg
  client.send event: 'initial', data: chats.toJSON()
  socket.broadcast event: 'update', clients: activeClients

#聊天内容
chatMessage = (client, socket, msg) ->
  chat = new models.Chat(msg)
  rc.incr 'next.chatentry.id', (err, newId) ->
    chat.set id: newId
    console.log chat.toJSON()
    chats.add chat
    rc.rpush 'chatentries', JSON.stringify(chat.toJSON()), redis.print
    socket.broadcast event: 'chat', data: chat.toJSON()

# Routes

app.get '/', (req, res) ->
  res.render 'index', title: 'Express', layout: true

# Only listen on $ node app.js

unless module.parent
  app.listen 3000
  console.log "Express server listening on port %d", app.address().port
