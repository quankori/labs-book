# Microservices

## SAGA Pattern

- Orchestration: Command based

```ts
async createOrder(customerId: number, productId: number) {
    try {
      // Step 1: Create Order
      const order = await this.orderService.createOrder(customerId, productId);
      console.log(`Order created with ID: ${order.id}`);

      // Step 2: Process Payment
      const payment = await this.paymentService.processPayment(order.id);
      if (!payment.success) throw new Error('Payment failed');
      console.log(`Payment processed for Order ID: ${order.id}`);

      // Step 3: Ship Order
      const shipment = await this.shippingService.shipOrder(order.id);
      console.log(`Order shipped with shipment ID: ${shipment.id}`);

      return { success: true, order, payment, shipment };

    } catch (error) {
      console.error(`Error during order processing: ${error.message}`);
      // Rollback compensation actions
      await this.compensateOrder(customerId, productId);
      return { success: false, error: error.message };
    }
  }
```

- Choreography: Event based

```ts
// order.service.ts
class OrderService {
  async createOrder() {
    // Create order and emit event
    this.eventBus.emit("OrderCreated", { orderId: newOrder.id });
  }
}

// payment.listener.ts
class PaymentListener {
  @OnEvent("OrderCreated")
  async handleOrderCreated(event: { orderId: string }) {
    // Handle payment and emit event
    this.eventBus.emit("PaymentCompleted", { orderId: event.orderId });
  }
}

// shipping.listener.ts
class ShippingListener {
  @OnEvent("PaymentCompleted")
  async handlePaymentCompleted(event: { orderId: string }) {
    // Ship order
  }
}
```

## Outbox/Inbox Pattern

- Outbox pattern: In a microservices context, this means that when a service writes data to its database, it also records an "outbox" entry with the message that needs to be sent to other services. This outbox entry can then be processed by a separate worker or polling mechanism to send messages to other microservices.

```ts
@Entity()
export class Outbox {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  eventType: string;

  @Column({ type: "json" })
  payload: Record<string, any>;

  @Column()
  processed: boolean = false;
}
```

Outbox Processor

```ts
async processOutboxEntries() {
    const entries = await this.outboxRepository.find({ processed: false });
    for (const entry of entries) {
      // Send event to other microservices
      await this.sendMessageToQueue(entry);

      // Mark as processed
      entry.processed = true;
      await this.outboxRepository.save(entry);
    }
  }
```

- Inbox pattern: Each service maintains an inbox table, where it logs every processed event’s ID to avoid duplicates.

```ts
@Entity()
export class Inbox {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  eventId: string;  // Unique ID of the incoming event

  @Column()
  processed: boolean = false;
}

async onOrderCreatedEvent(eventId: string, eventPayload: Record<string, any>) {
    const existing = await this.inboxRepository.findOne({ eventId });
    if (existing) {
        return; // Event already processed
    }

    // Process the event
    // Save order, update status, etc.

    // Record the event as processed
    const inboxEntry = this.inboxRepository.create({ eventId, processed: true });
    await this.inboxRepository.save(inboxEntry);
}
```
