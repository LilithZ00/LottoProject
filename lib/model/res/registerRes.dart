// To parse this JSON data, do
//
//     final registerRes = registerResFromJson(jsonString);

import 'dart:convert';

RegisterRes registerResFromJson(String str) => RegisterRes.fromJson(json.decode(str));

String registerResToJson(RegisterRes data) => json.encode(data.toJson());

class RegisterRes {
    String message;

    RegisterRes({
        required this.message,
    });

    factory RegisterRes.fromJson(Map<String, dynamic> json) => RegisterRes(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
