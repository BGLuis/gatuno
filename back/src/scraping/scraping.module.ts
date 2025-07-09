import { Module } from '@nestjs/common';
import { ScrapingService } from './scraping.service';
import { AppConfigModule } from 'src/app-config/app-config.module';
import { FilesModule } from 'src/files/files.module';
import { Website } from './entitys/website.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WebsiteService } from './website.service';
import { WebsiteController } from './website.controller';

@Module({
	controllers: [WebsiteController],
	providers: [ScrapingService, WebsiteService],
	exports: [ScrapingService],
	imports: [
		AppConfigModule,
		FilesModule,
		TypeOrmModule.forFeature([Website]),
	],
})
export class ScrapingModule {}
