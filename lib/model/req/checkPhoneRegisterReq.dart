// To parse this JSON data, do
//
//     final checkPhoneRegisterReq = checkPhoneRegisterReqFromJson(jsonString);

import 'dart:convert';

CheckPhoneRegisterReq checkPhoneRegisterReqFromJson(String str) => CheckPhoneRegisterReq.fromJson(json.decode(str));

String checkPhoneRegisterReqToJson(CheckPhoneRegisterReq data) => json.encode(data.toJson());

class CheckPhoneRegisterReq {
    String userPhone;

    CheckPhoneRegisterReq({
        required this.userPhone,
    });

    factory CheckPhoneRegisterReq.fromJson(Map<String, dynamic> json) => CheckPhoneRegisterReq(
        userPhone: json["user_phone"],
    );

    Map<String, dynamic> toJson() => {
        "user_phone": userPhone,
    };
}
