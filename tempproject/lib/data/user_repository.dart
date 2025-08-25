class User {
  final String email;
  final String password;
  final String name;
  final String contact;
  final int age;

  const User({
    required this.email,
    required this.password,
    required this.name,
    required this.contact,
    required this.age,
  });
}

class UserRepository {
  // Mutable list now
  final List<User> _users = [
    const User(
      email: "musfiq677@gmail.com",
      password: "11111111",
      name: "Musfiq",
      contact: "+880123456789",
      age: 28,
    ),
    const User(
      email: "john.doe@example.com",
      password: "password123",
      name: "John Doe",
      contact: "+1234567890",
      age: 35,
    ),
    const User(
      email: "jane.smith@example.com",
      password: "mypassword",
      name: "Jane Smith",
      contact: "+1987654321",
      age: 30,
    ),
    const User(
      email: "admin@example.com",
      password: "adminadmin",
      name: "Admin User",
      contact: "+1122334455",
      age: 40,
    ),
  ];

  /// Authenticate user
  bool authenticate(String email, String password) {
    return _users.any((u) =>
        u.email.toLowerCase().trim() == email.toLowerCase().trim() &&
        u.password == password);
  }

  /// Get user by email
  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere(
        (u) => u.email.toLowerCase().trim() == email.toLowerCase().trim(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Register new user
  bool registerUser({
    required String email,
    required String password,
    required String name,
    required String contact,
    required int age,
  }) {
    // Check if user already exists
    if (getUserByEmail(email) != null) return false;

    _users.add(User(
      email: email,
      password: password,
      name: name,
      contact: contact,
      age: age,
    ));
    return true;
  }
}
