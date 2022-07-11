import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:mongo_dart/mongo_dart.dart';

PushNotifyModel pushNotifyFromJson(String str) =>
    PushNotifyModel.fromJson(json.decode(str));

String pushNotifyToJson(PushNotifyModel data) => json.encode(data.toJson());

class PushNotifyModel {
  PushNotifyModel(
      {this.memberid,
      this.fcmtoken,
      this.nickname,
      this.chatroomid,
      this.avatar,
      this.route});

  ObjectId? memberid;
  String? chatroomid;
  String? nickname;
  String? avatar;
  String? fcmtoken;
  String? route;

  factory PushNotifyModel.fromJson(Map<String, dynamic> json) =>
      PushNotifyModel(
        memberid: mongo.ObjectId.fromHexString(json["memberid"]),
        chatroomid: json["chatroomid"],
        avatar: json["avatar"],
        fcmtoken: json["fcmtoken"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        route: json["route"],
      );

  Map<String, dynamic> toJson() => {
        "memberid": memberid,
        'nickname': nickname,
        'chatroomid': chatroomid,
        'avatar': avatar,
        'fcmtoken': fcmtoken,
        'route': route,
      };
}
