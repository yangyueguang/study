var express = require('express');
var port = process.env.PORT || 8080;
var app = express();
var path = require('path');

app.use(express.static(path.resolve(__dirname, 'dist')));

app.get('*', function (req, res) {
    res.sendFile(__dirname + '/dist/index.html')
})

var server = app.listen(port, function () {
    var host = server.address().address;
    var port = server.address().port;
    console.log('listening at http://%s:%s start is success', host, port);
});
