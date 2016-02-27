
http = require('http')
url = require('url')

function handleIt(request, response) {
    requrl = url.parse(request.url, true)
    // console.log(requrl)

    strdate = requrl.query.iso
    // console.log(strdate)

    date = new Date(strdate)

    result = new Object()

    response.writeHead(200, { 'Content-Type': 'application/json' })

    if (requrl.pathname == "/api/parsetime") {
        result.hour = date.getHours()
        result.minute = date.getMinutes()
        result.second = date.getSeconds()
    } else if (requrl.pathname == "/api/unixtime") {
        result.unixtime = date.getTime()
    }

    response.end(JSON.stringify(result))
}


server = http.createServer(handleIt)
server.listen(Number(process.argv[2]))
