import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:ime_new/business_logic/model/mqtt_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/otherpage/other_profile_page.dart';
import 'package:ime_new/ui/widget/showimage.dart';
import 'package:ime_new/utils/sticker_address.dart';
import 'package:ime_new/utils/viewconfig.dart';

import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';

enum recordState {
  notrecord,
  recording,
  waiting,
  recordnotsend,
}

class O2OChatroom extends StatefulWidget {
  O2OChatroom(
      {Key? key,
      required this.chatroomid,
      required this.memberid,
      this.nickname,
      this.avatar,
      this.fcmtoken})
      : super(key: key);

  final chatroomid;
  final memberid;
  final nickname;
  final avatar;
  final fcmtoken;

  /// 1 揪團 2約會 3私聊

  @override
  _O2OChatroomState createState() => _O2OChatroomState();
}

class _O2OChatroomState extends State<O2OChatroom> {
  late TextEditingController _textController;
  final FocusNode _focus = FocusNode();
  Directory? rootPath;
  ScrollController scrollController = ScrollController();

  ///錄音
  late FlutterSoundRecorder _audioRecorder;
  late FlutterSoundPlayer _audioPlayer;
  bool _mRecorderIsInited = false;
  bool startplayaudio = false;
  String recorderTxt = '未開始錄音';
  String playerTxt = '未開始播放';
  DateTime recordtime = DateTime.now();
  DateTime playertime = DateTime.now();

  double bottomrecordheight = 0;
  double bottomstickerheight = 0;

  // double bottominsetheight = 70;
  bool insetopen = false;
  recordState myrecord = recordState.notrecord;
  int? topicindex = -1;
  bool iconopen = false;

  late CustomPopupMenuController _controller;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // String fcmtoken = 'cZfAETdEQJWmG9gE-GQqne:APA91bESE-nD2QdBsBMgDCMXLhoLKUMXqu47tR68rOoQJwFyCfnVpQSAdq2o06ihCAKLMx3huN-poIG3aZQQb_javEtaZ-P6Hf8C3eOpdUyi0XaRJ0VQ0L7EBZZZKaiL5uetE9h7EBlC';
  // String fcmtoken =
  //     'ewIzEkGmTUYElPcxgF8syr:APA91bFot-nG03NJ2q6zDwcieyr8w1XVBdiVYoZc4Gos-qSoKKq-k6zA6R7hHBA8nZ5KnCT3RgWXb2qW83d2C2GzWId1zK5Cm4VDPUsja9ylofRnO05pJftv4dH_vDL9OyiZP92NYF12';

