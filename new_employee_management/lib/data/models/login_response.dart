class LoginResponse {
  LoginResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  bool success;
  String message;
  int status;
  Data data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      status: json['status'] as int,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'status': status,
        'data': data.toJson(), // ✅ calls toJson on your Data object
      };
}

class Data {
  Data({
    required this.name,
    required this.email,
    required this.token,
    required this.expiry,
  });

  String name;
  String email;
  String token;
  String expiry;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      expiry: json['expiry'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'token': token,
        'expiry': expiry,
      };
}
