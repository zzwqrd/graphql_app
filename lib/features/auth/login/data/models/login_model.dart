class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class LoginResponse {
  final String token;
  final Customer? customer;

  LoginResponse({required this.token, this.customer});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'])
          : null,
    );
  }
}

class Customer {
  final String? id;
  final String? firstname;
  final String? lastname;
  final String? email;

  Customer({this.id, this.firstname, this.lastname, this.email});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
  };
}

class LoginData {
  final LoginResponse? loginResponse;
  final String? token;
  final Customer? customer;

  LoginData({this.loginResponse, this.token, this.customer});
}
