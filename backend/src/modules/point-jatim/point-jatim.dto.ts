import { IsEmail, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreatePointJatimSubmissionDto {
  @IsString()
  @IsNotEmpty()
  project_id!: string;

  @IsString()
  @IsNotEmpty()
  nama_investor!: string;

  @IsEmail()
  email!: string;

  @IsString()
  @IsNotEmpty()
  telepon!: string;

  @IsOptional()
  @IsString()
  catatan?: string;
}
