import { Controller, Get, Param, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { TicketsService } from './tickets.service';

@Public()
@Controller('tickets')
export class TicketsController {
  constructor(private readonly ticketsService: TicketsService) {}

  @Get()
  getTickets(@Query('nik') nik?: string) {
    return this.ticketsService.getTickets(nik);
  }

  @Get(':id')
  getTicket(@Param('id') id: string) {
    return this.ticketsService.getTicket(id);
  }
}
