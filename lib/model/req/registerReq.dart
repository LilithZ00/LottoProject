// To parse this JSON data, do
//
//     final registerRequset = registerRequsetFromJson(jsonString);

import 'dart:convert';

RegisterRequset registerRequsetFromJson(String str) => RegisterRequset.fromJson(json.decode(str));

String registerRequsetToJson(RegisterRequset data) => json.encode(data.toJson());

class RegisterRequset {
    String username;
    String email;
    String password;

    RegisterRequset({
        required this.username,
        required this.email,
        required this.password,
    });

    factory RegisterRequset.fromJson(Map<String, dynamic> json) => RegisterRequset(
        username: json["username"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
    };
}
