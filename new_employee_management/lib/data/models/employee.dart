class EmployeeList {
  EmployeeList({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  final bool success;
  final String message;
  final int status;
  final List<EmployeeListData> data;

  factory EmployeeList.fromJson(Map<String, dynamic> json) {
    return EmployeeList(
      success: json['success'] as bool,
      message: json['message'] as String,
      status: json['status'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => EmployeeListData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class EmployeeListData {
  EmployeeListData({
    required this.id,
    required this.name,
    this.designation,
    this.email,
    this.phone,
    this.bloodGroup,
    required this.isDonor,
  });

  final int id;
  final String name;
  final String? designation;
  final String? email;
  final String? phone;
  final String? bloodGroup;
  final bool isDonor;

  factory EmployeeListData.fromJson(Map<String, dynamic> json) {
    return EmployeeListData(
      id: json['id'] as int,
      name: json['name'] as String? ?? "",
      designation: json['designation'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      bloodGroup: json['blood_group'] as String? ?? "",
      isDonor: json['is_donor'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'designation': designation,
        'email': email,
        'phone': phone,
        'blood_group': bloodGroup,
        'is_donor': isDonor,
      };
}
