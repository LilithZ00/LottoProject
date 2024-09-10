// To parse this JSON data, do
//
//     final insertLotto = insertLottoFromJson(jsonString);

import 'dart:convert';

InsertLotto insertLottoFromJson(String str) => InsertLotto.fromJson(json.decode(str));

String insertLottoToJson(InsertLotto data) => json.encode(data.toJson());

class InsertLotto {
    String lottoNumber;

    InsertLotto({
        required this.lottoNumber,
    });

    factory InsertLotto.fromJson(Map<String, dynamic> json) => InsertLotto(
        lottoNumber: json["lottoNumber"],
    );

    Map<String, dynamic> toJson() => {
        "lottoNumber": lottoNumber,
    };
}
