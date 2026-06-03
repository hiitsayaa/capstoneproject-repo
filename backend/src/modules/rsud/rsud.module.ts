import { Module } from '@nestjs/common';
import { RsudController } from './rsud.controller';
import { RsudService } from './rsud.service';

@Module({
  controllers: [RsudController],
  providers: [RsudService],
})
export class RsudModule {}
