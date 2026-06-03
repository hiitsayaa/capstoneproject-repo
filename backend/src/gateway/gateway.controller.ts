import { Controller, Get } from '@nestjs/common';
import { Public } from '../common/decorators/public.decorator';
import { GatewayService } from './gateway.service';

@Controller('gateway')
export class GatewayController {
  constructor(private readonly gatewayService: GatewayService) {}

  @Public()
  @Get('features')
  getFeatures() {
    return this.gatewayService.getActiveFeatures();
  }
}
