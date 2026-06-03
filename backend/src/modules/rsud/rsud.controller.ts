import { Body, Controller, Get, Param, Post, Query } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { CreateQueueDto } from './rsud.dto';
import { RsudService } from './rsud.service';

@Controller('rsud')
export class RsudController {
  constructor(private readonly rsudService: RsudService) {}

  @Public()
  @Get('hospitals')
  getHospitals() {
    return this.rsudService.getHospitals();
  }

  @Public()
  @Get(':hospitalId')
  getHospital(@Param('hospitalId') hospitalId: string) {
    return this.rsudService.getHospital(hospitalId);
  }

  @Public()
  @Get(':hospitalId/rooms')
  getRooms(@Param('hospitalId') hospitalId: string) {
    return this.rsudService.getRooms(hospitalId);
  }

  @Public()
  @Get(':hospitalId/rooms/:roomId')
  getRoom(@Param('hospitalId') hospitalId: string, @Param('roomId') roomId: string) {
    return this.rsudService.getRoom(hospitalId, roomId);
  }

  @Public()
  @Post(':hospitalId/queue')
  createQueue(
    @Param('hospitalId') hospitalId: string,
    @Body() body: CreateQueueDto,
  ) {
    return this.rsudService.createQueue(hospitalId, body);
  }

  @Public()
  @Get(':hospitalId/surgeries')
  getSurgeries(@Param('hospitalId') hospitalId: string, @Query('tanggal') tanggal?: string) {
    return this.rsudService.getSurgeries(hospitalId, tanggal);
  }

  @Public()
  @Get(':hospitalId/queues')
  getQueues(
    @Param('hospitalId') hospitalId: string,
    @Query('spesialisasi') spesialisasi?: string,
    @Query('dokter_nama') dokter_nama?: string,
  ) {
    return this.rsudService.getQueues(hospitalId, spesialisasi, dokter_nama);
  }
}
