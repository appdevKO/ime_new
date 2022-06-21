import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

MqttMsg mqttMsgFromJson(String str) => MqttMsg.fromJson(json.decode(str));

String mqttMsgToJson(MqttMsg data) => json.encode(data.toJson());

class MqttMsg {
  MqttMsg(
      {this.fromid,
      this.text,
      this.note,
      this.type,
      this.id,
      this.play,
      this.time,
      this.topicid,
      this.sendtopicid,
      this.nickname,
      this.recordtime,
      this.current_play_position,});

  String? fromid;
  String? text;
  String? note;
  int? type;
  String? id;
  bool? play = false;
  DateTime? time;
  String? topicid;
  String? sendtopicid;
  String? nickname;
  String? recordtime = '';
  String? current_play_position = '';

  factory MqttMsg.fromJson(Map<String, dynamic> json) => MqttMsg(
        fromid: json["from"],
        text: json["text"],
        note: json["note"],
        type: json["type"],
        id: json["id"],
        play: false,
        time: json["time"] is String
            ? DateTime.tryParse(json["time"])
            : json["time"],
        topicid: json["topic_id"] is ObjectId
            ? json["topic_id"].toHexString()
            : json["topic_id"],
        sendtopicid: json["memberid"] is ObjectId
            ? json["memberid"].toHexString()
            : json["memberid"],
        nickname: json["nickname"],
        recordtime: '',
        current_play_position: '',
      );

  Map<String, dynamic> toJson() => {
        "from": fromid,
        "text": text,
        "note": note,
        "type": type,
        "id": id,
        "time": time,
        "topic_id": topicid,
        "memberid": sendtopicid,
        "nickname": nickname,
      };
}

class ChatMsg {
  ChatMsg({this.msg, this.topicid, this.mqtt_tyype});

  List<MqttMsg>? msg;
  String? topicid;
  String? mqtt_tyype;
}

class O2OChatMsg {
  O2OChatMsg(
      {this.msg,
      this.from,
      this.mqtt_tyype,
      this.topicid,
      this.memberid,
      this.nickname});

  List<MqttMsg>? msg;
  String? from;

  //用不到
  String? mqtt_tyype;
  String? topicid;

  //topic id 對哪個頻道說話
  String? memberid;
  String? nickname;
}
