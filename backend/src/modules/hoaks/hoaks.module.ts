import { Module } from '@nestjs/common';
import { HoaksController } from './hoaks.controller';
import { HoaksService } from './hoaks.service';

@Module({
  controllers: [HoaksController],
  providers: [HoaksService],
})
export class HoaksModule {}
