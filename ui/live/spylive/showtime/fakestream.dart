import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/mission_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
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
    super.initState();
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
                                          child: Text('確定'))
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'status:${widget.TheMission?.status}     title:${widget.TheMission?.title} ',
                  style: TextStyle(fontSize: 30),
                ),
                widget.TheMission?.type == 3
                    ? widget.TheMission?.memberid ==
                            Provider.of<ChatProvider>(context, listen: false)
                                .remoteUserInfo[0]
                                .memberid
                        ?
                        //showtime 發起者 =主播本人
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              GestureDetector(
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  color: Colors.blue,
                                  child: Center(
                                    child: Text('關閉 showtime 直播-募資成功 =任務成功=7'),
                                  ),
                                ),
                                onTap: () async {
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .approve_mission_success(
                                          widget.TheMission?.id);
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
                              GestureDetector(
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  color: Colors.blue,
                                  child: Center(
                                    child: Text('關閉 showtime 直播-募資失敗 6'),
                                  ),
                                ),
                                onTap: () async {
                                  Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .finish_mission(widget.TheMission?.id);
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
                              )
                            ],
                          )
                        :
                        // showtime觀眾
                        Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  color: Colors.yellow,
                                  child: Center(
                                    child: Text('抖內100'),
                                  ),
                                ),
                                onTap: () {
                                  Provider.of<ChatProvider>(context,
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
                                    child: Text('關閉  直播'),
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

                                    ///
                                    await Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .approve_mission_success(
                                            widget.TheMission?.id);
                                    // await Provider.of<ChatProvider>(context,
                                    //         listen: false)
                                    //     .finish_mission(widget.TheMission?.id);
                                    ///
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
                                  child: Text('確定'))
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
