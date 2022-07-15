import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/live/spylive/showtime/fakestream.dart';
import 'package:ime_new/utils/viewconfig.dart';

import 'createmission.dart';
import 'missiondetailpage.dart';
import 'mymission.dart';
import 'package:provider/provider.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mission_streaminglist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mission_accessible_list();
  }

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
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    spy_bar_blue,
                    spy_bar_purple,
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
                              Consumer<ChatProvider>(
                                  builder: (context, value, child) {
                                return value.spy_streaming_mission_list != null
                                    ? value.spy_streaming_mission_list
                                            .isNotEmpty
                                        ? ListView.separated(
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(16, 8, 16, 0),
                                                child: GestureDetector(
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 150,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            spy_card_background,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 2,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Color(
                                                                    0xff00CCFF)
                                                                : Color(
                                                                    0xff9900CC),
                                                            offset: Offset(
                                                                index % 2 == 0
                                                                    ? 2
                                                                    : -2,
                                                                0),
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                spy_card_border_background)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 8, 0, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            16,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Image
                                                                    .network(
                                                                  'https://picsum.photos/seed/556/600',
                                                                  width: 100,
                                                                  height: 100,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 100,
                                                                height: 30,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius
                                                                                .only(
                                                                          bottomLeft:
                                                                              Radius.circular(12),
                                                                          bottomRight:
                                                                              Radius.circular(0),
                                                                          topLeft:
                                                                              Radius.circular(0),
                                                                          topRight:
                                                                              Radius.circular(12),
                                                                        ),
                                                                        gradient:
                                                                            LinearGradient(colors: [
                                                                          spy_gradient_light_blue,
                                                                          spy_gradient_light_purple,
                                                                        ])),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          5,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '觀看人數',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          10,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.spy_streaming_mission_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 180,
                                                                    child:
                                                                        RichText(
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      strutStyle:
                                                                          StrutStyle(
                                                                              fontSize: 12.0),
                                                                      text:
                                                                          TextSpan(
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .grey,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700),
                                                                        text:
                                                                            '${value.spy_streaming_list[index].content}',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child: Text(
                                                                    '懸賞獎金\$${value.spy_streaming_list[index].price}',
                                                                    style: TextStyle(
                                                                        color:
                                                                            spy_mission_money,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    GestureDetector(
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            30,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(0),
                                                                              bottomRight: Radius.circular(12),
                                                                              topLeft: Radius.circular(12),
                                                                              topRight: Radius.circular(0),
                                                                            ),
                                                                            gradient: LinearGradient(colors: [
                                                                              spy_gradient_light_blue,
                                                                              spy_gradient_light_purple,
                                                                            ])),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              5,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            '立即觀看',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => FakeStream()));
                                                                      },
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
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MissionDetailPage(ThisMission: value
                                                                    .spy_streaming_mission_list[index],)));
                                                  },
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Container(
                                                height: 5,
                                              );
                                            },
                                            itemCount: value
                                                .spy_streaming_mission_list
                                                .length,
                                          )
                                        : Center(
                                            child: Text(
                                              '目前沒有在直播中的任務',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                    : Center(
                                        child: Text(
                                          '任務加載中',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                              }),
                              // 接取任務
                              Consumer<ChatProvider>(
                                  builder: (context, value, child) {
                                return value.spy_accessible_mission_list != null
                                    ? value.spy_accessible_mission_list
                                            .isNotEmpty
                                        ? ListView.separated(
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(16, 8, 16, 0),
                                                child: GestureDetector(
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff25253D),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 2,
                                                          color: index % 2 == 0
                                                              ? Color(
                                                                  0xff00CCFF)
                                                              : Color(
                                                                  0xff9900CC),
                                                          offset: Offset(
                                                              index % 2 == 0
                                                                  ? 2
                                                                  : -2,
                                                              0),
                                                        )
                                                      ],
                                                      border: Border.all(
                                                          width: 1,
                                                          color:
                                                              spy_card_border_background),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 180,
                                                                  child:
                                                                      RichText(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    strutStyle: StrutStyle(
                                                                        fontSize:
                                                                            12.0),
                                                                    text:
                                                                        TextSpan(
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                      text:
                                                                          '${value.spy_accessible_mission_list[index].title}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 180,
                                                                  child:
                                                                      RichText(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    strutStyle: StrutStyle(
                                                                        fontSize:
                                                                            12.0),
                                                                    text:
                                                                        TextSpan(
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                      text:
                                                                          '${value.spy_accessible_mission_list[index].content}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          10,
                                                                          30),
                                                              child: Text(
                                                                '懸賞獎金\$${value.spy_accessible_mission_list[index].price}',
                                                                style: TextStyle(
                                                                    color:
                                                                        spy_mission_money,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  height: 30,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius
                                                                              .only(
                                                                            bottomLeft:
                                                                                Radius.circular(0),
                                                                            bottomRight:
                                                                                Radius.circular(12),
                                                                            topLeft:
                                                                                Radius.circular(12),
                                                                            topRight:
                                                                                Radius.circular(0),
                                                                          ),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            spy_gradient_light_blue,
                                                                            spy_gradient_light_purple,
                                                                          ])),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            5,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      '接取任務',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>MissionDetailPage()));
                                                                }),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MissionDetailPage(ThisMission: value
                                                                    .spy_accessible_mission_list[index])));
                                                  },
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Container(
                                                height: 5,
                                              );
                                            },
                                            itemCount: value
                                                .spy_accessible_mission_list
                                                .length,
                                          )
                                        : Center(
                                            child: Text(
                                              '目前沒有在直播中的任務',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                    : Center(
                                        child: Text(
                                          '任務加載中',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      );
                              })
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
