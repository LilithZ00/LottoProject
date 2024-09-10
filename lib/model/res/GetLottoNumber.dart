// To parse this JSON data, do
//
//     final getLottoNumber = getLottoNumberFromJson(jsonString);

import 'dart:convert';

List<GetLottoNumber> getLottoNumberFromJson(String str) => List<GetLottoNumber>.from(json.decode(str).map((x) => GetLottoNumber.fromJson(x)));

String getLottoNumberToJson(List<GetLottoNumber> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLottoNumber {
    int lottoId;
    String lottoNumber;
    String lottoStatus;

    GetLottoNumber({
        required this.lottoId,
        required this.lottoNumber,
        required this.lottoStatus,
    });

    factory GetLottoNumber.fromJson(Map<String, dynamic> json) => GetLottoNumber(
        lottoId: json["lotto_id"],
        lottoNumber: json["lotto_number"],
        lottoStatus: json["lotto_status"],
    );

    Map<String, dynamic> toJson() => {
        "lotto_id": lottoId,
        "lotto_number": lottoNumber,
        "lotto_status": lottoStatus,
    };
}
