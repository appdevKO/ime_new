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
      this.like_num,
      this.msg_num,
      this.like_list});

  ObjectId? msgid;
  ObjectId? action_id;
  ObjectId? memberid;
  String? text;
  String? avatar;
  String? nickname;
  DateTime? createTime;
  int? like_num;
  int? msg_num;
  List? like_list;

  factory ActionMsgModel.fromJson(Map<String, dynamic> json) => ActionMsgModel(
        action_id: json["action_id"],
        msgid: json["_id"],
        text: json["text"],
        avatar: json["avatar"],
        like_num: json["like_num"],
        msg_num: json["msg_num"],
        createTime: json["time"],
        memberid: json["memberid"],
        like_list: json["like_id_list"],
        nickname: json["nickname"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "action_id": action_id,
        "_id": msgid,
        "text": text,
        "like_num": like_num,
        "like_id_list": like_list,
        "msg_num": msg_num,
        "avatar": avatar,
        "time": createTime,
        "memberid": memberid,
        "nickname": nickname,
      };
}
