// Run
// $ go run hello.go
// Build
// $ go build hello.go
// $ ./hello
// 
// Hello Word in Go
package main

// Import OS and fmt packages
import (
    "fmt"
    "os"
    "rsc.io/quote"	
)

// Let us start
func main() {
    fmt.Println("Hello, world!")  // Print simple text on screen
    fmt.Println(os.Getenv("USER"), ", Let's be friends!") // Read Linux $USER environment variable
    fmt.Println(quote.Go())
}
