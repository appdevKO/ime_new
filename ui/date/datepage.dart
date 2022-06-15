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
                  ? const Icon(
                      Icons.live_tv,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.live_tv_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
              label: '私聊'),
          BottomNavigationBarItem(
              icon: pageIndex == 1
                  ? const Icon(
                Icons.message,
                color: Colors.red,
                size: 35,
              )
                  : const Icon(
                Icons.message_outlined,
                color: Colors.black,
                size: 35,
              ),
              label: '揪團'),
          BottomNavigationBarItem(
              icon: pageIndex == 2
                  ? const Icon(
                Icons.home_filled,
                color: Colors.red,
                size: 35,
              )
                  : const Icon(
                Icons.home_outlined,
                color: Colors.black,
                size: 35,
              ),
              label: '首頁'),
          BottomNavigationBarItem(
              icon: pageIndex == 3
                  ? const Icon(
                      Icons.group_add,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.group_add_outlined,
                      color: Colors.black,
                      size: 35,
                    ),
              label: '動態'),
          BottomNavigationBarItem(
              icon: pageIndex == 4
                  ? const Icon(
                      Icons.person,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.person_outline,
                      color: Colors.black,
                      size: 35,
                    ),
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
