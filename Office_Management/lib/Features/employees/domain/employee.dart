class Employee {
  final String id;
  final String name;
  final String designation;
  final String email;
  final String phone;
  final String bloodGroup;
  final bool isDonor;

  Employee({
    required this.id,
    required this.name,
    required this.designation,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.isDonor,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      isDonor: json['isDonor'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "designation": designation,
      "email": email,
      "phone": phone,
      "bloodGroup": bloodGroup,
      "isDonor": isDonor,
    };
  }
}
