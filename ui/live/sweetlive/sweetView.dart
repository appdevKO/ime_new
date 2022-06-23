// import 'dart:async';
// import 'dart:developer';
//
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:agora_rtc_rawdata/agora_rtc_rawdata.dart';
// import 'package:faceunity_ui/Faceunity_ui.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:ime_new/business_logic/provider/sweetProvider.dart';
// import 'package:ime_new/ui/live/sweetlive/sweetlive_list.dart';
//
// import 'package:permission_handler/permission_handler.dart';
// import 'package:get/get.dart';
//
// import 'package:provider/provider.dart';
// import 'package:mqtt_client/mqtt_client.dart';
//
// // 開播 看直播畫面
// int myRoomSeatIndex = 0;
// String T_D_player = "";
// const appId = '27e69b885f864b0da5a75265e8c96cdb';
//
// class sweetView extends StatefulWidget {
//   const sweetView({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<sweetView> createState() => _theRoomState();
// }
//
// class _theRoomState extends State<sweetView> with TickerProviderStateMixin {
//   String msg = "";
//   AnimationController? _controller;
//   RtcEngine? engine;
//   bool isJoined = false;
//   bool isSelfMute = false;
//   bool isSelfHide = false;
//   List<int> remoteUid = [];
//   final _gridViewKey = GlobalKey();
//   final TextEditingController _chatController = new TextEditingController();
//   final List<Widget> _message = [];
//   Size? _gridViewSize;
//
//   void getSize() {
//     setState(() {
//       _gridViewSize = _gridViewKey.currentContext!.size;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 2));
//     // myUid = getUid();
//     // MqttListen().resetSeats();
//     Future(() async {
//       // myAgoraUid = getUid();
//       myAgoraUid = myUid;
//       final builder = MqttClientPayloadBuilder();
//       builder.addString("iamjoined," + identity.toString() + "," + myAgoraUid);
//       await client.publishMessage(
//           "imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce, builder.payload!);
//     });
//
//     client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);
//
//     this._initEngine();
//   }
//
//   @override
//   void deactivate() {
//     print('有沒有啦啦啦');
//     engine!.muteAllRemoteVideoStreams(true);
//     engine!.muteAllRemoteAudioStreams(true);
//     engine!.disableVideo();
//     engine!.leaveChannel();
//     this._deinitEngine();
//
//     client.subscribe("imeSweetRoom/info", MqttQos.atLeastOnce);
//
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     // this._deinitEngine();
//   }
//
//   _initEngine() async {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       await [Permission.microphone, Permission.camera].request();
//     }
//     engine = await RtcEngine.create(appId);
//     engine!.setRemoteDefaultVideoStreamType(VideoStreamType.Low);
//     // engine!.enableDualStreamMode(true);
//     engine!.disableVideo();
//     engine!.setEventHandler(
//         RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
//       log('joinChannelSuccess $channel $uid $elapsed');
//       setState(() {
//         isJoined = true;
//       });
//     }, userJoined: (uid, elapsed) {
//       log('userJoined  $uid $elapsed');
//       setState(() {
//         remoteUid.add(uid);
//         engine!.muteAllRemoteVideoStreams(false);
//       });
//     }, userOffline: (uid, reason) {
//       log('userJoined  $uid $reason');
//       setState(() {
//         remoteUid.removeWhere((element) => element == uid);
//       });
//     }));
//     await engine!.enableVideo();
//     await engine!.startPreview();
//     setState(() {});
//     var handle = await engine!.getNativeHandle();
//     if (handle != null) {
//       await AgoraRtcRawdata.registerAudioFrameObserver(handle);
//       await AgoraRtcRawdata.registerVideoFrameObserver(handle);
//     }
//
//     await engine!
//         .joinChannel(channelToken, sweetRoomId, null, int.parse(myAgoraUid));
//
//     //关闭本地声音
//     await engine!.muteLocalAudioStream(false);
//     //关闭远程声音
//     await engine!.muteAllRemoteVideoStreams(false);
//     await engine!.muteAllRemoteAudioStreams(false);
//
//     VideoEncoderConfiguration videoConfig =
//         VideoEncoderConfiguration(frameRate: VideoFrameRate.Fps30);
//     await engine!.setVideoEncoderConfiguration(videoConfig);
//     await engine!.enableLocalAudio(isSelfMute);
//     await engine!.enableLocalVideo(isSelfHide);
//   }
//
//   _deinitEngine() async {
//     await AgoraRtcRawdata.unregisterAudioFrameObserver();
//     await AgoraRtcRawdata.unregisterVideoFrameObserver();
//     // await engine!.destroy();
//   }
//
//   void _submitText(String text) {
//     msg = text;
//     _chatController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () {
//               final builder = MqttClientPayloadBuilder();
//               builder.addString("leaveRoom," + identity.toString());
//               client.publishMessage("imeSweetRoom/" + sweetRoomId,
//                   MqttQos.atLeastOnce, builder.payload!);
//               client.unsubscribe("imeSweetRoom/" + sweetRoomId);
//               client.unsubscribe("imeSweetUser/" + myUid);
//               myUid = getUid();
//               client.subscribe("imeSweetUser/" + myUid, MqttQos.atLeastOnce);
//               print('訂閱新Uid $myUid');
//               Get.back();
//             },
//           ),
//           title: Text(
//             roomName,
//             textAlign: TextAlign.center,
//           ),
//           flexibleSpace: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: <Color>[Color(0xffff7090), Color(0xfff0c0c0)],
//               ),
//             ),
//           ),
//         ),
//         body: Stack(
//           children: [
//             Consumer<sweetProvider>(builder: (context, _sweetProvider, child) {
//               print('seatId1 ${_sweetProvider.seatId1}');
//               print('sweetRoomId ${sweetRoomId}');
//               return Stack(children: <Widget>[
//                 identity!
//                     ? isSelfHide == false
//                         ? Stack(
//                             children: [
//                               Container(
//                                 child: Image.network(
//                                   _sweetProvider.inRoomAvatar,
//                                   fit: BoxFit.cover,
//                                   height: double.infinity,
//                                   width: double.infinity,
//                                   alignment: Alignment.center,
//                                 ),
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Align(
//                                           alignment: Alignment.bottomLeft,
//                                           child: IconButton(
//                                             icon: Image.asset(
//                                                 'assets/images/camera-w.png'),
//                                             iconSize: 3,
//                                             onPressed: () {
//                                               engine!.switchCamera();
//                                             },
//                                           ),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: IconButton(
//                                             icon: Image.asset(
//                                                 'assets/images/mic-off-w.png'),
//                                             iconSize: 3,
//                                             onPressed: () {
//                                               setState(() {
//                                                 isSelfMute = !isSelfMute;
//                                               });
//                                               engine!
//                                                   .enableLocalAudio(isSelfMute);
//                                             },
//                                           ),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomRight,
//                                           child: IconButton(
//                                             icon: Image.asset(
//                                                 'assets/images/vdo-off-w.png'),
//                                             iconSize: 3,
//                                             onPressed: () {
//                                               setState(() {
//                                                 isSelfHide = !isSelfHide;
//                                                 pushMqtt(
//                                                     "imeSweetRoom/" +
//                                                         sweetRoomId,
//                                                     "vdoHide,$isSelfHide");
//                                               });
//                                               engine!
//                                                   .enableLocalVideo(isSelfHide);
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   FaceunityUI(
//                                     cameraCallback: () =>
//                                         engine!.switchCamera(),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         : Stack(
//                             children: [
//                               RtcLocalView.SurfaceView(),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Align(
//                                           alignment: Alignment.bottomLeft,
//                                           child: IconButton(
//                                             icon: Image.asset(
//                                                 'assets/images/camera.png'),
//                                             iconSize: 3,
//                                             onPressed: () {
//                                               engine!.switchCamera();
//                                             },
//                                           ),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: IconButton(
//                                             icon: Image.asset(
//                                                 'assets/images/mic-off.png'),
//                                             iconSize: 3,
//                                             onPressed: () {
//                                               setState(() {
//                                                 isSelfMute = !isSelfMute;
//                                               });
//                                               engine!
//                                                   .enableLocalAudio(isSelfMute);
//                                             },
//                                           ),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomRight,
//                                           child: IconButton(
//                                             icon: Image.asset(
//                                                 'assets/images/vdo-off.png'),
//                                             iconSize: 3,
//                                             onPressed: () {
//                                               setState(() {
//                                                 isSelfHide = !isSelfHide;
//                                                 pushMqtt(
//                                                     "imeSweetRoom/" +
//                                                         sweetRoomId,
//                                                     "vdoHide,$isSelfHide");
//                                               });
//                                               engine!
//                                                   .enableLocalVideo(isSelfHide);
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   FaceunityUI(
//                                     cameraCallback: () =>
//                                         engine!.switchCamera(),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                     : Stack(
//                         children: [
//                           _sweetProvider.vdoSta == false
//                               ? Container(
//                                   child: Image.network(
//                                     _sweetProvider.inRoomAvatar,
//                                     fit: BoxFit.cover,
//                                     height: double.infinity,
//                                     width: double.infinity,
//                                     alignment: Alignment.center,
//                                   ),
//                                 )
//                               : Stack(
//                                   children: [
//                                     Container(
//                                       child: RtcRemoteView.SurfaceView(
//                                         uid: _sweetProvider.seatId1,
//                                         channelId: sweetRoomId,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                           Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Container(
//                                   margin: const EdgeInsets.only(bottom: 1.0),
//                                   child: Row(
//                                     children: <Widget>[
//                                       Flexible(
//                                         child: TextField(
//                                           decoration: InputDecoration(
//                                               contentPadding:
//                                                   EdgeInsets.all(16.0),
//                                               border: OutlineInputBorder(),
//                                               hintText: '輸入訊息'),
//                                           controller: _chatController,
//                                           onSubmitted: _submitText,
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.send),
//                                         onPressed: () {
//                                           _submitText(_chatController.text);
//                                           FocusScope.of(context)
//                                               .requestFocus(FocusNode());
//                                           if (msg != '') {}
//                                         },
//                                       ),
//                                     ],
//                                   ))),
//                         ],
//                       ),
//
//                 //传camera 回调显示 UI，不传不显示
//                 _sweetProvider.getGift_1
//                     ? Align(
//                         alignment: Alignment.center,
//                         child: Image.asset(
//                           'assets/images/bag.gif',
//                           width: 300,
//                           height: 300,
//                         ),
//                       )
//                     : Container(),
//               ]);
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
