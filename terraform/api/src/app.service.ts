import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class AppService {
  constructor(private configService: ConfigService) {}
  getHello(): string {
    const nodeEnv = this.configService.get<string>('NODE_ENV');
    return 'Environment is: ' + nodeEnv + " Hello";
  }
}
