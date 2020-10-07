
function f(cb) {
    console.log( cb(1,2) )
}

f((a,b) => {
    return a+b
})
