let express = require('express')
let socket = require('socket.io')
let http = require('http')
let app = express()
let server = http.createServer(app)
let io = socket.listen(server)
let users = [];
// specify the html we will use
// app.use('/', express.static(__dirname + '/www'));
server.listen(process.env.PORT || 3333);// publish to heroku
io.sockets.on('connection', function (socket) {
  // new user login
  socket.on('login', function (nickname) {
    if (users.indexOf(nickname) > -1) {
      socket.emit('nickExisted', nickname, users);
    } else {
        // socket.userIndex = users.length;
      socket.nickname = nickname;
      users.push(nickname);
      socket.emit('loginSuccess', nickname, users);
      io.sockets.emit('system', nickname, users, 'login');
    }
  });
  // user leaves
  socket.on('disconnect', function () {
    if (socket.nickname != null) {
        // users.splice(socket.userIndex, 1);
      users.splice(users.indexOf(socket.nickname), 1);
      socket.broadcast.emit('system', socket.nickname, users, 'logout');
    }
  });
  // new message get
  socket.on('postMsg', function (msg, color) {
    console.log(msg)
    socket.broadcast.emit('newMsg', socket.nickname, msg, color);
  });
  // new image get
  socket.on('img', function (imgData, color) {
    socket.broadcast.emit('newImg', socket.nickname, imgData, color);
  });
});
