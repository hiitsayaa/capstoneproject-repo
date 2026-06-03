import { Module } from '@nestjs/common';
import { TbcScreeningController } from './tbc-screening.controller';
import { TbcScreeningService } from './tbc-screening.service';

@Module({
  controllers: [TbcScreeningController],
  providers: [TbcScreeningService],
})
export class TbcScreeningModule {}
