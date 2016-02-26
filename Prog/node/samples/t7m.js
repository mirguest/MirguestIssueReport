var fs = require('fs')
var path = require('path')

module.exports = function(dir, ext, callback) {
    fs.readdir(dir, function ready(err, list) {
        if (err != null) {
            // log(err)
            return callback(err)
        }
        var newlist = []
        for (var i = 0; i < list.length; ++i) {
            // console.log(list[i])
            // console.log(path.extname(list[i]))
            if (path.extname(list[i]) == '.'+ext) {
                newlist.push(list[i])
            }
        }
        // console.log(newlist)
        callback(null, newlist)
    })
}
