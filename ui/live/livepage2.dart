import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/spylive/spylivepage.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class LivePage2 extends StatefulWidget {
  const LivePage2({Key? key}) : super(key: key);

  @override
  State<LivePage2> createState() => _LivePage2State();
}

class _LivePage2State extends State<LivePage2> {
  int pageIndex = 0;
  String avatar = "https://i.ibb.co/cFFSzdK/sex-man.png";
  String nickName = "";

  final pages = [
    SweetLiveList(),
    Container(),
    SpyLivePage(),
  ];

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
        }
      } catch (err) {
        ChatProvider1.getaccountinfo();
      }
      return SafeArea(
          child: Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black45,
          currentIndex: pageIndex,
          items: [
            BottomNavigationBarItem(
                icon: pageIndex == 0
                    ? Container(
                        height: 50,
                        child: Image.asset(
                            'assets/icon/navigator/sweetlive02.png'))
                    : Container(
                        height: 50,
                        child: Image.asset(
                            'assets/icon/navigator/sweetlive01.png')),
                label: '甜心直播'),
            BottomNavigationBarItem(
                icon: Center(
                    child: Container(
                        height: 70,
                        child: Image.asset(
                            'assets/icon/navigator/takestream02.png'))),
                label: ''),
            BottomNavigationBarItem(
                icon: pageIndex == 2
                    ? Container(
                        height: 50,
                        child:
                            Image.asset('assets/icon/navigator/spylive02.png'))
                    : Container(
                        height: 50,
                        child:
                            Image.asset('assets/icon/navigator/spylive01.png')),
                label: '特務直播'),
          ],
          onTap: (currentindex) async {
            if (currentindex == 1) {
              await openRoom(context, avatar, nickName);
            } else {
              setState(() {
                pageIndex = currentindex;
              });
            }
          },
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       enableFeedback: false,
          //       onPressed: () {
          //         setState(() {
          //           pageIndex = 0;
          //         });
          //       },
          //       icon: pageIndex == 0
          //           ? const Icon(
          //               Icons.live_tv,
          //               color: Colors.red,
          //               size: 35,
          //             )
          //           : const Icon(
          //               Icons.live_tv_outlined,
          //               color: Colors.black,
          //               size: 35,
          //             ),
          //     ),
          //     IconButton(
          //       enableFeedback: false,
          //       onPressed: () {
          //         setState(() {
          //           pageIndex = 1;
          //         });
          //       },
          //       icon: pageIndex == 1
          //           ? const Icon(
          //               Icons.home_filled,
          //               color: Colors.red,
          //               size: 35,
          //             )
          //           : const Icon(
          //               Icons.home_outlined,
          //               color: Colors.black,
          //               size: 35,
          //             ),
          //     ),
          //     IconButton(
          //       enableFeedback: false,
          //       onPressed: () {
          //         setState(() {
          //           pageIndex = 2;
          //         });
          //       },
          //       icon: pageIndex == 2
          //           ? const Icon(
          //               Icons.local_fire_department,
          //               color: Colors.red,
          //               size: 35,
          //             )
          //           : const Icon(
          //               Icons.local_fire_department_outlined,
          //               color: Colors.black,
          //               size: 35,
          //             ),
          //     ),
          //     IconButton(
          //       enableFeedback: false,
          //       onPressed: () {
          //         setState(() {
          //           pageIndex = 3;
          //         });
          //       },
          //       icon: pageIndex == 3
          //           ? const Icon(
          //               Icons.group_add,
          //               color: Colors.red,
          //               size: 35,
          //             )
          //           : const Icon(
          //               Icons.group_add_outlined,
          //               color: Colors.black,
          //               size: 35,
          //             ),
          //     ),
          //     IconButton(
          //       enableFeedback: false,
          //       onPressed: () {
          //         setState(() {
          //           pageIndex = 4;
          //         });
          //       },
          //       icon: pageIndex == 4
          //           ? const Icon(
          //               Icons.person,
          //               color: Colors.red,
          //               size: 35,
          //             )
          //           : const Icon(
          //               Icons.person_outline,
          //               color: Colors.black,
          //               size: 35,
          //             ),
          //     ),
          //   ],
          // ),
        ),
      ));
    });
  }
}
