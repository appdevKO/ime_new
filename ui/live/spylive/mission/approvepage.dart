import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/live/spylive/showtime/fakestream.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:provider/provider.dart';

import 'missiondetailpage.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({Key? key}) : super(key: key);

  @override
  State<ApprovePage> createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .get_spy_mymission_ilaunch_approvelist();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('待審核'),
          backgroundColor: Color(0xff1A1A1A),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<ChatProvider>(context, listen: false)
                  .get_spy_streaminglist();
            },
          ),
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
                Expanded(
                  child:
                      Consumer<ChatProvider>(builder: (context, value, child) {
                    return value.mymission_ilaunch_approve_list != null
                        ? value.mymission_ilaunch_approve_list.isNotEmpty
                            ? ListView.separated(
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 8, 16, 0),
                                    child: GestureDetector(
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
                                                offset: Offset(
                                                    index % 2 == 0 ? 2 : -2, 0),
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
                                                  15, 8, 15, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
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
                                                                10, 0, 0, 0),
                                                    child: Text(
                                                      '${value.mymission_ilaunch_approve_list[index].title}',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  value.mymission_ilaunch_approve_list[index]
                                                              .status ==
                                                          5
                                                      ? Container(
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  gradient:
                                                                      LinearGradient(
                                                                          colors: [
                                                                        spy_gradient_light_blue,
                                                                        spy_gradient_light_purple,
                                                                      ])),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 7,
                                                                    horizontal:
                                                                        30),
                                                            child: Text(
                                                              value.mymission_ilaunch_approve_list[index]
                                                                          .status ==
                                                                      5
                                                                  ? '等待審核'
                                                                  : value.mymission_ilaunch_approve_list[index].status == 6
                                                                      ? '募資失敗'
                                                                      : value.mymission_ilaunch_approve_list[index].status == 7
                                                                          ? '任務成功'
                                                                          : value.mymission_ilaunch_approve_list[index].status == 8
                                                                              ? '任務失敗'
                                                                              : '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .white)),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 7,
                                                                    horizontal:
                                                                        30),
                                                            child: Text(
                                                              value.mymission_ilaunch_approve_list[index]
                                                                          .status ==
                                                                      5
                                                                  ? '等待審核'
                                                                  : value.mymission_ilaunch_approve_list[index].status == 6
                                                                      ? '募資失敗'
                                                                      : value.mymission_ilaunch_approve_list[index].status == 7
                                                                          ? '任務成功'
                                                                          : value.mymission_ilaunch_approve_list[index].status == 8
                                                                              ? '任務失敗'
                                                                              : '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 16,
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
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(10, 20, 0, 0),
                                                child: Text(
                                                  '${value.mymission_ilaunch_approve_list[index].content}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700),
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
                                                              .mymission_ilaunch_approve_list[
                                                          index],
                                                    )));
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Container(
                                    height: 5,
                                  );
                                },
                                itemCount:
                                    value.mymission_ilaunch_approve_list.length,
                              )
                            : Center(
                                child: Text(
                                  '目前沒有在直播中的任務',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                        : Center(
                            child: Text(
                              '任務加載中',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
