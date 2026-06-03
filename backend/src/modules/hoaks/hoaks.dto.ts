import { IsNotEmpty, IsOptional, IsString, IsUrl } from 'class-validator';

export class ReportHoaxDto {
  @IsString()
  @IsNotEmpty()
  judul_laporan!: string;

  @IsString()
  @IsNotEmpty()
  deskripsi_kejadian!: string;

  @IsOptional()
  @IsUrl({ require_protocol: true })
  url_bukti?: string;
}
