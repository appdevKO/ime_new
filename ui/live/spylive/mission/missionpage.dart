import 'package:flutter/material.dart';
import 'package:ime_new/utils/color_config.dart';

import 'createmission.dart';
import 'mymission.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mission'),
          backgroundColor: Color(0xff1A1A1A),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: Color(0xff1A1A1A),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height ,
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xff336666),
                    Color(0xff9900cc),
                  ])),
                ),
                //上面按鈕
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: Container(
                          width: 150,
                          height: 45,
                          child: Center(
                              child: Text(
                            '我的任務',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          )),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                width: 2.5,
                                color: Color(0xff00CCFF),
                              )),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyMission()));
                        },
                      ),
                      GestureDetector(
                        child: Container(
                          width: 150,
                          height: 50,
                          child: Center(
                            child: Text(
                              '發起任務',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2.5,
                              color: Color(0xff00CCFF),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateMission()));
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Color(0xff00CCFF),
                          labelColor: Color(0xff00CCFF),
                          unselectedLabelColor: Color(0xff808080),
                          tabs: [
                            Tab(
                              text: '特務執行任務',
                            ),
                            Tab(
                              text: '我想接取任務',
                            ),
                            // Tab(
                            //   text: '已申請',
                            // ),
                            // Tab(
                            //   text: '已接取',
                            // ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              //觀看任務
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(),
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 8, 16, 0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            color: spy_card_background,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 2,
                                                color: index % 2 == 0
                                                    ? Color(0xff00CCFF)
                                                    : Color(0xff9900CC),
                                                offset: Offset(index % 2 == 0 ? 2 : -2, 0),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                width: 1,
                                                color:
                                                    spy_card_border_background)),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 8, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16, 0, 0, 0),
                                                    child: Image.network(
                                                      'https://picsum.photos/seed/556/600',
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  12),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  0),
                                                          topLeft:
                                                              Radius.circular(
                                                                  0),
                                                          topRight:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              spy_gradient_light_blue,
                                                              spy_gradient_light_purple,
                                                            ])),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 5, 0, 0),
                                                      child: Text(
                                                        '觀看人數',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10, 10, 0, 0),
                                                      child: Text(
                                                        '任務標題',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  10, 0, 0, 0),
                                                      child: Text(
                                                        '任務內容',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 0, 10, 0),
                                                      child: Text(
                                                        '懸賞獎金\$6666666',
                                                        style: TextStyle(
                                                            color:
                                                                spy_mission_money,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            12),
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            12),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            0),
                                                                  ),
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        spy_gradient_light_blue,
                                                                        spy_gradient_light_purple,
                                                                      ])),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        5,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              '立即觀看',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Container(
                                      height: 5,
                                    );
                                  },
                                  itemCount: 7,
                                ),
                              ),
                              // 接取任務
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(),
                                child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 8, 16, 0),
                                      child: Container(
                                        width: double.infinity,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Color(0xff25253D),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2,
                                              color: index % 2 == 0
                                                  ? Color(0xff00CCFF)
                                                  : Color(0xff9900CC),
                                              offset: Offset(index % 2 == 0 ? 2 : -2, 0),
                                            )
                                          ],
                                          border: Border.all(
                                              width: 1,
                                              color:
                                                  spy_card_border_background),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 0, 0, 0),
                                                    child: Text(
                                                      '任務標題',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                10, 0, 0, 0),
                                                    child: Text(
                                                      '任務內容',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 10, 30),
                                                  child: Text(
                                                    '懸賞獎金\$6666666',
                                                    style: TextStyle(
                                                        color:
                                                            spy_mission_money,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(0),
                                                        bottomRight:
                                                            Radius.circular(12),
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(0),
                                                      ),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            spy_gradient_light_blue,
                                                            spy_gradient_light_purple,
                                                          ])),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 5, 0, 0),
                                                    child: Text(
                                                      '接取任務',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Container(
                                      height: 5,
                                    );
                                  },
                                  itemCount: 4,
                                ),
                              ),
                              // // 已申請
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   height: MediaQuery.of(context).size.height,
                              //   decoration: BoxDecoration(),
                              //   child: ListView.separated(
                              //     itemBuilder: (context, index) {
                              //       return Padding(
                              //         padding: EdgeInsetsDirectional.fromSTEB(
                              //             16, 8, 16, 0),
                              //         child: Container(
                              //           width: double.infinity,
                              //           height: 100,
                              //           decoration: BoxDecoration(
                              //             color: Color(0xff25253D),
                              //             boxShadow: [
                              //               BoxShadow(
                              //                 blurRadius: 3,
                              //                 color: index % 2 == 0
                              //                     ? Color(0xff00CCFF)
                              //                     : Color(0xff9900CC),
                              //                 offset: Offset(0, 1),
                              //               )
                              //             ],
                              //             border: Border.all(
                              //                 width: 1,
                              //                 color:
                              //                     spy_card_border_background),
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //           ),
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.max,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             children: [
                              //               Expanded(
                              //                 child: Column(
                              //                   mainAxisSize: MainAxisSize.max,
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceEvenly,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     Padding(
                              //                       padding:
                              //                           EdgeInsetsDirectional
                              //                               .fromSTEB(
                              //                                   10, 0, 0, 0),
                              //                       child: Text(
                              //                         '任務標題',
                              //                         textAlign:
                              //                             TextAlign.start,
                              //                         style: TextStyle(
                              //                             color: Colors.white,
                              //                             fontSize: 20,
                              //                             fontWeight:
                              //                                 FontWeight.w700),
                              //                       ),
                              //                     ),
                              //                     Padding(
                              //                       padding:
                              //                           EdgeInsetsDirectional
                              //                               .fromSTEB(
                              //                                   10, 0, 0, 0),
                              //                       child: Text(
                              //                         '任務內容',
                              //                         style: TextStyle(
                              //                             color: Colors.grey,
                              //                             fontSize: 14,
                              //                             fontWeight:
                              //                                 FontWeight.w700),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Column(
                              //                 mainAxisSize: MainAxisSize.max,
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.end,
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.end,
                              //                 children: [
                              //                   Padding(
                              //                     padding: EdgeInsetsDirectional
                              //                         .fromSTEB(0, 0, 10, 30),
                              //                     child: Text(
                              //                       '懸賞獎金\$6666666',
                              //                       style: TextStyle(
                              //                           color:
                              //                               spy_mission_money,
                              //                           fontSize: 16,
                              //                           fontWeight:
                              //                               FontWeight.w700),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     width: 100,
                              //                     height: 30,
                              //                     decoration: BoxDecoration(
                              //                         borderRadius:
                              //                             BorderRadius.only(
                              //                           bottomLeft:
                              //                               Radius.circular(0),
                              //                           bottomRight:
                              //                               Radius.circular(12),
                              //                           topLeft:
                              //                               Radius.circular(12),
                              //                           topRight:
                              //                               Radius.circular(0),
                              //                         ),
                              //                         color: Colors.grey),
                              //                     child: Padding(
                              //                       padding:
                              //                           EdgeInsetsDirectional
                              //                               .fromSTEB(
                              //                                   0, 5, 0, 0),
                              //                       child: Text(
                              //                         '已申請',
                              //                         textAlign:
                              //                             TextAlign.center,
                              //                         style: TextStyle(
                              //                             color: Colors.white),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     separatorBuilder: (context, index) {
                              //       return Container(
                              //         height: 5,
                              //       );
                              //     },
                              //     itemCount: 4,
                              //   ),
                              // ),
                              // // 已接受
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   height: MediaQuery.of(context).size.height,
                              //   decoration: BoxDecoration(),
                              //   child: ListView.separated(
                              //     itemBuilder: (context, index) {
                              //       return Padding(
                              //         padding: EdgeInsetsDirectional.fromSTEB(
                              //             16, 8, 16, 0),
                              //         child: Container(
                              //           width: double.infinity,
                              //           height: 100,
                              //           decoration: BoxDecoration(
                              //             color: Color(0xff25253D),
                              //             boxShadow: [
                              //               BoxShadow(
                              //                 blurRadius: 3,
                              //                 color: index % 2 == 0
                              //                     ? Color(0xff00CCFF)
                              //                     : Color(0xff9900CC),
                              //                 offset: Offset(0, 1),
                              //               )
                              //             ],
                              //             border: Border.all(
                              //                 width: 1,
                              //                 color:
                              //                     spy_card_border_background),
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //           ),
                              //           child: Row(
                              //             mainAxisSize: MainAxisSize.max,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             children: [
                              //               Expanded(
                              //                 child: Column(
                              //                   mainAxisSize: MainAxisSize.max,
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceEvenly,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     Padding(
                              //                       padding:
                              //                           EdgeInsetsDirectional
                              //                               .fromSTEB(
                              //                                   10, 0, 0, 0),
                              //                       child: Text(
                              //                         '任務標題',
                              //                         textAlign:
                              //                             TextAlign.start,
                              //                         style: TextStyle(
                              //                             color: Colors.white,
                              //                             fontSize: 20,
                              //                             fontWeight:
                              //                                 FontWeight.w700),
                              //                       ),
                              //                     ),
                              //                     Padding(
                              //                       padding:
                              //                           EdgeInsetsDirectional
                              //                               .fromSTEB(
                              //                                   10, 0, 0, 0),
                              //                       child: Text(
                              //                         '任務內容',
                              //                         style: TextStyle(
                              //                             color: Colors.grey,
                              //                             fontSize: 14,
                              //                             fontWeight:
                              //                                 FontWeight.w700),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Column(
                              //                 mainAxisSize: MainAxisSize.max,
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment.end,
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment.end,
                              //                 children: [
                              //                   Padding(
                              //                     padding: EdgeInsetsDirectional
                              //                         .fromSTEB(0, 0, 10, 30),
                              //                     child: Text(
                              //                       '懸賞獎金\$6666666',
                              //                       style: TextStyle(
                              //                           color:
                              //                               spy_mission_money,
                              //                           fontSize: 16,
                              //                           fontWeight:
                              //                               FontWeight.w700),
                              //                     ),
                              //                   ),
                              //                   Container(
                              //                     width: 100,
                              //                     height: 30,
                              //                     decoration: BoxDecoration(
                              //                         borderRadius:
                              //                             BorderRadius.only(
                              //                           bottomLeft:
                              //                               Radius.circular(0),
                              //                           bottomRight:
                              //                               Radius.circular(12),
                              //                           topLeft:
                              //                               Radius.circular(12),
                              //                           topRight:
                              //                               Radius.circular(0),
                              //                         ),
                              //                         gradient: LinearGradient(
                              //                             colors: [
                              //                               spy_gradient_light_blue,
                              //                               spy_gradient_light_purple,
                              //                             ])),
                              //                     child: Padding(
                              //                       padding:
                              //                           EdgeInsetsDirectional
                              //                               .fromSTEB(
                              //                                   0, 5, 0, 0),
                              //                       child: Text(
                              //                         '執行任務',
                              //                         textAlign:
                              //                             TextAlign.center,
                              //                         style: TextStyle(
                              //                             color: Colors.white),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     separatorBuilder: (context, index) {
                              //       return Container(
                              //         height: 5,
                              //       );
                              //     },
                              //     itemCount: 4,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
