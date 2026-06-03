import { Module } from '@nestjs/common';
import { PointJatimController } from './point-jatim.controller';
import { PointJatimService } from './point-jatim.service';

@Module({
  controllers: [PointJatimController],
  providers: [PointJatimService],
})
export class PointJatimModule {}
