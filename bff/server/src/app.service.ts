import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  private users = [
    { id: '1', username: 'john', email: 'john@example.com', isActive: true },
  ];

  getUser(data: { userId: string }) {
    return this.users.find((user) => user.id === data.userId) || null;
  }

  createUser(data: { username: string; email: string }) {
    const newUser = {
      id: (this.users.length + 1).toString(),
      ...data,
      isActive: true,
    };
    this.users.push(newUser);
    return newUser;
  }
}
