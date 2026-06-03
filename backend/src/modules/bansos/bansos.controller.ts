import { Body, Controller, Get, Post, Query, Req } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { ApplyBansosDto } from './bansos.dto';
import { BansosService } from './bansos.service';

@Controller('bansos')
export class BansosController {
  constructor(private readonly bansosService: BansosService) {}

  @Public()
  @Get('programs')
  getPrograms() {
    return this.bansosService.getPrograms();
  }

  @Post('apply')
  apply(
    @Req() request: { user: { nik: string } },
    @Body() body: ApplyBansosDto,
  ) {
    return this.bansosService.apply(request.user.nik, body);
  }

  @Get('status')
  getStatus(@Req() request: { user: { nik: string } }, @Query('application_id') applicationId?: string) {
    return this.bansosService.getStatus(request.user.nik, applicationId);
  }
}
