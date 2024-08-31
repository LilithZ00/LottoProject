// To parse this JSON data, do
//
//     final loginRes = loginResFromJson(jsonString);

import 'dart:convert';

LoginRes loginResFromJson(String str) => LoginRes.fromJson(json.decode(str));

String loginResToJson(LoginRes data) => json.encode(data.toJson());

class LoginRes {
    int userId;
    String userName;
    String userPhone;
    String userEmail;
    int userWallet;
    String userType;

    LoginRes({
        required this.userId,
        required this.userName,
        required this.userPhone,
        required this.userEmail,
        required this.userWallet,
        required this.userType,
    });

    factory LoginRes.fromJson(Map<String, dynamic> json) => LoginRes(
        userId: json["user_id"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        userEmail: json["user_email"],
        userWallet: json["user_wallet"],
        userType: json["user_type"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_phone": userPhone,
        "user_email": userEmail,
        "user_wallet": userWallet,
        "user_type": userType,
    };
}
