// To parse this JSON data, do
//
//     final dbUserinfoModel = dbUserinfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

DbUserinfoModel dbUserinfoModelFromJson(String str) =>
    DbUserinfoModel.fromJson(json.decode(str));

String dbUserinfoModelToJson(DbUserinfoModel data) =>
    json.encode(data.toJson());

class DbUserinfoModel {
  DbUserinfoModel({
    this.memberid,
    this.nickname,
    this.account,
    this.chatroomId,
    this.avatar,
    this.avatar_sub,
    this.cover,
    this.height,
    this.age,
    this.sex,
    this.money,
    this.constellation,
    this.introduction,
    this.size,
    this.interest_list,
    this.personality,
    this.profession,
    this.role,
    this.area,
    this.position,
    this.date,
    this.lookfor,
    this.education,
    this.language,
    this.smoke,
    this.drink,
    this.voice_introduction,
    this.profilepic_list,
    this.little_profilepic_list,
    this.followme_num,
    this.default_chat_text,
    this.follow_log_list,
    this.birthday,
    this.age_range,
    this.distance_range,
    this.vip,
    this.tag,
  });

  ObjectId? memberid;
  String? account;
  String? sex;
  String? nickname;
  List? chatroomId;
  String? avatar;
  String? avatar_sub;
  String? cover;
  int? height;
  int? age;
  int? followme_num;
  String? money;
  String? constellation;
  String? introduction;
  String? size;
  String? personality;
  String? profession;
  String? area;
  Map? position;
  String? lookfor;
  String? date;
  String? education;
  String? language;
  String? smoke;
  String? drink;
  String? voice_introduction;
  String? default_chat_text;
  List? profilepic_list;
  List? little_profilepic_list;
  List? interest_list;
  List? follow_log_list;
  DateTime? birthday;
  double? distance_range;
  int? age_range;
  int? role;
  bool? vip;
  List? tag = [];

  factory DbUserinfoModel.fromJson(Map<String, dynamic> json) {
    var list = [];
    if (json["personality"] != null && json["personality"] != '')
      list.add(json["personality"]);
    if (json["size"] != null && json["size"] != '') list.add(json["size"]);
    if (json["profession"] != null && json["profession"] != '')
      list.add(json["profession"]);
    if (json["area"] != null && json["area"] != '') list.add(json["area"]);
    if (json["money"] != null && json["money"] != '') list.add(json["money"]);
    if (json["education"] != null && json["education"] != '')
      list.add(json["education"]);

    if (json["language"] != null && json["language"] != '')
      list.add(json["language"]);

    if (json["smoke"] != null && json["smoke"] != '') list.add(json["smoke"]);
    if (json["drink"] != null && json["drink"] != '') list.add(json["drink"]);
    return DbUserinfoModel(
        memberid: json["_id"],
        nickname: json["nickname"] == null ? null : json["nickname"],
        default_chat_text: json["default_chat"],
        account: json["account"],
        chatroomId: json["chatroomid"],
        avatar: json["avatar"],
        avatar_sub: json["avatar_sub"],
        birthday: json["birthday"],
        cover: json['cover'],
        role: json['role'],
        vip: json['vip'],
        height: json['height'] != null ? json['height'] : null,
        age: json['age'] != null ? json['age'] : null,
        sex: json['sex'] != null ? json['sex'] : null,
        distance_range:
            json['distance_range'] != null ? json['distance_range'] : null,
        age_range: json['age_range'] != null ? json['age_range'] : null,
        money: json['money'] != null ? json['money'] : null,
        followme_num: json['follow_num'] != null ? json['follow_num'] : null,
        constellation:
            json["constellation"] != null ? json['constellation'] : null,
        introduction:
            json["introduction"] != null ? json['introduction'] : null,
        size: json["size"] != null ? json['size'] : null,
        interest_list:
            json["interest_list"] != null ? json['interest_list'] : null,
        follow_log_list: json["follow_log"] != null ? json['follow_log'] : null,
        personality: json["personality"] != null ? json['personality'] : null,
        profession: json["profession"] != null ? json['profession'] : null,
        area: json["area"] != null ? json['area'] : null,
        position: json["position"] != null ? json['position'] : null,
        date: json["date"] != null ? json['date'] : null,
        lookfor: json["lookfor"] != null ? json['lookfor'] : null,
        education: json["education"] != null ? json['education'] : null,
        language: json["language"] != null ? json['language'] : null,
        smoke: json["smoke"] != null ? json['smoke'] : null,
        drink: json["drink"] != null ? json['drink'] : null,
        profilepic_list:
            json["profile_pic"] != null ? json['profile_pic'] : null,
        little_profilepic_list: json["little_profile_pic"] != null
            ? json['little_profile_pic']
            : null,
        voice_introduction: json["voice_introduction"] != null
            ? json['voice_introduction']
            : null,
        tag: list);
  }

  Map<String, dynamic> toJson() => {
        "_id": memberid,
        "account": account,
        "nickname": nickname,
        "default_chat": default_chat_text,
        "chatroomid": chatroomId,
        "follow_num": followme_num,
        "age_range": age_range,
        "role": role,
        "vip": vip,
        "distance_range": distance_range,
        "avatar": avatar,
        "avatar_sub": avatar_sub,
        "cover": cover,
        "height": height,
        "birthday": birthday,
        "age": age,
        "sex": sex,
        "money": money,
        "constellation": constellation,
        "introduction": introduction,
        "size": size,
        "interest_list": interest_list,
        "follow_log": follow_log_list,
        "personality": personality,
        "profession": profession,
        "area": area,
        'position': position,
        "lookfor": lookfor,
        "date": date,
        "education": education,
        "language": language,
        "profile_pic": profilepic_list,
        "little_profile_pic": little_profilepic_list,
        "smoke": smoke,
        "drink": drink,
        "voice_introduction": voice_introduction,
      };
}
