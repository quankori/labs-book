// app.controller.ts
import { Controller } from '@nestjs/common';
import { EventPattern, MessagePattern, Payload } from '@nestjs/microservices';

@Controller()
export class AppController {
  @MessagePattern('pattern_one')
  handlePatternOne(@Payload() message: any) {
    console.log('Received in pattern_one:', message);
    return { test: 'pattern_one processed' };
  }
}
