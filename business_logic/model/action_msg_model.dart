import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

ActionMsgModel actionMsgModelFromJson(String str) =>
    ActionMsgModel.fromJson(json.decode(str));

String actionMsgModelToJson(ActionMsgModel data) => json.encode(data.toJson());

class ActionMsgModel {
  ActionMsgModel(
      {this.msgid,
      this.action_id,
      this.text,
      this.avatar,
      this.createTime,
      this.memberid,
      this.nickname,
    });

  ObjectId? msgid;
  ObjectId? action_id;
  ObjectId? memberid;
  String? text;
  String? avatar;
  String? nickname;
  DateTime? createTime;



  factory ActionMsgModel.fromJson(Map<String, dynamic> json) => ActionMsgModel(
        action_id: json["action_id"],
        msgid: json["_id"],
        text: json["text"],
        avatar: json["avatar"],
        createTime: json["time"],
        memberid: json["memberid"],

        nickname: json["nickname"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "action_id": action_id,
        "_id": msgid,
        "text": text,

        "avatar": avatar,
        "time": createTime,
        "memberid": memberid,
        "nickname": nickname,
      };
}
