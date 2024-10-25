import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { GrpcMethod } from '@nestjs/microservices';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @GrpcMethod('UserService', 'GetUser')
  getUser(data: { userId: string }) {
    return this.appService.getUser(data);
  }

  @GrpcMethod('UserService', 'CreateUser')
  createUser(data: { username: string; email: string }) {
    return this.appService.createUser(data);
  }
}
