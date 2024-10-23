package messaging

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"time"

	"github.com/streadway/amqp"
)

type Message struct {
	ID      string `json:"id"`
	Pattern string `json:"pattern"`
	Body    string `json:"body"`
	Data    string `json:"data"`
}

// Helper function for generating random correlation ID
func randomString(length int) string {
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var seededRand = rand.New(rand.NewSource(time.Now().UnixNano()))
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[seededRand.Intn(len(charset))]
	}
	return string(b)
}

// SendMessageToQueue sends a message to RabbitMQ, with an optional wait for a response
func SendMessageToQueue(message Message, waitForResponse bool) (string, error) {
	// Connect to RabbitMQ server
	conn, err := amqp.Dial("amqp://user:password@rabbitmq:5672")
	if err != nil {
		return "", fmt.Errorf("Failed to connect to RabbitMQ: %w", err)
	}
	defer conn.Close()

	// Create a channel
	ch, err := conn.Channel()
	if err != nil {
		return "", fmt.Errorf("Failed to open a channel: %w", err)
	}
	defer ch.Close()

	// Declare the main queue
	q, err := ch.QueueDeclare(
		"queue_message", // Queue name
		true,            // Durable
		false,           // Delete when unused
		false,           // Exclusive
		false,           // No-wait
		nil,             // Arguments
	)
	if err != nil {
		return "", fmt.Errorf("Failed to declare a queue: %w", err)
	}

	// Declare a temporary queue for the reply if needed
	var replyQueue amqp.Queue
	if waitForResponse {
		replyQueue, err = ch.QueueDeclare(
			"",    // Name (empty means RabbitMQ will generate a unique name)
			false, // Durable
			true,  // Auto-delete (true to auto-delete)
			true,  // Exclusive
			false, // No-wait
			nil,   // Arguments
		)
		if err != nil {
			return "", fmt.Errorf("Failed to declare a reply queue: %w", err)
		}
	}

	// Create a correlation ID for this request
	corrId := randomString(32)
	message.ID = corrId

	// Serialize the message to JSON
	body, err := json.Marshal(message)
	if err != nil {
		return "", fmt.Errorf("Failed to encode message to JSON: %w", err)
	}

	// Prepare the publishing options
	publishing := amqp.Publishing{
		ContentType:   "application/json",
		CorrelationId: corrId,
		Body:          body,
	}
	if waitForResponse {
		publishing.ReplyTo = replyQueue.Name
	}

	// Send the message asynchronously (no blocking)
	go func() {
		err = ch.Publish(
			"",     // No exchange
			q.Name, // Queue name
			false,  // Mandatory
			false,  // Immediate
			publishing,
		)
		if err != nil {
			log.Printf("Failed to publish a message: %s", err)
			return
		}
		log.Println("Message sent")
	}()

	// If not waiting for a response, return immediately (continue execution)
	if !waitForResponse {
		return "Message sent without waiting for response", nil
	}

	// Waiting for the response (blocking)
	msgs := make(chan string)

	go func() {
		deliveries, err := ch.Consume(
			replyQueue.Name, // Queue name
			"",              // Consumer tag
			true,            // Auto-ack
			false,           // Exclusive
			false,           // No-local
			false,           // No-wait
			nil,             // Arguments
		)
		if err != nil {
			log.Printf("Failed to register a consumer: %s", err)
			return
		}

		// Wait for the response and match the correlation ID
		for d := range deliveries {
			if corrId == d.CorrelationId {
				// We have received the correct response
				msgs <- string(d.Body)
				return
			}
		}
	}()

	// Wait for the response with a timeout (blocking)
	select {
	case response := <-msgs:
		return response, nil
	case <-time.After(10 * time.Second): // Timeout of 10 seconds
		return "", fmt.Errorf("Request timed out waiting for response")
	}
}
