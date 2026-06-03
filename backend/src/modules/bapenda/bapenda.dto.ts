import { Type } from 'class-transformer';
import { IsInt, IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CheckPkbQueryDto {
  @IsString()
  @IsNotEmpty()
  nopol!: string;
}

export class CreatePaymentDto {
  @IsString()
  @IsNotEmpty()
  bill_id!: string;

  @IsOptional()
  @IsString()
  payment_method?: string;
}

export class SearchNjkbQueryDto {
  @IsOptional()
  @IsString()
  merk?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  tahun?: number;
}
