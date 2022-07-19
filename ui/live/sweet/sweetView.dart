import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_rawdata/agora_rtc_rawdata.dart';
import 'package:faceunity_plugin/faceunity_plugin.dart';
import 'package:faceunity_ui/Faceunity_ui.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/business_logic/provider/sweetProvider.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:petitparser/petitparser.dart';

import 'package:provider/provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

int myRoomSeatIndex = 0;
String T_D_player = "";
const appId = '4981f60af0874faa9381f782c93706bf';

class sweetView extends StatefulWidget {
  const sweetView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<sweetView> createState() => _theRoomState();
}

class _theRoomState extends State<sweetView> with TickerProviderStateMixin {
  int previouClick = 0;
  int clicking = 0;
  int giftIndex = 0;
  String msg = "";
  String _selfAccount = "";
  String _selfencodeName = "";
  String? memberId;
  AnimationController? _controller;
  RtcEngine? engine;
  bool faceunityInit = true;
  bool isJoined = false;
  bool moreView = false;
  bool isSelfMute = false;
  bool isSelfHide = false;
  bool initFaceunity = false;
  bool _cantalk = false;
  bool gifPlaying = false;
  bool musicPlaying = false;
  bool screenClear = false;
  bool giftFrist = true;
  bool _chat = false;
  bool _camera = false;
  bool _gift = false;

  String giftMoney = '';
  String giftName = '';
  String giftChName = '';
  String giftMusic = '';
  String ms = '';
  List<int> remoteUid = [];
  final _gridViewKey = GlobalKey();
  final TextEditingController _chatController = new TextEditingController();
  final List<Widget> _message = [];
  ScrollController _ScrollController =
      ScrollController(initialScrollOffset: 50.0);

  late AudioPlayer player;

