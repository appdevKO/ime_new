import 'package:flutter/material.dart';

class SettingOption {
  String? title;
  Widget? icon;
  Function callback;

  SettingOption({this.title, this.icon,required this.callback});
}
