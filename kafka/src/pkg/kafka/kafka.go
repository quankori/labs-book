package kafka

import (
	"fmt"

	"github.com/IBM/sarama"
)

func Consumer(broker string, topic string) (*sarama.PartitionConsumer, error) {
	config := sarama.NewConfig()

	// Create Kafka consumer
	master, err := sarama.NewConsumer([]string{broker}, config)
	if err != nil {
		return nil, fmt.Errorf("Failed to start consumer: %w", err)
	}

	// Consume from partition 0 (for simplicity)
	partitionConsumer, err := master.ConsumePartition(topic, 0, sarama.OffsetNewest)
	if err != nil {
		master.Close() // Close the master consumer if partition consumer fails
		return nil, fmt.Errorf("Failed to consume partition: %w", err)
	}

	// Return the partitionConsumer
	return &partitionConsumer, nil
}

func Producer(broker string, topic string, key string, value string) error {
	// Create a new Sarama configuration
	config := sarama.NewConfig()
	config.Producer.RequiredAcks = sarama.WaitForAll // Wait for acknowledgment from all brokers
	config.Producer.Retry.Max = 5                    // Retry up to 5 times in case of failure
	config.Producer.Return.Successes = true          // Return success messages

	// Create a new Kafka SyncProducer
	producer, err := sarama.NewSyncProducer([]string{broker}, config)
	if err != nil {
		return fmt.Errorf("Failed to start producer: %w", err)
	}
	defer producer.Close()

	// Create a new producer message with dynamic topic, key, and value
	msg := &sarama.ProducerMessage{
		Topic: topic,                       // Dynamic topic
		Key:   sarama.StringEncoder(key),   // Dynamic key
		Value: sarama.StringEncoder(value), // Dynamic value
	}

	// Send the message
	partition, offset, err := producer.SendMessage(msg)
	if err != nil {
		return fmt.Errorf("Failed to send message: %w", err)
	}

	// Log the message details (partition and offset)
	fmt.Printf("Message sent to partition %d with offset %d for key %s\n", partition, offset, key)
	return nil
}
