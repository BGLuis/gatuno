import {
	IsNumber,
	IsOptional,
	IsPositive,
	IsString,
	IsUrl,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateChapterDto {
	@ApiPropertyOptional({
		description: 'Chapter title',
		example: 'Chapter 1: The Beginning',
		maxLength: 200,
	})
	@IsString()
	@IsOptional()
	title?: string;

	@ApiProperty({
		description: 'URL of the chapter source',
		example: 'https://example.com/book/chapter-1',
		format: 'url',
	})
	@IsUrl()
	url: string;

	@ApiPropertyOptional({
		description: 'Chapter order index',
		example: 1,
		minimum: 1,
	})
	@IsNumber()
	@IsPositive()
	@IsOptional()
	index?: number;
}
