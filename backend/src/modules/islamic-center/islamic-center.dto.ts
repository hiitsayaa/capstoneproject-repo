import { IsDateString, IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateIslamicCenterBookingDto {
  @IsString()
  @IsNotEmpty()
  facility_id!: string;

  @IsString()
  @IsNotEmpty()
  nama_pemohon!: string;

  @IsString()
  @IsNotEmpty()
  telepon!: string;

  @IsEmail()
  email!: string;

  @IsDateString()
  tanggal!: string;

  @IsString()
  @IsNotEmpty()
  waktu!: string;

  @IsOptional()
  @IsString()
  catatan?: string;
}
