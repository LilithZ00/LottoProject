// To parse this JSON data, do
//
//     final postMoneyUserReponse = postMoneyUserReponseFromJson(jsonString);

import 'dart:convert';

PostMoneyUserReponse postMoneyUserReponseFromJson(String str) => PostMoneyUserReponse.fromJson(json.decode(str));

String postMoneyUserReponseToJson(PostMoneyUserReponse data) => json.encode(data.toJson());

class PostMoneyUserReponse {
    int userId;
    int amount;

    PostMoneyUserReponse({
        required this.userId,
        required this.amount,
    });

    factory PostMoneyUserReponse.fromJson(Map<String, dynamic> json) => PostMoneyUserReponse(
        userId: json["userId"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "amount": amount,
    };
}
