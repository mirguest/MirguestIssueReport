
http = require('http')

var urls = []
var datas = new Array()
var tags = new Array()
for (var i = 2; i < 5; ++i) {
    var url = process.argv[i]
    urls.push(url)
    datas[url] = ""
    tags[url] = 0
}

function myget(url) {
    http.get(url, function (response) {
        // console.log(url)
        response.on("data", function (data) {
            // console.log(data.toString())
            datas[url]+=data.toString()
        })
        response.on("end", function() {
            // console.log(url)
            tags[url] = 1
            var printit = 0
            for (var j = 0; j < 3; ++j) {
                var nowurl = urls[j]
                // console.log(nowurl + tags[nowurl])
                printit += tags[nowurl]
            }
            // console.log(printit)
            if (printit == 3) {
                for (var j = 0; j < 3; ++j) {
                    var nowurl = urls[j]
                    console.log(datas[nowurl])
                }
            }
        })
    })
}

for (var j = 0; j < 3; ++j) {
    myget(urls[j])
}
