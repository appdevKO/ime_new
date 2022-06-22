import 'dart:convert';

import 'action_model.dart';

FollowActionModel followActionModelFromJson(String str) =>
    FollowActionModel.fromJson(json.decode(str));

String followActionModelToJson(FollowActionModel data) =>
    json.encode(data.toJson());

class FollowActionModel {
  FollowActionModel({this.list_id, this.actionlist});

  List? list_id;
  List? actionlist;

  factory FollowActionModel.fromJson(Map<String, dynamic> json) {
    var datalist = [];
    Map<String, dynamic> map;
    json["actionlist"].forEach((v) {
      map = Map<String, dynamic>.from(v);
      datalist.add(ActionModel.fromJson(map));
    });
    return FollowActionModel(list_id: json["list_id"], actionlist: datalist);
  }

  Map<String, dynamic> toJson() => {
        "list_id": list_id,
        "actionlist": actionlist,
      };
}
