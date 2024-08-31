// To parse this JSON data, do
//
//     final registerRequset = registerRequsetFromJson(jsonString);

import 'dart:convert';

RegisterRequset registerRequsetFromJson(String str) => RegisterRequset.fromJson(json.decode(str));

String registerRequsetToJson(RegisterRequset data) => json.encode(data.toJson());

class RegisterRequset {
    String username;
    String phone;
    String email;
    String password;
    int wallet;

    RegisterRequset({
        required this.username,
        required this.phone,
        required this.email,
        required this.password,
        required this.wallet,
    });

    factory RegisterRequset.fromJson(Map<String, dynamic> json) => RegisterRequset(
        username: json["username"],
        phone: json["phone"],
        email: json["email"],
        password: json["password"],
        wallet: json["wallet"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "phone": phone,
        "email": email,
        "password": password,
        "wallet": wallet,
    };
}
