import { Module } from '@nestjs/common';
import { IslamicCenterController } from './islamic-center.controller';
import { IslamicCenterService } from './islamic-center.service';

@Module({
  controllers: [IslamicCenterController],
  providers: [IslamicCenterService],
})
export class IslamicCenterModule {}
