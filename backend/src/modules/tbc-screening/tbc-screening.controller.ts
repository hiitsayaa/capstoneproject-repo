import { Body, Controller, Get, Post, Patch, Param, Query, Req } from '@nestjs/common';
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
  submit(@Req() req: any, @Body() body: SubmitTbcScreeningDto) {
    const userId = req.user?.id;
    return this.tbcScreeningService.submit(body, userId?.toString());
  }

  @Get('records')
  getHistory(@Req() req: any, @Query('nik') nik?: string) {
    const userId = req.user?.id;
    return this.tbcScreeningService.getHistory(userId?.toString(), nik);
  }

  @Patch('records/:id/faskes')
  updateFaskes(@Param('id') id: string, @Body('faskes_name') faskesName: string) {
    return this.tbcScreeningService.updateFaskes(id, faskesName);
  }
}
