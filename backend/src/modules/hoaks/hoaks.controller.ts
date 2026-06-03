import { Body, Controller, Get, Post, Req } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { ReportHoaxDto } from './hoaks.dto';
import { HoaksService } from './hoaks.service';

@Controller('hoaks')
export class HoaksController {
  constructor(private readonly hoaksService: HoaksService) {}

  @Public()
  @Get('articles')
  getArticles() {
    return this.hoaksService.getArticles();
  }

  @Public()
  @Post('report')
  reportHoax(
    @Req() request: { user?: { nik: string } },
    @Body() body: ReportHoaxDto,
  ) {
    return this.hoaksService.report(body, request.user?.nik);
  }
}
