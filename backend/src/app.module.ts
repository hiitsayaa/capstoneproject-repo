import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { DatabaseModule } from './common/database/database.module';
import { JwtRbacGuard } from './common/guards/jwt-rbac.guard';
import { DocsModule } from './docs/docs.module';
import { GatewayModule } from './gateway/gateway.module';
import { AuthModule } from './modules/auth/auth.module';
import { BansosModule } from './modules/bansos/bansos.module';
import { BapendaModule } from './modules/bapenda/bapenda.module';
import { EmergencyModule } from './modules/emergency/emergency.module';
import { HoaksModule } from './modules/hoaks/hoaks.module';
import { IslamicCenterModule } from './modules/islamic-center/islamic-center.module';
import { PointJatimModule } from './modules/point-jatim/point-jatim.module';
import { RsudModule } from './modules/rsud/rsud.module';
import { TbcScreeningModule } from './modules/tbc-screening/tbc-screening.module';
import { TicketsModule } from './modules/tickets/tickets.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    DatabaseModule,
    ThrottlerModule.forRoot([
      {
        ttl: 60000,
        limit: 100,
      },
    ]),
    GatewayModule,
    DocsModule,
    AuthModule,
    BapendaModule,
    RsudModule,
    BansosModule,
    HoaksModule,
    EmergencyModule,
    IslamicCenterModule,
    PointJatimModule,
    TbcScreeningModule,
    TicketsModule,
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: JwtRbacGuard,
    },
  ],
})
export class AppModule {}
