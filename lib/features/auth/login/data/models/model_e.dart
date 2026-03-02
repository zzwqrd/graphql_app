import '../../../../../core/utils/base.dart';

class GetDataUserModel extends Model {
  late String message;
  late Datum data;

  GetDataUserModel.fromJson([Map<String, dynamic>? json]) {
    id = stringFromJson(json, "id");
    message = stringFromJson(json, "message");
    data = Datum.fromJson(json?["data"]);
  }
}

class Datum extends Model {
  late User1 user;
  late Access access;

  Datum.fromJson([Map<String, dynamic>? json]) {
    id = stringFromJson(json, "id");
    user = User1.fromJson(json?["user"]);
    access = Access.fromJson(json?["access"]);
  }
}

class User1 extends Model {
  late String name;
  late String phone;
  late bool phoneVerified;
  late String email;
  late bool emailVerified;
  late bool isActive;
  late String profilePhoto;
  late dynamic gender;
  late dynamic dateOfBirth;
  late String country;
  late String phoneCode;

  User1.fromJson([Map<String, dynamic>? json]) {
    id = intFromJson(json, "id");
    name = stringFromJson(json, "name");
    phone = stringFromJson(json, "phone");
    phoneVerified = boolFromJson(json, "phone_verified");
    email = stringFromJson(json, "email");
    emailVerified = boolFromJson(json, "email_verified");
    isActive = boolFromJson(json, "is_active");
    profilePhoto = stringFromJson(json, "profile_photo");
    country = stringFromJson(json, "country");
    phoneCode = stringFromJson(json, "phone_code");
  }
}

class Access extends Model {
  late String authType;
  late String token;
  late String expiresAt;

  Access.fromJson([Map<String, dynamic>? json]) {
    id = stringFromJson(json, "id");
    authType = stringFromJson(json, "auth_type");
    token = stringFromJson(json, "token");
    expiresAt = stringFromJson(json, "expires_at");
  }
}
