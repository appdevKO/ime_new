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
import 'package:ime_new/business_logic/provider/TD_game.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import './pointer.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:ime_new/business_logic/model/TD_room.dart';

class RoomController extends GetxController {
  RxList<Room> roomsList = List<Room>.from([]).obs;
}

int myRoomSeatIndex = 0;
String T_D_player = "";
const appId = '27e69b885f864b0da5a75265e8c96cdb';

class theRoom extends StatefulWidget {
  const theRoom({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<theRoom> createState() => _theRoomState();
}

class _theRoomState extends State<theRoom> with TickerProviderStateMixin {
  AnimationController? _controller;
  RtcEngine? engine;
  bool isJoined = false;
  bool startPreview_1 = false;
  bool startPreview_2 = false;
  bool startPreview_3 = false;
  bool startPreview_4 = false;
  bool isSelfMute = false;
  bool isSelfHide = false;
  List<int> remoteUid = [];
  final _gridViewKey = GlobalKey();
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
    Future(() async {
      myAgoraUid = myUid;
      final builder = MqttClientPayloadBuilder();
      builder.addString(
          "iamjoined," + myRoomSeatIndex.toString() + "," + myAgoraUid);
      await client.publishMessage(
          "imedotRoom/" + myRoomId, MqttQos.atLeastOnce, builder.payload!);
    });

    Future(() async {
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (myRoomSeatIndex == 0) {
          timer.cancel();
        } else {
          final builder = MqttClientPayloadBuilder();
          builder.addString("refreshLive," + myRoomSeatIndex.toString());
          client.publishMessage(
              "imedotRoom/" + myRoomId, MqttQos.atLeastOnce, builder.payload!);
          print('imlive');
        }
      });
    });

    client.subscribe("imedotRoom/" + myRoomId, MqttQos.atLeastOnce);

