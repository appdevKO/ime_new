import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/push_model.dart';
import 'package:ime_new/ui/date/one2one_chat/o2ochatroom.dart';
import 'package:ime_new/ui/loginpage/loginpage.dart';
import 'package:ime_new/ui/push.dart';

class RouteName {
  static const String index = '/';
  static const String message = '/message';
  static const String sweetlive = '/sweetlive';
  static const String spylive = '/spylive';
}

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(
        'settings.name ${settings.name} settings.arguments ${settings.arguments}');

    switch (settings.name) {
      case RouteName.index:
        return NoAnimRouteBuilder(new LeadPage());
      case RouteName.message:
        {
          final args = settings.arguments as PushNotifyModel;
          return NoAnimRouteBuilder(O2OChatroom(
            memberid: args.memberid!,
            chatroomid: args.chatroomid!,
            nickname: args.nickname,
            avatar: args.avatar,
            fcmtoken: args.fcmtoken,
          ));
        }
      case RouteName.sweetlive:
        return NoAnimRouteBuilder(new FakeMessage());
      case RouteName.spylive:
        return NoAnimRouteBuilder(new FakeMessage());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

class NoAnimRouteBuilder extends PageRouteBuilder {
  final Widget page;

  NoAnimRouteBuilder(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => child);
}
