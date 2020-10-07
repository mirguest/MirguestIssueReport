
fs = require('fs')
http = require('http')

var port = 12345
var file = ""
if (process.argv.length == 4) {
    port = Number(process.argv[2])
    file = process.argv[3]
}

srcfile = fs.createReadStream(file)

function handleIt(request, response) {
    srcfile.pipe(response)
}

server = http.createServer(handleIt);
server.listen(port)
