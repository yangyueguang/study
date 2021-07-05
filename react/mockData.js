const http = require('http')

const Mock = require('mockjs')

const data = Mock.mock({
  // 属性 list 的值是一个数组，其中含有 1 到 10 个元素
  'list|10': [{
    // 属性 id 是一个自增数，起始值为 1，每次增 1
    'id|+1': ['a', 'b', 'c'],
    'name|3': 'zhangsan ',
    'count|1-100.1-3': 10.10,
    'show|1-3': true,
    'obj|1-3': {
      x: 0,
      y: 1,
      z: 2
    },
    'list|1-3': ['a', 'b'],
    'name': function() {
      return new Date().getTime()
    },
    'reg': /\d{1,5}/,
    'num': '@character()',
    'str': '@string(10)',
    'range': '@range(1, 10, 3)',
    'img': "@image('200x100', '#00405d', '#FFF', 'Mock.js')",
    'info': '@cparagraph()'
  }]
})

http.createServer((req, res) => {
  let url = req.url
  if (url === '/api/list') {
    res.writeHead(200, {'content-type': 'application/json'})
    res.write(JSON.stringify(data))
  } else {
    res.write('page not found.')
  }
  res.end()
}).listen(8080, () => {
  console.log('localhost: 8080')
})
