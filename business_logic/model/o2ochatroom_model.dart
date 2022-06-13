import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

O2ORoomModel o2oRoomModelFromJson(String str) =>
    O2ORoomModel.fromJson(json.decode(str));

String o2oRoomModelToJson(O2ORoomModel data) => json.encode(data.toJson());

class O2ORoomModel {
  O2ORoomModel(
      {this.id, this.memberid, this.chatto_id, this.nickname, this.avatar});

  ObjectId? id;
  ObjectId? memberid;
  ObjectId? chatto_id;
  String? nickname;
  String? avatar;
//  建立room list的時候 傳入的圖片就是小圖

  factory O2ORoomModel.fromJson(Map<String, dynamic> json) => O2ORoomModel(
        id: json["_id"],
        memberid: json["member_id"],
        chatto_id: json["chatto_id"],
        nickname: json["nickname"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "member_id": memberid,
        "chatto_id": chatto_id,
        "nickname": nickname,
        "avatar": avatar,
      };
}