  List<List<String>> _imageList = <List<String>>[
    <String>['wild', '6D', '7D', '8D', '9D', '10D', 'QD', 'KD', 'AD', 'wild'],
    <String>['5D', '3H', '2H', '2S', '3S', '4S', '5S', '6S', '7S', 'AC'],
  ];
  Size? _gridViewSize;
  void getSize() {
    setState(() {
      _gridViewSize = _gridViewKey.currentContext!.size;
    });
  }

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();
    // myUid = getUid();
    // MqttListen().resetSeats();
    Future(() async {
      // myAgoraUid = getUid();
      myAgoraUid = myUid;
    });
    Future(() async {
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (myRoomSeatIndex == 0) {
          timer.cancel();
        } else {
          final builder = MqttClientPayloadBuilder();
          builder.addString("refreshLive," + myRoomSeatIndex.toString());
          client.publishMessage("imeSweetRoom/" + sweetRoomId,
              MqttQos.atLeastOnce, builder.payload!);
          //print('imlive');
        }
      });
    });
    if (identity == true) {
      isSelfMute = true;
      isSelfHide = true;
      Future(() async {
        Timer.periodic(Duration(milliseconds: 100), (timer) {
          if (gifQueue.isNotEmpty &&
              gifPlaying == false &&
              musicPlaying == false) {
            pushMqtt("imeSweetRoom/" + sweetRoomId,
                "gif/play," + gifQueue.first.toString());
            gifQueue.removeFirst();
          }
        });
      });
    }
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        faceunityInit = false;
      });
    });

    client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);

    this._initEngine();
  }

  @override
  Future<void> deactivate() async {
    myRoomSeatIndex = 0;
    engine!.muteAllRemoteVideoStreams(true);
    engine!.muteAllRemoteAudioStreams(true);
    engine!.disableVideo();
    engine!.leaveChannel();
    this._deinitEngine();

    client.subscribe("imeSweetRoom/info", MqttQos.atLeastOnce);
    final builder = MqttClientPayloadBuilder();
    builder.addString("leaveRoom," + identity.toString() + ',' + _selfAccount);
    client.publishMessage(
        "imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce, builder.payload!);
    client.unsubscribe("imeSweetRoom/" + sweetRoomId);
    client.unsubscribe("imeSweetUser/" + myUid);
    //sprint('old $myUid');
    myUid = await getUid();
    //print('訂閱新Uid $myUid');
    client.subscribe("imeSweetUser/" + myUid, MqttQos.atLeastOnce);
    super.deactivate();
  }

  @override
  void dispose() {
    player.dispose();

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
      print('joinChannelSuccess $channel $uid $elapsed');
      //log('joinChannelSuccess $channel $uid $elapsed');
      setState(() {
        isJoined = true;
      });
    }, userJoined: (uid, elapsed) {
      print('userJoined  $uid $elapsed');
      //log('userJoined  $uid $elapsed');
      setState(() {
        remoteUid.add(uid);
        engine!.muteAllRemoteVideoStreams(false);
      });
    }, userOffline: (uid, reason) {
      print('userleave  $uid $reason');
      //log('userJoined  $uid $reason');
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
        .joinChannel(null, sweetRoomId, null, await int.parse(myAgoraUid));
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

  void _submitText(String encodeSelfName) {
    if (_cantalk == false) {
      pushMqtt(
          'imeSweetRoom/' + sweetRoomId,
          'addChatMsg,' +
              _selfencodeName +
              ',' +
              strToEncode(_chatController.text));
    } else {
      cantTalk(context);
    }
    _chatController.clear();
    setState(() {
      _chat = false;
    });
  }

  Future<void> playMusic(String url) async {
    await player.setUrl(url);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onPanUpdate: (details) {
              // Swiping in right direction.
              if (details.delta.dx > 0) {}
              setState(() {
                screenClear = false;
              });
              // Swiping in left direction.
              if (details.delta.dx < 0) {
                setState(() {
                  screenClear = true;
                });
              }
            },
            onTap: () {
              if (_chat == true) {
                setState(() {
                  _chat = false;
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              } else if (_gift == true) {
                setState(() {
                  _gift = false;
                });
              } else if (_camera == true) {
                setState(() {
                  _camera = false;
                });
              }
              //FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Stack(
              children: <Widget>[
                Consumer<sweetProvider>(
                    builder: (context, _sweetProvider, child) {
                  _selfAccount = _sweetProvider.selfAccount;
                  _selfencodeName = _sweetProvider.selfEncodeName;
                  _cantalk = _sweetProvider.cantTalk;
                  gifPlaying = _sweetProvider.giftAnime;
                  if (gifPlaying == true) {
                    if (_sweetProvider.giftMusic == true) {
                      Timer(const Duration(milliseconds: 900), () {
                        playMusic(_sweetProvider.giftMusicUrl);
                        _sweetProvider.giftMusic = false;
                      });
                    }
                  } else {
                    imageCache?.clear();
                  }
                  if (_sweetProvider.musicStop) {
                    player.stop();
                    _sweetProvider.musicStop = false;
                  }
                  if (_sweetProvider.chatroomRefresh == true) {
                    _ScrollController.jumpTo(
                        _ScrollController.position.maxScrollExtent);
                    _sweetProvider.chatroomRefresh = false;
                  }

                  return Stack(children: <Widget>[
                    if (faceunityInit == true) ...[FaceunityUI()],
                    if (_sweetProvider.offStreaming == true) ...[
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ImageFiltered(
                            imageFilter:
                                ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                            child: Image.network(
                              _sweetProvider.anchorAvatar,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                            )),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.75,
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Colors.transparent,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Text(
                                    '直播結束',
                                    style: TextStyle(
                                        fontSize: 50, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CircleAvatar(
                                    radius: 27.5,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                        _sweetProvider.anchorAvatar),
                                  ),
                                  Text(
                                    _sweetProvider.anchorName,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    // name
                                    height: 30,
                                    width: 125,
                                    decoration: new BoxDecoration(
                                        //背景半透明
                                        color: Colors.white,
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        //设置四周边框
                                        border: new Border.all(
                                          width: 1,
                                          color: Colors.transparent,
                                        )),
                                    child: Center(
                                      child: (Text(
                                        '追蹤',
                                        style: TextStyle(fontSize: 15),
                                      )),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            color: Colors.black,
                            icon: Icon(Icons.clear,
                                color: Colors.black), //Icons.arrow_back
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: _sweetProvider.vdoStatus == false
                              ? Image.network(
                                  _sweetProvider.anchorAvatar,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                )
                              : isJoined //沒有會黑屏
                                  ? identity! //F= 觀眾 T=主播
                                      ? RtcLocalView.SurfaceView()
                                      : RtcRemoteView.SurfaceView(
                                          uid: _sweetProvider.anchorID,
                                          channelId: sweetRoomId,
                                        )
                                  : Image.network(
                                      _sweetProvider.anchorAvatar,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                    )),

                      _sweetProvider.giftAnime
                          ? Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Transform.scale(
                                    scale: 1.0,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              _sweetProvider.gifUrl),
                                          fit: BoxFit.cover,
                                          repeat: ImageRepeat.noRepeat,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          : Container(width: 0, height: 0),
                      //共同都有 appbar
                      if (screenClear == false) ...[
                        Positioned(
                          top: MediaQuery.of(context).padding.top,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 80,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              // name
                                              height: 50,
                                              width: 180,
                                              decoration: new BoxDecoration(
                                                  //背景半透明
                                                  // color: Color.fromARGB(
                                                  //     100, 22, 44, 33),
                                                  //设置四周圆角 角度
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  //设置四周边框
                                                  border: new Border.all(
                                                    width: 1,
                                                    color: Colors.transparent,
                                                  )),
                                              child: Stack(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showAnchorInfo(
                                                          context,
                                                          _sweetProvider
                                                              .anchorInfo);
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            height: 40,
                                                            width: 160,
                                                            decoration:
                                                                new BoxDecoration(
                                                                    //背景
                                                                    color: Color
                                                                        .fromARGB(
                                                                            100,
                                                                            22,
                                                                            44,
                                                                            33),
                                                                    //设置四周圆角 角度
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            20)),
                                                                    //设置四周边框
                                                                    border:
                                                                        new Border
                                                                            .all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .transparent,
                                                                    )),
                                                          ),
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              anchorNameConvert(
                                                                  _sweetProvider
                                                                      .anchorInfo
                                                                      .nickname),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .white),
                                                            )),
                                                        Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: CircleAvatar(
                                                              radius: 28.5,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      'https://storage.googleapis.com/ime-gift/icon/border.png'),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 16.0,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        _sweetProvider
                                                                            .anchorAvatar),
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Transform.scale(
                                                      scale: 1.25,
                                                      child: IconButton(
                                                        onPressed: () {
                                                          pushMqtt(
                                                              'imeSweetRoom/' +
                                                                  sweetRoomId,
                                                              'follow/anchor,' +
                                                                  strToEncode(
                                                                      _sweetProvider
                                                                          .anchorName));
                                                        },
                                                        icon: Image.network(
                                                            "https://storage.googleapis.com/ime-gift/icon/follow.png"),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                //禮物count
                                                height: 25,
                                                width: 100,
                                                decoration: new BoxDecoration(
                                                  //背景
                                                  color: Color.fromARGB(
                                                      100, 22, 44, 33),
                                                  //设置四周圆角 角度
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  //设置四周边框
                                                  border: new Border.all(
                                                    width: 1,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                                // child: Align(
                                                //   alignment: Alignment.center,
                                                //   child: Text('123'),
                                                // ),
                                                child: Row(
                                                  children: [
                                                    Image.network(
                                                        "https://storage.googleapis.com/ime-gift/icon/star.png"),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        donateNumConvert(
                                                            _sweetProvider
                                                                .donateCount),
                                                        style: TextStyle(
                                                          fontSize: 12.5,
                                                          color: Colors.white,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      children: [
                                        Expanded(child: SizedBox()),
                                        Container(
                                          height: 40,
                                          width: 190,
                                          //color: Colors.red,
                                          child: (Row(
                                            children: [
                                              Expanded(child: SizedBox()),
                                              GestureDetector(
                                                onTap: () async {
                                                  (await _showAudienceList(
                                                      context,
                                                      _sweetProvider
                                                          .audienceList));
                                                  ;
                                                },
                                                child: (Container(
                                                  //audience
                                                  height: 40,
                                                  width: 140,
                                                  //color: Colors.green,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: SizedBox()),
                                                      if (_sweetProvider
                                                              .accountList
                                                              .length <
                                                          4) ...[
                                                        for (int i = 0;
                                                            i <
                                                                _sweetProvider
                                                                    .audienceCount;
                                                            i++) ...[
                                                          Stack(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 21,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        'https://storage.googleapis.com/ime-gift/icon/border.png'),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 13,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          _sweetProvider.audienceList[i]
                                                                              [
                                                                              "avatar_sub"]),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ]
                                                      ] else ...[
                                                        for (int i = 0;
                                                            i < 4;
                                                            i++) ...[
                                                          if (i != 3) ...[
                                                            Stack(
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 21,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          'https://storage.googleapis.com/ime-gift/icon/border.png'),
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 13,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    backgroundImage:
                                                                        NetworkImage(_sweetProvider.audienceList[i]
                                                                            [
                                                                            "avatar_sub"]),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ] else ...[
                                                            Container(
                                                                height: 25,
                                                                width: 40,
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  //背景
                                                                  color: Color
                                                                      .fromARGB(
                                                                          100,
                                                                          22,
                                                                          44,
                                                                          33),
                                                                  //设置四周圆角 角度
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                  //设置四周边框
                                                                  border:
                                                                      new Border
                                                                          .all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                      _sweetProvider
                                                                          .audienceCount
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.5,
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                )),
                                                          ]
                                                        ]
                                                      ],
                                                    ],
                                                  ),
                                                )),
                                              ),
                                              IconButton(
                                                color: Colors.black,
                                                icon: Icon(Icons.clear,
                                                    color: Colors
                                                        .black), //Icons.arrow_back
                                                onPressed: () {
                                                  //final builder = MqttClientPayloadBuilder();
                                                  // builder.addString("leaveRoom," +
                                                  //     identity.toString() +
                                                  //     ',' +
                                                  //     selfAccount);
                                                  // client.publishMessage(
                                                  //     "imeSweetRoom/" + sweetRoomId,
                                                  //     MqttQos.atLeastOnce,
                                                  //     builder.payload!);
                                                  // client.unsubscribe(
                                                  //     "imeSweetRoom/" + sweetRoomId);
                                                  // client.unsubscribe("imeSweetUser/" + myUid);
                                                  // myUid = getUid();
                                                  // client.subscribe("imeSweetUser/" + myUid,
                                                  //     MqttQos.atLeastOnce);
                                                  // print('訂閱新Uid $myUid');
                                                  Get.back();
                                                },
                                              ),
                                            ],
                                          )),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),

                        //共同都有 聊天室 主播：美顏 送禮物
                        Positioned(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              ListView(
                                shrinkWrap: true,
                                children: <Widget>[
                                  Stack(
                                    //印象中 用Column 聊天列表會Bug
                                    children: [
                                      Container(
                                        //聊天列表
                                        height: 150,
                                        child: ListView.builder(
                                          itemCount:
                                              _sweetProvider.messages.length,
                                          shrinkWrap: true,
                                          controller: _ScrollController,
                                          padding: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                                onTap: () async {
                                                  (await userInfo(
                                                      context,
                                                      _sweetProvider
                                                          .messages[index]
                                                          .account,
                                                      sweetRoomId));
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
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Color.fromARGB(
                                                              100, 22, 44, 33),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          _sweetProvider
                                                                  .messages[
                                                                      index]
                                                                  .account +
                                                              " " +
                                                              _sweetProvider
                                                                  .messages[
                                                                      index]
                                                                  .messageContent,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  // under bar
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 10, bottom: 10, top: 10),
                                    height: 60,
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            height: 40,
                                            width: 40,
                                            decoration: new BoxDecoration(
                                              //背景
                                              color: Color.fromARGB(
                                                  100, 22, 44, 33),
                                              //设置四周圆角 角度
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40)),
                                              //设置四周边框
                                              border: new Border.all(
                                                width: 1,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                icon: Icon(Icons.chat_rounded),
                                                iconSize: 15,
                                                onPressed: () {
                                                  //聊天
                                                  setState(() {
                                                    _chat = true;
                                                  });
                                                  ;
                                                },
                                              ),
                                            )),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        if (identity == true) ...[
                                          Container(
                                              height: 40,
                                              width: 40,
                                              decoration: new BoxDecoration(
                                                //背景
                                                color: Color.fromARGB(
                                                    100, 22, 44, 33),
                                                //设置四周圆角 角度
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40)),
                                                //设置四周边框
                                                border: new Border.all(
                                                  width: 1,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  icon: Image.asset(
                                                      'assets/images/more.png'),
                                                  iconSize: 15,
                                                  onPressed: () {
                                                    setState(() {
                                                      _camera = true;
                                                    });
                                                    ;
                                                  },
                                                ),
                                              )),
                                        ],
                                        Expanded(child: SizedBox()),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _gift = true;
                                            });
                                          },
                                          child: (Image.network(
                                            "https://storage.googleapis.com/ime-gift/icon/gift.png",
                                            height: 40,
                                            width: 40,
                                          )),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (_chat == true) ...[
                          //輸入欄
                          Positioned(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 10, bottom: 10, top: 10),
                              height: 60,
                              width: double.infinity,
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      autofocus: true,
                                      textInputAction: TextInputAction.go,
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
                                    //回頭補 鍵盤return 送出mqtt
                                    onPressed: () {
                                      if (_sweetProvider.cantTalk == false) {
                                        if ((_chatController.text.length)
                                                .toInt() >
                                            0) {
                                          pushMqtt(
                                              'imeSweetRoom/' + sweetRoomId,
                                              'addChatMsg,' +
                                                  _sweetProvider
                                                      .selfEncodeName +
                                                  ',' +
                                                  strToEncode(
                                                      _chatController.text));
                                          _chatController.clear();
                                        }

                                        ;
                                      } else {
                                        cantTalk(context);
                                        _chatController.clear();
                                      }
                                      setState(() {
                                        _chat = false;
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
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
                          )
                        ],

                        if (_camera == true) ...[
                          Positioned(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: 0,
                              right: 0,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.bottomLeft,
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
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/images/mic-on.png'),
                                                iconSize: 3,
                                                onPressed: () {
                                                  setState(() {
                                                    isSelfMute = !isSelfMute;
                                                  });
                                                  engine!.enableLocalAudio(
                                                      isSelfMute);
                                                },
                                              ),
                                            ),
                                          ] else if (isSelfMute == false) ...[
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/images/mic-off.png'),
                                                iconSize: 3,
                                                onPressed: () {
                                                  setState(() {
                                                    isSelfMute = !isSelfMute;
                                                  });
                                                  engine!.enableLocalAudio(
                                                      isSelfMute);
                                                },
                                              ),
                                            ),
                                          ],
                                          if (isSelfHide == true) ...[
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/images/vdo-on.png'),
                                                iconSize: 3,
                                                onPressed: () {
                                                  setState(() {
                                                    isSelfHide = !isSelfHide;
                                                    pushMqtt(
                                                        "imeSweetRoom/" +
                                                            sweetRoomId,
                                                        "vdoHide,$isSelfHide");
                                                  });
                                                  engine!.enableLocalVideo(
                                                      isSelfHide);
                                                },
                                              ),
                                            ),
                                          ] else if (isSelfHide == false) ...[
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    'assets/images/vdo-off.png'),
                                                iconSize: 3,
                                                onPressed: () {
                                                  setState(() {
                                                    isSelfHide = !isSelfHide;
                                                    pushMqtt(
                                                        "imeSweetRoom/" +
                                                            sweetRoomId,
                                                        "vdoHide,$isSelfHide");
                                                  });
                                                  engine!.enableLocalVideo(
                                                      isSelfHide);
                                                },
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    FaceunityUI()
                                  ],
                                ),
                              ))
                        ],

                        if (_gift == true) ...[
                          Positioned(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            left: 0,
                            right: 0,
                            child: Container(
                                height:
                                    (MediaQuery.of(context).size.height) * 0.4,
                                decoration: new BoxDecoration(
                                  //背景
                                  color: Colors.white,
                                  //设置四周圆角 角度
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  //设置四周边框
                                  border: new Border.all(
                                      width: 1, color: Colors.red),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height:
                                          (MediaQuery.of(context).size.height) *
                                              0.3,
                                      child: ListView(
                                        padding: const EdgeInsets.all(10.0),
                                        shrinkWrap: true,
                                        children: [
                                          Column(
                                            children: [
                                              for (int i = 0; i < 5; i++) ...[
                                                Row(
                                                  children: [
                                                    for (int j = 1;
                                                        j < 5;
                                                        j++) ...[
                                                      if (i == 0) ...[
                                                        GestureDetector(
                                                          // behavior:
                                                          //     HitTestBehavior.opaque,
                                                          onTap: () {
                                                            giftIndex = j - 1;
                                                            if (giftFrist ==
                                                                true) {
                                                              previouClick =
                                                                  giftIndex;
                                                              clicking =
                                                                  giftIndex;
                                                              giftFrist = false;
                                                              setState(() {
                                                                borderList[
                                                                        clicking] =
                                                                    true;
                                                              });
                                                            } else {
                                                              previouClick =
                                                                  clicking;
                                                              clicking =
                                                                  giftIndex;
                                                              borderList[
                                                                      previouClick] =
                                                                  false;
                                                              setState(() {
                                                                borderList[
                                                                        previouClick] =
                                                                    false;
                                                                borderList[
                                                                        clicking] =
                                                                    true;
                                                              });
                                                              ;
                                                            }
                                                            ms = _sweetProvider
                                                                .giftList[
                                                                    giftIndex]
                                                                .ms;
                                                            giftMusic =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .music;
                                                            giftMoney =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .money;
                                                            giftName =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .name;
                                                            giftChName =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .ch_name;
                                                            _sweetProvider
                                                                .sendCount = 1;
                                                          },
                                                          child: Container(
                                                            width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width) *
                                                                0.23,
                                                            height: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height) *
                                                                0.125,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              border:
                                                                  (borderList[j -
                                                                              1] ==
                                                                          false)
                                                                      ? Border
                                                                          .all(
                                                                          style:
                                                                              BorderStyle.none, //BorderSide
                                                                        )
                                                                      : Border
                                                                          .all(
                                                                          width:
                                                                              1.0,
                                                                          color:
                                                                              Colors.pinkAccent,
                                                                        ),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Image.network(
                                                                  _sweetProvider
                                                                      .giftList[
                                                                          j - 1]
                                                                      .icon_url,
                                                                  width: 60,
                                                                  height: 60,
                                                                ),
                                                                Text(
                                                                  _sweetProvider
                                                                      .giftList[
                                                                          j - 1]
                                                                      .ch_name,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10.5),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                      'assets/images/sweet/coin.png',
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Text(_sweetProvider
                                                                        .giftList[
                                                                            j - 1]
                                                                        .money,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          10.5),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ] else if (i * 4 + j >
                                                          _sweetProvider
                                                              .giftList.length
                                                              .toInt()) ...[
                                                        Container(
                                                          height: 0,
                                                          width: 0,
                                                        )
                                                      ] else if (i != 0) ...[
                                                        GestureDetector(
                                                          onTap: () {
                                                            giftIndex =
                                                                i * 4 + j - 1;
                                                            if (giftFrist ==
                                                                true) {
                                                              previouClick =
                                                                  giftIndex;
                                                              clicking =
                                                                  giftIndex;
                                                              giftFrist = false;
                                                              setState(() {
                                                                borderList[
                                                                        clicking] =
                                                                    true;
                                                              });
                                                            } else {
                                                              previouClick =
                                                                  clicking;
                                                              clicking =
                                                                  giftIndex;
                                                              borderList[
                                                                      previouClick] =
                                                                  false;
                                                              setState(() {
                                                                borderList[
                                                                        previouClick] =
                                                                    false;
                                                                borderList[
                                                                        clicking] =
                                                                    true;
                                                              });
                                                              ;
                                                            }
                                                            ms = _sweetProvider
                                                                .giftList[
                                                                    giftIndex]
                                                                .ms;
                                                            giftMusic =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .music;
                                                            giftMoney =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .money;
                                                            giftName =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .name;
                                                            giftChName =
                                                                _sweetProvider
                                                                    .giftList[
                                                                        giftIndex]
                                                                    .ch_name;
                                                            _sweetProvider
                                                                .sendCount = 1;
                                                          },
                                                          child: Container(
                                                            width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width) *
                                                                0.23,
                                                            height: (MediaQuery.of(
                                                                context)
                                                                .size
                                                                .height) *
                                                                0.125,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10.0)),
                                                              border: (borderList[i *
                                                                              4 +
                                                                          j -
                                                                          1] ==
                                                                      false)
                                                                  ? Border.all(
                                                                      style: BorderStyle
                                                                          .none, //BorderSide
                                                                    )
                                                                  : Border.all(
                                                                      width:
                                                                          1.0,
                                                                      color: Colors
                                                                          .pinkAccent,
                                                                    ),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Image.network(
                                                                  _sweetProvider
                                                                      .giftList[
                                                                          i * 4 +
                                                                              j -
                                                                              1]
                                                                      .icon_url,
                                                                  width: 60,
                                                                  height: 60,
                                                                ),
                                                                Text(
                                                                  _sweetProvider
                                                                      .giftList[
                                                                          i * 4 +
                                                                              j -
                                                                              1]
                                                                      .ch_name,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10.5),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                      'assets/images/sweet/coin.png',
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Text(_sweetProvider
                                                                        .giftList[i *
                                                                                4 +
                                                                            j -
                                                                            1]
                                                                        .money,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          10.5),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                    ]
                                                  ],
                                                ),
                                              ]
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          height: (MediaQuery.of(context)
                                                  .size
                                                  .height) *
                                              0.09,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: (Container(
                                                  height:
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .height) *
                                                          0.07,
                                                  width: 200,
                                                  decoration: new BoxDecoration(
                                                    //背景
                                                    color: Colors.white,
                                                    //设置四周圆角 角度
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                45)),
                                                    //设置四周边框
                                                    border: new Border.all(
                                                        width: 1,
                                                        color: Colors.pink),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            _sweetProvider
                                                                .sendCount
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                _sweetProvider
                                                                    .sendCount += 1;
                                                              },
                                                              icon: const Icon(Icons
                                                                  .expand_less)),
                                                        ],
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Color(0xffff7090),
                                                        ),
                                                        onPressed: () {
                                                          SendGift(
                                                              _sweetProvider
                                                                  .selfEncodeName,
                                                              _sweetProvider
                                                                  .anchorName,
                                                              _sweetProvider
                                                                  .sendCount,
                                                              giftMoney,
                                                              giftName,
                                                              giftMusic,
                                                              giftChName,
                                                              ms);
                                                        },
                                                        child: Text('贈送'),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                              )
                                            ],
                                          )),
                                    )
                                  ],
                                )),
                          )
                        ],
                        //共同都有 聊天室 主播更多：美顏 觀眾更多：送禮物
                      ],

                      //gif


                    ]
                  ]);
                })
              ],
            ),
          )),
    );
  }
}

