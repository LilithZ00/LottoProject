// To parse this JSON data, do
//
//     final upDateUserId = upDateUserIdFromJson(jsonString);

import 'dart:convert';

UpDateUserId upDateUserIdFromJson(String str) => UpDateUserId.fromJson(json.decode(str));

String upDateUserIdToJson(UpDateUserId data) => json.encode(data.toJson());

class UpDateUserId {
    String name;
    String image;

    UpDateUserId({
        required this.name,
        required this.image,
    });

    factory UpDateUserId.fromJson(Map<String, dynamic> json) => UpDateUserId(
        name: json["name"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
    };
}
