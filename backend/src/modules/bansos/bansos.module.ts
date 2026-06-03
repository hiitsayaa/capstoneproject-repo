import { Module } from '@nestjs/common';
import { BansosController } from './bansos.controller';
import { BansosService } from './bansos.service';

@Module({
  controllers: [BansosController],
  providers: [BansosService],
})
export class BansosModule {}
