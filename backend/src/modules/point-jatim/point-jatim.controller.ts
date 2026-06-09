import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { CreatePointJatimSubmissionDto } from './point-jatim.dto';
import { PointJatimService } from './point-jatim.service';

@Controller('point-jatim')
export class PointJatimController {
  constructor(private readonly pointJatimService: PointJatimService) {}

  @Public()
  @Get('projects')
  getProjects(@Query('sector') sector?: string) {
    return this.pointJatimService.getProjects(sector);
  }

  @Public()
  @Get('projects/:id')
  getProject(@Param('id') id: string) {
    return this.pointJatimService.getProject(id);
  }

  @Public()
  @Post('submissions')
  createSubmission(@Body() body: CreatePointJatimSubmissionDto) {
    return this.pointJatimService.createSubmission(body);
  }
}
