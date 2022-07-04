import 'dart:convert';

import 'package:ime_new/business_logic/model/dbuserinfo_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

FollowLogModel follow_logFromJson(String str) =>
    FollowLogModel.fromJson(json.decode(str));

String follow_logToJson(FollowLogModel data) => json.encode(data.toJson());

class FollowLogModel {
  FollowLogModel(
      {this.id,
      this.memberid,
      this.createtime,
      this.list_id,
      this.following_userinfo,
      this.followed_userinfo});

  ObjectId? id;
  ObjectId? memberid;
  DateTime? createtime;
  List? list_id;
  var following_userinfo;
  var followed_userinfo;

  factory FollowLogModel.fromJson(Map<String, dynamic> json) => FollowLogModel(
      id: json["_id"],
      memberid: json["member_id"],
      createtime: json["create_time"],
      list_id: json["list_id"] != null ? json["list_id"] : null,
      following_userinfo: json['following_userinfo'] != null
          ? DbUserinfoModel.fromJson(json['following_userinfo'])
          : null,
      followed_userinfo: json['followed_userinfo'] != null
          ? DbUserinfoModel.fromJson(json['followed_userinfo'])
          : null);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "member_id": memberid,
        'create_time': createtime,
        'list_id': list_id,
        'following_userinfo': following_userinfo,
        'followed_userinfo': followed_userinfo,
      };
}
