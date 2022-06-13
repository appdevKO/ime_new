import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

InterestModel interest_logFromJson(String str) =>
    InterestModel.fromJson(json.decode(str));

String interest_logToJson(InterestModel data) => json.encode(data.toJson());

class InterestModel {
  InterestModel({this.id,
    this.memberid,
    this.age,
    this.interest_list,
    this.nickname,
    this.area,
    this.intro});

  ObjectId? id;
  ObjectId? memberid;
  int? age;
  String? intro;
  String? nickname;
  String? area;

  List? interest_list;

  factory InterestModel.fromJson(Map<String, dynamic> json) =>
      InterestModel(
        id: json["_id"],
        memberid: json["member_id"],
        age: json["age"] == null ? null :json["age"],
        interest_list: json["interest_id"] == null ? null : json["interest_id"],
        intro: json["intro"] == null ? null : json["intro"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        area: json["area"] == null ? null : json["area"],
      );

  Map<String, dynamic> toJson() =>
      {
        "_id": id,
        "member_id": memberid,
        'age': age,
        'interest_list': interest_list,
        'intro': intro,
        'nickname': nickname,
        'area': area,
      };
}
