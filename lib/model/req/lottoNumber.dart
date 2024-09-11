import 'dart:convert';

LottoNumberReq lottoNumberReqFromJson(String str) => LottoNumberReq.fromJson(json.decode(str));

String lottoNumberReqToJson(LottoNumberReq data) => json.encode(data.toJson());

class LottoNumberReq {
    String lottoNumber;

    LottoNumberReq({
        required this.lottoNumber,
    });

    factory LottoNumberReq.fromJson(Map<String, dynamic> json) => LottoNumberReq(
        lottoNumber: json["lottoNumber"],
    );

    Map<String, dynamic> toJson() => {
        "lottoNumber": lottoNumber,
    };
}