    this._initEngine();
  }

  @override
  void deactivate() {
    engine!.muteAllRemoteVideoStreams(true);
    engine!.muteAllRemoteAudioStreams(true);
    engine!.disableVideo();
    engine!.leaveChannel();
    this._deinitEngine();
    startPreview_1 = false;
    startPreview_2 = false;
    startPreview_3 = false;
    startPreview_4 = false;
    final builder = MqttClientPayloadBuilder();
    builder.addString("leaveRoom," + myRoomSeatIndex.toString());
    client.publishMessage(
        "imedotRoom/" + myRoomId, MqttQos.atLeastOnce, builder.payload!);

    client.subscribe("imedot/info", MqttQos.atLeastOnce);
    client.unsubscribe("imedotRoom/" + myRoomId);
    client.unsubscribe("imedotUser/" + myUid);
    myUid = getUid();
    client.subscribe("imedotUser/" + myUid, MqttQos.atLeastOnce);

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
    engine!.setRemoteDefaultVideoStreamType(VideoStreamType.Low);
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
    setState(() {
      if (myRoomSeatIndex == 1) {
        startPreview_1 = true;
      } else if (myRoomSeatIndex == 2) {
        startPreview_2 = true;
      } else if (myRoomSeatIndex == 3) {
        startPreview_3 = true;
      } else if (myRoomSeatIndex == 4) {
        startPreview_4 = true;
      }
    });
    var handle = await engine!.getNativeHandle();
    if (handle != null) {
      await AgoraRtcRawdata.registerAudioFrameObserver(handle);
      await AgoraRtcRawdata.registerVideoFrameObserver(handle);
    }

    await engine!
        .joinChannel(channelToken, myRoomId, null, int.parse(myAgoraUid));

    //关闭本地声音
    await engine!.muteLocalAudioStream(false);
    //关闭远程声音
    await engine!.muteAllRemoteVideoStreams(false);
    await engine!.muteAllRemoteAudioStreams(false);

    VideoEncoderConfiguration videoConfig = VideoEncoderConfiguration(
        frameRate: VideoFrameRate.Fps24,
        minFrameRate: VideoFrameRate.Fps7,
        dimensions: VideoDimensions(width: 480, height: 360));
    await engine!.setVideoEncoderConfiguration(videoConfig);
    await engine!.enableLocalAudio(isSelfMute);
    await engine!.enableLocalVideo(isSelfHide);
  }

  _deinitEngine() async {
    await AgoraRtcRawdata.unregisterAudioFrameObserver();
    await AgoraRtcRawdata.unregisterVideoFrameObserver();
    // await engine!.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              final builder = MqttClientPayloadBuilder();
              builder.addString("leaveRoom," + myRoomSeatIndex.toString());
              client.publishMessage("imedotRoom/" + myRoomId,
                  MqttQos.atLeastOnce, builder.payload!);
            },
          ),
          title: Text(
            roomName,
            textAlign: TextAlign.center,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color(0xffff7090), Color(0xfff0c0c0)],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Consumer<TD_game>(builder: (context, MqttListen1, child) {
              if (MqttListen1.roulette_wheel_view == true) {
                _controller!.forward();
              } else if (MqttListen1.roulette_wheel_view == false) {
                _controller!.reset();
              }
              return Stack(children: <Widget>[
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: Stack(
                                          children: [
                                            startPreview_1 //玩家1
                                                ? isSelfHide == false
                                                    ? Container(
                                                        child: Image.network(
                                                          MqttListen1
                                                              .avatarUrl1,
                                                          fit: BoxFit.cover,
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      )
                                                    : Container(
                                                        child: RtcLocalView
                                                            .SurfaceView(),
                                                      )
                                                : MqttListen1.TDseatId1 != null
                                                    ? MqttListen1.vdoSta_1
                                                        ? Container(
                                                            child: Stack(
                                                                children: [
                                                                  RtcRemoteView
                                                                      .SurfaceView(
                                                                    uid: MqttListen1
                                                                        .TDseatId1!,
                                                                    channelId:
                                                                        myRoomId,
                                                                  ),
                                                                ]),
                                                          )
                                                        : Container(
                                                            child:
                                                                Image.network(
                                                              MqttListen1
                                                                  .avatarUrl1,
                                                              fit: BoxFit.cover,
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          )
                                                    : Image.asset(
                                                        'assets/images/blank_avatar.png',
                                                        fit: BoxFit.cover,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                            MqttListen1.hat_view_1
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Image.asset(
                                                      'assets/images/tdGame/hat.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.crown_view_1
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Image.asset(
                                                      'assets/images/tdGame/crown.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.pass_view_1
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 80.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/ok.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              pushMqtt(
                                                                  "imedotRoom/" +
                                                                      (myRoomId),
                                                                  'next_game,');
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/punish.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              pushMqtt(
                                                                  "imedotRoom/" +
                                                                      (myRoomId) +
                                                                      "/game",
                                                                  'backend_punish,' +
                                                                      T_D_player);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.truth_dare_view_1
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 80.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/truth.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'truth,');
                                                                MqttListen1
                                                                        .truth_dare_view_1 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/dare.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'dare,');
                                                                MqttListen1
                                                                        .truth_dare_view_1 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.choose_button_view_1
                                                ? Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: 80.0,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: ButtonBar(
                                                            alignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/2b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,2');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "2";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/3b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,3');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "3";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/4b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,4');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "4";
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Image.asset(
                                                'assets/images/tdGame/1.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: Stack(
                                          children: [
                                            startPreview_2 //玩家2
                                                ? isSelfHide == false
                                                    ? Container(
                                                        child: Image.network(
                                                          MqttListen1
                                                              .avatarUrl2,
                                                          fit: BoxFit.cover,
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      )
                                                    : Container(
                                                        child: RtcLocalView
                                                            .SurfaceView(),
                                                      )
                                                : MqttListen1.TDseatId2 != null
                                                    ? MqttListen1.vdoSta_2
                                                        ? Container(
                                                            child: Stack(
                                                                children: [
                                                                  RtcRemoteView
                                                                      .SurfaceView(
                                                                    uid: MqttListen1
                                                                        .TDseatId2!,
                                                                    channelId:
                                                                        myRoomId,
                                                                  ),
                                                                ]),
                                                          )
                                                        : Container(
                                                            child:
                                                                Image.network(
                                                              MqttListen1
                                                                  .avatarUrl2,
                                                              fit: BoxFit.cover,
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          )
                                                    : Image.asset(
                                                        'assets/images/blank_avatar.png',
                                                        fit: BoxFit.cover,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                            myRoomSeatIndex == 1
                                                ? MqttListen1.TDseatId2 != null
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.logout,
                                                              color:
                                                                  Colors.black),
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            pushMqtt(
                                                                "imedotRoom/" +
                                                                    myRoomId,
                                                                "leaveRoom,2");
                                                            MqttListen1
                                                                    .out_view_2 =
                                                                false;
                                                          },
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 0,
                                                        height: 0,
                                                      )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  ),
                                            MqttListen1.pass_view_2
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 80.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/ok.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId),
                                                                    'next_game,');
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/punish.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'backend_punish,' +
                                                                        T_D_player);
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.truth_dare_view_2
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 80.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/truth.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'truth,');
                                                                MqttListen1
                                                                        .truth_dare_view_2 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/dare.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'dare,');
                                                                MqttListen1
                                                                        .truth_dare_view_2 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.hat_view_2
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Image.asset(
                                                      'assets/images/tdGame/hat.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.crown_view_2
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Image.asset(
                                                      'assets/images/tdGame/crown.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.choose_button_view_2
                                                ? Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: 80.0,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: ButtonBar(
                                                            alignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/1b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,1');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "1";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/3b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,3');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "3";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/4b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,4');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "4";
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Image.asset(
                                                  'assets/images/tdGame/2.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: Stack(
                                          children: [
                                            startPreview_3 //玩家1
                                                ? isSelfHide == false
                                                    ? Container(
                                                        child: Image.network(
                                                          MqttListen1
                                                              .avatarUrl3,
                                                          fit: BoxFit.cover,
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      )
                                                    : Container(
                                                        child: RtcLocalView
                                                            .SurfaceView(),
                                                      )
                                                : MqttListen1.TDseatId3 != null
                                                    ? MqttListen1.vdoSta_3
                                                        ? Container(
                                                            child: Stack(
                                                                children: [
                                                                  RtcRemoteView
                                                                      .SurfaceView(
                                                                    uid: MqttListen1
                                                                        .TDseatId3!,
                                                                    channelId:
                                                                        myRoomId,
                                                                  ),
                                                                ]),
                                                          )
                                                        : Container(
                                                            child:
                                                                Image.network(
                                                              MqttListen1
                                                                  .avatarUrl3,
                                                              fit: BoxFit.cover,
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          )
                                                    : Image.asset(
                                                        'assets/images/blank_avatar.png',
                                                        fit: BoxFit.cover,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                            myRoomSeatIndex == 1
                                                ? MqttListen1.TDseatId3 != null
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.logout,
                                                              color:
                                                                  Colors.black),
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            pushMqtt(
                                                                "imedotRoom/" +
                                                                    myRoomId,
                                                                "leaveRoom,3");
                                                            MqttListen1
                                                                    .out_view_3 =
                                                                false;
                                                          },
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 0,
                                                        height: 0,
                                                      )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  ),
                                            MqttListen1.pass_view_3
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 80.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/ok.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId),
                                                                    'next_game,');
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/punish.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'backend_punish,' +
                                                                        T_D_player);
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.truth_dare_view_3
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 20.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/truth.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'truth,');
                                                                MqttListen1
                                                                        .truth_dare_view_3 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/dare.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'dare,');
                                                                MqttListen1
                                                                        .truth_dare_view_3 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.hat_view_3
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Image.asset(
                                                      'assets/images/tdGame/hat.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.crown_view_3
                                                ? Visibility(
                                                    visible: MqttListen1
                                                        .crown_view_3,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Image.asset(
                                                        'assets/images/tdGame/crown.png',
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.choose_button_view_3
                                                ? Stack(
                                                    children: [
                                                      Positioned(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: ButtonBar(
                                                            alignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/1b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,1');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "1";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/2b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,2');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "2";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/4b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,4');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "4";
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Image.asset(
                                                  'assets/images/tdGame/3.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: Stack(
                                          children: [
                                            startPreview_4 //玩家4
                                                ? isSelfHide == false
                                                    ? Container(
                                                        child: Image.network(
                                                          MqttListen1
                                                              .avatarUrl4,
                                                          fit: BoxFit.cover,
                                                          height:
                                                              double.infinity,
                                                          width:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                        ),
                                                      )
                                                    : Container(
                                                        child: RtcLocalView
                                                            .SurfaceView(),
                                                      )
                                                : MqttListen1.TDseatId4 != null
                                                    ? MqttListen1.vdoSta_4
                                                        ? Container(
                                                            child: Stack(
                                                                children: [
                                                                  RtcRemoteView
                                                                      .SurfaceView(
                                                                    uid: MqttListen1
                                                                        .TDseatId4!,
                                                                    channelId:
                                                                        myRoomId,
                                                                  ),
                                                                ]),
                                                          )
                                                        : Container(
                                                            child:
                                                                Image.network(
                                                              MqttListen1
                                                                  .avatarUrl4,
                                                              fit: BoxFit.cover,
                                                              height: double
                                                                  .infinity,
                                                              width: double
                                                                  .infinity,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
                                                          )
                                                    : Image.asset(
                                                        'assets/images/blank_avatar.png',
                                                        fit: BoxFit.cover,
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                            myRoomSeatIndex == 1
                                                ? MqttListen1.TDseatId4 != null
                                                    ? Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.logout,
                                                              color:
                                                                  Colors.black),
                                                          iconSize: 20,
                                                          onPressed: () {
                                                            pushMqtt(
                                                                "imedotRoom/" +
                                                                    myRoomId,
                                                                "leaveRoom,4");
                                                            MqttListen1
                                                                    .out_view_4 =
                                                                false;
                                                          },
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 0,
                                                        height: 0,
                                                      )
                                                : Container(
                                                    width: 0,
                                                    height: 0,
                                                  ),
                                            MqttListen1.pass_view_4
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 80.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/ok.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId),
                                                                    'next_game,');
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                                'assets/images/tdGame/punish.png'),
                                                            iconSize: 60,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'backend_punish,' +
                                                                        T_D_player);
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.truth_dare_view_4
                                                ? Positioned(
                                                    left: 15.0,
                                                    bottom: 20.0,
                                                    child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/truth.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'truth,');
                                                                MqttListen1
                                                                        .truth_dare_view_4 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: Image.asset(
                                                              'assets/images/tdGame/dare.png',
                                                            ),
                                                            iconSize: 55,
                                                            onPressed: () {
                                                              setState(() {
                                                                pushMqtt(
                                                                    "imedotRoom/" +
                                                                        (myRoomId) +
                                                                        "/game",
                                                                    'dare,');
                                                                MqttListen1
                                                                        .truth_dare_view_4 =
                                                                    false;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ))
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.hat_view_4
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Image.asset(
                                                      'assets/images/tdGame/hat.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.crown_view_4
                                                ? Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Image.asset(
                                                      'assets/images/tdGame/crown.png',
                                                      width: 40,
                                                      height: 40,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            MqttListen1.choose_button_view_4
                                                ? Stack(
                                                    children: [
                                                      Positioned(
                                                        bottom: 20.0,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: ButtonBar(
                                                            alignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/1b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,1');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "1";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/2b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,2');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "2";
                                                                  });
                                                                },
                                                              ),
                                                              IconButton(
                                                                icon: Image.asset(
                                                                    'assets/images/tdGame/3b.png'),
                                                                iconSize: 40,
                                                                onPressed: () {
                                                                  pushMqtt(
                                                                      "imedotRoom/" +
                                                                          (myRoomId) +
                                                                          "/game",
                                                                      'choose_this,3');
                                                                  setState(() {
                                                                    T_D_player =
                                                                        "3";
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(
                                                    width: 0, height: 0),
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Image.asset(
                                                  'assets/images/tdGame/4.png',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Container(
                                child: Stack(children: <Widget>[
                                  MqttListen1.roulette_wheel_view
                                      ? Visibility(
                                          //轉針
                                          visible:
                                              MqttListen1.roulette_wheel_view,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: SpinningContainer(
                                                    controller: _controller!)),
                                          ),
                                        )
                                      : Container(
                                          height: 0.1,
                                          width: 0.1,
                                        ),
                                  MqttListen1.choose_button_view_1
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/tdGame/chooseOne.png',
                                            width: 250,
                                            height: 250,
                                          ),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.choose_button_view_2
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/tdGame/chooseOne.png',
                                            width: 250,
                                            height: 250,
                                          ),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.choose_button_view_3
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/tdGame/chooseOne.png',
                                            width: 250,
                                            height: 250,
                                          ),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.choose_button_view_4
                                      ? Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/tdGame/chooseOne.png',
                                            width: 250,
                                            height: 250,
                                          ),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.text_view_start
                                      ? Visibility(
                                          visible: MqttListen1.text_view_start,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              'assets/images/tdGame/start.png',
                                              width: 300,
                                              height: 300,
                                            ),
                                          ),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.text_view_be_choose
                                      ? Visibility(
                                          visible:
                                              MqttListen1.text_view_be_choose,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  if (MqttListen1.BeChosen ==
                                                      '1') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/1.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '2') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/2.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '3') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/3.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '4') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/4.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ],
                                                  Image.asset(
                                                    'assets/images/tdGame/beChoose.png',
                                                    width: 200,
                                                    height: 200,
                                                  )
                                                ],
                                              )),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.text_view_choose_T
                                      ? Visibility(
                                          visible:
                                              MqttListen1.text_view_choose_T,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (MqttListen1.BeChosen ==
                                                      '1') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/1.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '2') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/2.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '3') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/3.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '4') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/4.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ],
                                                  Image.asset(
                                                    'assets/images/tdGame/chooseT.png',
                                                    width: 250,
                                                    height: 250,
                                                  )
                                                ],
                                              )),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.text_view_choose_D
                                      ? Visibility(
                                          visible:
                                              MqttListen1.text_view_choose_D,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (MqttListen1.BeChosen ==
                                                      '1') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/1.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '2') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/2.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '3') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/3.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ] else if (MqttListen1
                                                          .BeChosen ==
                                                      '4') ...[
                                                    Image.asset(
                                                      'assets/images/tdGame/4.png',
                                                      width: 30,
                                                      height: 30,
                                                    ),
                                                  ],
                                                  Image.asset(
                                                    'assets/images/tdGame/chooseD.png',
                                                    width: 250,
                                                    height: 250,
                                                  )
                                                ],
                                              )),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.text_view_punish
                                      ? Visibility(
                                          visible: MqttListen1.text_view_punish,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Stack(
                                                children: <Widget>[
                                                  Text(
                                                    '${MqttListen1.BeChosen}號玩家的懲罰是\n${MqttListen1.Punish}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      foreground: Paint()
                                                        ..style =
                                                            PaintingStyle.stroke
                                                        ..strokeWidth = 6
                                                        ..color = Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${MqttListen1.BeChosen}號玩家的懲罰是\n${MqttListen1.Punish}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        )
                                      : Container(width: 0, height: 0),
                                  MqttListen1.text_view_notify_king
                                      ? Visibility(
                                          visible:
                                              MqttListen1.text_view_notify_king,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                'assets/images/tdGame/selecting.png',
                                                width: 200,
                                                height: 200,
                                              )))
                                      : Container(width: 0, height: 0),
                                ]),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  isSelfHide
                                      ? Align(
                                          alignment: Alignment.bottomLeft,
                                          child: IconButton(
                                            icon: Image.asset(
                                                'assets/images/camera.png'),
                                            iconSize: 3,
                                            onPressed: () {
                                              engine!.switchCamera();
                                            },
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.bottomLeft,
                                          child: IconButton(
                                            icon: Image.asset(
                                                'assets/images/camera-w.png'),
                                            iconSize: 3,
                                            onPressed: () {
                                              engine!.switchCamera();
                                            },
                                          ),
                                        ),
                                  isSelfHide
                                      ? Align(
                                          alignment: Alignment.bottomCenter,
                                          child: IconButton(
                                            icon: isSelfMute
                                                ? Image.asset(
                                                    'assets/images/mic-on.png')
                                                : Image.asset(
                                                    'assets/images/mic-off.png'),
                                            iconSize: 3,
                                            onPressed: () {
                                              setState(() {
                                                isSelfMute = !isSelfMute;
                                              });
                                              engine!
                                                  .enableLocalAudio(isSelfMute);
                                            },
                                          ),
                                        )
                                      : Align(
                                          alignment: Alignment.bottomCenter,
                                          child: IconButton(
                                            icon: isSelfMute
                                                ? Image.asset(
                                                    'assets/images/mic-on-w.png')
                                                : Image.asset(
                                                    'assets/images/mic-off-w.png'),
                                            iconSize: 3,
                                            onPressed: () {
                                              setState(() {
                                                isSelfMute = !isSelfMute;
                                              });
                                              engine!
                                                  .enableLocalAudio(isSelfMute);
                                            },
                                          ),
                                        ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: isSelfHide
                                          ? Image.asset(
                                              'assets/images/vdo-on.png')
                                          : Image.asset(
                                              'assets/images/vdo-off-w.png'),
                                      iconSize: 3,
                                      onPressed: () {
                                        setState(() {
                                          isSelfHide = !isSelfHide;
                                          pushMqtt("imedotRoom/" + myRoomId,
                                              "vdoHide,$myRoomSeatIndex,$isSelfHide");
                                        });
                                        engine!.enableLocalVideo(isSelfHide);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FaceunityUI(cameraCallback: () => engine!.switchCamera()),
                  ],
                ),
              ]);
            })
          ],
        ),
      ),
    );
  }
}
