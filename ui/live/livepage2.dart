import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/spylive/spylivepage.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/live/sweet/sweetlivepage.dart';

import 'package:provider/provider.dart';

class LivePage2 extends StatefulWidget {
  const LivePage2({Key? key}) : super(key: key);

  @override
  State<LivePage2> createState() => _LivePage2State();
}

class _LivePage2State extends State<LivePage2> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, ChatProvider1, child) {
      return SafeArea(
          child: Scaffold(
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            GestureDetector(
                child: Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon/navigator/sweetlive02.png'),
                        Text(
                          '甜心直播',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )),
                onTap: () async {
                  _fetchData(context);
                  await Provider.of<ChatProvider>(context, listen: false)
                      .getaccountinfo();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SweetLivePage()));
                }),
            Container(
              height: 200,
              child: Center(
                child: Divider(
                  thickness: 2,
                ),
              ),
            ),
            GestureDetector(
                child: Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon/navigator/spylive02.png'),
                        Text(
                          '特務直播',
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    )),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SpyLivePage()));
                })
          ])
              // bottomNavigationBar: BottomNavigationBar(
              //   type: BottomNavigationBarType.fixed,
              //   selectedItemColor: Colors.red,
              //   unselectedItemColor: Colors.black45,
              //   currentIndex: pageIndex,
              //   items: [
              //     BottomNavigationBarItem(
              //         icon: pageIndex == 0
              //             ? Container(
              //                 height: 50,
              //                 child: Image.asset(
              //                     'assets/icon/navigator/sweetlive02.png'))
              //             : Container(
              //                 height: 50,
              //                 child: Image.asset(
              //                     'assets/icon/navigator/sweetlive01.png')),
              //         label: '甜心直播'),
              //     BottomNavigationBarItem(
              //         icon: Center(
              //             child: Container(
              //                 height: 70,
              //                 child: Image.asset(
              //                     'assets/icon/navigator/takestream02.png'))),
              //         label: ''),
              //     BottomNavigationBarItem(
              //         icon: pageIndex == 2
              //             ? Container(
              //                 height: 50,
              //                 child:
              //                     Image.asset('assets/icon/navigator/spylive02.png'))
              //             : Container(
              //                 height: 50,
              //                 child:
              //                     Image.asset('assets/icon/navigator/spylive01.png')),
              //         label: '特務直播'),
              //   ],
              //   onTap: (currentindex) async {
              //     if (currentindex == 1) {
              //       await openRoom(context, avatar, nickName,account);
              //     } else {
              //       setState(() {
              //         pageIndex = currentindex;
              //       });
              //     }
              //   },
              //   // child: Row(
              //   //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   //   crossAxisAlignment: CrossAxisAlignment.center,
              //   //   children: [
              //   //     IconButton(
              //   //       enableFeedback: false,
              //   //       onPressed: () {
              //   //         setState(() {
              //   //           pageIndex = 0;
              //   //         });
              //   //       },
              //   //       icon: pageIndex == 0
              //   //           ? const Icon(
              //   //               Icons.live_tv,
              //   //               color: Colors.red,
              //   //               size: 35,
              //   //             )
              //   //           : const Icon(
              //   //               Icons.live_tv_outlined,
              //   //               color: Colors.black,
              //   //               size: 35,
              //   //             ),
              //   //     ),
              //   //     IconButton(
              //   //       enableFeedback: false,
              //   //       onPressed: () {
              //   //         setState(() {
              //   //           pageIndex = 1;
              //   //         });
              //   //       },
              //   //       icon: pageIndex == 1
              //   //           ? const Icon(
              //   //               Icons.home_filled,
              //   //               color: Colors.red,
              //   //               size: 35,
              //   //             )
              //   //           : const Icon(
              //   //               Icons.home_outlined,
              //   //               color: Colors.black,
              //   //               size: 35,
              //   //             ),
              //   //     ),
              //   //     IconButton(
              //   //       enableFeedback: false,
              //   //       onPressed: () {
              //   //         setState(() {
              //   //           pageIndex = 2;
              //   //         });
              //   //       },
              //   //       icon: pageIndex == 2
              //   //           ? const Icon(
              //   //               Icons.local_fire_department,
              //   //               color: Colors.red,
              //   //               size: 35,
              //   //             )
              //   //           : const Icon(
              //   //               Icons.local_fire_department_outlined,
              //   //               color: Colors.black,
              //   //               size: 35,
              //   //             ),
              //   //     ),
              //   //     IconButton(
              //   //       enableFeedback: false,
              //   //       onPressed: () {
              //   //         setState(() {
              //   //           pageIndex = 3;
              //   //         });
              //   //       },
              //   //       icon: pageIndex == 3
              //   //           ? const Icon(
              //   //               Icons.group_add,
              //   //               color: Colors.red,
              //   //               size: 35,
              //   //             )
              //   //           : const Icon(
              //   //               Icons.group_add_outlined,
              //   //               color: Colors.black,
              //   //               size: 35,
              //   //             ),
              //   //     ),
              //   //     IconButton(
              //   //       enableFeedback: false,
              //   //       onPressed: () {
              //   //         setState(() {
              //   //           pageIndex = 4;
              //   //         });
              //   //       },
              //   //       icon: pageIndex == 4
              //   //           ? const Icon(
              //   //               Icons.person,
              //   //               color: Colors.red,
              //   //               size: 35,
              //   //             )
              //   //           : const Icon(
              //   //               Icons.person_outline,
              //   //               color: Colors.black,
              //   //               size: 35,
              //   //             ),
              //   //     ),
              //   //   ],
              //   // ),
              // ),
              ));
    });
  }
}

_fetchData(BuildContext context) async {
  // show the loading dialog
  showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // The loading indicator
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                // Some text
                Text('Loading...')
              ],
            ),
          ),
        );
      });
  await Future.delayed(const Duration(milliseconds: 2000));

  // Close the dialog programmatically
  Navigator.of(context).pop();
}
