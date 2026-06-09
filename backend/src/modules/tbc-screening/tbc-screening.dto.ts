import { Type } from 'class-transformer';
import { IsArray, IsBoolean, IsNotEmpty, IsOptional, IsString, ValidateNested } from 'class-validator';

class ScreeningAnswerDto {
  @IsString()
  @IsNotEmpty()
  question_id!: string;

  @IsBoolean()
  answer!: boolean;
}

export class SubmitTbcScreeningDto {
  @IsString()
  @IsNotEmpty()
  nama!: string;

  @IsString()
  @IsNotEmpty()
  nik!: string;

  @IsOptional()
  @IsString()
  kabupaten_kota?: string;

  @IsOptional()
  @IsBoolean()
  is_self?: boolean;

  @IsOptional()
  @IsString()
  pelapor_nama?: string;

  @IsOptional()
  @IsString()
  pelapor_kelompok?: string;

  @IsOptional()
  @IsString()
  pelapor_instansi?: string;

  @IsOptional()
  @IsString()
  pelapor_telepon?: string;

  @IsOptional()
  @IsString()
  jenis_kelamin?: string;

  @IsOptional()
  @IsString()
  telepon?: string;

  @IsOptional()
  @IsString()
  tanggal_lahir?: string;

  @IsOptional()
  usia?: number;

  @IsOptional()
  berat_badan?: number;

  @IsOptional()
  tinggi_badan?: number;

  @IsOptional()
  @IsString()
  alamat?: string;

  @IsOptional()
  @IsString()
  pekerjaan?: string;

  @IsOptional()
  @IsString()
  kecamatan?: string;

  @IsOptional()
  @IsString()
  kelurahan?: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ScreeningAnswerDto)
  answers!: ScreeningAnswerDto[];
}
