import 'dart:convert';

import 'action_model.dart';

FollowActionModel followActionModelFromJson(String str) =>
    FollowActionModel.fromJson(json.decode(str));

String followActionModelToJson(FollowActionModel data) =>
    json.encode(data.toJson());

class FollowActionModel {
  FollowActionModel({this.action});

  var action;

  factory FollowActionModel.fromJson(Map<String, dynamic> json) {
    return FollowActionModel(
        action: ActionModel.fromJson(json["actionlist"]));
  }

  Map<String, dynamic> toJson() => {
        "actionlist": action,
      };
}
