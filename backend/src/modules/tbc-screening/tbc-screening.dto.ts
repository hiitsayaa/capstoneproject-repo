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

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ScreeningAnswerDto)
  answers!: ScreeningAnswerDto[];
}
