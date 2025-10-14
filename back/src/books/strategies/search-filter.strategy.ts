import { SelectQueryBuilder } from 'typeorm';
import { Book } from '../entitys/book.entity';
import { BookPageOptionsDto } from '../dto/book-page-options.dto';
import { FilterStrategy } from './filter-strategy.interface';

export class SearchFilterStrategy implements FilterStrategy {
    canApply(options: BookPageOptionsDto): boolean {
        return !!options.search && options.search.trim().length > 0;
    }

    apply(
        queryBuilder: SelectQueryBuilder<Book>,
        options: BookPageOptionsDto,
    ): void {
        queryBuilder.andWhere(
            '(book.title LIKE :search OR book.description LIKE :search OR book.alternativeTitle LIKE :search)',
            { search: `%${options.search}%` },
        );
    }
}
