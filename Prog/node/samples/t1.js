#!/usr/bin/env node
/*
 * Handle I/O with:
 * * callback
 * * event
 * * stream
 * * module
 */

console.log('Hello')

/*
 * callback
 * one to one
 */

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
        console.log(number)
    })
}

addOne()

/* 
 * event
 * observer pattern
 * many to many
 */


/*
 * Streams
 * keep one semantics for i/o and net
 */

/*
 * modules
 */
