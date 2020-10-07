
var fs = require('fs')
var filename = undefined
if (process.argv.length>2) {
    filename = process.argv[2]
}
var len = 0
if (filename != undefined) {
    fs.readFile(filename, 'utf8', function ready(err, content) {
        len = content.split('\n').length
        if (len>1) len -= 1
        console.log(len)
    })
}

