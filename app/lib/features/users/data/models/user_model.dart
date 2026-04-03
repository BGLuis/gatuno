class UserModel {
  final String id;
  final String email;
  final String? userName;
  final String? name;
  final List<String> roles;
  final int maxWeightSensitiveContent;

  UserModel({
    required this.id,
    required this.email,
    this.userName,
    this.name,
    required this.roles,
    required this.maxWeightSensitiveContent,
  });

  factory UserModel.fromJwt(Map<String, dynamic> payload) {
    final sub = payload['sub'] as String? ?? '';
    final email = payload['email'] as String? ?? '';
    final roles = payload['roles'] as Iterable<dynamic>?;

    if (sub.isEmpty || email.isEmpty || roles == null) {
      throw const FormatException(
        'Invalid JWT payload: missing required fields or empty values (sub, email, or roles)',
      );
    }

    return UserModel(
      id: sub,
      email: email,
      userName: payload['username'] as String?,
      name: payload['name'] as String?,
      roles: List<String>.from(roles),
      maxWeightSensitiveContent:
          payload['maxWeightSensitiveContent'] as int? ?? 0,
    );
  }

  String get displayName => name ?? userName ?? email.split('@')[0];
}
