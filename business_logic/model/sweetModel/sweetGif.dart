import 'dart:convert';

SweetGif sweetGifFromJson(String str) => SweetGif.fromJson(json.decode(str));

String sweetGifToJson(SweetGif data) => json.encode(data.toJson());

class SweetGif {
  SweetGif({
    required this.senderName,
    required this.giftName,
    required this.ms,
    required this.musicUrl,
  });

  String senderName;
  String giftName;
  String ms;
  String musicUrl;

  factory SweetGif.fromJson(Map<String, dynamic> json) => SweetGif(
        senderName: json["senderName"],
        giftName: json["giftName"],
        ms: json["ms"],
        musicUrl: json["musicUrl"],
      );

  Map<String, dynamic> toJson() => {
        "senderName": senderName,
        "giftName": giftName,
        "ms": ms,
        "musicUrl": musicUrl,
      };
}
