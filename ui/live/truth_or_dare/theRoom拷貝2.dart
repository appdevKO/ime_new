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
    // myUid = getUid();
    // MqttListen().resetSeats();
    Future(() async {
      // myAgoraUid = getUid();
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
                colors: <Color>[Colors.red, Colors.blue],
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
              if (MqttListen1.youOut == true) {}
              // Timer(const Duration(milliseconds: 1500), () {
              //   getSize();
              // });
              return Stack(children: <Widget>[
                Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.red,
                        //height: MediaQuery.of(context).size.height * 0.8,
                        child: Stack(
                          children: [
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
                    FaceunityUI(
                      cameraCallback: () => engine!.switchCamera(),
                    ),
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
