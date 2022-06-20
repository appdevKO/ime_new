import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

ActionModel actionModelFromJson(String str) =>
    ActionModel.fromJson(json.decode(str));

String actionModelToJson(ActionModel data) => json.encode(data.toJson());

class ActionModel {
  ActionModel(
      {this.id,
      this.text,
      this.image,
      this.avatar,
      this.image_sub,
      this.createTime,
      this.memberid,
      this.nickname,
      this.area,
      this.like_num,
      this.msg_num,
      this.share_num,
      this.like_list,
      this.account});

  ObjectId? id;
  ObjectId? memberid;
  String? text;
  String? image;
  String? account;
  String? image_sub;
  String? avatar;
  String? nickname;
  String? area;
  DateTime? createTime;
  int? like_num;
  int? msg_num;
  int? share_num;
  List? like_list;

  factory ActionModel.fromJson(Map<String, dynamic> json) => ActionModel(
        id: json["_id"],
        text: json["text"],
        image: json["image"],
        account: json["account"],
        image_sub: json["image_sub"],
        avatar: json["avatar"],
        createTime: json["time"],
        memberid: json["memberid"],
        like_num: json["like_num"],
        msg_num: json["msg_num"],
        share_num: json["share_num"],
        nickname: json["nickname"].toString(),
        like_list: json["like_id_list"],
        area: json["area"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "account": account,
        "image": image,
        "image_sub": image_sub,
        "avatar": avatar,
        "time": createTime,
        "memberid": memberid,
        "like_id_list": like_list,
        "nickname": nickname,
        "area": area,
        "like_num": like_num,
        "msg_num": msg_num,
        "share_num": share_num,
      };
}
