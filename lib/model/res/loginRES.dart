// To parse this JSON data, do
//
//     final loginRes = loginResFromJson(jsonString);

import 'dart:convert';

LoginRes loginResFromJson(String str) => LoginRes.fromJson(json.decode(str));

String loginResToJson(LoginRes data) => json.encode(data.toJson());

class LoginRes {
    int userId;
    String userType;
    String userName;
    String phone;

    LoginRes({
        required this.userId,
        required this.userType,
        required this.userName,
        required this.phone,
    });

    factory LoginRes.fromJson(Map<String, dynamic> json) => LoginRes(
        userId: json["user_id"],
        userType: json["user_type"],
        userName: json["user_name"],
        phone: json["phone"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_type": userType,
        "user_name": userName,
        "phone": phone,
    };
}
//     class login {
//     int userId;
//     String userType;
//     String userName;
//     String phone;
    
//     login({
//         required this.userId,
//         required this.userType,
//         required this.userName,
//         required this.phone,
//     });

//     factory login.fromJson(Map<String, dynamic> json) => login(
//         userId: json["userId"],
//         userType: json["userType"],
//         userName: json["userName"],
//         phone: json["phone"],
//     );

//     Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "userType": userType,
//         "userName": userName,
//         "phone": phone,
//     };
// }
