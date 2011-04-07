/**
 * npm install express jade sass
 * npm install socket.io underscore backbone
 */

/**
 * Module dependencies.
 */

var express = require('express');

var app = module.exports = express.createServer();
var socket = require('socket.io').listen(app);
var rc = require('redis').createClient();
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

socket.on('connection', function(client){ 
  activeClients +=1;
  socket.broadcast({clients:activeClients})
  client.on('disconnect', function(){clientDisconnect(client)});
}); 

function clientDisconnect(client){
  activeClients -=1;
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
