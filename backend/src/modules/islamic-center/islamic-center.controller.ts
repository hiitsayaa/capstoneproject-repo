import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { CreateIslamicCenterBookingDto } from './islamic-center.dto';
import { IslamicCenterService } from './islamic-center.service';

@Controller('islamic-center')
export class IslamicCenterController {
  constructor(private readonly islamicCenterService: IslamicCenterService) {}

  @Public()
  @Get('facilities')
  getFacilities(@Query('category') category?: string) {
    return this.islamicCenterService.getFacilities(category);
  }

  @Public()
  @Get('facilities/:id')
  getFacility(@Param('id') id: string) {
    return this.islamicCenterService.getFacility(id);
  }

  @Post('bookings')
  createBooking(@Body() body: CreateIslamicCenterBookingDto) {
    return this.islamicCenterService.createBooking(body);
  }
}
