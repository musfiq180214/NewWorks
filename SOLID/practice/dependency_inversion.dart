abstract class Database {
  void saveData(String data);
}

class MySQLDatabase implements Database {
  @override
  void saveData(String data) => print('Saving "$data" to MySQL');
}

class FirebaseDatabase implements Database {
  @override
  void saveData(String data) => print('Saving "$data" to Firebase');
}

class UserService {
  final Database db;

  UserService(this.db);

  void saveUser(String user) {
    db.saveData(user);
  }
}

void main() {
  UserService service1 = UserService(MySQLDatabase());
  service1.saveUser("John");

  UserService service2 = UserService(FirebaseDatabase());
  service2.saveUser("Alice");
}
