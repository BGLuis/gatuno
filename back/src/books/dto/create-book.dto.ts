import {
	IsNumber,
	IsObject,
	IsOptional,
	IsPositive,
	IsString,
	ValidateNested,
	IsEnum,
	IsUrl,
	Min,
	Max,
} from 'class-validator';
import { CreateChapterDto } from './create-chapter.dto';
import { Transform, Type } from 'class-transformer';
import { CoverBookDto } from './cover-book.dto';
import { BookType } from '../enum/book-type.enum';
import { CreateAuthorDto } from './create-author.dto';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateBookDto {
	@ApiProperty({
		description: 'Book title',
		example: 'One Piece',
		maxLength: 300,
	})
	@ApiProperty({
		description: 'Book title',
		example: 'One Piece',
		maxLength: 300,
	})
	@IsString()
	title: string;

	@ApiPropertyOptional({
		description: 'Alternative titles for the book',
		example: ['ワンピース', 'Wan Pīsu'],
		type: [String],
		isArray: true,
	})
	@IsOptional()
	@IsString({ each: true })
	alternativeTitle?: string[] = [];

	@ApiPropertyOptional({
		description: 'Type of book (Manga, Manhwa, Manhua, Book, or Other)',
		example: BookType.MANGA,
		enum: BookType,
		default: BookType.OTHER,
	})
	@IsOptional()
	@IsEnum(BookType)
	type?: BookType = BookType.OTHER;

	@ApiPropertyOptional({
		description: 'Array of sensitive content tags',
		example: ['violence', 'gore'],
		type: [String],
		isArray: true,
	})
	@IsOptional()
	@IsString({ each: true })
	sensitiveContent?: string[] = [];

	@ApiPropertyOptional({
		description: 'Original URLs where the book can be found',
		example: ['https://example.com/onepiece'],
		type: [String],
		isArray: true,
		format: 'url',
	})
	@IsOptional()
	@IsUrl({}, { each: true })
	originalUrl?: string[] = [];

	@ApiPropertyOptional({
		description: 'Book description or synopsis',
		example: 'A story about a young pirate who dreams of becoming the Pirate King',
		maxLength: 5000,
	})
	@ApiPropertyOptional({
		description: 'Book description or synopsis',
		example: 'A story about a young pirate who dreams of becoming the Pirate King',
		maxLength: 5000,
	})
	@IsOptional()
	@IsString()
	description?: string;

	@ApiPropertyOptional({
		description: 'Book cover information',
		type: CoverBookDto,
	})
	@Transform(({ value }) => {
		if (value && value.urlImgs !== undefined) {
			return value;
		}

		if (value && value.urlImg && typeof value.urlImg === 'string') {
			return CoverBookDto.fromLegacyFormat({
				urlImg: value.urlImg,
				urlOrigin: value.urlOrigin
			});
		}

		return value;
	})
	@IsOptional()
	@ValidateNested()
	@Type(() => CoverBookDto)
	cover?: CoverBookDto;

	@ApiPropertyOptional({
		description: 'Year of publication',
		example: 1997,
		minimum: 1980,
		maximum: new Date().getFullYear() + 2,
	})
	@IsOptional()
	@IsNumber()
	@IsPositive()
	@Min(1980)
	@Max(new Date().getFullYear() + 2)
	publication?: number;

	@ApiPropertyOptional({
		description: 'Array of tag names for the book',
		example: ['Action', 'Adventure', 'Shonen'],
		type: [String],
		isArray: true,
	})
	@IsOptional()
	@IsString({ each: true })
	tags?: string[] = [];

	@ApiPropertyOptional({
		description: 'Array of authors',
		type: [CreateAuthorDto],
		isArray: true,
	})
	@IsOptional()
	@ValidateNested({ each: true })
	@Type(() => CreateAuthorDto)
	authors?: CreateAuthorDto[] = [];

	@ApiPropertyOptional({
		description: 'Array of chapters',
		type: [CreateChapterDto],
		isArray: true,
	})
	@IsOptional()
	@ValidateNested({ each: true })
	@Type(() => CreateChapterDto)
	chapters?: CreateChapterDto[] = [];
}
