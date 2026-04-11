import '../../domain/entities/author.dart';

class AuthorModel extends Author {
  const AuthorModel({required super.id, required super.name});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(id: json['id'] as String, name: json['name'] as String);
  }
}
