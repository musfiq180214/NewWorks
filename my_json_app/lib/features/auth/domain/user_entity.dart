class UserEntity {
  final int id;
  final String name;
  final String email;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