Future<Future<String?>> userInfo(
    BuildContext context, bannedName, roomid) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: true, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(''),
        content: new Row(
          children: <Widget>[new Text('')],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffff7090),
            ),
            onPressed: () {
              pushMqtt('imeSweetRoom/' + roomid,
                  'ban/talk,' + strToEncode(bannedName));
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

Future<Future<String?>> cantTalk(BuildContext context) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: true, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text('您已被禁言！！')),
        // content: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: <Widget>[],
        // ),
      );
    },
  );
}

SendGift(selfEncodeName, anchorName, count, money, giftName, giftMusic,
    giftCnName, ms) {
  var sendGiftJson = {};
  sendGiftJson['"dbName"'] = ('"ime"');
  sendGiftJson['"coll"'] = ('"member"');
  sendGiftJson['"eqKey"'] = ('"nickname"');
  sendGiftJson['"eqValue"'] = //("5q2k5Lmf5piv");
      ('"${strToEncode(anchorName)}"');
  sendGiftJson['"setKey"'] = ('"get_donate_count"');
  sendGiftJson['"setValue"'] = ('"${money}"');
  sendGiftJson['"senderName"'] = ('"${selfEncodeName}"');
  sendGiftJson['"sendCount"'] = ('"${count}"');
  sendGiftJson['"giftName"'] = ('"${strToEncode(giftName)}"');
  sendGiftJson['"musicUrl"'] = ('"${strToEncode(giftMusic)}"');
  sendGiftJson['"ms"'] = ('"${strToEncode(ms)}"');
  //print("sendGiftJson," + sendGiftJson.toString());
  pushMqtt('imeSweetRoom/' + sweetRoomId,
      "put/gift/count," + sendGiftJson.toString());
  pushMqtt(
      'imeSweetRoom/' + sweetRoomId,
      "gif/enQue," +
          selfEncodeName +
          "," +
          sendGiftJson.toString()           );
  pushMqtt(
      'imeSweetRoom/' + sweetRoomId,
      'addChatMsg,' +
          selfEncodeName +
          ',' +
          strToEncode('送給了主播' + count.toString() + '個' + giftCnName));
}

