import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/spylive/spylivepage.dart';
import 'package:ime_new/ui/live/sweetlive/start_stream.dart';
import 'package:ime_new/ui/live/sweetlivepage.dart';

class LivePage2 extends StatefulWidget {
  const LivePage2({Key? key}) : super(key: key);

  @override
  State<LivePage2> createState() => _LivePage2State();
}

class _LivePage2State extends State<LivePage2> {
  int pageIndex = 0;

  final pages = [
    SweetLivePage(),
    StartStream(),
    SpyLivePage(),
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

        items: [
          BottomNavigationBarItem(
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 35,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                      size: 35,
                    ),
              label: '甜心直播'),
          BottomNavigationBarItem(
              icon: const Icon(
                Icons.video_call_sharp,
                color: Colors.pink,
                size:60,
              ),
              label: ''),
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
              label: '特務直播'),
        ],
        onTap: (currentindex) {
          setState(() {
            pageIndex = currentindex;
          });
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
  }
}
