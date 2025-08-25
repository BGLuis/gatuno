import { Injectable, NotFoundException, OnModuleInit, Logger } from '@nestjs/common';
import { User } from './entitys/user.entity';
import { Role } from './entitys/role.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { UpdateUserDto } from './dto/update-user.dto';
import { RolesEnum } from './enum/roles.enum';

@Injectable()
export class UsersService implements OnModuleInit {
    private readonly logger = new Logger(UsersService.name);
    constructor(
        @InjectRepository(User)
        private readonly userRepository: Repository<User>,
        @InjectRepository(Role)
        private readonly roleRepository: Repository<Role>,
    ) {}

    async onModuleInit() {
        const roles = [
            {
                name: RolesEnum.ADMIN,
                maxWeightSensitiveContent: 99
            },
            {
                name: RolesEnum.USER,
                maxWeightSensitiveContent: 4
            },
        ]
        for (const role of roles) {
            const exists = await this.roleRepository.findOne({ where: { name: role.name } });
            if (!exists) {
                await this.roleRepository.save(this.roleRepository.create(role));
            }
        }
    }

    async updateUser(dto: UpdateUserDto, userId: string): Promise<User> {
        const user = await this.userRepository.findOne({ where: { id: userId } });
        if (!user) {
            throw new NotFoundException(`User with id ${userId} not found`);
        }
        return this.userRepository.save(
            this.userRepository.merge(user, dto)
        );
    }
}
