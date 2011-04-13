/*
~/redis-2.2.4/src/redis-server ~/redis-2.2.4/redis.conf
coffee --bare --compile --watch *.coffee *\/*.coffee
nodemon server.js
*/
/*
npm install express jade stylus oauth connect-auth
npm install socket.io underscore backbone redis
npm install connect-redis hash joose joosex-namespace-depended
***** development *****
npm install nodemon coffee-script
*/
/*
http://fzysqr.com/2011/02/28/nodechat-js-using-node-js-backbone-js-socket-io-and-redis-to-make-a-real-time-chat-app/
http://fzysqr.com/2011/03/27/nodechat-js-continued-authentication-profiles-ponies-and-a-meaner-socket-io/
http://joyeur.com/2010/09/15/installing-a-node-service-on-a-joyent-smartmachine/
*/
/*
https://my.joyent.com/smartmachines
ssh node@64.30.137.17
git push node master
*/var activeClients, app, auth, chatMessage, chats, connect, express, key, keys, models, rc, redis, socket, value, _;
try {
  keys = require('./keys_file');
  for (key in keys) {
    value = keys[key];
    global[key] = value;
  }
} catch (error) {
  console.log('Unable to locate the keys_file.js file.  Please copy and ammend the example_keys_file.js as appropriate');
  return;
}
express = require('express');
connect = require('connect');
auth = require('connect-auth');
app = module.exports = express.createServer();
socket = require('socket.io').listen(app);
redis = require('redis');
rc = redis.createClient();
_ = require('underscore')._;
models = require('./models/models');
app.configure(function() {
  app.set('views', "" + __dirname + "/views");
  app.set('view engine', 'jade');
  app.set('view options', {
    layout: false
  });
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({
    secret: 'secret 55true'
  }));
  app.use(require("stylus").middleware({
    src: "" + __dirname + "/public",
    compress: true
  }));
  app.use(express.static("" + __dirname + "/public"));
  app.use(auth([
    auth.Sina({
      consumerKey: sinaConsumerKey,
      consumerSecret: sinaConsumerSecret,
      callback: sinaCallbackAddress
    })
  ]));
  return app.use(app.router);
});
app.configure('development', function() {
  return app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }));
});
app.configure('production', function() {
  return app.use(express.errorHandler());
});
app.get('/*.(js|css)', function(req, res) {
  return res.sendfile("./" + req.url);
});
activeClients = 0;
chats = new models.Chats();
rc.lrange('chatentries', -10, -1, function(err, data) {
  if (err) {
    return console.log("Error: " + err);
  } else if (data) {
    _.each(data, function(jsonChat) {
      var chat;
      chat = new models.Chat(JSON.parse(jsonChat));
      return chats.add(chat);
    });
    return console.log("Revived " + chats.length + " chats");
  } else {
    return console.log('No data returned for key');
  }
});
socket.on('connection', function(client) {
  activeClients += 1;
  client.on('disconnect', function() {
    activeClients -= 1;
    return client.broadcast({
      event: 'update',
      clients: activeClients
    });
  });
  client.on('message', function(msg) {
    return chatMessage(client, socket, msg);
  });
  client.send({
    event: 'initial',
    data: chats.toJSON()
  });
  return socket.broadcast({
    event: 'update',
    clients: activeClients
  });
});
chatMessage = function(client, socket, msg) {
  var chat;
  chat = new models.Chat(msg);
  return rc.incr('next.chatentry.id', function(err, newId) {
    chat.set({
      id: newId
    });
    chats.add(chat);
    rc.rpush('chatentries', JSON.stringify(chat.toJSON()), redis.print);
    return socket.broadcast({
      event: 'chat',
      data: chat.toJSON()
    });
  });
};
app.get('/', function(req, res) {
  rc.hgetall("users:" + req.session.user_id, function(err, obj) {
    return console.log(obj);
  });
  return res.render('index', {
    title: 'Express',
    layout: true
  });
});
app.get('/logout', function(req, res) {
  req.logout();
  res.writeHead(303, {
    'Location': "/"
  });
  return res.end('');
});
app.get('/auth/sina', function(req, res) {
  if (req.isAuthenticated()) {
    rc.hmset("users:" + (req.getAuthDetails().user.user_id), {
      access_token: req.session.auth["sina_oauth_token"],
      secret_token: req.session.auth["sina_oauth_token_secret"]
    });
    req.session.user_id = req.getAuthDetails().user.user_id;
    return res.redirect('/');
  } else {
    return req.authenticate(['sina'], function(error, authenticated) {});
  }
});
if (!module.parent) {
  app.listen(3000);
  console.log("Express server listening on port %d", app.address().port);
}