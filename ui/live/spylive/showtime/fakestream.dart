import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/mission_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:provider/provider.dart';

class FakeStream extends StatefulWidget {
  FakeStream({Key? key, required this.TheMission}) : super(key: key);
  MissionModel? TheMission;

  @override
  State<FakeStream> createState() => _FakeStreamState();
}

class _FakeStreamState extends State<FakeStream> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    if (widget.TheMission?.type == 3) {
      await Provider.of<ChatProvider>(context, listen: false)
          .get_showtime_detail(widget.TheMission?.id);
    } else {
      await Provider.of<ChatProvider>(context, listen: false)
          .get_mission_detail_choose(widget.TheMission?.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('特務mission/showtime 直播間'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  //如果是showtime主播退出
                  if (widget.TheMission?.type == 3 &&
                      widget.TheMission?.memberid ==
                          Provider.of<ChatProvider>(context, listen: false)
                              .remoteUserInfo[0]
                              .memberid) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return AlertDialog(
                              title: Text('若退出直播間將結束此任務，確定要退出嗎'),
                              content: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('取消')),
                                      ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);

                                            ///暫定
                                            await Provider.of<ChatProvider>(
                                                    context,
                                                    listen: false)
                                                .showtime_fail(
                                              widget.TheMission?.id,
                                            );
                                            // await Provider.of<ChatProvider>(
                                            //         context,
                                            //         listen: false)
                                            //     .finish_mission(
                                            //         widget.TheMission?.id);

                                            ///
                                            Navigator.pop(context);
                                            await Provider.of<ChatProvider>(
                                                    context,
                                                    listen: false)
                                                .get_mission_detail_choose(
                                                    widget.TheMission?.id);
                                            await Provider.of<ChatProvider>(
                                                    context,
                                                    listen: false)
                                                .get_spy_showtime_streaminglist();
                                            await Provider.of<ChatProvider>(
                                                    context,
                                                    listen: false)
                                                .get_spy_streaminglist();
                                          },
                                          child: Text('確定(測試時退出為募資失敗)'))
                                    ],
                                  )));
                        });
                  } else if (widget.TheMission?.executor ==
                      Provider.of<ChatProvider>(context, listen: false)
                          .remoteUserInfo[0]
                          .memberid) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return AlertDialog(
                              title: Text('若退出直播間將結束此任務，確定要退出嗎'),
                              content: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('取消')),
                                      ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            await Provider.of<ChatProvider>(
                                                    context,
                                                    listen: false)
                                                .finish_mission(
                                                    widget.TheMission?.id);
                                            Navigator.pop(context);
                                            await Provider.of<ChatProvider>(
                                                    context,
                                                    listen: false)
                                                .get_mission_detail_choose(
                                                    widget.TheMission?.id);
                                          },
                                          child: Text('確定'))
                                    ],
                                  )));
                        });
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            body: Column(
              children: [
                Text(
                  'status:${widget.TheMission?.status}     title:${widget.TheMission?.title} ',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '募資名單 ',
                ),
                // Container(
                //   color: Color(0xffddaadd),
                //   height: 200,
                //   child: Consumer<ChatProvider>(
                //     builder: (context, value, child) {
                //       return ListView.builder(
                //         itemBuilder: (context, index) {
                //           return Container(
                //             child: Padding(
                //               padding: const EdgeInsets.symmetric(horizontal: 15.0),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   CircleAvatar(
                //                     backgroundImage: NetworkImage(
                //                         '${value.mission_detail[0].pay_userinfo_list[index].avatar_sub}'),
                //                   ),
                //                   Padding(
                //                     padding: const EdgeInsets.only(left: 5.0),
                //                     child: Text(
                //                       '${value.mission_detail[0].pay_userinfo_list[index].nickname}',
                //                       style: TextStyle(color: Colors.black),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           );
                //         },
                //         itemCount:
                //             value.mission_detail[0].pay_userinfo_list.length,
                //       );
                //
                //     },
                //   ),
                // ),
                Consumer<ChatProvider>(
                  builder: (context, value, child) {
                    return Text('現在有多少點數:${value.remoteUserInfo[0].icoin}');
                  },
                ),
                widget.TheMission?.type == 3
                    ? widget.TheMission?.memberid ==
                            Provider.of<ChatProvider>(context, listen: false)
                                .remoteUserInfo[0]
                                .memberid
                        ?
                        //showtime 發起者 =主播本人
                        Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  color: Colors.pink,
                                  child: Center(
                                    child: Text('完成募資開始執行任務'),
                                  ),
                                ),
                                onTap: () {
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .start_showtime(widget.TheMission?.id);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  child: Container(
                                    width: 150,
                                    height: 50,
                                    color: Colors.blue,
                                    child: Center(
                                      child: Text(
                                          '關閉 showtime (測試用 募資成功 =任務成功=7)'),
                                    ),
                                  ),
                                  onTap: () async {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .approve_mission_success(
                                            widget.TheMission?.id,
                                            widget.TheMission?.executor,
                                            widget.TheMission?.price);
                                    Navigator.pop(context);
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_mission_detail_choose(
                                            widget.TheMission?.id);
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_spy_showtime_streaminglist();
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_spy_streaminglist();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: GestureDetector(
                                  child: Container(
                                    width: 150,
                                    height: 50,
                                    color: Colors.green,
                                    child: Center(
                                      child: Text('關閉 showtime (測試用 募資失敗 6)'),
                                    ),
                                  ),
                                  onTap: () async {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .showtime_fail(widget.TheMission?.id);
                                    Navigator.pop(context);
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_mission_detail_choose(
                                            widget.TheMission?.id);
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_spy_showtime_streaminglist();
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_spy_streaminglist();
                                  },
                                ),
                              )
                            ],
                          )
                        :
                        // showtime觀眾
                        Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 250,
                                  height: 50,
                                  color: Colors.yellow,
                                  child: Center(
                                    child: Text('我是showtime觀眾 抖內100'),
                                  ),
                                ),
                                onTap: () async {
                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .donate_showtime(
                                          widget.TheMission?.id, 100);
                                },
                              ),
                            ],
                          )
                    :
                    // mission
                    widget.TheMission?.executor ==
                            Provider.of<ChatProvider>(context, listen: false)
                                .remoteUserInfo[0]
                                .memberid
                        ?
                        //是mission 執行者 = 主播
                        Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  color: Colors.purple,
                                  child: Center(
                                    child: Text('開始 mission 直播'),
                                  ),
                                ),
                                onTap: () {
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .start_mission(widget.TheMission?.id);
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  color: Colors.blue,
                                  child: Center(
                                    child: Text('關閉  mission直播 =5'),
                                  ),
                                ),
                                onTap: () async {
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .finish_mission(widget.TheMission?.id);
                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .get_mission_detail_choose(
                                          widget.TheMission?.id);
                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .get_spy_showtime_streaminglist();
                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .get_spy_streaminglist();
                                },
                              )
                            ],
                          )
                        :
                        // 是mission 觀眾
                        Column(
                            children: [
                              widget.TheMission?.memberid ==
                                      Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .remoteUserInfo[0]
                                          .memberid
                                  ?
                                  //我是發起者
                                  Container(
                                      child:
                                          Text('我是 mission發起者 在這邊看mission直播'),
                                    )
                                  : Container(
                                      child: Text('我是觀眾 在這邊看mission直播'),
                                    ),
                            ],
                          ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          //showtime 直播主 退出時
          if (widget.TheMission?.type == 3 &&
              widget.TheMission?.memberid ==
                  Provider.of<ChatProvider>(context, listen: false)
                      .remoteUserInfo[0]
                      .memberid) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                      title: Text('若退出直播間將結束此任務，確定要退出嗎'),
                      content: SizedBox(
                          height: 50,
                          width: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('取消')),
                              ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    Navigator.pop(context);

                                    ///測試
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .approve_mission_success(
                                            widget.TheMission?.id,
                                            widget.TheMission?.executor,
                                            widget.TheMission?.price);

                                    Navigator.pop(context);
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_mission_detail_choose(
                                            widget.TheMission?.id);
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_spy_showtime_streaminglist();
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .get_spy_streaminglist();
                                  },
                                  child: Text('確定(測試時為募資成功=任務成功=7)'))
                            ],
                          )));
                });
          } else if (widget.TheMission?.executor ==
              Provider.of<ChatProvider>(context, listen: false)
                  .remoteUserInfo[0]
                  .memberid) {
          } else {
            Navigator.pop(context);
          }
          return false;
        });
  }
}
