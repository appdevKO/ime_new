import 'dart:convert';

import 'package:ime_new/business_logic/model/dbuserinfo_model.dart';
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
      this.status,
      this.apply_list,
      this.applyedlist,
      this.executor,
      this.executor_info,
      this.fcmtoken,
      this.pay_list});

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
  ObjectId? executor;
  String? nickname;
  String? avatar;
  List? applyedlist;
  List? executor_info;
  List? apply_list;
  List? pay_list;
  String? fcmtoken;

  factory MissionModel.fromJson(Map<String, dynamic> json) => MissionModel(
        id: json["_id"],
        title: json["title"],
        executor: json["executor"],
        content: json["content"],
        price: json["price"],
        actual_price: json["actual_price"],
        starttime: json["starttime"],
        endtime: json["endtime"],
        type: json["type"],
        status: json["status"],
        memberid: json["memberid"],
        nickname: json["nickname"],
        fcmtoken: json["fcmtoken"],
        avatar: json["avatar"],
        apply_list: json["apply_list"] ?? [],
        pay_list: json["pay_list"] ?? [],

        ///重要
        //收到list json 用 list generate  依次建造
        applyedlist: json["applyedlist"] != null
            ? List<DbUserinfoModel>.from(
                json["applyedlist"]?.map((p) => DbUserinfoModel.fromJson(p)))
            : null,
        executor_info: json["executor_info"] != null
            ? List<DbUserinfoModel>.from(
                json["executor_info"]?.map((p) => DbUserinfoModel.fromJson(p)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": content,
        "price": price,
        "actual_price": actual_price,
        "executor": executor,
        "status": status,
        "starttime": starttime,
        "endtime": endtime,
        "type": type,
        "memberid": memberid,
        "nickname": nickname,
        "avatar": avatar,
        "apply_list": apply_list,
        "pay_list": pay_list,
        "applyedlist": applyedlist,
        "executor_info": executor_info,
        "fcmtoken": fcmtoken,
      };
}
