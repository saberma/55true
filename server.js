/*
~/redis-2.2.4/src/redis-server ~/redis-2.2.4/redis.conf
coffee --bare --compile --watch *.coffee *\/*.coffee
nodemon server.js
*/
/*
npm install express jade stylus oauth connect-auth
npm install socket.io underscore backbone redis connect-redis
***** development *****
npm install nodemon coffee-script
*/
/*
http://fzysqr.com/2011/02/28/nodechat-js-using-node-js-backbone-js-socket-io-and-redis-to-make-a-real-time-chat-app/
http://fzysqr.com/2011/03/27/nodechat-js-continued-authentication-profiles-ponies-and-a-meaner-socket-io/
http://joyeur.com/2010/09/15/installing-a-node-service-on-a-joyent-smartmachine/
https://gist.github.com/771828
*/
/*
https://my.joyent.com/smartmachines
ssh node@64.30.137.17
git push node master
*/var OAuth, RedisStore, activeClients, app, auth, chatMessage, chats, connect, express, key, keys, models, rc, redis, requireLogin, sina_auth, socket, value, _;
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
OAuth = require('oauth').OAuth;
connect = require('connect');
RedisStore = require('connect-redis');
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
    layout: true
  });
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({
    secret: 'secret 55true',
    store: new RedisStore({
      maxAge: 24 * 60 * 60 * 1000
    })
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
sina_auth = new OAuth("http://api.t.sina.com.cn/oauth/request_token", "http://api.t.sina.com.cn/oauth/access_token", sinaConsumerKey, sinaConsumerSecret, "1.0", sinaCallbackAddress, "HMAC-SHA1");
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
requireLogin = function(req, res, next) {
  if (req.session.user) {
    return next();
  } else {
    return res.redirect('/');
  }
};
app.get('/', function(req, res) {
  if (req.session.user) {
    return res.redirect('/home');
  } else {
    return res.render('index');
  }
});
app.get('/home', requireLogin, function(req, res) {
  return res.render('home');
});
app.get('/logout', function(req, res) {
  return req.session.destroy(function() {
    return res.redirect('/');
  });
});
app.get('/auth/sina', function(req, res) {
  return req.authenticate(['sina'], function(error, authenticated) {
    if (authenticated) {
      return sina_auth.getProtectedResource('http://api.t.sina.com.cn/account/verify_credentials.json', 'GET', req.getAuthDetails()['sina_oauth_token'], req.getAuthDetails()['sina_oauth_token_secret'], function(err, data) {
        var user;
        if (err) {
          return res.end("<html><pre>error = " + (util.inspect(err)) + "</pre></html>");
        } else {
          user = JSON.parse(data);
          rc.hmset("users:" + user.id, {
            access_token: req.session.auth["sina_oauth_token"],
            secret_token: req.session.auth["sina_oauth_token_secret"],
            name: user.name,
            screen_name: user.screen_name
          });
          req.session.user = user;
          return res.redirect('/');
        }
      });
    }
  });
});
app.get('/partys/new', requireLogin, function(req, res) {});
app.dynamicHelpers({
  current_user: function(req, res) {
    return req.session.user || {};
  }
});
if (!module.parent) {
  app.listen(3000);
  console.log("Express server listening on port %d", app.address().port);
}