_showAnchorInfo(BuildContext context, anchorInfo) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: (Column(
        children: [
          CircleAvatar(
            radius: 37.5,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
                'https://storage.googleapis.com/ime-gift/icon/border.png'),
            child: CircleAvatar(
              radius: 24.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(anchorInfo.avatar_sub),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                anchorNameConvert(anchorInfo.nickname),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                  height: 20,
                  width: 50,
                  decoration: new BoxDecoration(
                      //背景
                      color: Colors.orange,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      //设置四周边框
                      border: new Border.all(
                        width: 1,
                        color: Colors.transparent,
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: (Text(anchorInfo.age.toString())),
                  )),
            ],
          ),
          SizedBox(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    children: [
                      Text(
                        "10",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "追蹤者",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    children: [
                      Text(
                        donateNumConvert(anchorInfo.get_donate_count),
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "禮物",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  )),
            ],
          ),
          Container(
            // name
            height: 50,
            width: 125,
            decoration: new BoxDecoration(
                //背景半透明
                color: Color.fromARGB(100, 22, 44, 33),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(25)),
                //设置四周边框
                border: new Border.all(
                  width: 1,
                  color: Colors.transparent,
                )),
            child: Center(
              child: (Text(
                '追蹤',
                style: TextStyle(fontSize: 15),
              )),
            ),
          )
        ],
      )),
    ),
  );
}

_showAudienceList(BuildContext context, audienceList) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: (Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '觀看人數',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'VIP',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '貢獻榜',
                style: TextStyle(fontSize: 20),
              ),
            ],
          )
        ],
      )),
    ),
  );
}

_showUserDetail(BuildContext context, account) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          for (dynamic i in account.keys) ...[
            if (i == 'nickname') Text(i + '  ' + account["$i"])
          ]
        ],
      ),
    ),
  );
}

donateNumConvert(num) {
  if (num > 10000) {
    return (num ~/ 1000).toString() + 'K';
  } else {
    return num.toString();
  }
}

anchorNameConvert(name) {
  if (name.length > 5) {
    return (name.substring(0, 5) + '...');
  } else {
    return name;
  }
}
