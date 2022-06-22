import 'dart:async';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_rawdata/agora_rtc_rawdata.dart';
import 'package:faceunity_ui/Faceunity_ui.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/sweetProvider.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';

int myRoomSeatIndex = 0;
String T_D_player = "";
const appId = '27e69b885f864b0da5a75265e8c96cdb';

class sweetView extends StatefulWidget {
  const sweetView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<sweetView> createState() => _theRoomState();
}

class _theRoomState extends State<sweetView> with TickerProviderStateMixin {
  String msg = "";
  AnimationController? _controller;
  RtcEngine? engine;
  bool isJoined = false;
  bool isSelfMute = false;
  bool isSelfHide = false;
  bool moreView = false;
  List<int> remoteUid = [];
  final _gridViewKey = GlobalKey();
  final TextEditingController _chatController = new TextEditingController();
  final List<Widget> _message = [];
  Size? _gridViewSize;
  void getSize() {
    setState(() {
      _gridViewSize = _gridViewKey.currentContext!.size;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // myUid = getUid();
    // MqttListen().resetSeats();
    Future(() async {
      // myAgoraUid = getUid();
      myAgoraUid = myUid;
    });

    client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);

    this._initEngine();
  }

  @override
  void deactivate() {
    engine!.muteAllRemoteVideoStreams(true);
    engine!.muteAllRemoteAudioStreams(true);
    engine!.disableVideo();
    engine!.leaveChannel();
    this._deinitEngine();

    client.subscribe("imeSweetRoom/info", MqttQos.atLeastOnce);

    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    // this._deinitEngine();
  }

  _initEngine() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
    engine = await RtcEngine.create(appId);
    engine!.setRemoteDefaultVideoStreamType(VideoStreamType.High);
    // engine!.enableDualStreamMode(true);
    engine!.disableVideo();
    engine!.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      log('joinChannelSuccess $channel $uid $elapsed');
      setState(() {
        isJoined = true;
      });
    }, userJoined: (uid, elapsed) {
      log('userJoined  $uid $elapsed');
      setState(() {
        remoteUid.add(uid);
        engine!.muteAllRemoteVideoStreams(false);
      });
    }, userOffline: (uid, reason) {
      log('userJoined  $uid $reason');
      setState(() {
        remoteUid.removeWhere((element) => element == uid);
      });
    }));
    await engine!.enableVideo();
    await engine!.startPreview();
    setState(() {});
    var handle = await engine!.getNativeHandle();
    if (handle != null) {
      await AgoraRtcRawdata.registerAudioFrameObserver(handle);
      await AgoraRtcRawdata.registerVideoFrameObserver(handle);
    }

    await engine!
        .joinChannel(channelToken, sweetRoomId, null, int.parse(myAgoraUid));

    //关闭本地声音
    await engine!.muteLocalAudioStream(false);
    //关闭远程声音
    await engine!.muteAllRemoteVideoStreams(false);
    await engine!.muteAllRemoteAudioStreams(false);

    VideoEncoderConfiguration videoConfig =
        VideoEncoderConfiguration(frameRate: VideoFrameRate.Fps30);
    await engine!.setVideoEncoderConfiguration(videoConfig);
    await engine!.enableLocalAudio(isSelfMute);
    await engine!.enableLocalVideo(isSelfHide);
  }

  _deinitEngine() async {
    await AgoraRtcRawdata.unregisterAudioFrameObserver();
    await AgoraRtcRawdata.unregisterVideoFrameObserver();
    // await engine!.destroy();
  }

  void _submitText(String text) {
    msg = text;
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> _imageList = <List<String>>[
      <String>['wild', '6D', '7D', '8D', '9D', '10D', 'QD', 'KD', 'AD', 'wild'],
      <String>['5D', '3H', '2H', '2S', '3S', '4S', '5S', '6S', '7S', 'AC'],
    ];

    List<ChatMessage> messages = [
      ChatMessage(account: "123", messageContent: "Hello, 123"),
      ChatMessage(account: "456", messageContent: "How have you been?"),
      ChatMessage(account: "789", messageContent: "Hello, 7"),
      ChatMessage(account: "10", messageContent: "Hello, 6"),
      ChatMessage(account: "12", messageContent: "Hello, 5"),
      ChatMessage(account: "13", messageContent: "Hello, 1"),
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              final builder = MqttClientPayloadBuilder();
              builder.addString("leaveRoom," + identity.toString());
              client.publishMessage("imeSweetRoom/" + sweetRoomId,
                  MqttQos.atLeastOnce, builder.payload!);
              client.unsubscribe("imeSweetRoom/" + sweetRoomId);
              client.unsubscribe("imeSweetUser/" + myUid);
              myUid = getUid();
              client.subscribe("imeSweetUser/" + myUid, MqttQos.atLeastOnce);
              print('訂閱新Uid $myUid');
              Get.back();
            },
          ),
          title: Text(
            roomName,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            Consumer<sweetProvider>(builder: (context, _sweetProvider, child) {
              return Stack(children: <Widget>[
                _sweetProvider.vdoSta == false
                    ? Image.network(
                        _sweetProvider.inRoomAvatar,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center,
                      )
                    : identity! //F= 觀眾 T=主播
                        ? RtcLocalView.SurfaceView()
                        : RtcRemoteView.SurfaceView(
                            uid: _sweetProvider.seatId1,
                            channelId: sweetRoomId,
                          ),

                //共同都有 聊天室 主播更多：美顏 觀眾更多：送禮物
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Stack(
                            children: [
                              if (identity == true) ...[
                                moreView
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: IconButton(
                                                    icon: Image.asset(
                                                        'assets/images/camera.png'),
                                                    iconSize: 3,
                                                    onPressed: () {
                                                      engine!.switchCamera();
                                                    },
                                                  ),
                                                ),
                                                if (isSelfMute == true) ...[
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                          'assets/images/mic-on.png'),
                                                      iconSize: 3,
                                                      onPressed: () {
                                                        setState(() {
                                                          isSelfMute =
                                                              !isSelfMute;
                                                        });
                                                        engine!
                                                            .enableLocalVideo(
                                                                isSelfHide);
                                                      },
                                                    ),
                                                  ),
                                                ] else if (isSelfMute ==
                                                    false) ...[
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                          'assets/images/mic-off.png'),
                                                      iconSize: 3,
                                                      onPressed: () {
                                                        setState(() {
                                                          isSelfMute =
                                                              !isSelfMute;
                                                        });
                                                        engine!
                                                            .enableLocalVideo(
                                                                isSelfHide);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                                if (isSelfHide == true) ...[
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                          'assets/images/vdo-on.png'),
                                                      iconSize: 3,
                                                      onPressed: () {
                                                        setState(() {
                                                          isSelfHide =
                                                              !isSelfHide;
                                                          pushMqtt(
                                                              "imeSweetRoom/" +
                                                                  sweetRoomId,
                                                              "vdoHide,$isSelfHide");
                                                        });
                                                        engine!
                                                            .enableLocalVideo(
                                                                isSelfHide);
                                                      },
                                                    ),
                                                  ),
                                                ] else if (isSelfHide ==
                                                    false) ...[
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: IconButton(
                                                      icon: Image.asset(
                                                          'assets/images/vdo-off.png'),
                                                      iconSize: 3,
                                                      onPressed: () {
                                                        setState(() {
                                                          isSelfHide =
                                                              !isSelfHide;
                                                          pushMqtt(
                                                              "imeSweetRoom/" +
                                                                  sweetRoomId,
                                                              "vdoHide,$isSelfHide");
                                                        });
                                                        engine!
                                                            .enableLocalVideo(
                                                                isSelfHide);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          FaceunityUI(
                                            cameraCallback: () =>
                                                engine!.switchCamera(),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        //聊天列表
                                        height: 150,
                                        child: ListView.builder(
                                          itemCount: messages.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                onTap: () async {
                                                  (await userInfo(context,
                                                      messages[index].account));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 8,
                                                      top: 1,
                                                      bottom: 1),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.blue[200],
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Text(
                                                        messages[index]
                                                                .account +
                                                            " " +
                                                            messages[index]
                                                                .messageContent,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      )
                              ] else if (identity == false) ...[
                                moreView //送禮清單
                                    ? Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 150,
                                              decoration: new BoxDecoration(
                                                //背景
                                                color: Colors.white,
                                                //设置四周圆角 角度
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                //设置四周边框
                                                border: new Border.all(
                                                    width: 1,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                for (var i in _imageList)
                                                  IconButton(
                                                    icon: Image.asset(
                                                        'assets/images/bag.png'),
                                                    iconSize: 3,
                                                    onPressed: () {},
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(
                                        //聊天列表
                                        height: 150,
                                        child: ListView.builder(
                                          itemCount: messages.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                onTap: () async {
                                                  (await userInfo(context,
                                                      messages[index].account));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 8,
                                                      top: 1,
                                                      bottom: 1),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.blue[200],
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Text(
                                                        messages[index]
                                                                .account +
                                                            " " +
                                                            messages[index]
                                                                .messageContent,
                                                        style: TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      )
                              ]
                            ],
                          ),
                          //輸入欄
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, top: 10),
                              height: 60,
                              width: double.infinity,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  if (identity == true) ...[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          moreView = !moreView;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/more.png"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ] else if (identity == false) ...[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          moreView = !moreView;
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://i.ibb.co/mBhTmgL/image.png")),
                                        ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "輸入訊息",
                                          hintStyle:
                                              TextStyle(color: Colors.black54),
                                          border: InputBorder.none),
                                      controller: _chatController,
                                      onSubmitted: _submitText,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  FloatingActionButton(
                                    onPressed: () {
                                      messages.addAll([
                                        ChatMessage(
                                            account: "asdsad",
                                            messageContent:
                                                _chatController.text),
                                      ]);
                                      _submitText(_chatController.text);
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      for (var i in messages)
                                        print(
                                            '1111 ${i.messageContent} ${i.account}');
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    backgroundColor: Colors.blue,
                                    elevation: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _sweetProvider.getGift_1
                    ? Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'assets/images/gif/sportsCar.gif',
                          width: 300,
                          height: 300,
                        ),
                      )
                    : Container(width: 0, height: 0),
              ]);
            })
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  String account;
  String messageContent;
  ChatMessage({required this.account, required this.messageContent});
}

Future<Future<String?>> userInfo(BuildContext context, account) async {
  //回頭補
  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(account),
        content: new Row(
          children: <Widget>[new Text('')],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffff7090),
            ),
            onPressed: () {
              var pubTopic = 'imeSweetRoom/';
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
            },
            child: Text('禁言'),
          ),
        ],
      );
    },
  );
}
