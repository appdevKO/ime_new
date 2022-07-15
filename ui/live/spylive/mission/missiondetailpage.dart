import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/mission_model.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:intl/intl.dart';

class MissionDetailPage extends StatefulWidget {
  MissionDetailPage({Key? key, required this.ThisMission}) : super(key: key);
  MissionModel ThisMission;

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('任務細節頁'),
              backgroundColor: Color(0xff1A1A1A),
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                color: Color(0xff1A1A1A),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color(0xff336666),
                          Color(0xff9900cc),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '任務標題',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '任務標題',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Text(
                              '任務內容',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '任務內容',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Text(
                              '任務獎金',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '任務獎金',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color(
                                            0xff808080,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Text(
                                        '${DateFormat('yyyy/MM/dd').format(widget.ThisMission.starttime!)}',
                                        style: TextStyle(
                                          color: Color(
                                            0xff808080,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color(
                                            0xff808080,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Text(
                                        '${DateFormat('yyyy/MM/dd').format(widget.ThisMission.endtime!)}',
                                        style: TextStyle(
                                          color: Color(
                                            0xff808080,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // GestureDetector(
                                  //   child: Container(
                                  //     width: MediaQuery.of(context).size.width /
                                  //         2.3,
                                  //     padding: EdgeInsets.all(5),
                                  //     decoration: BoxDecoration(
                                  //         gradient: LinearGradient(
                                  //           colors: type == 1
                                  //               ? [
                                  //                   Color(0xffcb27f7),
                                  //                   Color(0xff24d7f7),
                                  //                 ]
                                  //               : [
                                  //                   Colors.transparent,
                                  //                   Colors.transparent,
                                  //                 ],
                                  //         ),
                                  //         border: Border.all(
                                  //             width: type == 1 ? 0 : 1,
                                  //             color: Color(0xff808080)),
                                  //         borderRadius:
                                  //             BorderRadius.circular(15)),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       children: [
                                  //         Padding(
                                  //           padding: EdgeInsets.only(right: 8),
                                  //           child: Icon(
                                  //             Icons.person,
                                  //             color: type == 1
                                  //                 ? Colors.white
                                  //                 : Color(0xff808080),
                                  //           ),
                                  //         ),
                                  //         Text(
                                  //           '獨樂樂-私人觀看',
                                  //           style: TextStyle(
                                  //             color: type == 1
                                  //                 ? Colors.white
                                  //                 : Color(0xff808080),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  //   onTap: () {},
                                  // ),
                                  // GestureDetector(
                                  //   child: Container(
                                  //     width: MediaQuery.of(context).size.width /
                                  //         2.3,
                                  //     padding: EdgeInsets.all(5),
                                  //     decoration: BoxDecoration(
                                  //         gradient: LinearGradient(
                                  //           colors: type == 2
                                  //               ? [
                                  //                   Color(0xffcb27f7),
                                  //                   Color(0xff24d7f7),
                                  //                 ]
                                  //               : [
                                  //                   Colors.transparent,
                                  //                   Colors.transparent,
                                  //                 ],
                                  //         ),
                                  //         border: Border.all(
                                  //             width: type == 2 ? 0 : 1,
                                  //             color: Color(0xff808080)),
                                  //         borderRadius:
                                  //             BorderRadius.circular(15)),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.center,
                                  //       children: [
                                  //         Padding(
                                  //           padding: EdgeInsets.only(right: 8),
                                  //           child: Icon(
                                  //             Icons.group,
                                  //             color: type == 2
                                  //                 ? Colors.white
                                  //                 : Color(0xff808080),
                                  //           ),
                                  //         ),
                                  //         Text(
                                  //           '眾樂樂-公開觀看',
                                  //           style: TextStyle(
                                  //             color: type == 2
                                  //                 ? Colors.white
                                  //                 : Color(0xff808080),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  //   onTap: () {},
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    spy_gradient_light_purple,
                                    spy_gradient_light_blue,
                                  ]),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                '發起任務',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () async {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
