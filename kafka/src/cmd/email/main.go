package main

import (
	"fmt"
	"log"
	"pkg/kafka"
)

func main() {
	// Call kafka.Consumer and handle errors
	partitionConsumer, err := kafka.Consumer("localhost:9092", "send-mail")
	if err != nil {
		log.Fatalf("Error starting Kafka consumer: %v", err)
	}

	// Ensure partitionConsumer is valid
	if partitionConsumer == nil {
		log.Fatalln("Error: partitionConsumer is nil")
	}

	// Dereference the consumer and start reading messages
	consumer := *partitionConsumer

	defer consumer.Close()

	for {
		select {
		case msg := <-consumer.Messages():
			fmt.Printf("Received message with key: %s, value: %s\n", msg.Key, msg.Value)
		case err := <-consumer.Errors():
			fmt.Println("Error consuming message:", err)
		}
	}
}

func sendEmail(userEmail string) {
	fmt.Println("Email sent to", userEmail)
}
