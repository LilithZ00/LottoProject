// To parse this JSON data, do
//
//     final getUsers = getUsersFromJson(jsonString);

import 'dart:convert';

GetUsers getUsersFromJson(String str) => GetUsers.fromJson(json.decode(str));

String getUsersToJson(GetUsers data) => json.encode(data.toJson());

class GetUsers {
    int userId;
    String userName;
    String userEmail;
    int userWallet;
    String userType;
    String userImage;

    GetUsers({
        required this.userId,
        required this.userName,
        required this.userEmail,
        required this.userWallet,
        required this.userType,
        required this.userImage,
    });

    factory GetUsers.fromJson(Map<String, dynamic> json) => GetUsers(
        userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userWallet: json["user_wallet"],
        userType: json["user_type"],
        userImage: json["user_image"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_wallet": userWallet,
        "user_type": userType,
        "user_image": userImage,
    };
}
