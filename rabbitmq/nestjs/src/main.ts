// main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Transport, MicroserviceOptions } from '@nestjs/microservices';

import { ServerRMQ } from '@nestjs/microservices';
import { Message } from 'amqplib';

export class CustomRMQServer extends ServerRMQ {
  async handleMessage(message: Message, channel: any): Promise<void> {
    // Proceed with the normal handling
    super.handleMessage(message, channel);
  }
}

async function bootstrap() {
  const app = await NestFactory.createMicroservice<MicroserviceOptions>(
    AppModule,
    {
      strategy: new CustomRMQServer({
        urls: ['amqp://user:password@rabbitmq:5672'],
        queue: 'queue_message',
        queueOptions: {
          durable: true,
        },
      }),
    },
  );

  await app.listen();
  console.log('NestJS Microservice is listening...');
}
bootstrap();
