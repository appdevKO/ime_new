import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MissionModel missionModelFromJson(String str) =>
    MissionModel.fromJson(json.decode(str));

String missionModelToJson(MissionModel data) => json.encode(data.toJson());

class MissionModel {
  MissionModel({
    this.id,
    this.title,
    this.content,
    this.price,
    this.starttime,
    this.endtime,
    this.type,
    this.memberid,
    this.nickname,
    this.avatar,
  });

  ObjectId? id;
  String? title;
  String? content;
  String? price;
  DateTime? starttime;
  DateTime? endtime;
  int? type;
  ObjectId? memberid;
  String? nickname;
  String? avatar;

  factory MissionModel.fromJson(Map<String, dynamic> json) => MissionModel(
        id: json["_id"],
        title: json["title"],
        content: json["content"],
        price: json["price"],
        starttime: json["starttime"],
        endtime: json["endtime"],
        type: json["type"],
        memberid: json["memberid"],
        nickname: json["nickname"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "price": price,
        "starttime": starttime,
        "endtime": endtime,
        "type": type,
        "memberid": memberid,
        "nickname": nickname,
        "avatar": avatar,
      };
}
