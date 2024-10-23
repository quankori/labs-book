package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/quankori/kori-book/rabbitmq/go/messaging"
)

func main() {
	// Initialize the Gin router
	router := gin.Default()

	// Define the POST endpoint to send a message to RabbitMQ
	router.GET("/send", func(c *gin.Context) {
		waitForResponse := c.DefaultQuery("wait", "false") == "true"

		message := messaging.Message{
			Pattern: "pattern_one",
			Body:    "Hello from Golang",
			Data:    "test",
			ID:      "",
		}

		// Send the message to RabbitMQ
		response, err := messaging.SendMessageToQueue(message, waitForResponse)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		// Return success response
		c.JSON(http.StatusOK, gin.H{"message": response})
	})

	// Run the server on port 4000
	router.Run(":4000")
}
