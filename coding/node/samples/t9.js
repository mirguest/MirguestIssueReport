
http = require('http')

var url = process.argv[2]

var d = ""
http.get(url, function (response) {
    response.on("data", function (data) {
        // console.log(data.toString())
        d+=data.toString()
    })
    response.on("end", function() {
        // console.log("end")
        console.log(d.length)
        console.log(d)
    })
})
