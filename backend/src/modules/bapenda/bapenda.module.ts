import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { BapendaController } from './bapenda.controller';
import { BapendaService } from './bapenda.service';

@Module({
  imports: [AuthModule],
  controllers: [BapendaController],
  providers: [BapendaService],
})
export class BapendaModule {}
