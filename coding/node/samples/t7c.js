
var mymod = require("./t7m.js")

var dir = undefined
var ext = undefined
if (process.argv.length==4) {
    dir = process.argv[2]
    ext = process.argv[3]
}

mymod(dir, ext, function cb(err, list) {
    // console.log('before')
    // console.log(list.length)
    for (var i = 0; i < list.length; ++i) {
        console.log(list[i])
    }
})

