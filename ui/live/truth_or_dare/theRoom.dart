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
import 'package:ime_new/business_logic/provider/mqtt_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import './pointer.dart';
import 'package:mqtt_client/mqtt_client.dart';
import './room.dart';

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
            onPressed: () => Navigator.of(context).pop(),
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
            Consumer<MqttListen>(builder: (context, MqttListen1, child) {
              if (MqttListen1.roulette_wheel_view == true) {
                _controller!.forward();
              } else if (MqttListen1.roulette_wheel_view == false) {
                _controller!.reset();
              }
              if (MqttListen1.youOut) {
                //print('我被踢了');
                engine!.leaveChannel();
              }
              // Timer(const Duration(milliseconds: 1500), () {
              //   getSize();
              // });
              return Stack(children: <Widget>[
                GridView(
                  key: _gridViewKey,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.57 //數字越小越長 越大越短
                  ),
                  children: [
                    startPreview_1 //玩家1
                        ? isSelfHide == false
                        ? Container(
                      color: Colors.black,
                    )
                        : Container(
                      child: Stack(children: [
                        RtcLocalView.SurfaceView(),
                        Visibility(
                          visible: MqttListen1.crown_view_1,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.hat_view_1,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ]),
                    )
                        : MqttListen1.seatId1 != null
                        ? MqttListen1.vdoSta_1
                        ? Container(
                      child: Stack(children: [
                        RtcRemoteView.SurfaceView(
                          uid: MqttListen1.seatId1!,
                          channelId: myRoomId,
                        ),
                        Visibility(
                          visible: MqttListen1.crown_view_1,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.hat_view_1,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ]),
                    )
                        : Container(
                      color: Colors.black,
                    )
                        : Image.asset('assets/images/blank_avatar.png',
                        fit: BoxFit.cover),
                    startPreview_2 //玩家2
                        ? isSelfHide == false
                        ? Container(
                      color: Colors.black,
                    )
                        : Container(
                      child: Stack(children: [
                        RtcLocalView.SurfaceView(),
                        Visibility(
                          visible: MqttListen1.crown_view_2,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.hat_view_2,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ]),
                    )
                        : MqttListen1.seatId2 != null
                        ? MqttListen1.vdoSta_2
                        ? Container(
                      child: Stack(children: [
                        RtcRemoteView.SurfaceView(
                          uid: MqttListen1.seatId2!,
                          channelId: myRoomId,
                        ),
                        Visibility(
                          visible: MqttListen1.crown_view_2,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.hat_view_2,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        myRoomSeatIndex == 1
                            ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.logout,
                                color: Colors.black),
                            iconSize: 20,
                            onPressed: () {
                              pushMqtt(
                                  "imedotRoom/" + myRoomId,
                                  "getOut,2");
                              MqttListen1.out_view_2 =
                              false;
                            },
                          ),
                        )
                            : Container()
                      ]),
                    )
                        : Container(
                      color: Colors.black,
                    )
                        : Image.asset('assets/images/blank_avatar.png',
                        fit: BoxFit.cover),
                    startPreview_3 //玩家3
                        ? isSelfHide == false
                        ? Container(
                      color: Colors.black,
                    )
                        : Container(
                      child: Stack(children: [
                        RtcLocalView.SurfaceView(),
                        Visibility(
                          visible: MqttListen1.hat_view_3,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.crown_view_3,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ]),
                    )
                        : MqttListen1.seatId3 != null
                        ? MqttListen1.vdoSta_3
                        ? Container(
                      child: Stack(children: [
                        RtcRemoteView.SurfaceView(
                          uid: MqttListen1.seatId3!,
                          channelId: myRoomId,
                        ),
                        Visibility(
                          visible: MqttListen1.crown_view_3,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.hat_view_3,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        myRoomSeatIndex == 1
                            ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.logout,
                                color: Colors.black),
                            iconSize: 20,
                            onPressed: () {
                              pushMqtt(
                                  "imedotRoom/" + myRoomId,
                                  "getOut,3");
                              MqttListen1.out_view_3 =
                              false;
                            },
                          ),
                        )
                            : Container()
                      ]),
                    )
                        : Container(
                      color: Colors.black,
                    )
                        : Image.asset('assets/images/blank_avatar.png',
                        fit: BoxFit.cover),
                    startPreview_4 //玩家4
                        ? isSelfHide == false
                        ? Container(
                      color: Colors.black,
                    )
                        : Container(
                      child: Stack(children: [
                        RtcLocalView.SurfaceView(),
                        Visibility(
                          visible: MqttListen1.hat_view_4,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.crown_view_4,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ]),
                    )
                        : MqttListen1.seatId4 != null
                        ? MqttListen1.vdoSta_4
                        ? Container(
                      child: Stack(children: [
                        RtcRemoteView.SurfaceView(
                          uid: MqttListen1.seatId4!,
                          channelId: myRoomId,
                        ),
                        Visibility(
                          visible: MqttListen1.crown_view_4,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/crown.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: MqttListen1.hat_view_4,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset(
                              'assets/images/hat.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        myRoomSeatIndex == 1
                            ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.logout,
                                color: Colors.black),
                            iconSize: 20,
                            onPressed: () {
                              pushMqtt(
                                  "imedotRoom/" + myRoomId,
                                  "getOut,4");
                              MqttListen1.out_view_4 =
                              false;
                            },
                          ),
                        )
                            : Container()
                      ]),
                    )
                        : Container(
                      color: Colors.black,
                    )
                        : Image.asset('assets/images/blank_avatar.png',
                        fit: BoxFit.cover),
                  ],
                ),
                //传camera 回调显示 UI，不传不显示

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          isSelfHide
                              ? Align(
                            alignment: Alignment.bottomLeft,
                            child: IconButton(
                              icon:
                              Image.asset('assets/images/camera.png'),
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
                                engine!.enableLocalAudio(isSelfMute);
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
                                engine!.enableLocalAudio(isSelfMute);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: isSelfHide
                                  ? Image.asset('assets/images/vdo-on.png')
                                  : Image.asset('assets/images/vdo-off-w.png'),
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
                    FaceunityUI(
                      cameraCallback: () => engine!.switchCamera(),
                    ),
                  ],
                ),

                Container(
                  alignment: Alignment.center,
                  height: (MediaQuery.of(context).size.height) * 0.815,
                  width: (MediaQuery.of(context).size.width),
                  child: Stack(children: <Widget>[
                    MqttListen1.roulette_wheel_view
                        ? Visibility(
                      //轉針
                      visible: MqttListen1.roulette_wheel_view,
                      child: Align(
                        alignment: Alignment.center,
                        child: Align(
                            alignment: Alignment.center,
                            child: SpinningContainer(
                                controller: _controller!)),
                      ),
                    )
                        : Container(),
                    MqttListen1.choose_button_view_1
                        ? Visibility(
                      visible: MqttListen1.choose_button_view_1,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('2'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,2');
                                setState(() {
                                  T_D_player = "2";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('3'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,3');
                                setState(() {
                                  T_D_player = "3";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('4'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,4');
                                setState(() {
                                  T_D_player = "4";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    MqttListen1.choose_button_view_2
                        ? Visibility(
                      visible: MqttListen1.choose_button_view_2,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('1'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,1');
                                setState(() {
                                  T_D_player = "1";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('3'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,3');
                                setState(() {
                                  T_D_player = "3";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('4'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,4');
                                setState(() {
                                  T_D_player = "4";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    MqttListen1.choose_button_view_3
                        ? Visibility(
                      visible: MqttListen1.choose_button_view_3,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('1'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,1');
                                setState(() {
                                  T_D_player = "1";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('2'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,2');
                                setState(() {
                                  T_D_player = "2";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('4'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,4');
                                setState(() {
                                  T_D_player = "4";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    MqttListen1.choose_button_view_4
                        ? Visibility(
                      visible: MqttListen1.choose_button_view_4,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('1'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,1');
                                setState(() {
                                  T_D_player = "1";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('2'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,2');
                                setState(() {
                                  T_D_player = "2";
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('3'),
                              onPressed: () {
                                pushMqtt(
                                    "imedotRoom/" + (myRoomId) + "/game",
                                    'choose_this,3');
                                setState(() {
                                  T_D_player = "3";
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    MqttListen1.truth_dare_view
                        ? Visibility(
                      visible: MqttListen1.truth_dare_view,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('真心話'),
                              onPressed: () {
                                setState(() {
                                  pushMqtt(
                                      "imedotRoom/" +
                                          (myRoomId) +
                                          "/game",
                                      'truth,');
                                  MqttListen1.truth_dare_view = false;
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('大冒險'),
                              onPressed: () {
                                setState(() {
                                  pushMqtt(
                                      "imedotRoom/" +
                                          (myRoomId) +
                                          "/game",
                                      'dare,');
                                  MqttListen1.truth_dare_view = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    MqttListen1.pass_view
                        ? Visibility(
                      visible: MqttListen1.pass_view,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text(
                                '完成',
                              ),
                              onPressed: () {
                                setState(() {
                                  pushMqtt(
                                      "imedotRoom/" +
                                          (myRoomId) +
                                          "/game",
                                      'next_game,');
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('懲罰'),
                              onPressed: () {
                                setState(() {
                                  pushMqtt(
                                      "imedotRoom/" +
                                          (myRoomId) +
                                          "/game",
                                      'backend_punish,' + T_D_player);
                                  MqttListen1.pass_view = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    MqttListen1.next_view
                        ? Visibility(
                      visible: MqttListen1.next_view,
                      child: Align(
                        alignment: Alignment.center,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              child: Text('下一回合'),
                              onPressed: () {
                                setState(() {
                                  pushMqtt(
                                      "imedotRoom/" +
                                          (myRoomId) +
                                          "/game",
                                      'next_game,');
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : Container(),
                    MqttListen1.text_view_start
                        ? Visibility(
                      visible: MqttListen1.text_view_start,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: <Widget>[
                              Text(
                                '開始遊戲',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 60,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                '開始遊戲',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 60,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                    )
                        : Container(),
                    MqttListen1.text_view_be_choose
                        ? Visibility(
                      visible: MqttListen1.text_view_be_choose,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: <Widget>[
                              Text(
                                '${MqttListen1.BeChosen}號玩家被選擇了!\n請選擇真心話或大冒險',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                '${MqttListen1.BeChosen}號玩家被選擇了!\n請選擇真心話或大冒險',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                    )
                        : Container(),
                    MqttListen1.text_view_choose_T
                        ? Visibility(
                      visible: MqttListen1.text_view_choose_T,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: <Widget>[
                              Text(
                                '${MqttListen1.BeChosen}號玩家選擇的是真心話',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                '${MqttListen1.BeChosen}號玩家選擇的是真心話',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                    )
                        : Container(),
                    MqttListen1.text_view_choose_D
                        ? Visibility(
                      visible: MqttListen1.text_view_choose_D,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: <Widget>[
                              Text(
                                '${MqttListen1.BeChosen}號玩家選擇的是大冒險',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                '${MqttListen1.BeChosen}號玩家選擇的是大冒險',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                    )
                        : Container(),
                    MqttListen1.text_view_punish
                        ? Visibility(
                      visible: MqttListen1.text_view_punish,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: <Widget>[
                              Text(
                                '${MqttListen1.BeChosen}號玩家的懲罰是\n${MqttListen1.Punish}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
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
                        : Container(),
                    MqttListen1.text_view_notify_king
                        ? Visibility(
                      visible: MqttListen1.text_view_notify_king,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            children: <Widget>[
                              Text(
                                '恭喜 ${(int.parse(king)) + 1} 號玩家成為國王',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 6
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                '恭喜 ${(int.parse(king)) + 1} 號玩家成為國王',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )),
                    )
                        : Container(),
                  ]),
                ),
              ]);
            })
          ],
        ),
      ),
    );
  }
}
