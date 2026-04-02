import 'package:flutter_test/flutter_test.dart';
import 'package:gatuno/features/users/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJwt should create valid model from correct payload', () {
      final payload = {
        'sub': '123',
        'email': 'test@example.com',
        'username': 'testuser',
        'name': 'Test User',
        'roles': ['user'],
        'maxWeightSensitiveContent': 5,
      };

      final model = UserModel.fromJwt(payload);

      expect(model.id, equals('123'));
      expect(model.email, equals('test@example.com'));
      expect(model.userName, equals('testuser'));
      expect(model.name, equals('Test User'));
      expect(model.roles, equals(['user']));
      expect(model.maxWeightSensitiveContent, equals(5));
      expect(model.displayName, equals('Test User'));
    });

    test('displayName should fallback correctly', () {
      final payload = {
        'sub': '123',
        'email': 'test@example.com',
        'roles': ['user'],
      };

      final model = UserModel.fromJwt(payload);
      expect(model.displayName, equals('test'));

      final modelWithUsername = UserModel.fromJwt({
        ...payload,
        'username': 'johndoe',
      });
      expect(modelWithUsername.displayName, equals('johndoe'));
    });

    test(
      'fromJwt should throw FormatException for missing required fields',
      () {
        expect(
          () => UserModel.fromJwt({'sub': '123'}),
          throwsA(isA<FormatException>()),
        );
      },
    );

    test('fromJwt should throw FormatException for empty required strings', () {
      final payload = {
        'sub': '',
        'email': 'test@example.com',
        'roles': ['user'],
      };
      expect(() => UserModel.fromJwt(payload), throwsA(isA<FormatException>()));
    });
  });
}
