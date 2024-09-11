// To parse this JSON data, do
//
//     final allLottoRes = allLottoResFromJson(jsonString);

import 'dart:convert';

List<AllLottoRes> allLottoResFromJson(String str) => List<AllLottoRes>.from(json.decode(str).map((x) => AllLottoRes.fromJson(x)));

String allLottoResToJson(List<AllLottoRes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllLottoRes {
    int lottoId;
    String lottoNumber;

    AllLottoRes({
        required this.lottoId,
        required this.lottoNumber,
    });

    factory AllLottoRes.fromJson(Map<String, dynamic> json) => AllLottoRes(
        lottoId: json["lotto_id"],
        lottoNumber: json["lotto_number"],
    );

    Map<String, dynamic> toJson() => {
        "lotto_id": lottoId,
        "lotto_number": lottoNumber,
    };
}
