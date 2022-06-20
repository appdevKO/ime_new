import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:ime_new/business_logic/model/mqtt_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/user_profile/other_profile_page.dart';
import 'package:ime_new/ui/widget/showimage.dart';
import 'package:ime_new/utils/sticker_address.dart';
import 'package:ime_new/utils/viewconfig.dart';

import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

import 'chatroomsetting.dart';

enum recordState {
  notrecord,
  recording,
  waiting,
  recordnotsend,
}

class GroupChatRoom2 extends StatefulWidget {
  GroupChatRoom2(
      {Key? key,
        required this.chatroomid,
        required this.title,
        required this.chattype,
        required this.own})
      : super(key: key);

  final mongo.ObjectId chatroomid;
  final String title;
  final int chattype;
  final bool own;

  /// 1 揪團 2約會 3私聊

  @override
  _GroupChatRoom2State createState() => _GroupChatRoom2State();
}

class _GroupChatRoom2State extends State<GroupChatRoom2> {
  late TextEditingController _textController;
  final FocusNode _focus = FocusNode();
  Directory? rootPath;
  ScrollController scrollController = ScrollController();

  ///錄音
  late FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  late FlutterSoundPlayer _audioPlayer;
  bool _mRecorderIsInited = false;
  bool startplayaudio = false;
  String recorderTxt = '未開始錄音';
  String playerTxt = '未開始播放';
  DateTime recordtime = DateTime.now();
  late StreamSubscription _playerSubscription;

  // String _directoryPath = '/storage/emulated/0/SoundRecorder';
  double bottomrecordheight = 0;
  double bottomstickerheight = 0;

  // double bottominsetheight = 70;
  bool insetopen = false;
  recordState myrecord = recordState.notrecord;
  int? topicindex = -1;
  bool iconopen = false;
  late TextEditingController dialogcontroller;
  static const flutterChannel =
  const MethodChannel('com.example.flutter/flutter');
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    _textController = TextEditingController();
    dialogcontroller = TextEditingController();

    initdata();
    _focus.addListener(_onFocusChange);
    initmic();
    initplayer();
    Provider.of<ChatProvider>(context, listen: false)
        .findindex(widget.chatroomid.toHexString());

    ///method channel backbutton
    Future<dynamic> handler(MethodCall call) async {
      switch (call.method) {
        case 'backAction':
          print('1234 backaction');
          // Get.back();
          Navigator.pop(context);
          break;
      }
    }

