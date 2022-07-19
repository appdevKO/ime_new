import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/live/spylive/contract/becomespy.dart';
import 'package:ime_new/ui/live/spylive/mission/missiondetailpage.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:provider/provider.dart';

class MyShowTime extends StatefulWidget {
  const MyShowTime({Key? key}) : super(key: key);

  @override
  State<MyShowTime> createState() => _MyShowTimeState();
}

class _MyShowTimeState extends State<MyShowTime> {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: ScrollableState(),
      initialIndex: 0,
    );
    initData();
    super.initState();
  }

  Future initData() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_myshowtime_streaminglist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_myshowtime_endedlist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_myshowtime_hadcreatedlist();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('我的ShowTime'),
              backgroundColor: Color(0xff1A1A1A),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pop(context);
                  await Provider.of<ChatProvider>(context, listen: false)
                      .get_spy_showtime_streaminglist();
                },
              ),
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                color: Color(0xff1A1A1A),
                // color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
                    Container(
                      height: 30,
                      color: Color(0xff1A1A1A),
                      child: TabBar(
                          controller: _tabController,
                          indicatorColor: spy_gradient_light_purple,
                          labelColor: spy_gradient_light_purple,
                          labelStyle: TextStyle(fontSize: 14),
                          unselectedLabelStyle: TextStyle(fontSize: 12),
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(
                              text: '進行中',
                            ),
                            Tab(
                              text: '已結束',
                            ),
                            Tab(
                              text: '曾經發起',
                            ),
                          ]),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Consumer<ChatProvider>(
                            builder: (context, value, child) {
                              return value.myshowtime_streaming_list != null
                                  ? value.myshowtime_streaming_list.isNotEmpty
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
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
                                                              MainAxisSize.max,
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
                                                              child:
                                                                  Image.network(
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
                                                                  '觀看人數',
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
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  '${value.myshowtime_streaming_list[index].title}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
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
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                      text:
                                                                          '${value.myshowtime_streaming_list[index].content}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            10,
                                                                            0),
                                                                child: Text(
                                                                  '懸賞獎金\$${value.myshowtime_streaming_list[index].price}',
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
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  GestureDetector(
                                                                    child: Container(
                                                                      width: 100,
                                                                      height: 30,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.only(
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
                                                                        padding: EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                                0,
                                                                                5,
                                                                                0,
                                                                                0),
                                                                        child:
                                                                            Text(
                                                                          '立即觀看',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Colors.white,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
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
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MissionDetailPage(
                                                                  ThisMission: value
                                                                          .myshowtime_streaming_list[
                                                                      index])));
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
                                              .myshowtime_streaming_list.length,
                                        )
                                      : Center(
                                          child: Text(
                                            '目前沒有在直播中的任務',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                  : Center(
                                      child: Text(
                                        '任務加載中',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                            },
                          ),
                          Consumer<ChatProvider>(
                            builder: (context, value, child) {
                              return value.myshowtime_ended_list != null
                                  ? value.myshowtime_ended_list.isNotEmpty
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
                                                    color: spy_card_background,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 3,
                                                        color:
                                                            Color(0x20000000),
                                                        offset: Offset(0, 1),
                                                      )
                                                    ],
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
                                                              MainAxisSize.max,
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
                                                              child: Text(
                                                                  '${value.myshowtime_ended_list[index].title}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700)),
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
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      text:
                                                                          '${value.myshowtime_ended_list[index].content}',
                                                                    ),
                                                                  ),
                                                                )),
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
                                                                        5),
                                                            child: Text(
                                                                '目標獎金\$${value.myshowtime_ended_list[index].price}',
                                                                style: TextStyle(
                                                                    color:
                                                                        spy_gradient_light_blue,
                                                                    fontSize:
                                                                        18)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        10,
                                                                        10),
                                                            child: Text(
                                                                '貢獻金額\$${value.myshowtime_ended_list[index].actual_price}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                          ),
                                                          Container(
                                                            width: 100,
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                      colors: value.myshowtime_ended_list[index].status ==
                                                                              6
                                                                          ? [
                                                                              spy_bar_purple,
                                                                              spy_bar_purple
                                                                            ]
                                                                          : [
                                                                              spy_gradient_light_blue,
                                                                              spy_gradient_light_purple,
                                                                            ]),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            12),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12),
                                                                topRight: Radius
                                                                    .circular(
                                                                        0),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              value.myshowtime_ended_list[index]
                                                                          .status ==
                                                                      6
                                                                  ? Icons.close
                                                                  : Icons.check_circle_outline,
                                                              color:
                                                                  Colors.white,
                                                              size: 22,
                                                            ),
                                                          ),
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
                                                              MissionDetailPage(
                                                                  ThisMission: value
                                                                          .myshowtime_ended_list[
                                                                      index])));
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
                                              .myshowtime_ended_list.length,
                                        )
                                      : Center(
                                          child: Text(
                                            '目前沒有已結束的任務',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                  : Center(
                                      child: Text(
                                        '任務加載中',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                            },
                          ),
                          Consumer<ChatProvider>(
                              builder:
                                  (context, value, child) =>
                                      value.remoteUserInfo[0].role == 2
                                          ? value.myshowtime_hadcreated_list !=
                                                  null
                                              ? value.myshowtime_hadcreated_list
                                                      .isNotEmpty
                                                  ? ListView.separated(
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(16,
                                                                      8, 16, 0),
                                                          child:
                                                              GestureDetector(
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              height: 150,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color:
                                                                          spy_card_background,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          blurRadius:
                                                                              2,
                                                                          color: index % 2 == 0
                                                                              ? Color(0xff00CCFF)
                                                                              : Color(0xff9900CC),
                                                                          offset: Offset(
                                                                              index % 2 == 0 ? 2 : -2,
                                                                              0),
                                                                        )
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                      border: Border.all(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              spy_card_border_background)),
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            8,
                                                                            0,
                                                                            0),
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
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              10,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Text(
                                                                            '${value.myshowtime_hadcreated_list[index].title}',
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              '目標獎金\$${value.myshowtime_hadcreated_list[index].price}',
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                                                                            ),
                                                                            Text(
                                                                              '實際獎金\$${value.myshowtime_hadcreated_list[index].actual_price}',
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              10,
                                                                              20,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            '任務內容',
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
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
                                                                          child: Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                                                                              child: Icon(
                                                                                Icons.close_outlined,
                                                                                color: Colors.white,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          MissionDetailPage(
                                                                              ThisMission: value.myshowtime_hadcreated_list[index])));
                                                            },
                                                          ),
                                                        );
                                                      },
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          height: 5,
                                                        );
                                                      },
                                                      itemCount: value
                                                          .myshowtime_hadcreated_list
                                                          .length,
                                                    )
                                                  : Center(
                                                      child: Text(
                                                        '目前沒有已結束的任務',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                              : Center(
                                                  child: Text(
                                                    '任務加載中',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                          : Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '尚未成為特務',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  '立即點擊下方按鈕成為特務',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 18.0,
                                                          right: 30,
                                                          left: 30),
                                                  child: GestureDetector(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                spy_gradient_light_purple,
                                                                spy_gradient_light_blue,
                                                              ]),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                            size: 38,
                                                          ),
                                                          Text(
                                                            '我要當特務',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BecomeSpy()));
                                                    },
                                                  ),
                                                )
                                              ],
                                            )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
