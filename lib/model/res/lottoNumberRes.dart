
import 'dart:convert';

LottoNumberRes lottoNumberResFromJson(String str) => LottoNumberRes.fromJson(json.decode(str));

String lottoNumberResToJson(LottoNumberRes data) => json.encode(data.toJson());

class LottoNumberRes {
    String message;

    LottoNumberRes({
        required this.message,
    });

    factory LottoNumberRes.fromJson(Map<String, dynamic> json) => LottoNumberRes(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
