package main

import (
	"fmt"
	"log"
	"pkg/kafka"
	"time"
)

func main() {
	// Dynamic parameters
	broker := "localhost:9092" // Kafka broker
	topic := "send-mail"       // Kafka topic
	key := "user-123"          // Message key (can be dynamic)

	// Call the dynamic producer function in a loop
	for i := 0; i < 10; i++ {
		dynamicKey := fmt.Sprintf("%s-%d", key, i)
		err := kafka.Producer(broker, topic, dynamicKey, fmt.Sprintf("test_%d@gmail.com", i+1))
		if err != nil {
			log.Fatalf("Error sending message: %v", err)
		}
		time.Sleep(1 * time.Second)
	}
}
