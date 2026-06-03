import { Controller, Get, Param, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { EmergencyService } from './emergency.service';

@Public()
@Controller('emergency')
export class EmergencyController {
  constructor(private readonly emergencyService: EmergencyService) {}

  @Get('regions')
  getRegions() {
    return this.emergencyService.getRegions();
  }

  @Get('contacts')
  getContacts(@Query('region') region?: string) {
    return this.emergencyService.getContacts(region);
  }

  @Get('contacts/:id')
  getContact(@Param('id') id: string) {
    return this.emergencyService.getContact(id);
  }
}
