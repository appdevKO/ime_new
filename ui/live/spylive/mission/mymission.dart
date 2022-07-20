import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/date/one2one_chat/o2ochatroom.dart';
import 'package:ime_new/ui/live/spylive/mission/missiondetailpage.dart';
import 'package:ime_new/ui/live/spylive/showtime/fakestream.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:provider/provider.dart';

import 'approvepage.dart';

class MyMission extends StatefulWidget {
  const MyMission({Key? key}) : super(key: key);

  @override
  State<MyMission> createState() => _MyMissionState();
}

class _MyMissionState extends State<MyMission> {
  bool positive = false;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: ScrollableState(),
      initialIndex: 0,
    );
    initData();
    super.initState();
  }

  Future initData() async {
    //我接的
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_icatch_startyetlist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_icatch_appliedlist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_icatch_approvelist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_icatch_finishedlist();
    // 我發的
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_ilaunch_startyetlist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_ilaunch_streaminglist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_ilaunch_notcatchedlist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_ilaunch_finishlist();
    //審核
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_ilaunch_approvelist();
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
              title: Text('我的任務'),
              backgroundColor: Color(0xff1A1A1A),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pop(context);
                  await Provider.of<ChatProvider>(context, listen: false)
                      .get_spy_mission_streaminglist();
                  await Provider.of<ChatProvider>(context, listen: false)
                      .get_spy_mission_accessible_list();
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedToggleSwitch<bool>.dual(
                            current: positive,
                            first: false,
                            second: true,
                            dif: 30.0,
                            borderColor: Colors.transparent,
                            borderWidth: 2.0,
                            height: 35,
                            onChanged: (value) =>
                                setState(() => positive = value),
                            colorBuilder: (b) =>
                                b ? spy_button_purple : spy_button_blue,
                            iconBuilder: (value) => value
                                ? Icon(Icons.coronavirus_rounded)
                                : Icon(Icons.tag_faces_rounded),
                            textBuilder: (value) => value
                                ? Center(
                                    child: Text(
                                    '我發起的',
                                    style: TextStyle(color: Colors.white),
                                  ))
                                : Center(
                                    child: Text(
                                    '我接取的',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            innerColor: Colors.blueGrey,
                          ),
                          positive
                              //待審核
                              ? Consumer<ChatProvider>(
                                  builder: (context, value, child) {
                                    return GestureDetector(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Center(
                                              child: Text(
                                                '待審核',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: value.approvenum != 0
                                                ? CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor: Colors.red,
                                                  )
                                                : Container(),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ApprovePage()));
                                      },
                                    );
                                  },
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      color: Color(0xff1A1A1A),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: spy_button_blue,
                        labelColor: spy_button_blue,
                        labelStyle: TextStyle(fontSize: 14),
                        unselectedLabelStyle: TextStyle(fontSize: 12),
                        unselectedLabelColor: Colors.grey,
                        tabs: positive
                            ? [
                                Tab(
                                  text: '進行中',
                                ),
                                Tab(
                                  text: '未進行',
                                ),
                                Tab(
                                  text: '未接取',
                                ),
                                Tab(
                                  text: '已結束',
                                ),
                              ]
                            : [
                                Tab(
                                  text: '未進行',
                                ),
                                Tab(
                                  text: '已申請',
                                ),
                                Tab(
                                  text: '待審核',
                                ),
                                Tab(
                                  text: '任務結束',
                                ),
                              ],
                      ),
                    ),
                    positive
                        //我發起的
                        ? Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                //進行中
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_ilaunch_streaming_list !=
                                          null
                                      ? value.mymission_ilaunch_streaming_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                  padding: EdgeInsetsDirectional
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
                                                                          borderRadius: BorderRadius
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
                                                                  child:
                                                                      Padding(
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
                                                                      '${value.mymission_ilaunch_streaming_list[index].title}',
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
                                                                    child: Text(
                                                                      '${value.mymission_ilaunch_streaming_list[index].content}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700),
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
                                                                      '懸賞獎金\$${value.mymission_ilaunch_streaming_list[index].price}',
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
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                                                            ),
                                                                          ),
                                                                        ),onTap: (){
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                    FakeStream(
                                                                                      TheMission: value.mymission_ilaunch_streaming_list[index],
                                                                                    )));
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
                                                                  MissionDetailPage(
                                                                      ThisMission:
                                                                          value.mymission_ilaunch_streaming_list[
                                                                              index])));
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
                                                  .mymission_ilaunch_streaming_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                                // 未進行
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_ilaunch_startyet_list !=
                                          null
                                      ? value.mymission_ilaunch_startyet_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                .fromSTEB(15, 8,
                                                                    15, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
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
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.mymission_ilaunch_startyet_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            spy_gradient_light_blue,
                                                                            spy_gradient_light_purple,
                                                                          ])),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7,
                                                                        horizontal:
                                                                            30),
                                                                    child: Text(
                                                                      '跟TA聊聊',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                '${value.mymission_ilaunch_startyet_list[index].content}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
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
                                                                      ThisMission:
                                                                          value.mymission_ilaunch_startyet_list[
                                                                              index])));
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
                                                  .mymission_ilaunch_startyet_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                                // 未接取
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_ilaunch_notcatched_list !=
                                          null
                                      ? value.mymission_ilaunch_notcatched_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                .fromSTEB(15, 8,
                                                                    15, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
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
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.mymission_ilaunch_notcatched_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            spy_gradient_light_blue,
                                                                            spy_gradient_light_purple,
                                                                          ])),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7,
                                                                        horizontal:
                                                                            30),
                                                                    child: Text(
                                                                      '申請列表',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                '${value.mymission_ilaunch_notcatched_list[index].content}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
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
                                                                      ThisMission:
                                                                          value.mymission_ilaunch_notcatched_list[
                                                                              index])));
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
                                                  .mymission_ilaunch_notcatched_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                                // 已結束
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_ilaunch_finish_list !=
                                          null
                                      ? value.mymission_ilaunch_finish_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                .fromSTEB(15, 8,
                                                                    15, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
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
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.mymission_ilaunch_finish_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            spy_gradient_light_blue,
                                                                            spy_gradient_light_purple,
                                                                          ])),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7,
                                                                        horizontal:
                                                                            30),
                                                                    child: Text(
                                                                      '詳細內容',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                '${value.mymission_ilaunch_finish_list[index].content}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
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
                                                                      ThisMission:
                                                                          value.mymission_ilaunch_finish_list[
                                                                              index])));
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
                                                  .mymission_ilaunch_finish_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                                // Container(), Container(), Container(), Container(),
                              ],
                            ),
                          )
                        //我接取的
                        : Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Container(), Container(), Container(),
                                // 未進行
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_icatch_startyet_list !=
                                          null
                                      ? value.mymission_icatch_startyet_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                .fromSTEB(15, 8,
                                                                    15, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
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
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.mymission_icatch_startyet_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            spy_gradient_light_blue,
                                                                            spy_gradient_light_purple,
                                                                          ])),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7,
                                                                        horizontal:
                                                                            30),
                                                                    child: Text(
                                                                      '立即開播',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          0,
                                                                          0),
                                                              child: Container(
                                                                height: 40,
                                                                width: 300,
                                                                child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  strutStyle:
                                                                      StrutStyle(
                                                                          fontSize:
                                                                              12.0),
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                    text:
                                                                        '${value.mymission_icatch_startyet_list[index].content}',
                                                                  ),
                                                                ),
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
                                                                      ThisMission:
                                                                          value.mymission_icatch_startyet_list[
                                                                              index])));
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
                                                  .mymission_icatch_startyet_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                                // 已申請
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_icatch_applied_list !=
                                          null
                                      ? value.mymission_icatch_applied_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                .fromSTEB(15, 8,
                                                                    15, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
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
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.mymission_icatch_applied_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                            gradient: LinearGradient(colors: [
                                                                              spy_gradient_light_blue,
                                                                              spy_gradient_light_purple,
                                                                            ])),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              7,
                                                                          horizontal:
                                                                              30),
                                                                      child:
                                                                          Text(
                                                                        '跟TA聊聊',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => O2OChatroom(
                                                                                  memberid: value.remoteUserInfo[0].memberid,
                                                                                  chatroomid: value.mymission_icatch_applied_list[index].memberid.toHexString(),
                                                                                  nickname: value.mymission_icatch_applied_list[index].nickname,
                                                                                  avatar: value.mymission_icatch_applied_list[index].avatar_sub,
                                                                                  fcmtoken: value.mymission_icatch_applied_list[index].fcmtoken,
                                                                                )));
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          0,
                                                                          0),
                                                              child: Container(
                                                                height: 40,
                                                                width: 300,
                                                                child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  strutStyle:
                                                                      StrutStyle(
                                                                          fontSize:
                                                                              12.0),
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                    text:
                                                                        '${value.mymission_icatch_applied_list[index].content}',
                                                                  ),
                                                                ),
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
                                                                      ThisMission:
                                                                          value.mymission_icatch_applied_list[
                                                                              index])));
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
                                                  .mymission_icatch_applied_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                                // 待審核
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_icatch_approve_list !=
                                          null
                                      ? value.mymission_icatch_approve_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                .fromSTEB(15, 8,
                                                                    15, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
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
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.mymission_icatch_approve_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            spy_gradient_light_blue,
                                                                            spy_gradient_light_purple,
                                                                          ])),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7,
                                                                        horizontal:
                                                                            30),
                                                                    child: Text(
                                                                      '申請列表',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          0,
                                                                          0),
                                                              child: Container(
                                                                height: 40,
                                                                width: 300,
                                                                child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  strutStyle:
                                                                      StrutStyle(
                                                                          fontSize:
                                                                              12.0),
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                    text:
                                                                        '${value.mymission_icatch_approve_list[index].content}',
                                                                  ),
                                                                ),
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
                                                                      ThisMission:
                                                                          value.mymission_icatch_approve_list[
                                                                              index])));
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
                                                  .mymission_icatch_approve_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                                // 任務結束
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return value.mymission_icatch_finished_list !=
                                          null
                                      ? value.mymission_icatch_finished_list
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
                                                              color: index %
                                                                          2 ==
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
                                                                .fromSTEB(15, 8,
                                                                    15, 0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
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
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Text(
                                                                    '${value.mymission_icatch_finished_list[index].title}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              20),
                                                                          gradient:
                                                                              LinearGradient(colors: [
                                                                            spy_gradient_light_blue,
                                                                            spy_gradient_light_purple,
                                                                          ])),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            7,
                                                                        horizontal:
                                                                            30),
                                                                    child: Text(
                                                                      '詳細內容',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            10,
                                                                            20,
                                                                            0,
                                                                            0),
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 300,
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
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                      text:
                                                                          '${value.mymission_icatch_finished_list[index].content}',
                                                                    ),
                                                                  ),
                                                                )),
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
                                                                      ThisMission:
                                                                          value.mymission_icatch_finished_list[
                                                                              index])));
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
                                                  .mymission_icatch_finished_list
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        );
                                }),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            )));
  }
}
