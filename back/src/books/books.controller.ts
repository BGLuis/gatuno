import {
	Body,
	Controller,
	Get,
	Logger,
	Param,
	Patch,
	Post,
	Query,
	UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam, ApiQuery } from '@nestjs/swagger';
import { BooksService } from './books.service';
import { BookPageOptionsDto } from './dto/book-page-options.dto';
import { CurrentUserDto } from 'src/auth/dto/current-user.dto';
import { CurrentUser } from 'src/auth/decorator/current-user.decorator';
import { OptionalAuthGuard } from 'src/auth/guard/optional-auth.guard';

@ApiTags('Books')
@Controller('books')
export class BooksController {
	constructor(private readonly booksService: BooksService) {}

	@Get()
	@ApiOperation({ summary: 'Get all books', description: 'Retrieve a paginated list of books with filters' })
	@ApiResponse({ status: 200, description: 'Books retrieved successfully' })
	@UseGuards(OptionalAuthGuard)
	getAllBooks(
		@Query() pageOptions: BookPageOptionsDto,
		@CurrentUser() user?: CurrentUserDto
	) {
		return this.booksService.getAllBooks(pageOptions, user?.maxWeightSensitiveContent);
	}

	@Get('random')
	@ApiOperation({ summary: 'Get random book', description: 'Retrieve a random book based on filters' })
	@ApiResponse({ status: 200, description: 'Random book retrieved successfully' })
	@UseGuards(OptionalAuthGuard)
	getRandomBook(
		@Query() options: BookPageOptionsDto,
		@CurrentUser() user?: CurrentUserDto
	) {
		return this.booksService.getRandomBook(options, user?.maxWeightSensitiveContent);
	}

	@Get('check-title/:title')
	@ApiOperation({
		summary: 'Check if book title already exists',
		description: 'Check if there is already a book with the given title or alternative titles before creating a new one. Returns all conflicting books.'
	})
	@ApiParam({
		name: 'title',
		description: 'Book title to check',
		example: 'One Piece'
	})
	@ApiQuery({
		name: 'alternativeTitles',
		description: 'Alternative titles to check (comma separated)',
		required: false,
		example: 'ワンピース,Wan Pīsu'
	})
	@ApiResponse({
		status: 200,
		description: 'Title check completed. Returns all books that conflict with the provided titles.',
		schema: {
			type: 'object',
			properties: {
				conflict: { type: 'boolean', example: true },
				existingBook: {
					type: 'object',
					description: 'First conflicting book (for backwards compatibility)',
					properties: {
						id: { type: 'string', example: '550e8400-e29b-41d4-a716-446655440000' },
						title: { type: 'string', example: 'One Piece' },
						alternativeTitle: {
							type: 'array',
							items: { type: 'string' },
							example: ['ワンピース', 'Wan Pīsu']
						}
					}
				},
				conflictingBooks: {
					type: 'array',
					description: 'All books that have conflicting titles',
					items: {
						type: 'object',
						properties: {
							id: { type: 'string', example: '550e8400-e29b-41d4-a716-446655440000' },
							title: { type: 'string', example: 'One Piece' },
							alternativeTitle: {
								type: 'array',
								items: { type: 'string' },
								example: ['ワンピース', 'Wan Pīsu']
							}
						}
					}
				}
			}
		}
	})
	checkBookTitle(
		@Param('title') title: string,
		@Query('alternativeTitles') alternativeTitles?: string
	) {
		const altTitlesArray = alternativeTitles
			? alternativeTitles.split(',').map(t => t.trim()).filter(t => t.length > 0)
			: undefined;
		return this.booksService.checkBookTitleConflict(title, altTitlesArray);
	}

	@Get(':idBook')
	@ApiOperation({ summary: 'Get book by ID', description: 'Retrieve detailed information about a specific book' })
	@ApiParam({ name: 'idBook', description: 'Book unique identifier', example: '550e8400-e29b-41d4-a716-446655440000' })
	@ApiResponse({ status: 200, description: 'Book found' })
	@ApiResponse({ status: 404, description: 'Book not found' })
	@UseGuards(OptionalAuthGuard)
	getBook(
		@Param('idBook') id: string,
		@CurrentUser() user?: CurrentUserDto
	) {
		return this.booksService.getOne(id, user?.maxWeightSensitiveContent);
	}

	@Get(':idBook/chapters')
	@ApiOperation({ summary: 'Get book chapters', description: 'Retrieve all chapters for a specific book' })
	@ApiParam({ name: 'idBook', description: 'Book unique identifier', example: '550e8400-e29b-41d4-a716-446655440000' })
	@ApiResponse({ status: 200, description: 'Chapters retrieved successfully' })
	@ApiResponse({ status: 404, description: 'Book not found' })
	@UseGuards(OptionalAuthGuard)
	getBookChapters(
		@Param('idBook') id: string,
		@CurrentUser() user?: CurrentUserDto
	) {
		return this.booksService.getChapters(id, user?.userId, user?.maxWeightSensitiveContent);
	}

	@Get(':idBook/covers')
	@ApiOperation({ summary: 'Get book covers', description: 'Retrieve all available covers for a book' })
	@ApiParam({ name: 'idBook', description: 'Book unique identifier', example: '550e8400-e29b-41d4-a716-446655440000' })
	@ApiResponse({ status: 200, description: 'Covers retrieved successfully' })
	@ApiResponse({ status: 404, description: 'Book not found' })
	@UseGuards(OptionalAuthGuard)
	getBookCovers(
		@Param('idBook') id: string,
		@CurrentUser() user?: CurrentUserDto
	) {
		return this.booksService.getCovers(id, user?.maxWeightSensitiveContent);
	}

	@Get(':idBook/infos')
	@ApiOperation({ summary: 'Get book information', description: 'Retrieve additional information and metadata about a book' })
	@ApiParam({ name: 'idBook', description: 'Book unique identifier', example: '550e8400-e29b-41d4-a716-446655440000' })
	@ApiResponse({ status: 200, description: 'Book information retrieved successfully' })
	@ApiResponse({ status: 404, description: 'Book not found' })
	@UseGuards(OptionalAuthGuard)
	getBookInfos(
		@Param('idBook') id: string,
		@CurrentUser() user?: CurrentUserDto
	) {
		return this.booksService.getInfos(id, user?.maxWeightSensitiveContent);
	}
}
