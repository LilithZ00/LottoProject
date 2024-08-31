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
    String userName;
    String phone;
    String email;

    LoginRes({
        required this.userId,
        required this.userName,
        required this.userPhone,
        required this.userEmail,
        required this.userWallet,
        required this.userType,
        required this.userName,
        required this.phone,
        required this.email,
    });

    factory LoginRes.fromJson(Map<String, dynamic> json) => LoginRes(
        userId: json["user_id"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        userEmail: json["user_email"],
        userWallet: json["user_wallet"],
        userType: json["user_type"],
        userName: json["user_name"],
        phone: json["user_phone"],
        email: json["user_email"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_phone": userPhone,
        "user_email": userEmail,
        "user_wallet": userWallet,
        "user_type": userType,
        "user_name": userName,
        "user_phone": phone,
        "user_email":email
    };
}
