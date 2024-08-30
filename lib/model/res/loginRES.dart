// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
    int userId;
    String userType;
    String userName;
    String phone;

    Profile({
        required this.userId,
        required this.userType,
        required this.userName,
        required this.phone,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
