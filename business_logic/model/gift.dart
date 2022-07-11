import 'dart:convert';

Gift giftFromJson(String str) => Gift.fromJson(json.decode(str));

String giftToJson(Gift data) => json.encode(data.toJson());

class Gift {
  Gift({
    required this.name,
    required this.ch_name,
    required this.money,
    required this.music,
    required this.icon_url,
    required this.gif_url,
  });

  String name;
  String ch_name;
  String music;
  String money;
  String icon_url;
  String gif_url;

  factory Gift.fromJson(Map<String, dynamic> json) => Gift(
        name: json["name"],
        ch_name: json["ch_name"],
        money: json["money"],
        music: json["music"],
        icon_url: json["icon_url"],
        gif_url: json["gif_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "ch_name": ch_name,
        "money": money,
        "music": music,
        "icon_url": icon_url,
        "gif_url": gif_url,
      };
}