  @override
  void initState() {
    _textController = TextEditingController();
    _controller = CustomPopupMenuController();
    initdata();
    _focus.addListener(_onFocusChange);
    initmic();
    initplayer();

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    // _audioRecorder.closeRecorder();
    _audioRecorder.closeAudioSession();
    _audioPlayer.closeAudioSession();
    // _audioPlayer.closePlayer();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
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
                gradient: LinearGradient(colors: colorlist[2]),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 拿來對齊 出去
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        if (topicindex != -1) {
                          Provider.of<ChatProvider>(context, listen: false)
                              .o2o_msglist![topicindex!]
                              .msg = [];
                        }
                        Provider.of<ChatProvider>(context, listen: false)
                            .geto2ochatroomlist();
                        Provider.of<ChatProvider>(context, listen: false)
                            .change_redpoint(1);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  //標題
                  Center(
                      child: Text(
                    // '聊天對象',
                    ' ${widget.nickname} ',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  )),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Consumer<ChatProvider>(
                        builder: (context, value, child) {
                      return CustomPopupMenu(
                        child: Icon(Icons.more_vert, color: Colors.white),
                        menuBuilder: () => ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                color: Colors.white,
                                child: IntrinsicWidth(
                                    child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .addblocklog(widget.chatroomid);
                                    _controller.hideMenu();
                                    //整理私訊
                                    Provider.of<ChatProvider>(context,
                                            listen: false)
                                        .geto2ochatroomlist();
                                    setState(() {
                                      iconopen = false;
                                    });
                                  },
                                  child: Container(
                                    width: 150,
                                    margin: EdgeInsets.all(20),
                                    child: Text(
                                      value.myblocklog != null
                                          ? value.myblocklog[0].list_id == null
                                              ? "加入黑名單"
                                              : value.myblocklog[0].list_id
                                                          .indexWhere((element) =>
                                                              element ==
                                                              widget
                                                                  .chatroomid) !=
                                                      -1
                                                  ? '解除黑名單'
                                                  : "加入黑名單"
                                          : "加入黑名單",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                )),
                              ),
                              // Container(
                              //   width: 150,
                              //   color: Colors.grey,
                              //   height: 1,
                              // ),
                              // Container(
                              //   color: Colors.white,
                              //   child: IntrinsicWidth(
                              //       child: GestureDetector(
                              //         behavior: HitTestBehavior
                              //             .translucent,
                              //         onTap: () {},
                              //         child: Container(
                              //           width: 150,
                              //           margin: EdgeInsets.all(20),
                              //           child: Text(
                              //             "查看資訊",
                              //             style: TextStyle(
                              //                 fontSize: 15),
                              //           ),
                              //         ),
                              //       )),
                              // ),
                            ],
                          ),
                        ),
                        pressType: PressType.singleClick,
                        verticalMargin: -10,
                        controller: _controller,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          body: GestureDetector(
            child: Stack(
              children: [
                Consumer<ChatProvider>(
                  builder: (context, value, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //對話紀錄
                        Expanded(
                            child: topicindex == -1
                                ? value.o2ohistorymsg != null
                                    ? value.o2ohistorymsg!.isEmpty
                                        ? Center(
                                            child: Container(
                                              child: Text('此聊天室沒有聊天記錄05'),
                                            ),
                                          )
                                        : SmartRefresher(
                                            enablePullDown: false,
                                            enablePullUp: true,
                                            controller: _refreshController,
                                            header: WaterDropMaterialHeader(
                                                backgroundColor:
                                                    Color(0xffaCEA00)),
                                            onLoading: _onLoading,
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                int correctindex;
                                                correctindex = index;
                                                return bubble(
                                                  value.o2ohistorymsg![
                                                      correctindex],
                                                );
                                              },
                                              reverse: true,
                                              itemCount: value.o2ohistorymsg !=
                                                      null
                                                  ? value.o2ohistorymsg!.isEmpty
                                                      ? 1
                                                      : value
                                                          .o2ohistorymsg!.length
                                                  : 1,
                                              controller: scrollController,
                                            ),
                                          )
                                    : Center(
                                        child: Container(
                                          child: Text('無聊天記錄'),
                                        ),
                                      )
                                : value.o2ohistorymsg != null
                                    ? value.o2ohistorymsg!.isEmpty &&
                                            value.o2o_msglist![topicindex!].msg!
                                                .isEmpty
                                        ? Center(
                                            child: Container(
                                              child: Text('此聊天室沒有聊天記錄04'),
                                            ),
                                          )
                                        : Container(
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                int correctindex;
                                                if (value.o2ohistorymsg!
                                                    .isNotEmpty) {
                                                  //歷史訊息回傳[xx]-有歷史
                                                  if (topicindex == -1) {
                                                    //沒當前 -純歷史
                                                    correctindex = index;
                                                    return bubble(
                                                      value.o2ohistorymsg![
                                                          correctindex],
                                                    );
                                                  } else {
                                                    // 是當前聊天室收到當前訊息 歷史+當前
                                                    correctindex = index <
                                                            value
                                                                .o2o_msglist![
                                                                    topicindex!]
                                                                .msg!
                                                                .length
                                                        ? index
                                                        : index -
                                                            value
                                                                .o2o_msglist![
                                                                    topicindex!]
                                                                .msg!
                                                                .length;

                                                    return index <
                                                            value
                                                                .o2o_msglist![
                                                                    topicindex!]
                                                                .msg!
                                                                .length
                                                        ? bubble(
                                                            value
                                                                .o2o_msglist![
                                                                    topicindex!]
                                                                .msg![correctindex],
                                                          )
                                                        : index ==
                                                                value
                                                                    .o2o_msglist![
                                                                        topicindex!]
                                                                    .msg!
                                                                    .length
                                                            ? Column(
                                                                children: [
                                                                  bubble(
                                                                    value.o2ohistorymsg![
                                                                        correctindex],
                                                                  ),
                                                                  Container(
                                                                    child: Text(
                                                                        '---以上為歷史紀錄---'),
                                                                  ),
                                                                ],
                                                              )
                                                            : bubble(
                                                                value.o2ohistorymsg![
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
                                                      .o2o_msglist![topicindex!]
                                                      .msg!
                                                      .isEmpty) {
                                                    // 沒歷史 沒當前
                                                    // 收到當前聊天室訊息
                                                    return Center(
                                                      child: Container(
                                                        child:
                                                            Text('此聊天室沒有聊天記錄'),
                                                      ),
                                                    );
                                                  } else {
                                                    // 沒歷史 有當前
                                                    correctindex = index <
                                                            value
                                                                .o2o_msglist![
                                                                    topicindex!]
                                                                .msg!
                                                                .length
                                                        ? index
                                                        : index -
                                                            value
                                                                .o2o_msglist![
                                                                    topicindex!]
                                                                .msg!
                                                                .length;

                                                    return bubble(
                                                      value
                                                          .o2o_msglist![
                                                              topicindex!]
                                                          .msg![correctindex],
                                                    );
                                                  }
                                                }
                                              },
                                              reverse: true,
                                              itemCount: value.o2ohistorymsg !=
                                                      null
                                                  ? value.o2ohistorymsg!.isEmpty
                                                      ? value
                                                              .o2o_msglist![
                                                                  topicindex!]
                                                              .msg!
                                                              .isEmpty
                                                          ? 1
                                                          : value
                                                              .o2o_msglist![
                                                                  topicindex!]
                                                              .msg!
                                                              .length
                                                      : value
                                                              .o2o_msglist![
                                                                  topicindex!]
                                                              .msg!
                                                              .isEmpty
                                                          ? value.o2ohistorymsg!
                                                              .length
                                                          : value
                                                                  .o2o_msglist![
                                                                      topicindex!]
                                                                  .msg!
                                                                  .length +
                                                              value
                                                                  .o2ohistorymsg!
                                                                  .length
                                                  : value
                                                          .o2o_msglist![
                                                              topicindex!]
                                                          .msg!
                                                          .isEmpty
                                                      ? 1
                                                      : value
                                                          .o2o_msglist![
                                                              topicindex!]
                                                          .msg!
                                                          .length,
                                              controller: scrollController,
                                            ),
                                          )
                                    : Center(
                                        child: Container(
                                          child: Text('歷史訊息加載中'),
                                        ),
                                      )),

                        value.myblocklog[0].list_id.indexWhere((element) =>
                                    element == widget.chatroomid) !=
                                -1
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Color(0xffb9b9b9),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.transparent,
                                        ),
                                        onPressed: () {},
                                      ),
                                      Text('已經加入黑名單'),
                                      IconButton(
                                        icon: Icon(Icons.add,
                                            color: Colors.transparent),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : bottomEnter(),
                        value.myblocklog[0].list_id.indexWhere((element) =>
                                    element == widget.chatroomid) !=
                                -1
                            ? Container()
                            : bottomRecord(),
                        value.myblocklog[0].list_id.indexWhere((element) =>
                                    element == widget.chatroomid) !=
                                -1
                            ? Container()
                            : bottomsticker()
                      ],
                    );
                  },
                ),
                //輸入框的那一排
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
                                            .sendimg_o2o(
                                          widget.chatroomid,
                                          'ime_o2o_chat',
                                          Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .remoteUserInfo[0]
                                              .memberid,
                                          widget.nickname,
                                          widget.avatar,
                                          widget.fcmtoken,
                                        );

                                        setState(() {
                                          topicindex =
                                              Provider.of<ChatProvider>(context,
                                                      listen: false)
                                                  .o2o_msglist
                                                  ?.indexWhere((element) =>
                                                      element.memberid ==
                                                      widget.chatroomid);
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      onPressed: () async {
                                        await Provider.of<ChatProvider>(context,
                                                listen: false)
                                            .sendimgwithcamera_o2o(
                                                widget.chatroomid,
                                                'ime_o2o_chat',
                                                Provider.of<ChatProvider>(
                                                        context,
                                                        listen: false)
                                                    .remoteUserInfo[0]
                                                    .memberid,
                                                widget.nickname,
                                                widget.avatar,
                                                widget.fcmtoken);

                                        setState(() {
                                          topicindex =
                                              Provider.of<ChatProvider>(context,
                                                      listen: false)
                                                  .o2o_msglist
                                                  ?.indexWhere((element) =>
                                                      element.memberid ==
                                                      widget.chatroomid);
                                        });
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
        if (topicindex != -1) {
          //當前mqtt收到的msg清除 -紅點消除
          Provider.of<ChatProvider>(context, listen: false)
              .o2o_msglist![topicindex!]
              .msg = [];
        }
        Provider.of<ChatProvider>(context, listen: false).geto2ochatroomlist();
        Provider.of<ChatProvider>(context, listen: false).change_redpoint(1);
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
        .add_o2o_his_page(mongo.ObjectId.fromHexString(widget.chatroomid));
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
      //傳送照片 圖片 選擇 picker
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
          // Padding(
          //   padding: const EdgeInsets.only(left: 5),
          //   child: IconButton(
          //     icon: Icon(Icons.photo),
          //     onPressed: () async {
          //       await Provider.of<ChatProvider>(context, listen: false)
          //           .sendimg_o2o(
          //               widget.chatroomid,
          //               'ime_o2o_chat',
          //               Provider.of<ChatProvider>(context, listen: false)
          //                   .remoteUserInfo[0]
          //                   .memberid,
          //               widget.nickname,
          //               widget.avatar);
          //
          //       setState(() {
          //         topicindex = Provider.of<ChatProvider>(context, listen: false)
          //             .o2o_msglist
          //             ?.indexWhere(
          //                 (element) => element.memberid == widget.chatroomid);
          //       });
          //     },
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 5),
          //   child: IconButton(
          //     icon: Icon(Icons.camera_alt),
          //     onPressed: () async {
          //       await Provider.of<ChatProvider>(context, listen: false)
          //           .sendimgwithcamera_o2o(
          //               widget.chatroomid,
          //               'ime_o2o_chat',
          //               Provider.of<ChatProvider>(context, listen: false)
          //                   .remoteUserInfo[0]
          //                   .memberid,
          //               widget.nickname,
          //               widget.avatar);
          //
          //       setState(() {
          //         topicindex = Provider.of<ChatProvider>(context, listen: false)
          //             .o2o_msglist
          //             ?.indexWhere(
          //                 (element) => element.memberid == widget.chatroomid);
          //       });
          //     },
          //   ),
          // ),
          // //打開下方錄音按鈕
          // Padding(
          //     padding: const EdgeInsets.only(right: 5),
          //     child: IconButton(
          //       icon: Icon(Icons.mic),
          //       onPressed: () {
          //         autoopen();
          //       },
          //     )),
          Flexible(
            child: Stack(
              children: [
                Container(
                    constraints:
                        BoxConstraints(minHeight: 60.0, maxHeight: 150.0),
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
                              .o2ochat(
                            _textController.text,
                            mongo.ObjectId.fromHexString(widget.chatroomid),
                            widget.memberid,
                            1,
                            Provider.of<ChatProvider>(context, listen: false)
                                .remoteUserInfo[0]
                                .memberid,
                            widget.nickname,
                            widget.avatar,
                            widget.fcmtoken,
                          );

                          _textController.clear();
                        }
                        FocusScope.of(context).unfocus();
                        print(
                            'rrrrrrrr ${Provider.of<ChatProvider>(context, listen: false).o2o_msglist?.indexWhere((element) => element.memberid == widget.chatroomid)}');
                        setState(() {
                          topicindex =
                              Provider.of<ChatProvider>(context, listen: false)
                                  .o2o_msglist
                                  ?.indexWhere((element) =>
                                      element.memberid == widget.chatroomid);
                        });
                      },

                      controller: _textController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: '輸入想說的話',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5)),
                      style: TextStyle(height: 1),
                    )),
              ],
            ),
          ),
          //傳送 發送 文字 箭頭 送出
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              child: Icon(Icons.send),
              onTap: () async {
                if (_textController.text != '') {
                  ///先關起來
                  await Provider.of<ChatProvider>(context, listen: false)
                      .o2ochat(
                          _textController.text,
                          mongo.ObjectId.fromHexString(widget.chatroomid),
                          widget.memberid,
                          1,
                          Provider.of<ChatProvider>(context, listen: false)
                              .remoteUserInfo[0]
                              .memberid,
                          widget.nickname,
                          widget.avatar,
                          widget.fcmtoken);

                  _textController.clear();
                  setState(() {
                    topicindex = Provider.of<ChatProvider>(context,
                            listen: false)
                        .o2o_msglist
                        ?.indexWhere(
                            (element) => element.memberid == widget.chatroomid);
                  });
                }
                FocusScope.of(context).unfocus();
              },
            ),
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
                                              BorderRadius.circular(8.0))),
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
                                  onPressed: () async {
                                    //傳送錄音
                                    await send_record_to_mqtt(
                                        widget.chatroomid);
                                    setState(() {
                                      topicindex = Provider.of<ChatProvider>(
                                              context,
                                              listen: false)
                                          .o2o_msglist
                                          ?.indexWhere((element) =>
                                              element.memberid ==
                                              widget.chatroomid);
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
                      Provider.of<ChatProvider>(context, listen: false).o2ochat(
                        index.toString(),
                        mongo.ObjectId.fromHexString(widget.chatroomid),
                        widget.memberid,
                        3,
                        Provider.of<ChatProvider>(context, listen: false)
                            .remoteUserInfo[0]
                            .memberid,
                        widget.nickname,
                        widget.avatar,
                        widget.fcmtoken,
                      );
                      //改變 純歷史訊息 到 歷史+當前 狀態
                      setState(() {
                        topicindex =
                            Provider.of<ChatProvider>(context, listen: false)
                                .o2o_msglist
                                ?.indexWhere((element) =>
                                    element.memberid == widget.chatroomid);
                      });
                    },
                  );
                },
                itemCount: stickers_list.length,
              )),
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

  Widget bubble(
    MqttMsg msg,
  ) {
    //type  1 文字 / 2 圖片 / 3 貼圖 / 4 音頻 / 6 通知
    double text_radius = 20.0;
    // type檢查樣式
    var memberindex = Provider.of<ChatProvider>(context, listen: false)
        .o2omemberlist!
        .indexWhere((element) => element.account == msg.fromid);
    return Container(
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
                              maxWidth: MediaQuery.of(context).size.width * .6,
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
                              maxWidth: MediaQuery.of(context).size.width * .6,
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
                            child: msg.type == 1
                                ? Container(child: Text('${msg.text}'))
                                : msg.type == 2
                                    ? GestureDetector(
                                        child: Container(
                                          child: Image.network('${msg.text}'),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowImage(
                                                        img: msg.text!,
                                                      )));
                                        },
                                      )
                                    // : msg.type == 3
                                    // ? Image.asset(
                                    // '${stickers_list[int.parse(msg.text!)]}')
                                    : msg.type == 4
                                        ? Container(
                                            child: Column(
                                              children: [
                                                Text('已傳送錄音'),
                                                IconButton(
                                                    icon: msg.play == false
                                                        ? Icon(Icons.play_arrow)
                                                        : Icon(Icons.pause),
                                                    onPressed: () {
                                                      startplay(msg);
                                                    })
                                              ],
                                            ),
                                          )
                                        : msg.type == 6
                                            ? Container(
                                                child: Text('通知:${msg.text}'),
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
                // //時間-已讀
                // Container(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Container(
                //         height: 5,
                //       ),
                //       // Text(
                //       //   //時間
                //       //   message.sendtime == null
                //       //       ? ''
                //       //       : formatTime(message.sendtime.toLocal().hour) +
                //       //           ':' +
                //       //           formatTime(message.sendtime.toLocal().minute),
                //       //   style: TextStyle(
                //       //     color: Colors.white,
                //       //     fontSize: 12,
                //       //   ),
                //       // ),
                //       Container(
                //         height: 5,
                //       ),
                //     ],
                //   ),
                // ),
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
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: memberindex != -1 &&
                                Provider.of<ChatProvider>(context, listen: false)
                                        .o2omemberlist![memberindex]
                                        .avatar_sub !=
                                    null &&
                                Provider.of<ChatProvider>(context, listen: false)
                                        .o2omemberlist![memberindex]
                                        .avatar_sub !=
                                    ''
                            ? NetworkImage(
                                Provider.of<ChatProvider>(context, listen: false)
                                    .o2omemberlist![memberindex]
                                    .avatar_sub)
                            : AssetImage(Provider.of<ChatProvider>(context, listen: false)
                                            .o2omemberlist![memberindex]
                                            .sex ==
                                        null ||
                                    Provider.of<ChatProvider>(context, listen: false)
                                            .o2omemberlist![memberindex]
                                            .sex ==
                                        '男'
                                ? 'assets/default/sex_man.png'
                                : 'assets/default/sex_woman.png') as ImageProvider,
                      ),
                      onTap: () {
                        if (Provider.of<ChatProvider>(context, listen: false)
                                .o2omemberlist![memberindex]
                                .account !=
                            Provider.of<ChatProvider>(context, listen: false)
                                .remoteUserInfo[0]
                                .account) {
                          //成員橫排 點 單一頭像
                          // 改成先進簡介
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherProfilePage(
                                        chatroomid: Provider.of<ChatProvider>(
                                                context,
                                                listen: false)
                                            .o2omemberlist![memberindex]
                                            .memberid,
                                      )));
                        } else {
                          print('同一人');
                        }
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
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 4),
                      //   child: Text('${msg.from}'),
                      // ),
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
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * .6,
                              ),
                              //泡泡顏色
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(text_radius),
                                  topRight: Radius.circular(text_radius),
                                  bottomRight: Radius.circular(text_radius),
                                ),
                              ),
                              // 泡泡內容
                              // 判斷type
                              child: msg.type == 1
                                  ? Container(child: Text('${msg.text}'))
                                  : msg.type == 2
                                      ? GestureDetector(
                                          child: Container(
                                            child: Image.network('${msg.text}'),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowImage(
                                                          img: msg.text!,
                                                        )));
                                          },
                                        )
                                      // : msg.type == 3
                                      // ? Image.asset(
                                      // '${stickers_list[int.parse(msg.text!)]}')
                                      : msg.type == 4
                                          ? Container(
                                              child: Column(
                                                children: [
                                                  Text('已收到錄音'),
                                                  IconButton(
                                                      icon: msg.play == false
                                                          ? Icon(
                                                              Icons.play_arrow)
                                                          : Icon(Icons.pause),
                                                      onPressed: () {
                                                        startplay(msg);
                                                      })
                                                ],
                                              ),
                                            )
                                          : msg.type == 6
                                              ? Container(
                                                  child: Text('通知'),
                                                )
                                              : Container(),
                              // child: SelectableText(
                              //   message.text, //訊息
                              //   style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 16.0,
                              //       fontWeight: FontWeight.w600,
                              //       height: 1.2),
                              //   showCursor: true,
                              // ),
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

  //下方貼圖 區塊 自動開關
  void autoopen() {
    if (bottomrecordheight > 0) {
      audiobuttonclose();
    } else {
      audiobuttonopen();
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
    // await Provider.of<ChatProvider>(context, listen: false)
    //     .geto2ochatroomlist();
    // Provider.of<ChatProvider>(context, listen: false)
    //     .o2ofindindex(widget.chatroomid);
    // //獲得 歷史紀錄
    await Provider.of<ChatProvider>(context, listen: false)
        .geto2ohismsg(mongo.ObjectId.fromHexString(widget.chatroomid))
        .whenComplete(() {
      print(
          'o2o chatroom init 印出${Provider.of<ChatProvider>(context, listen: false).o2o_msglist}');
      topicindex = Provider.of<ChatProvider>(context, listen: false)
          .o2o_msglist
          ?.indexWhere((element) => element.memberid == widget.chatroomid);
    });
    //要求對方的member 資料
    await Provider.of<ChatProvider>(context, listen: false)
        .getmemberinfo(widget.chatroomid);
    if (topicindex == -1 &&
        Provider.of<ChatProvider>(context, listen: false).o2ohistorymsg !=
            null &&
        Provider.of<ChatProvider>(context, listen: false)
            .o2ohistorymsg!
            .isEmpty) {
      //05 狀況
      _textController.text = Provider.of<ChatProvider>(context, listen: false)
          .remoteUserInfo[0]
          .default_chat_text;
    } else if (topicindex != -1 &&
        Provider.of<ChatProvider>(context, listen: false).o2ohistorymsg !=
            null &&
        Provider.of<ChatProvider>(context, listen: false)
            .o2ohistorymsg!
            .isEmpty &&
        Provider.of<ChatProvider>(context, listen: false)
            .o2o_msglist![topicindex!]
            .msg!
            .isEmpty) {
      //04 狀況
      _textController.text = Provider.of<ChatProvider>(context, listen: false)
          .remoteUserInfo[0]
          .default_chat_text;
    }
  }

  Future initmic() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('麥克風權限沒開');
      }
      _audioRecorder = FlutterSoundRecorder();
      print('初始麥克風');
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
    } catch (e) {
      print('open recorder exception $e');
    }
  }

  Future initplayer() async {
    _audioPlayer = FlutterSoundPlayer();
    await _audioPlayer.openAudioSession();
    // await _audioPlayer.openPlayer();
  }

  Future startmic() async {
    print('openopen');
    // var fileName = "44";
    var fileName = Uuid().v1().toString() + ".aac";
    try {
      if (_mRecorderIsInited == true) {
        await _audioRecorder
            .startRecorder(
          toFile: fileName,
        )
            .then((value) {
          _audioRecorder.setSubscriptionDuration(Duration(microseconds: 5000));
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
        content: Text("start record exception:$e"),
        duration: Duration(milliseconds: 1500),
      ));
      print('start record exception::$e');
      setState(() {
        myrecord = recordState.notrecord;
      });
    }
  }

  Future startplay(msg) async {
    Provider.of<ChatProvider>(context, listen: false).playaudiomsg(msg);
    try {
      if (_audioPlayer.isPlaying) {
        await _audioPlayer.stopPlayer();
      } else {
        await _audioPlayer.startPlayer(
            fromURI: msg.text,
            whenFinished: () {
              Provider.of<ChatProvider>(context, listen: false)
                  .playaudiomsg(msg);
            });
      }
    } catch (e) {
      print("msg play exception $e");
    }
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
        duration: Duration(milliseconds: 1000),
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
          .o2osendrecord(
            mongo.ObjectId.fromHexString(topic),
            recordpath,
            'ime_o2o_chat',
            widget.memberid,
            Provider.of<ChatProvider>(context, listen: false)
                .remoteUserInfo[0]
                .memberid,
            widget.nickname,
            widget.avatar,
            widget.fcmtoken,
          )
          .whenComplete(() => setState(() {
                myrecord = recordState.notrecord;
              }));
      autoopen();
    }
  }
}
