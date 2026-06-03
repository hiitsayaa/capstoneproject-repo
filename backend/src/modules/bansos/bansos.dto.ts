import { Type } from 'class-transformer';
import {
  IsArray,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Min,
  ValidateNested,
} from 'class-validator';

class BansosDocumentDto {
  @IsString()
  @IsNotEmpty()
  document_type!: string;

  @IsString()
  @IsNotEmpty()
  file_url!: string;
}

export class ApplyBansosDto {
  @IsString()
  @IsNotEmpty()
  program_id!: string;

  @IsString()
  @IsNotEmpty()
  nama_ibu_kandung!: string;

  @IsNumber()
  @Min(0)
  penghasilan_bulanan!: number;

  @IsInt()
  @Min(0)
  jumlah_tanggungan!: number;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => BansosDocumentDto)
  documents?: BansosDocumentDto[];
}
