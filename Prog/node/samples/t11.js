
net = require('net')

var port = 12345
if (process.argv.length == 3) {
    port = Number(process.argv[2])
}
console.log(port)

server = net.createServer(handleConnect)

function dateformat(date) {
    var s = ""
    iyear = date.getFullYear()
    imonth = date.getMonth() + 1
    idate = date.getDate()
    hour = date.getHours()
    minutes = date.getMinutes()

    s += iyear + "-" 
    if (imonth < 10) s += '0'
    s += imonth 
    s += "-"  
    if (idate < 10) s += '0'
    s += idate
    s += " "
    if (hour < 10) s += '0'
    s += hour 
    s += ":" 
    if (minutes < 10) s += '0'
    s += minutes
    return s
}

function handleConnect(socket) {
    
    var str = dateformat(new Date())

    socket.end(str+"\n")
}

server.listen(port)
