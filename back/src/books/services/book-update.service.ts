import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Book } from '../entitys/book.entity';
import { UpdateBookDto } from '../dto/update-book.dto';
import { CoverImageService } from '../jobs/cover-image.service';
import { BookRelationshipService } from './book-relationship.service';
import { EventEmitter2 } from '@nestjs/event-emitter';

/**
 * Service responsável pela atualização de livros
 */
@Injectable()
export class BookUpdateService {
    private readonly logger = new Logger(BookUpdateService.name);

    constructor(
        @InjectRepository(Book)
        private readonly bookRepository: Repository<Book>,
        private readonly bookRelationshipService: BookRelationshipService,
        private readonly coverImageService: CoverImageService,
        private readonly eventEmitter: EventEmitter2,
    ) {}

    /**
     * Atualiza um livro existente
     */
    async updateBook(id: string, dto: UpdateBookDto): Promise<Book> {
        const book = await this.bookRepository.findOne({
            where: { id },
            relations: ['tags', 'sensitiveContent', 'authors'],
        });

        if (!book) {
            this.logger.warn(`Book with id ${id} not found`);
            throw new NotFoundException(`Book with id ${id} not found`);
        }

        this.bookRepository.merge(book, {
            title: dto.title,
            alternativeTitle: dto.alternativeTitle,
            originalUrl: dto.originalUrl,
            description: dto.description,
            publication: dto.publication,
            type: dto.type,
        });

        if (dto.tags && dto.tags.length > 0) {
            book.tags = await this.bookRelationshipService.findOrCreateTags(dto.tags);
        }

        if (dto.authors && dto.authors.length > 0) {
            book.authors = await this.bookRelationshipService.findOrCreateAuthors(dto.authors);
        }

        if (dto.sensitiveContent && dto.sensitiveContent.length > 0) {
            book.sensitiveContent = await this.bookRelationshipService.findOrCreateSensitiveContent(
                dto.sensitiveContent,
            );
        }

        if (dto.cover && dto.cover.urlImgs && dto.cover.urlImgs.length > 0) {
            await this.coverImageService.addCoverToQueue(
                book.id,
                dto.cover.urlOrigin,
                dto.cover.urlImgs,
            );
        }

        const updatedBook = await this.bookRepository.save(book);

        // Emite evento de atualização de livro
        this.eventEmitter.emit('book.updated', updatedBook);

        return updatedBook;
    }

    /**
     * Seleciona uma capa específica para um livro
     */
    async selectCover(idBook: string, idCover: string): Promise<void> {
        const book = await this.bookRepository.findOne({
            where: { id: idBook },
            relations: ['covers'],
        });

        if (!book) {
            this.logger.warn(`Book with id ${idBook} not found`);
            throw new NotFoundException(`Book with id ${idBook} not found`);
        }

        book.covers = book.covers.map((cover) => ({
            ...cover,
            selected: cover.id === idCover,
        }));

        await this.bookRepository.save(book);

        // Emite evento de seleção de capa
        this.eventEmitter.emit('cover.selected', { bookId: idBook, coverId: idCover });
    }
}
