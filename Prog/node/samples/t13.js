
http = require('http')

function handleIt(request, response) {
    var body = ""
    request.on('data', function (data) {
        body += data.toString()
    })
    request.on('end', function() {
        response.end(body.toUpperCase())
    })
}


server = http.createServer(handleIt)
server.listen(Number(process.argv[2]))
