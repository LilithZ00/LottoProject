// To parse this JSON data, do
//
//     final customerLoginPostRequest = customerLoginPostRequestFromJson(jsonString);

import 'dart:convert';

CustomerLoginPostRequest customerLoginPostRequestFromJson(String str) => CustomerLoginPostRequest.fromJson(json.decode(str));

String customerLoginPostRequestToJson(CustomerLoginPostRequest data) => json.encode(data.toJson());

class CustomerLoginPostRequest {
    String email;
    String password;

    CustomerLoginPostRequest({
        required this.email,
        required this.password,
    });

    factory CustomerLoginPostRequest.fromJson(Map<String, dynamic> json) => CustomerLoginPostRequest(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
