import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/mission_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/live/spylive/showtime/fakestream.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MissionDetailPage extends StatefulWidget {
  MissionDetailPage({Key? key, required this.ThisMission}) : super(key: key);
  MissionModel ThisMission;

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    if (widget.ThisMission.status == 1) {
      await Provider.of<ChatProvider>(context, listen: false)
          .get_mission_detail_apply(widget.ThisMission.id);
    } else if (widget.ThisMission.status == 2) {
      await Provider.of<ChatProvider>(context, listen: false)
          .get_mission_detail_choose(widget.ThisMission.id);
    } else {
      print('狀態不是1/2 ${widget.ThisMission.status}');
      await Provider.of<ChatProvider>(context, listen: false)
          .get_mission_detail_choose(widget.ThisMission.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text('任務細節頁'),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: widget.ThisMission.type == 1
                        ? Text('私密Mission')
                        : widget.ThisMission.type == 2
                            ? Text('公開Mission')
                            : Text('ShowTime'),
                  )
                ],
              ),
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
                              '任務標題:${widget.ThisMission.title}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            Text(
                              '任務內容:${widget.ThisMission.content}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '任務目標獎金:${widget.ThisMission.price}',
                              style: TextStyle(color: spy_mission_money),
                            ),
                            widget.ThisMission.starttime != null
                                ? Text(
                                    '開始時間: ${DateFormat('yyyy/MM/dd').format(widget.ThisMission.starttime!)}',
                                    style: TextStyle(
                                      color: Color(
                                        0xff808080,
                                      ),
                                    ),
                                  )
                                : Container(),
                            widget.ThisMission.endtime != null
                                ? Text(
                                    '結束時間: ${DateFormat('yyyy/MM/dd').format(widget.ThisMission.endtime!)}',
                                    style: TextStyle(
                                      color: Color(
                                        0xff808080,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Consumer<ChatProvider>(
                            builder: (context, value, child) {
                          return value.mission_detail != null
                              ? value.mission_detail[0].status == 1 &&
                                      value.mission_detail[0].memberid ==
                                          Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .remoteUserInfo[0]
                                              .memberid
                                  ? value.mission_detail[0].applyedlist != null
                                      ? Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white)),
                                          child: Column(
                                            children: [
                                              Text(
                                                '申請列表',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                height: 200,
                                                child: ListView.separated(
                                                  itemBuilder:
                                                      (context, index) =>
                                                          Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      '${value.mission_detail[0].applyedlist[index].avatar_sub}'),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          5.0),
                                                              child: Text(
                                                                '${value.mission_detail[0].applyedlist[index].nickname}',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        GestureDetector(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        2),
                                                            child: Text('指定'),
                                                            color:
                                                                spy_button_blue,
                                                          ),
                                                          onTap: () async {
                                                            await value.choose_mission_executor(
                                                                widget
                                                                    .ThisMission
                                                                    .id,
                                                                value
                                                                    .mission_detail[
                                                                        0]
                                                                    .applyedlist[
                                                                        index]
                                                                    .memberid);
                                                            //刷新狀態
                                                            await value
                                                                .get_mission_detail_choose(
                                                                    widget
                                                                        .ThisMission
                                                                        .id);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  itemCount: value
                                                      .mission_detail[0]
                                                      .applyedlist
                                                      .length,
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          Container(
                                                    height: 5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                      : Center(
                                          child: Text(
                                            '尚未有申請者',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                  : value.mission_detail[0].status == 2
                                      ? Column(
                                          children: [
                                            Text(
                                              '選定特務人選:',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      '${value.mission_detail[0].executor_info[0].avatar_sub}'),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                  child: Text(
                                                    '${value.mission_detail[0].executor_info[0].nickname}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container()
                              : Center(
                                  child: Text(
                                    '加載中',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer<ChatProvider>(
                            builder: (context, value, child) {
                              return value.mission_detail == null
                                  ? Container()
                                  : value.mission_detail[0].memberid ==
                                              value
                                                  .remoteUserInfo[0].memberid ||
                                          (value.mission_detail[0].status ==
                                                  2 &&
                                              value.mission_detail[0]
                                                      .executor !=
                                                  value.remoteUserInfo[0]
                                                      .memberid)
                                      ? Container()
                                      : GestureDetector(
                                          child: Container(
                                            width: 300,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            decoration: BoxDecoration(
                                                gradient:
                                                    LinearGradient(colors: [
                                                  spy_gradient_light_purple,
                                                  spy_gradient_light_blue,
                                                ]),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Text(
                                                value.mission_detail == null
                                                    ? '獲取資料中'
                                                    : value.mission_detail[0]
                                                                .status ==
                                                            1
                                                        ? value
                                                                    .mission_detail[
                                                                        0]
                                                                    .apply_list
                                                                    .indexWhere((element) =>
                                                                        element ==
                                                                        value
                                                                            .remoteUserInfo[
                                                                                0]
                                                                            .memberid) !=
                                                                -1
                                                            ? '已經申請'
                                                            : '我想做任務'
                                                        : value
                                                                        .mission_detail[
                                                                            0]
                                                                        .status ==
                                                                    2 &&
                                                                value
                                                                        .mission_detail[
                                                                            0]
                                                                        .executor ==
                                                                    value
                                                                        .remoteUserInfo[
                                                                            0]
                                                                        .memberid
                                                            ? '被選為此任務特務，立即開播'
                                                            : value
                                                                        .mission_detail[
                                                                            0]
                                                                        .status ==
                                                                    3
                                                                ? '去觀看募資'
                                                                : value.mission_detail[0]
                                                                            .status ==
                                                                        4
                                                                    ? '去觀看任務'
                                                                    : '任務已結束',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            if (value
                                                    .mission_detail[0].status ==
                                                1) {
                                              //未選擇
                                              if (value.mission_detail[0]
                                                      .memberid ==
                                                  Provider.of<ChatProvider>(
                                                          context,
                                                          listen: false)
                                                      .remoteUserInfo[0]
                                                      .memberid) {
                                                // '去指定特務' 是我發起的
                                              } else {
                                                if (value.mission_detail[0]
                                                        .apply_list
                                                        .indexWhere((element) =>
                                                            element ==
                                                            value
                                                                .remoteUserInfo[
                                                                    0]
                                                                .memberid) ==
                                                    -1) {
                                                  // '我想做任務' 不是我發起的
                                                  Provider.of<ChatProvider>(
                                                          context,
                                                          listen: false)
                                                      .submit_mission(widget
                                                          .ThisMission.id);
                                                }
                                              }
                                              //刷新狀態
                                              await value
                                                  .get_mission_detail_apply(
                                                      widget.ThisMission.id);
                                            } else if (value
                                                    .mission_detail[0].status ==
                                                2) {
                                              // 開播
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FakeStream(
                                                            TheMission: widget
                                                                .ThisMission,
                                                          )));
                                            } else if (value.mission_detail[0]
                                                        .status ==
                                                    3 ||
                                                value.mission_detail[0]
                                                        .status ==
                                                    4) {
                                              //看播
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FakeStream(
                                                            TheMission: widget
                                                                .ThisMission,
                                                          )));
                                            }
                                          });
                            },
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
