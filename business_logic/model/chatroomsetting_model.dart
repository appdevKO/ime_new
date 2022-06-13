import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

ChatroomSettingModel chatroomFromJson(String str) =>
    ChatroomSettingModel.fromJson(json.decode(str));

String chatroomToJson(ChatroomSettingModel data) => json.encode(data.toJson());

class ChatroomSettingModel {
  ChatroomSettingModel({this.id, this.imgurl, this.rule, this.note,this.purpose});

  ObjectId? id;
  String? imgurl;
  String? rule;
  String? note;
  String? purpose;

  factory ChatroomSettingModel.fromJson(Map<String, dynamic> json) =>
      ChatroomSettingModel(
        id: json["_id"],
        imgurl: json["imgurl"],
        note: json["note"],
        rule: json["rule"],
        purpose: json["purpose"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "imgurl": imgurl,
        "rule": rule,
        "note": note,
        "purpose": purpose,
      };
}
