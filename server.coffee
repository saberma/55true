###
~/redis-2.2.4/src/redis-server ~/redis-2.2.4/redis.conf
coffee --bare --compile --watch *.coffee *\/*.coffee
nodemon server.js
###

###
npm install express jade stylus oauth connect-auth
npm install socket.io underscore backbone redis connect-redis
***** development *****
npm install nodemon coffee-script
###

###
http://fzysqr.com/2011/02/28/nodechat-js-using-node-js-backbone-js-socket-io-and-redis-to-make-a-real-time-chat-app/
http://fzysqr.com/2011/03/27/nodechat-js-continued-authentication-profiles-ponies-and-a-meaner-socket-io/
http://joyeur.com/2010/09/15/installing-a-node-service-on-a-joyent-smartmachine/
https://gist.github.com/771828
###

###
https://my.joyent.com/smartmachines
ssh node@64.30.137.17
git push node master
###

ID_RANGE=[0,1,2,3,4,5,6,7,8,9,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

# Confnig
try
  keys = require './keys_file'
  for key, value of keys
    global[key] = value
catch error
  console.log 'Unable to locate the keys_file.js file.  Please copy and ammend the example_keys_file.js as appropriate'
  return


# Module dependencies.

express = require 'express'
OAuth = require('oauth').OAuth
connect= require 'connect'
RedisStore = require 'connect-redis'
auth= require 'connect-auth'

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
  app.set 'view options', layout: true
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session secret: 'secret 55true', store: new RedisStore(maxAge: 24 * 60 * 60 * 1000)
  app.use require("stylus").middleware src: "#{__dirname}/public", compress: true
  app.use express.static "#{__dirname}/public"
  #put auth before app.router, or we will get:
  #TypeError: Object #<IncomingMessage> has no method 'authenticate'
  app.use auth [ auth.Sina consumerKey: sinaConsumerKey, consumerSecret: sinaConsumerSecret, callback: sinaCallbackAddress ]
  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

sina_auth = new OAuth "http://api.t.sina.com.cn/oauth/request_token",
  "http://api.t.sina.com.cn/oauth/access_token",
  sinaConsumerKey, sinaConsumerSecret,
  "1.0", sinaCallbackAddress, "HMAC-SHA1"

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
    #console.log chat.toJSON()
    chats.add chat
    rc.rpush 'chatentries', JSON.stringify(chat.toJSON()), redis.print
    socket.broadcast event: 'chat', data: chat.toJSON()

# MiddleWares
requireLogin = (req, res, next) ->
  if req.session.user
    next()
  else
    res.redirect '/'

# Routes

app.get '/', (req, res) ->
  if req.session.user
    res.redirect '/home'
  else
    res.render 'index'

app.get '/home', requireLogin, (req, res) ->
  rc.get "user:#{req.session.user.id}:party_id", (error, party_id) ->
    rc.get "party:#{party_id}", (error, party) ->
      res.render 'home', party: JSON.parse(party), host: req.header('Host')

app.get '/logout', (req, res) ->
  req.session.destroy ->
    res.redirect '/'

app.get '/auth/sina', (req, res) ->
  req.authenticate ['sina'], (error, authenticated) ->
    if authenticated
      sina_auth.getProtectedResource 'http://api.t.sina.com.cn/account/verify_credentials.json', 'GET', req.getAuthDetails()['sina_oauth_token'], req.getAuthDetails()['sina_oauth_token_secret'], (err, data)->
          if err then res.end "<html><pre>error = #{util.inspect(err)}</pre></html>"
          else
            user = JSON.parse data
            rc.hmset "users:#{user.id}", access_token: req.session.auth["sina_oauth_token"], secret_token: req.session.auth["sina_oauth_token_secret"], name: user.name, screen_name: user.screen_name
            req.session.user = user
            res.redirect '/'

# Party
app.post '/partys/new', requireLogin, (req, res) ->
  id = _.map([0,1,2,3], (n) -> ID_RANGE[ Math.floor(Math.random() * ID_RANGE.length) ]).join ''
  user = req.session.user
  rc.set "user:#{user.id}:party_id", "#{id}"
  rc.set "party:#{id}", JSON.stringify(id: id, user_id: user.id, user_name: user.name, created_at: new Date())
  rc.expire "user:#{user.id}:party_id", 10
  rc.expire "party:#{id}", 10
  res.redirect '/home'

app.get '/:party_id', requireLogin, (req, res) ->
  rc.get "party:#{req.params.party_id}", (error, party) ->
    res.render 'party'


# Helpers
app.dynamicHelpers
  current_user: (req, res) ->
    req.session.user or {}


# Only listen on $ node app.js

unless module.parent
  app.listen 3000
  console.log "Express server listening on port %d", app.address().port
