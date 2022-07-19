import 'dart:convert';

Audience audienceFromJson(String str) => Audience.fromJson(json.decode(str));

String audienceToJson(Audience data) => json.encode(data.toJson());

class Audience {
  Audience({
    required this.selfAccount,
    required this.selfEncodeName,
    required this.anchorId,
    required this.anchorAccount,
    required this.encodeAnchorName,
    required this.anchorAvatar,
    required this.roomId,
    required this.vdoStatus,
  });
  String selfAccount;
  String selfEncodeName;
  String anchorId;
  String encodeAnchorName;
  String anchorAccount;
  String anchorAvatar;
  String roomId;
  String vdoStatus;

  factory Audience.fromJson(Map<String, dynamic> json) => Audience(
        selfAccount: json["selfAccount"],
        selfEncodeName: json["selfEncodeName"],
        anchorId: json["anchorId"],
        anchorAccount: json["anchorAccount"],
        encodeAnchorName: json["encodeAnchorName"],
        anchorAvatar: json["anchorAvatar"],
        roomId: json["roomId"],
        vdoStatus: json["vdoStatus"],
      );

  Map<String, dynamic> toJson() => {
        "selfAccount": selfAccount,
        "selfEncodeName": selfEncodeName,
        "anchorId": anchorId,
        "anchorAccount": anchorAccount,
        "encodeAnchorName": encodeAnchorName,
        "anchorAvatar": anchorAvatar,
        "roomID": roomId,
        "vdoStatus": vdoStatus,
      };
}
