
/*
 * Handle I/O with:
 * * callback
 * * event
 * * stream
 * * module
 */

console.log('Hello')

fs = require('fs')

var number = undefined

function addOne() {
    fs.readFile('number.txt', function ready(err, content) {
        if (err) {
            console.error("error: " + err)
        }
        console.log("content:")
        console.log(content)
        number = parseInt(content)
        number++
    })
}

addOne()

console.log(number)
