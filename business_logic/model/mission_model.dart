import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MissionModel missionModelFromJson(String str) =>
    MissionModel.fromJson(json.decode(str));

String missionModelToJson(MissionModel data) => json.encode(data.toJson());

class MissionModel {
  MissionModel(
      {this.id,
      this.title,
      this.content,
      this.price,
      this.actual_price,
      this.starttime,
      this.endtime,
      this.type,
      this.memberid,
      this.nickname,
      this.avatar,
      this.status});

  ObjectId? id;
  String? title;
  String? content;
  int? price;
  int? status;
  int? actual_price;
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
        actual_price: json["actual_price"],
        starttime: json["starttime"],
        endtime: json["endtime"],
        type: json["type"],
        status: json["status"],
        memberid: json["memberid"],
        nickname: json["nickname"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "price": price,
        "actual_price": actual_price,
        "status": status,
        "starttime": starttime,
        "endtime": endtime,
        "type": type,
        "memberid": memberid,
        "nickname": nickname,
        "avatar": avatar,
      };
}
