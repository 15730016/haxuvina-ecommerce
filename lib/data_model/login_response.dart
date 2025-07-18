import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  bool? result;
  dynamic message;
  String? access_token;

  String? tokenType;
  DateTime? expiresAt;
  User? user;

  LoginResponse({
    this.result,
    this.message,
    this.access_token,
    this.tokenType,
    this.expiresAt,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    result: json["result"],
    message: json["message"],
    access_token: json["access_token"],
    tokenType: json["token_type"],
    expiresAt: json["expires_at"] == null
        ? null
        : DateTime.tryParse(json["expires_at"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "access_token": access_token,
    "token_type": tokenType,
    "expires_at": expiresAt?.toIso8601String(),
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  String? type;
  String? name;
  String? email;
  String? avatar;
  String? avatar_original;
  String? phone;
  bool? emailVerified;

  User({
    this.id,
    this.type,
    this.name,
    this.email,
    this.avatar,
    this.avatar_original,
    this.phone,
    this.emailVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    type: json["type"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    avatar_original: json["avatar_original"],
    phone: json["phone"],
    emailVerified: json["email_verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "name": name,
    "email": email,
    "avatar": avatar,
    "avatar_original": avatar_original,
    "phone": phone,
    "email_verified": emailVerified,
  };
}
