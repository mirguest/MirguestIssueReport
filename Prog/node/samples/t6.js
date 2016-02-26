
var fs = require('fs')
var path = require('path')

var dir = undefined
var ext = undefined
if (process.argv.length==4) {
    dir = process.argv[2]
    ext = '.'+process.argv[3]
}
var len = 0
if (dir != undefined && ext != undefined) {
    fs.readdir(dir, function ready(err, list) {
        for (var i = 0; i < list.length; ++i) {
            if (path.extname(list[i]) == ext) {
                console.log(list[i])
            }
        }
    })
}

