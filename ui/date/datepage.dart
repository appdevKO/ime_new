import 'package:flutter/material.dart';
import 'package:ime_new/ui/action/actionpage.dart';
import 'package:ime_new/ui/date/square/date_square.dart';
import 'package:ime_new/ui/live/truth_or_dare/truth_or_dare_page.dart';

import 'group_chat/grouppage.dart';
import 'one2one_chat/o2o_chatroomlist.dart';

class DatePage extends StatefulWidget {
  const DatePage({Key? key}) : super(key: key);

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  int pageIndex = 2;

  final pages = [
    OneChat(),
    GroupPage(),
    DateSquare(),
    ActionPage(),
    TurthOrDare(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black45,
        currentIndex: pageIndex,
        // height: 65,
        // decoration: BoxDecoration(
        //   color: Colors.grey.withOpacity(.2),
        //   // borderRadius: BorderRadius.only(
        //   //     topLeft: Radius.circular(20), topRight: Radius.circular(20))
        // ),
        items: [
          BottomNavigationBarItem(
              icon: pageIndex == 0
                  ? Container(
                      height: 30,
                      child: Image.asset(
                        'assets/icon/navigator/chat02.png',
                      ))
                  : Container(
                      height: 30,
                      child: Image.asset('assets/icon/navigator/chat01.png')),
              // ? const Icon(
              //     Icons.live_tv,
              //     color: Colors.red,
              //     size: 35,
              //   )
              // : const Icon(
              //     Icons.live_tv_outlined,
              //     color: Colors.black,
              //     size: 35,
              //   ),
              label: '私聊'),
          BottomNavigationBarItem(
              icon: pageIndex == 1
                  ? Container(
                      height: 30,
                      child: Image.asset('assets/icon/navigator/group02.png'))
                  : Container(
                      height: 30,
                      child: Image.asset('assets/icon/navigator/group01.png')),
              label: '揪團'),
          BottomNavigationBarItem(
              icon: pageIndex == 2
                  ? Container(
                      height: 30,
                      child: Image.asset('assets/icon/navigator/index02.png'))
                  : Container(
                      height: 30,
                      child: Image.asset('assets/icon/navigator/index01.png')),
              label: '首頁'),
          BottomNavigationBarItem(
              icon: pageIndex == 3
                  ? Container(
                      height: 30,
                      child: Image.asset('assets/icon/navigator/action02.png'))
                  : Container(
                      height: 30,
                      child: Image.asset('assets/icon/navigator/action01.png')),
              label: '動態'),
          BottomNavigationBarItem(
              icon: pageIndex == 4
                  ? Container( height: 30,child: Image.asset('assets/icon/navigator/tod02.png'))
                  : Container( height: 30,child: Image.asset('assets/icon/navigator/tod01.png')),
              label: '遊戲'),
        ],
        onTap: (currentindex) {
          setState(() {
            pageIndex = currentindex;
          });
        },
      ),
    ));
  }
}
