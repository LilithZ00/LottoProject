// To parse this JSON data, do
//
//     final getUserReponse = getUserReponseFromJson(jsonString);

import 'dart:convert';

GetUserReponse getUserReponseFromJson(String str) => GetUserReponse.fromJson(json.decode(str));

String getUserReponseToJson(GetUserReponse data) => json.encode(data.toJson());

class GetUserReponse {
    //int userId;
    String userName;
    String userEmail;
    int userWallet;
    String userType;
    String userImage;

    GetUserReponse({
        //required this.userId,
        required this.userName,
        required this.userEmail,
        required this.userWallet,
        required this.userType,
        required this.userImage,
    });

    factory GetUserReponse.fromJson(Map<String, dynamic> json) => GetUserReponse(
        //userId: json["user_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userWallet: json["user_wallet"],
        userType: json["user_type"],
        userImage: json["user_image"],
    );

    Map<String, dynamic> toJson() => {
        //"user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_wallet": userWallet,
        "user_type": userType,
        "user_image": userImage,
    };
}
