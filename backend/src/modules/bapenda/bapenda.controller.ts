import { Body, Controller, Get, Param, Post, Query, Req } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { CheckPkbQueryDto, CreatePaymentDto, SearchNjkbQueryDto } from './bapenda.dto';
import { BapendaService } from './bapenda.service';

@Controller('bapenda')
export class BapendaController {
  constructor(private readonly bapendaService: BapendaService) {}

  @Get('vehicles/me')
  getMyVehicles(@Req() request: { user: { nik: string } }) {
    return this.bapendaService.getMyVehicles(request.user.nik);
  }

  @Get('pkb/check')
  checkPkb(@Query() query: CheckPkbQueryDto) {
    return this.bapendaService.checkPkb(query.nopol);
  }

  @Post('pkb/pay')
  createPayment(@Body() body: CreatePaymentDto, @Req() request: { user: { nik: string } }) {
    return this.bapendaService.createPayment(body.bill_id, body.payment_method, request.user.nik);
  }

  @Get('pkb/payments/:paymentId')
  getPayment(@Param('paymentId') paymentId: string) {
    return this.bapendaService.getPayment(paymentId);
  }

  @Public()
  @Get('njkb')
  searchNjkb(@Query() query: SearchNjkbQueryDto) {
    return this.bapendaService.searchNjkb(query);
  }
}
