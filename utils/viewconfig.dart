import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<List<Color>> colorlist = [
  [
    Color(0xff1a79e8),
    Color(0xff7fb1ec),
  ],
  [
    Color(0xffe37c7c),
    Color(0xffeecfea),
  ],
  [
    Color(0xff5832e3),
    Color(0xffb796f5),
  ],
  [
    Color(0xff5ac9e8),
    Color(0xffa1e4ac),
  ],
  [Color(0xffff9494), Color(0xfffdf0f0)]
];
String default_roomimg =
    'https://media.istockphoto.com/photos/new-normal-concept-picture-id1294957728?s=612x612';

String userhead = 'https://img.icons8.com/nolan/344/user.png';
String userhead2 = 'http://pic.616pic.com/ys_bnew_img/00/23/07/nlWpK5lQd9.jpg';
String userhead3 =
    'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=765&q=80';

String default_cover =
    'https://www.crazybackground.com/wp-content/uploads/2019/12/vector-abstract-gray-background-low-poly-textured-triangle-shapes-in-random-pattern-trendy-lowpoly-background.jpg';

String birthday_trans_star(datetime) {
  String time = DateFormat('MMdd').format(datetime);
  int timeInt = int.parse(time);
  if (timeInt >= 321 && timeInt <= 419) {
    return '牡羊座';
  } else if (timeInt >= 420 && timeInt <= 520) {
    return '金牛座';
  } else if (timeInt >= 521 && timeInt <= 621) {
    return '雙子座';
  } else if (timeInt >= 622 && timeInt <= 722) {
    return '巨蟹座';
  } else if (timeInt >= 723 && timeInt <= 822) {
    return '獅子座';
  } else if (timeInt >= 823 && timeInt <= 922) {
    return '處女座';
  } else if (timeInt >= 923 && timeInt <= 1023) {
    return '天秤座';
  } else if (timeInt >= 1024 && timeInt <= 1122) {
    return '天蠍座';
  } else if (timeInt >= 1123 && timeInt <= 1221) {
    return '射手座';
  }else if (timeInt >= 120 && timeInt <= 218) {
    return '水瓶座';
  }else if (timeInt >= 219 && timeInt <= 320) {
    return '雙魚座';
  }
  return '摩羯座';
}
//畫面底色
Color background_white = Color(0xffffffff);
Color spy_gradient_light_blue = Color(0xff24d7f7);
Color spy_gradient_light_purple = Color(0xffcb27f7);
Color spy_button_blue = Color(0xff00ccff);
Color spy_button_purple = Color(0xff9900cc);
Color spy_bar_blue = Color(0xff336666);
Color spy_bar_purple = Color(0xff9900cc);
Color spy_card_background = Color(0xff25253d);
Color spy_card_border_background = Color(0xff27283D);
Color spy_mission_money = Color(0xffff6699);
