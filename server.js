/**
 * npm install express jade sass
 * npm install socket.io underscore backbone redis
 * npm install connect-redis hash joose joosex-namespace-depended
 */

/**
 * http://fzysqr.com/2011/02/28/nodechat-js-using-node-js-backbone-js-socket-io-and-redis-to-make-a-real-time-chat-app/
 * http://fzysqr.com/2011/03/27/nodechat-js-continued-authentication-profiles-ponies-and-a-meaner-socket-io/
 * http://joyeur.com/2010/09/15/installing-a-node-service-on-a-joyent-smartmachine/
 */

/**
 * https://my.joyent.com/smartmachines
 * ssh node@64.30.137.17
 * git push node master
 */

/**
 * Module dependencies.
 */

var express = require('express');

var app = module.exports = express.createServer();
var socket = require('socket.io').listen(app);
var redis = require('redis');
var rc = redis.createClient();
var models = require('./models/models');

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set('view options', {layout: false});
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: 'secret from 55true' }));
  app.use(express.compiler({ src: __dirname + '/public', enable: ['sass'] }));
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

//访问modes,controllers,views目录
app.get('/*.(js|css)', function(req, res){
  res.sendfile('./'+req.url);
});

// Socket
var activeClients = 0;
var nodeChatModel = new models.NodeChatModel();

// 从redis中获取前10条消息
rc.lrange('chatentries', -10, -1, function(err, data) {
  if (err) {
    console.log('Error: ' + err);
  } else if (data) {
    _.each(data, function(jsonChat) {
      var chat = new models.ChatEntry();
      chat.mport(jsonChat);
      nodeChatModel.chats.add(chat);
    });

    console.log('Revived ' + nodeChatModel.chats.length + ' chats');
  } else {
    console.log('No data returned for key');
  }
});

//连接
socket.on('connection', function(client){ 
  activeClients += 1;
  client.on('disconnect', function(){clientDisconnect(client)});
  client.on('message', function(msg){chatMessage(client, socket, msg)});

  client.send({
    event: 'initial',
    data: nodeChatModel.xport()
  });

  socket.broadcast({
    event: 'update',
    clients: activeClients
  });
}); 

//聊天内容
function chatMessage(client, socket, msg){
  var chat = new models.ChatEntry();
  chat.mport(msg);

  rc.incr('next.chatentry.id', function(err, newId) {
    chat.set({id: newId});
    nodeChatModel.chats.add(chat);

    var expandedMsg = chat.get('id') + ' ' + chat.get('name') + ': ' + chat.get('text');
    console.log('(' + client.sessionId + ') ' + expandedMsg);

    rc.rpush('chatentries', chat.xport(), redis.print);
    rc.bgsave();

    socket.broadcast({
      event: 'chat',
      data:chat.xport()
    }); 
  }); 
}

function clientDisconnect(client) {
  activeClients -= 1;
  client.broadcast({clients:activeClients})
}

// Routes

app.get('/', function(req, res){
  res.render('index', {
    title: 'Express',
    layout: true
  });
});

// Only listen on $ node app.js

if (!module.parent) {
  app.listen(3000);
  console.log("Express server listening on port %d", app.address().port);
}
