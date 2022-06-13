import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

ChatRoomModel chatRoomModelFromJson(String str) =>
    ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  ChatRoomModel({
    this.id,
    this.area,
    this.imgurl,
    this.note,
    this.purpose,
    this.ownerId,
    this.quota,
    this.rule,
    this.title,
    this.createTime,
    this.owner_sex,
    this.datetime,
  });

  ObjectId? id;
  String? area;
  String? imgurl;
  String? note;
  String? purpose;
  String? ownerId;
  int? quota;
  String? rule;
  String? title;
  DateTime? createTime;
  int? owner_sex;
  DateTime? datetime;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        id: json["_id"],
        area: json["area"],
        imgurl: json["imgurl"],
        note: json["note"],
        purpose: json["purpose"],
        ownerId: json["owner_id"],
        quota: json["quota"],
        rule: json["rule"],
        title: json["title"],
        createTime: json["create_time"],
        owner_sex: json["owner_sex"],
        datetime: json["datetime"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "area": area,
        "imgurl": imgurl,
        "note": note,
        "purpose": purpose,
        "owner_id": ownerId,
        "quota": quota,
        "rule": rule,
        "title": title,
        "create_time": createTime,
        "owner_sex": owner_sex,
        "datetime": datetime,
      };
}