    flutterChannel.setMethodCallHandler(handler);

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    dialogcontroller.dispose();
    // _audioRecorder.closeRecorder();
    _audioRecorder.closeAudioSession();
    // _audioPlayer.closePlayer();
    _audioPlayer.closeAudioSession();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    // _playerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 50),
            child: Container(
              height: Platform.isIOS ? 44 : 168,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: widget.chattype == 1
                        ? colorlist[1]
                        : widget.chattype == 2
                        ? colorlist[1]
                        : [Colors.grey]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //拿來對齊
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        //離開群聊聊天室時
                        Provider.of<ChatProvider>(context, listen: false)
                            .msglist![topicindex!]
                            .msg = [];
                        // 清空memberlist
                        Provider.of<ChatProvider>(context, listen: false)
                            .memberlist = [];
                        // 重新獲得揪團揪咖房間
                        await Provider.of<ChatProvider>(context, listen: false)
                            .getgroupperson();
                        await Provider.of<ChatProvider>(context, listen: false)
                            .getgroupteam();
                        Navigator.pop(context);
                      }),
                  Center(
                    child: Container(
                      width: 250,
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              height: 1,
                              color: Colors.white),
                          text: '${widget.title}',
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _focus.unfocus();
                      // FocusScope.of(context).unfocus();
                      // print("退出退出退出 ${widget.chatroomid}");
                      // Provider.of<ChatProvider>(context, listen: false)
                      //     .notify_chatroom_member_exit(widget.chatroomid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatroomSetting(
                                chatroomId: widget.chatroomid,
                                own: widget.own,
                              )));
                    },
                  ),
                ],
              ),
            ),
          ),
          body: GestureDetector(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    topMember(),
                    //對話紀錄
                    Expanded(child: Consumer<ChatProvider>(
                      builder: (context, value, child) {
                        /// 歷史訊息與當前訊息混合
                        /// 歷史訊息會有null [] [xx]三種狀態
                        /// 當前訊息會有[] [xx]兩種狀態

                        return topicindex == -1
                            ? Center(
                          child: Container(
                            child: Text('聊天室加載中 01'),
                          ),
                        )
                            : value.historymsg != null
                            ? value.historymsg!.isEmpty &&
                            value.msglist![topicindex!].msg!.isEmpty
                            ? Center(
                          child: Container(
                            child: Text('此聊天室沒有聊天記錄'),
                          ),
                        )
                            :
                        SmartRefresher(
                                        enablePullDown: false,
                                        enablePullUp: true,
                                        controller: _refreshController,
                                        header: WaterDropMaterialHeader(
                                            backgroundColor: Color(0xffaCEA00)),

                                        onLoading:  _onLoading,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            // print('index 數量$index');
                                            int correctindex;
                                            if (value.historymsg!.isNotEmpty) {
                                              //歷史訊息回傳[xx]-有歷史
                                              if (topicindex == -1) {
                                                //沒當前 -純歷史
                                                correctindex = index;
                                                return bubble(
                                                  value.historymsg![
                                                      correctindex],
                                                );
                                              } else {
                                                // print('收到當前訊息');
                                                // 是當前聊天室收到當前訊息 歷史+當前
                                                correctindex = index <
                                                        value
                                                            .msglist![
                                                                topicindex!]
                                                            .msg!
                                                            .length
                                                    ? index
                                                    : index -
                                                        value
                                                            .msglist![
                                                                topicindex!]
                                                            .msg!
                                                            .length;

                                                return index <
                                                        value
                                                            .msglist![
                                                                topicindex!]
                                                            .msg!
                                                            .length
                                                    ? bubble(
                                                        value
                                                            .msglist![
                                                                topicindex!]
                                                            .msg![correctindex],
                                                      )
                                                    : index ==
                                                            value
                                                                .msglist![
                                                                    topicindex!]
                                                                .msg!
                                                                .length
                                                        ? Column(
                                                            children: [
                                                              bubble(
                                                                value.historymsg![
                                                                    correctindex],
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                    '---以上為歷史紀錄---'),
                                                              ),
                                                            ],
                                                          )
                                                        : bubble(
                                                            value.historymsg![
                                                                correctindex],
                                                          );
                                              }
                                            } else {
                                              //歷史訊息回傳[]-沒有歷史訊息
                                              if (topicindex == -1) {
                                                return Center(
                                                  child: Container(
                                                    child: Text('沒有聊天記錄'),
                                                  ),
                                                );
                                              } else if (value
                                                  .msglist![topicindex!]
                                                  .msg!
                                                  .isEmpty) {
                                                // 沒歷史 沒當前
                                                // 收到當前聊天室訊息
                                                return Center(
                                                  child: Container(
                                                    child: Text('此聊天室沒有聊天記錄'),
                                                  ),
                                                );
                                              } else {
                                                // 沒歷史 有當前
                                                correctindex = index <
                                                        value
                                                            .msglist![
                                                                topicindex!]
                                                            .msg!
                                                            .length
                                                    ? index
                                                    : index -
                                                        value
                                                            .msglist![
                                                                topicindex!]
                                                            .msg!
                                                            .length;

                                                return bubble(
                                                  value.msglist![topicindex!]
                                                      .msg![correctindex],
                                                );
                                              }
                                            }
                                          },
                                          reverse: true,
                                          itemCount: value.historymsg != null
                                              ? value.historymsg!.isEmpty
                                                  ? value.msglist![topicindex!]
                                                          .msg!.isEmpty
                                                      ? 1
                                                      : value
                                                          .msglist![topicindex!]
                                                          .msg!
                                                          .length
                                                  : value.msglist![topicindex!]
                                                          .msg!.isEmpty
                                                      ? value.historymsg!.length
                                                      : value
                                                              .msglist![
                                                                  topicindex!]
                                                              .msg!
                                                              .length +
                                                          value.historymsg!
                                                              .length
                                              : value.msglist![topicindex!].msg!
                                                      .isEmpty
                                                  ? 1
                                                  : value.msglist![topicindex!]
                                                      .msg!.length,
                                          controller: scrollController,
                                        ),
                                      )

                        // Container(
                        //   child: ListView.builder(
                        //     itemBuilder: (context, index) {
                        //       int correctindex;
                        //       if (value.historymsg!.isNotEmpty) {
                        //         //歷史訊息回傳[xx]-有歷史
                        //         if (topicindex == -1) {
                        //           //沒當前 -純歷史
                        //           correctindex = index;
                        //           return bubble(
                        //             value.historymsg![
                        //             correctindex],
                        //           );
                        //         } else {
                        //           // 是當前聊天室收到當前訊息 歷史+當前
                        //           correctindex = index <
                        //               value
                        //                   .msglist![
                        //               topicindex!]
                        //                   .msg!
                        //                   .length
                        //               ? index
                        //               : index -
                        //               value
                        //                   .msglist![
                        //               topicindex!]
                        //                   .msg!
                        //                   .length;
                        //
                        //           return index <
                        //               value
                        //                   .msglist![
                        //               topicindex!]
                        //                   .msg!
                        //                   .length
                        //               ? bubble(
                        //             value
                        //                 .msglist![
                        //             topicindex!]
                        //                 .msg![correctindex],
                        //           )
                        //               : index ==
                        //               value
                        //                   .msglist![
                        //               topicindex!]
                        //                   .msg!
                        //                   .length
                        //               ? Column(
                        //             children: [
                        //               bubble(
                        //                 value.historymsg![
                        //                 correctindex],
                        //               ),
                        //               Container(
                        //                 child: Text(
                        //                     '---以上為歷史紀錄---'),
                        //               ),
                        //             ],
                        //           )
                        //               : bubble(
                        //             value.historymsg![
                        //             correctindex],
                        //           );
                        //         }
                        //       } else {
                        //         //歷史訊息回傳[]-沒有歷史訊息
                        //         if (topicindex == -1) {
                        //           return Center(
                        //             child: Container(
                        //               child: Text('沒有聊天記錄'),
                        //             ),
                        //           );
                        //         } else if (value
                        //             .msglist![topicindex!]
                        //             .msg!
                        //             .isEmpty) {
                        //           // 沒歷史 沒當前
                        //           // 收到當前聊天室訊息
                        //           return Center(
                        //             child: Container(
                        //               child: Text('此聊天室沒有聊天記錄'),
                        //             ),
                        //           );
                        //         } else {
                        //           // 沒歷史 有當前
                        //           correctindex = index <
                        //               value
                        //                   .msglist![
                        //               topicindex!]
                        //                   .msg!
                        //                   .length
                        //               ? index
                        //               : index -
                        //               value
                        //                   .msglist![
                        //               topicindex!]
                        //                   .msg!
                        //                   .length;
                        //
                        //           return bubble(
                        //             value.msglist![topicindex!]
                        //                 .msg![correctindex],
                        //           );
                        //         }
                        //       }
                        //     },
                        //     reverse: true,
                        //     itemCount: value.historymsg != null
                        //         ? value.historymsg!.isEmpty
                        //         ? value.msglist![topicindex!]
                        //         .msg!.isEmpty
                        //         ? 1
                        //         : value
                        //         .msglist![topicindex!]
                        //         .msg!
                        //         .length
                        //         : value.msglist![topicindex!]
                        //         .msg!.isEmpty
                        //         ? value.historymsg!.length
                        //         : value
                        //         .msglist![
                        //     topicindex!]
                        //         .msg!
                        //         .length +
                        //         value.historymsg!
                        //             .length
                        //         : value.msglist![topicindex!].msg!
                        //         .isEmpty
                        //         ? 1
                        //         : value.msglist![topicindex!]
                        //         .msg!.length,
                        //     controller: scrollController,
                        //   ),
                        // )
                            : Center(
                          child: Container(
                            child: Text('沒有歷史訊息'),
                          ),
                        );
                      },
                    )),
                    bottomEnter(),
                    bottomRecord(),
                    bottomsticker(),
                    // Container(
                    //   height: 75,
                    // ),
                  ],
                ),
                //+號 列表
                Positioned(
                  bottom: bottomrecordheight != 0 || bottomstickerheight != 0
                      ? 365
                      : 75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      iconopen
                          ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // height: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.photo),
                                onPressed: () async {
                                  await Provider.of<ChatProvider>(context,
                                      listen: false)
                                      .sendimg_group(widget.chatroomid,
                                      'ime_group_chat');
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {
                                  Provider.of<ChatProvider>(context,
                                      listen: false)
                                      .sendimgwithcamera_group(
                                      widget.chatroomid,
                                      'ime_group_chat');
                                },
                              ),
                              //打開下方貼圖按鈕
                              IconButton(
                                icon: Icon(Icons.face),
                                onPressed: () {
                                  stickerautoopen();
                                },
                              ),
                              //打開下方錄音按鈕
                              IconButton(
                                icon: Icon(Icons.mic),
                                onPressed: () {
                                  audioautoopen();
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(),

                      // Container(
                      //   height: bottomrecordheight,
                      //   width: MediaQuery.of(context).size.width,
                      //   color: Colors.red,
                      // ),
                      // Container(
                      //   height: bottomstickerheight,
                      //   width: MediaQuery.of(context).size.width,
                      //   color: Colors.green,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              _focus.unfocus();
              // FocusScope.of(context).unfocus();
              audiobuttonclose();
              stickerbuttonclose();
            },
          ),
        ),
      ),
      onWillPop: () async {
        Provider.of<ChatProvider>(context, listen: false).getgroupteam();
        Provider.of<ChatProvider>(context, listen: false).getgroupperson();
        return true;
      },
    );
  }

  void _onLoading() async {
    print('loading');
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
    await Provider.of<ChatProvider>(context, listen: false)
        .add_group_his_page(widget.chatroomid);
  }

  void _onFocusChange() {
    debugPrint("Focus:111111111 ${_focus.hasFocus.toString()}");
    if (_focus.hasFocus) {
      print('keyboard open');
      setState(() {
        // bottominsetheight = MediaQuery.of(context).size.height / 2;
        insetopen = true;
        bottomrecordheight = 0;
        bottomstickerheight = 0;
      });
    } else {
      print('keyboard close');
      setState(() {
        // bottominsetheight = 70;
        insetopen = false;
        audiobuttonclose();
        stickerbuttonclose();
        // bottomrecordheight = 0;
        // bottomstickerheight = 0;
      });
    }
  }

  Widget bottomEnter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: Color(0xffF9F9F9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              if (iconopen) {
                setState(() {
                  iconopen = false;
                });
              } else {
                setState(() {
                  iconopen = true;
                });
              }
            },
          ),

          Flexible(
            child: Container(
                constraints: BoxConstraints(minHeight: 60.0, maxHeight: 150.0),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 2, left: 2),
                child: TextField(
                  focusNode: _focus,
                  //限制輸入文字多長
                  // maxLength: 75,
                  //換行
                  // maxLines: null,
                  keyboardType: TextInputType.text,
                  onSubmitted: (val) {
                    if (_textController.text != '') {
                      Provider.of<ChatProvider>(context, listen: false)
                          .groupchat(
                        _textController.text,
                        widget.chatroomid,
                        1,
                      );
                      _textController.clear();
                    }
                    _focus.unfocus();
                    // FocusScope.of(context).unfocus();
                  },
                  textInputAction: TextInputAction.done,
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: '輸入想說的話',
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  ),
                  style: TextStyle(height: 1),
                )),
          ),
          //傳送 發送 文字 箭頭 送出
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_textController.text != '') {
                Provider.of<ChatProvider>(context, listen: false).groupchat(
                  _textController.text,
                  widget.chatroomid,
                  1,
                );
                // Provider.of<ChatProvider>(context, listen: false).mqttpublish(
                //   _textController.text,
                //   widget.chatroomid,
                //   1,
                //   "ime_group_chat",
                // );
                _textController.clear();
              }
              _focus.unfocus();
              // FocusScope.of(context).unfocus();
            },
          )
        ],
      ),
    );
  }

  //錄音按鈕
  Widget bottomRecord() {
    return Container(
      height: bottomrecordheight,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: bottomrecordheight == 0
          ? Container()
          : myrecord == recordState.waiting
          ? Center(
        child: SizedBox(
          child: CircularProgressIndicator(),
          height: 50.0,
          width: 50.0,
        ),
      )
          : Container(
        height: bottomrecordheight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.all(20),
                child: myrecord == recordState.recordnotsend
                    ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      myrecord = recordState.notrecord;
                      recorderTxt = '未開始錄音';
                    });
                  },
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(8.0),
                      )),
                )
                    : Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  recorderTxt,
                  style: TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  child: Container(
                    height: 130,
                    width: 130,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1,
                            color: myrecord == recordState.recording
                                ? Colors.red
                                : myrecord ==
                                recordState.recordnotsend
                                ? Colors.blue
                                : Colors.black)),
                    child: Center(
                        child: myrecord == recordState.recordnotsend
                            ? Text(
                          '已錄音',
                          style: TextStyle(
                              color: Colors.blue, fontSize: 18),
                        )
                            : Icon(
                          myrecord == recordState.recording
                              ? Icons.stop
                              : Icons.mic,
                          color:
                          myrecord == recordState.recording
                              ? Colors.red
                              : Colors.black,
                          size: 35,
                        )),
                  ),
                  onTap: () {
                    if (myrecord == recordState.recording) {
                      stopmic(widget.chatroomid);
                      setState(() {
                        myrecord = recordState.recordnotsend;
                      });
                    } else if (myrecord ==
                        recordState.recordnotsend) {
                    } else {
                      startmic();
                      setState(() {
                        myrecord = recordState.recording;
                      });
                    }
                  },
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.all(20),
                child: myrecord == recordState.recordnotsend
                    ? ElevatedButton(
                  onPressed: () {
                    send_record_to_mqtt(widget.chatroomid);
                    setState(() {
                      recorderTxt = '未開始錄音';
                    });
                  },
                  child: Text(
                    '傳送',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8.0))),
                )
                    : Container()),
          ],
        ),
      ),
    );
  }

  //貼圖
  Widget bottomsticker() {
    return Container(
      height: bottomstickerheight,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: bottomstickerheight == 0
          ? Container()
          : Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 5.0,
              childAspectRatio: .9, //子元素在横轴长度和主轴长度的比例
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('${stickers_list[index]}')),
                  ),
                ),
                onTap: () {
                  print('sticker :$index');
                  Provider.of<ChatProvider>(context, listen: false)
                      .groupchat(
                    index.toString(),
                    widget.chatroomid,
                    3,
                  );
                },
              );
            },
            itemCount: stickers_list.length,
          )),
    );
  }

  Widget topMember() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffF9F9F9),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Consumer<ChatProvider>(
          builder: (context, value, child) {
            return value.memberlist != null
                ? value.memberlist!.isEmpty
                ? Container(
              child: Center(child: Text('成員加載中')),
            )
                : ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: value
                        .memberlist![index].avatar_sub !=
                        null &&
                        value.memberlist![index].avatar_sub != ''
                        ? NetworkImage(
                        value.memberlist![index].avatar_sub)
                        : AssetImage(
                        value.memberlist![index]
                            .sex ==
                            null ||
                            value.memberlist![index]
                                .sex ==
                                '男'
                            ? 'assets/default/sex_man.png'
                            : 'assets/default/sex_woman.png')
                    as ImageProvider,
                  ),
                  onTap: () {
                    if (value.memberlist![index].account !=
                        value.remoteUserInfo[0].account) {
                      //成員橫排 點 單一頭像
                      // 改成先進簡介
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtherProfilePage(
                                chatroomid: value
                                    .memberlist![index].memberid,
                              )));
                    } else {
                      print('同一人');
                    }
                  },
                );
              },
              itemCount: value.memberlist!.length,
              separatorBuilder: (context, index) {
                return Container(
                  width: 10,
                );
              },
              scrollDirection: Axis.horizontal,
            )
                : Container(
              child: Center(child: Text('沒有參與成員')),
            );
          },
        ),
      ),
    );
  }

  //泡泡樣式
  Widget bubble(
      MqttMsg msg,
      ) {
    //type  1 文字 / 2 圖片 / 3 貼圖 / 4 音頻 / 6 通知
    double text_radius = 20.0;
    // type檢查樣式
    var memberindex = Provider.of<ChatProvider>(context, listen: false)
        .memberlist!
        .indexWhere((element) => element.account == msg.fromid);

    return memberindex == -1
        ? Container()
        : Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: msg.fromid ==
          Provider.of<ChatProvider>(context, listen: false).account_id
      // 檢查左右 我發出的
          ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 泡泡
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              msg.type == 3
                  ? Container(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                constraints: BoxConstraints(
                  maxWidth:
                  MediaQuery.of(context).size.width * .6,
                ),
                child: Image.asset(
                    '${stickers_list[int.parse(msg.text!)]}'),
              )
                  : Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                //控制泡泡裡面的大小
                //大小
                constraints: BoxConstraints(
                  maxWidth:
                  MediaQuery.of(context).size.width * .6,
                ),
                //泡泡顏色
                decoration: BoxDecoration(
                  color: Color(0xffEAEFF6),
                  // gradient: LinearGradient(
                  //     colors: [Color(0xfffd669a), Color(0xffff836a)]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(text_radius),
                    bottomRight: Radius.circular(text_radius),
                    bottomLeft: Radius.circular(text_radius),
                  ),
                ),
                // 泡泡內容
                // 判斷type
                //type  1 文字 / 2 圖片 / 3 貼圖 / 4 音頻 / 6 通知
                child: msg.type == 1
                    ? Container(child: Text('${msg.text}'))
                    : msg.type == 2
                    ? msg.text != '' && msg.text != null
                    ? GestureDetector(
                  child: Container(
                    child: Image.network(
                        '${msg.text}'),
                  ),
                  onTap: () {
                    print(
                        '${msg.text}//////${msg.note}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                ShowImage(
                                  img: msg
                                      .note!,
                                )));
                  },
                )
                    : Container(
                  child: Text('圖片損毀'),
                )
                // : msg.type == 3
                //     ? Image.asset(
                //         '${stickers_list[int.parse(msg.text!)]}')
                    : msg.type == 4
                    ? Container(
                  child: Column(
                    children: [
                      Text('已傳送錄音'),
                      Padding(
                        padding:
                        EdgeInsets.only(
                            top: 10),
                        child: msg.recordtime ==
                            '' ||
                            msg.recordtime ==
                                null
                            ? Text(
                          '00:00:00 / 00:00:00',
                          style: TextStyle(
                              color: Colors
                                  .transparent),
                        )
                            : Text(
                            '${msg.recordtime} / ${msg.current_play_position}'),
                      ),
                      IconButton(
                          icon: msg.play ==
                              false
                              ? Icon(Icons
                              .play_arrow)
                              : Icon(
                              Icons.pause),
                          onPressed: () {
                            startplay(msg,
                                topicindex);
                          })
                    ],
                  ),
                )
                    : msg.type == 6
                    ? Container(
                  child: Text(
                      '通知:${msg.text}'),
                )
                    : Container(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  //時間
                  msg.time == null
                      ? ''
                      : " ${DateFormat('yyyy/MM/dd  KK:mm a').format(msg.time!)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 5.0,
          ),
          //時間-已讀

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: Provider.of<ChatProvider>(context,
                    listen: false)
                    .remoteUserInfo[0]
                    .avatar_sub !=
                    null &&
                    Provider.of<ChatProvider>(context, listen: false)
                        .remoteUserInfo[0]
                        .avatar_sub !=
                        ''
                    ? NetworkImage(
                    '${Provider.of<ChatProvider>(context, listen: false).remoteUserInfo[0].avatar_sub}')
                    : AssetImage(Provider.of<ChatProvider>(context,
                    listen: false)
                    .remoteUserInfo[0]
                    .sex ==
                    null ||
                    Provider.of<ChatProvider>(context,
                        listen: false)
                        .remoteUserInfo[0]
                        .sex ==
                        '男'
                    ? 'assets/default/sex_man.png'
                    : 'assets/default/sex_woman.png') as ImageProvider,
              ),
              Text(
                '地區',
                style: TextStyle(
                  // color: Color(0xffa6aFa3),
                    color: Colors.transparent,
                    fontSize: 10),
              )
            ],
          ),
        ],
      )
      //  對方 對面
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //頭像
              GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: memberindex != -1 &&
                      Provider.of<ChatProvider>(context, listen: false)
                          .memberlist![memberindex]
                          .avatar_sub !=
                          null &&
                      Provider.of<ChatProvider>(context, listen: false)
                          .memberlist![memberindex]
                          .avatar_sub !=
                          ''
                      ? NetworkImage(
                      '${Provider.of<ChatProvider>(context, listen: false).memberlist![memberindex].avatar_sub}')
                      : AssetImage(Provider.of<ChatProvider>(
                      context,
                      listen: false)
                      .memberlist![memberindex]
                      .sex ==
                      null ||
                      Provider.of<ChatProvider>(context,
                          listen: false)
                          .memberlist![memberindex]
                          .sex ==
                          '男'
                      ? 'assets/default/sex_man.png'
                      : 'assets/default/sex_woman.png')
                  as ImageProvider,
                ),
                onTap: () {
                  //私聊簡易泡泡
                  // 改掉
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherProfilePage(
                            chatroomid:
                            Provider.of<ChatProvider>(
                                context,
                                listen: false)
                                .memberlist![memberindex]
                                .memberid,
                          )));
                },
              ),
              Text(
                '地區',
                style: TextStyle(
                  // color: Color(0xffa6aFa3),
                    color: Colors.transparent,
                    fontSize: 10),
              )
            ],
          ),
          // 泡泡
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${msg.fromid} '),
                ),
                msg.type == 3
                    ? Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  constraints: BoxConstraints(
                    maxWidth:
                    MediaQuery.of(context).size.width *
                        .6,
                  ),
                  child: Image.asset(
                      '${stickers_list[int.parse(msg.text!)]}'),
                )
                    : Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  //控制泡泡裡面的大小
                  //大小
                  constraints: BoxConstraints(
                    maxWidth:
                    MediaQuery.of(context).size.width *
                        .6,
                  ),
                  //泡泡顏色
                  decoration: BoxDecoration(
                    color: Color(0xffEAEFF6),
                    // gradient: LinearGradient(
                    //     colors: [Color(0xfffd669a), Color(0xffff836a)]),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(text_radius),
                      bottomRight:
                      Radius.circular(text_radius),
                      bottomLeft:
                      Radius.circular(text_radius),
                    ),
                  ),
                  // 泡泡內容
                  // 判斷type
                  //type  1 文字 / 2 圖片 / 3 貼圖 / 4 音頻 / 6 通知
                  child: msg.type == 1
                      ? Container(child: Text('${msg.text}'))
                      : msg.type == 2
                      ? msg.text != '' && msg.text != null
                      ? GestureDetector(
                    child: Container(
                      child: Image.network(
                          '${msg.text}'),
                    ),
                    onTap: () {
                      print(
                          '${msg.text}//////${msg.note}');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:
                                  (context) =>
                                  ShowImage(
                                    img: msg
                                        .note!,
                                  )));
                    },
                  )
                      : Container(
                    child: Text('圖片損毀'),
                  )
                  // : msg.type == 3
                  //     ? Image.asset(
                  //         '${stickers_list[int.parse(msg.text!)]}')
                      : msg.type == 4
                      ? Container(
                    child: Column(
                      children: [
                        Text('已傳送錄音'),
                        Padding(
                          padding:
                          EdgeInsets.only(
                              top: 10),
                          child: msg.recordtime ==
                              '' ||
                              msg.recordtime ==
                                  null
                              ? Text(
                            '00:00:00 / 00:00:00',
                            style: TextStyle(
                                color: Colors
                                    .transparent),
                          )
                              : Text(
                              '${msg.recordtime} / ${msg.current_play_position}'),
                        ),
                        IconButton(
                            icon: msg.play ==
                                false
                                ? Icon(Icons
                                .play_arrow)
                                : Icon(Icons
                                .pause),
                            onPressed: () {
                              startplay(msg,
                                  topicindex);
                            })
                      ],
                    ),
                  )
                      : msg.type == 6
                      ? Container(
                    child: Text(
                        '通知:${msg.text}'),
                  )
                      : Container(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    //時間
                    msg.time == null
                        ? ''
                        : " ${DateFormat('yyyy/MM/dd  KK:mm a').format(msg.time!)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //下方錄音 區塊 自動開關
  void audioautoopen() {
    stickerbuttonclose();
    if (bottomrecordheight > 0) {
      audiobuttonclose();
    } else {
      audiobuttonopen();
    }
  }

  //下方貼圖 區塊 自動開關
  void stickerautoopen() {
    if (bottomstickerheight > 0) {
      stickerbuttonclose();
    } else {
      stickerbuttonopen();
    }
  }

  void audiobuttonopen() {
    stickerbuttonclose();
    if (_focus.hasFocus) {
      _focus.unfocus();
    }
    setState(() {
      bottomrecordheight = 300;
      insetopen = true;
    });
  }

  void audiobuttonclose() {
    _audioRecorder.stopRecorder();
    setState(() {
      bottomrecordheight = 0;
      recorderTxt = '未開始錄音';
      insetopen = false;
    });
  }

  void stickerbuttonopen() {
    audiobuttonclose();
    if (_focus.hasFocus) {
      _focus.unfocus();
    }
    setState(() {
      bottomstickerheight = 300;
      audiobuttonclose();
      insetopen = true;
    });
  }

  void stickerbuttonclose() {
    setState(() {
      bottomstickerheight = 0;
      insetopen = false;
    });
  }

  Future initdata() async {
    Provider.of<ChatProvider>(context, listen: false)
        .mqttlistener(widget.chatroomid.toHexString(), 'ime_group_chat');
    //獲得 歷史紀錄
    await Provider.of<ChatProvider>(context, listen: false)
        .gethismsg(widget.chatroomid)
        .whenComplete(() => topicindex =
        Provider.of<ChatProvider>(context, listen: false)
            .msglist
            ?.indexWhere((element) =>
        element.topicid == widget.chatroomid.toHexString()));
    //要等 不然資料流會亂跑
    await Provider.of<ChatProvider>(context, listen: false)
        .getchatroommember(widget.chatroomid);
  }

  Future initmic() async {
    try {
      print('初始打開麥克風s');
      var status = await Permission.microphone.request();
      // print('444444');
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('麥克風權限沒開');
      }
      // print('111s1111');
      _audioRecorder = FlutterSoundRecorder();
      // await _audioRecorder.openRecorder().then((value) {
      //   setState(() {
      //     _mRecorderIsInited = true;
      //   });
      // });
      await _audioRecorder.openAudioSession().then((value) {
        setState(() {
          _mRecorderIsInited = true;
        });
      });
      print('初始打開麥克風3');
    } catch (e) {
      print('open recorder exception $e');
    }
  }

  Future initplayer() async {
    _audioPlayer = FlutterSoundPlayer();
    // await _audioPlayer.openPlayer();
    await _audioPlayer.openAudioSession();
  }

  Future startmic() async {
    // var fileName = "44";
    var fileName = Uuid().v1().toString() + ".aac";
    try {
      if (_mRecorderIsInited == true) {
        await _audioRecorder
            .startRecorder(
          toFile: fileName,
        )
            .then((value) {
          _audioRecorder.setSubscriptionDuration(Duration(microseconds: 50000));
          _audioRecorder.onProgress!.listen((event) {
            var date = DateTime.fromMillisecondsSinceEpoch(
                event.duration.inMilliseconds,
                isUtc: true);
            var txt = DateFormat('mm:ss:SS').format(date);
            setState(() {
              recorderTxt = txt.substring(0, 8);
              recordtime = date;
            });
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("start record exception:$e 請檢查麥克風權限是否有開啟"),
        duration: Duration(milliseconds: 800),
      ));
      print('start record exception::$e');
      setState(() {
        myrecord = recordState.notrecord;
      });
    }
  }

  Future startplay(msg, memberindex) async {
    print('點擊一下');
    Provider.of<ChatProvider>(context, listen: false).playaudiomsg(msg);
    try {
      if (_audioPlayer.isPlaying) {
        //為了不重複播放 先把全部都停止
        await _audioPlayer.stopPlayer();
        print('正在播放中 所以停止${memberindex}');
        Provider.of<ChatProvider>(context, listen: false)
            .allplayaudiostop(memberindex);
        _playerSubscription.cancel();
      } else {
        await _audioPlayer
            .startPlayer(
            fromURI: msg.text,
            whenFinished: () {
              Provider.of<ChatProvider>(context, listen: false)
                  .playaudiomsg(msg);
              _playerSubscription.cancel();
            })
            .then((value) {
          _audioPlayer.setSubscriptionDuration(Duration(microseconds: 50000));
          _playerSubscription = _audioPlayer.onProgress!.listen((event) {
            Duration currentPosition = event.position;
            Duration maxDuration = event.duration;
            Provider.of<ChatProvider>(context, listen: false)
                .showaudiotime(msg, _printDuration(currentPosition));
            Provider.of<ChatProvider>(context, listen: false)
                .loadaudio_alltime(msg, _printDuration(maxDuration));
            // Provider.of<ChatProvider>(context, listen: false)
            //     .showaudiotime(msg, maxDuration.toString());
          });
          // Provider.of<ChatProvider>(context, listen: false)
          //     .showaudiotime(msg, DateTime.now().toString());
        });
      }
    } catch (e) {
      print("msg play exception $e");
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  var recordpath;

  Future stopmic(topic) async {
    try {
      recordpath = await _audioRecorder.stopRecorder();
      print('錄音暫存在手機上 path::$recordpath');
      if (recordtime.second < 1) {
        Future.delayed(Duration(microseconds: 6000), () {
          setState(() {
            recorderTxt = '時間太短請重新錄製';
            myrecord = recordState.notrecord;
          });
        });
      } else {
        setState(() {
          myrecord = recordState.recordnotsend;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("stop record exception:$e"),
        duration: Duration(milliseconds: 1500),
      ));

      print('stop record exception $e');
    }
  }

  Future send_record_to_mqtt(topic) async {
    print('點擊傳送錄音 $recordpath');
    if (recordpath != null) {
      setState(() {
        myrecord = recordState.waiting;
      });
      await Provider.of<ChatProvider>(context, listen: false)
          .groupsendrecord(topic, recordpath, 'ime_group_chat')
          .whenComplete(() => setState(() {
        myrecord = recordState.notrecord;
      }));
      audioautoopen();
    }
  }
}

