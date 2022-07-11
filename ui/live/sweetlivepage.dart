import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class SweetLivePage extends StatefulWidget {
  const SweetLivePage({Key? key}) : super(key: key);

  @override
  State<SweetLivePage> createState() => _SweetLivePageState();
}

class _SweetLivePageState extends State<SweetLivePage> {
  int pageIndex = 0;
  String avatar = "https://i.ibb.co/cFFSzdK/sex-man.png";
  String nickName = "";
  String account = "";

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, ChatProvider1, child) {
      try {
        if (ChatProvider1.remoteUserInfo[0].avatar == null) {
          if ((ChatProvider1.remoteUserInfo[0].sex) == '男') {
            avatar = "https://i.ibb.co/cFFSzdK/sex-man.png";
          } else if ((ChatProvider1.remoteUserInfo[0].sex) == '女') {
            avatar = "https://i.ibb.co/kJxyvc4/sex-woman.png";
          }
        } else {
          avatar = ChatProvider1.remoteUserInfo[0].avatar;
          nickName = ChatProvider1.remoteUserInfo[0].nickname;
          account = ChatProvider1.remoteUserInfo[0].account;
        }
      } catch (err) {
        ChatProvider1.getaccountinfo();
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('甜心直播'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.video_call_outlined),
          onPressed: () async {
            await openRoom(context, avatar, nickName, account);
          },
        ),
        body: Column(
          children: [
            Expanded(
              child: SweetLiveList(),
            ),
          ],
        ),
      );
    });
  }
}
