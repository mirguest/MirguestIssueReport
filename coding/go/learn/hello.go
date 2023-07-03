// Run:
// $ go run hello.go
//
// Build:
// $ go build hello.go
// $ ./hello
//
// Create a mod:
// $ go mod init mirguest/go/learn
//
// Download dependencies:
// $ go mod tidy
//
// Hello Word in Go
package main

// Import OS and fmt packages
import (
	"fmt"
	"log"
	"mirguest/go/learn/greetings"
	"os"
	"rsc.io/quote"
)

// Let us start
func main() {
	fmt.Println("Hello, world!")                          // Print simple text on screen
	fmt.Println(os.Getenv("USER"), ", Let's be friends!") // Read Linux $USER environment variable
	fmt.Println(quote.Go())
	message, err := greetings.Hello("")

	if err != nil {
		log.Print(err)
	}

	message, err = greetings.Hello(os.Getenv("USER"))
	fmt.Println(message)
}
