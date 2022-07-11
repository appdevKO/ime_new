// To parse this JSON data, do
//
//     final anchor = anchorFromJson(jsonString);

import 'dart:convert';

Anchor anchorFromJson(String str) => Anchor.fromJson(json.decode(str));

String anchorToJson(Anchor data) => json.encode(data.toJson());

class Anchor {
  Anchor({
    required this.agoraId,
    required this.selfAccount,
    required this.selfEncodeName,
    required this.selfAvatar,
    required this.encodeRoomName,
    required this.encodeRoomExplain,
    required this.roomId,
    required this.vdoStatus,
  });

  String agoraId;
  String selfAccount;
  String selfEncodeName;
  String selfAvatar;
  String encodeRoomName;
  String encodeRoomExplain;
  String roomId;
  bool vdoStatus;

  factory Anchor.fromJson(Map<String, dynamic> json) => Anchor(
        agoraId: json["agoraId"],
        selfAccount: json["selfAccount"],
        selfEncodeName: json["selfEncodeName"],
        selfAvatar: json["selfAvatar"],
        encodeRoomName: json["encodeRoomName"],
        encodeRoomExplain: json["encodeRoomExplain"],
        roomId: json["roomId"],
        vdoStatus: json["vdoStatus"],
      );

  Map<String, dynamic> toJson() => {
        "agoraId": agoraId,
        "selfAccount": selfAccount,
        "selfEncodeName": selfEncodeName,
        "selfAvatar": selfAvatar,
        "encodeRoomName": encodeRoomName,
        "encodeRoomExplain": encodeRoomExplain,
        "roomId": roomId,
        "vdoStatus": vdoStatus,
      };
}
