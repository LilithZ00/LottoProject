// To parse this JSON data, do
//
//     final insertResult = insertResultFromJson(jsonString);

import 'dart:convert';

InsertResult insertResultFromJson(String str) => InsertResult.fromJson(json.decode(str));

String insertResultToJson(InsertResult data) => json.encode(data.toJson());

class InsertResult {
    String lottoNumber;

    InsertResult({
        required this.lottoNumber,
    });

    factory InsertResult.fromJson(Map<String, dynamic> json) => InsertResult(
        lottoNumber: json["lottoNumber"],
    );

    Map<String, dynamic> toJson() => {
        "lottoNumber": lottoNumber,
    };
}
