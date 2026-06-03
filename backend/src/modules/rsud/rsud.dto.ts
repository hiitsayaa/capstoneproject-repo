import { IsDateString, IsNotEmpty, IsString } from 'class-validator';

export class CreateQueueDto {
  @IsString()
  @IsNotEmpty()
  nik!: string;

  @IsString()
  @IsNotEmpty()
  dokter_nama!: string;

  @IsString()
  @IsNotEmpty()
  spesialisasi!: string;

  @IsDateString()
  tanggal_kunjungan!: string;
}
