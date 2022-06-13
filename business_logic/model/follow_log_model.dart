import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

FollowLogModel follow_logFromJson(String str) =>
    FollowLogModel.fromJson(json.decode(str));

String follow_logToJson(FollowLogModel data) => json.encode(data.toJson());

class FollowLogModel {
  FollowLogModel({this.id, this.memberid, this.createtime, this.list_id});

  ObjectId? id;
  ObjectId? memberid;
  DateTime? createtime;
  List? list_id;

  factory FollowLogModel.fromJson(Map<String, dynamic> json) => FollowLogModel(
        id: json["_id"],
        memberid: json["member_id"],
        createtime: json["create_time"],
        list_id: json["list_id"] != null ? json["list_id"] : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "member_id": memberid,
        'create_time': createtime,
        'list_id': list_id,
      };
}
