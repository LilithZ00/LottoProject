// To parse this JSON data, do
//
//     final allLotto = allLottoFromJson(jsonString);

import 'dart:convert';

List<AllLotto> allLottoFromJson(String str) => List<AllLotto>.from(json.decode(str).map((x) => AllLotto.fromJson(x)));

String allLottoToJson(List<AllLotto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllLotto {
    int lottoId;
    String lottoNumber;
    String lottoStatus;

    AllLotto({
        required this.lottoId,
        required this.lottoNumber,
        required this.lottoStatus,
    });

    factory AllLotto.fromJson(Map<String, dynamic> json) => AllLotto(
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
