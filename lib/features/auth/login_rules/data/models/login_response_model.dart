class LoginResponse {
  const LoginResponse({required this.token, this.customer});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      customer: json['customer'] != null
          ? LoginCustomer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
    );
  }

  final String token;
  final LoginCustomer? customer;
}

class LoginCustomer {
  const LoginCustomer({this.id, this.firstname, this.lastname, this.email});

  factory LoginCustomer.fromJson(Map<String, dynamic> json) {
    return LoginCustomer(
      id: json['id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
    );
  }

  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;
}
