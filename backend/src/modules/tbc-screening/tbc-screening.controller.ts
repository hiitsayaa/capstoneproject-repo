import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { SubmitTbcScreeningDto } from './tbc-screening.dto';
import { TbcScreeningService } from './tbc-screening.service';

@Controller('tbc-screening')
export class TbcScreeningController {
  constructor(private readonly tbcScreeningService: TbcScreeningService) {}

  @Public()
  @Get('questions')
  getQuestions() {
    return this.tbcScreeningService.getQuestions();
  }

  @Public()
  @Get('faskes')
  getFaskes(@Query('region') region?: string, @Query('type') type?: string) {
    return this.tbcScreeningService.getFaskes(region, type);
  }

  @Post('records')
  submit(@Body() body: SubmitTbcScreeningDto) {
    return this.tbcScreeningService.submit(body);
  }

  @Get('records')
  getHistory(@Query('nik') nik?: string) {
    return this.tbcScreeningService.getHistory(nik);
  }
}
