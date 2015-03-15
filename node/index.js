var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io').listen(http);
var redis_global = require('redis').createClient();
var redis_client = require('redis').createClient();
var config = require('konfig')();
var cookie = require("cookie");

redis_client.subscribe('rt-change');

io.set('authorization', function (data, callback) {
  if (data.headers.cookie) {
    data.cookie = cookie.parse(data.headers.cookie);
    data.sessionID = data.cookie['_validation_token_key'];
    redis_global.hget(["olympicSession", data.sessionID], function (err, session) {
      if (err || !session) {
        return callback('Unauthorized user', false);
      } else {
        data.session = JSON.parse(session);
        return callback(null, true);
      }
    });
  } else {
    return callback('Unauthorized user', false);
  }
});

io.sockets.on('connection', function(socket) {
  redis_global.hset("olympicSession", socket.request.session.user_id, true)
  redis_client.on('message', function(channel, message){
    response = JSON.parse(message);
    socket.emit(response.channel, response.data);
  });
  socket.on('write', function(message){
    socket.broadcast.emit(message.channel, message.data);
  });
  socket.on('disconnect', function() {
    redis_global.hdel("olympicSession", socket.request.session.user_id)
  });
});


http.listen(3001, config.app.host, function(){
  console.log(config.app.host);
});