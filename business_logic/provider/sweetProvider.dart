import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/sweet/sweetView.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:ime_new/business_logic/model/sweetRoom.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

String myUid = getUid();
String myAgoraUid = myUid;
String channelToken = '';
String roomName = '';
var sweetRoomId;

///之後要換掉 伺服器
final client = MqttServerClient.withPort('iot.gotcash.me', myUid, 1883);
const appId = '27e69b885f864b0da5a75265e8c96cdb';

class ChatMessage {
  String account;
  String messageContent;
  ChatMessage({required this.account, required this.messageContent});
}

class sweetProvider with ChangeNotifier {
  var rooms;
  var roomId;
  var anchorID;
  var anchorName;
  int? roomCount;
  int? AudienceCount;
  String roomNam = '';
  String roomExplain = '';
  String inRoomAvatar = '';
  bool vdoSta = false;
  bool getGift_1 = false;

  Future<MqttServerClient> connect() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Permission.camera.request();
    await Permission.microphone.request();

    client.logging(on: false);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    // client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .authenticateAs('username', 'password')
        .keepAliveFor(60)
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect('sayhong_test', 'HoolyHi168888');
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.subscribe("imeSweet/info", MqttQos.atLeastOnce);
    client.subscribe("imeSweetUser/" + myUid, MqttQos.atLeastOnce);
    client.updates!.listen((dynamic c) {
      final MqttPublishMessage recMess = c[0].payload;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // print('topic is <${c[0].topic}>, payload is <-- $pt -->');

      if ('${c[0].topic}' == 'imeSweet/info') {
        // print('myUid $myUid');
        Iterable l = json.decode('$pt');
        rooms =
            RxList<sweetRoom>.from(l.map((model) => sweetRoom.fromJson(model)));

        //print('aaa');
        //print(rooms[0].explain);
        notifyListeners();
      } else if ('${c[0].topic}' == 'imeSweetUser/' + myUid) {
        if ('$pt'.startsWith('anchor')) {
          //主播用
          print('anchor $pt');
          Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          myRoomSeatIndex = 1;
          sweetRoomId = json["rid"];
          inRoomAvatar = json["avatarUrl"];
          anchorName = encodeToString(json['anchorName']);
          print('anchorName ${anchorName}');
          pushMqtt("imeSweetUser/postChannel", sweetRoomId + ',' + myUid);
          client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);

          Get.to(sweetView(
            title: sweetRoomId,
          ));
          notifyListeners();
        } else if ('$pt'.startsWith('audience,')) {
          //觀眾用
          //print('audience $pt');
          Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          print('json $json');
          sweetRoomId = json['rid'];
          inRoomAvatar = json['avatarUrl'];
          pushMqtt("imeSweetUser/postChannel", sweetRoomId + ',' + myUid);
          if (json['vdoSta'] == 'true') {
            vdoSta = true;
          }
          anchorID = json['anchorID'];
          anchorName = encodeToString(json['anchorName']);
          print('anchor $anchorName');
          client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);

          Get.to(sweetView(
            title: sweetRoomId,
          ));
          notifyListeners();
        } else if ('$pt'.startsWith('getToken,')) {
          channelToken = '$pt'.split(',')[1];
          print('getToken $channelToken');
        }
      } else if ('${c[0].topic}' == ('imeSweetRoom/' + sweetRoomId)) {
        // 從MQTT收新人入房消息，改變瀏覽器網址
        if ('$pt'.startsWith('postAudienceCount,')) {
          AudienceCount = int.parse('$pt'.split(',')[1]);
          notifyListeners();
        } else if ('$pt'.startsWith('leaveRoom,')) {
          anchorID = null;
          vdoSta = false;
          print('leave');
          notifyListeners();
        } else if ('$pt'.startsWith('vdoHide,')) {
          String _vdosta = '$pt'.split(',')[1];
          print('vdoHide $_vdosta');
          if (_vdosta == 'true') {
            vdoSta = true;
          } else if (_vdosta == 'false') {
            vdoSta = false;
          }
          notifyListeners();
        }
      }
    });

    return client;
  }
}

// 连接成功
void onConnected() {
  print('sweet Connected');
}

// 连接断开
void onDisconnected() {
  print('Disconnected');
}

// 订阅主题成功
void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

// 订阅主题失败
void onSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}

// 成功取消订阅
void onUnsubscribed(String topic) {
  print('Unsubscribed topic: $topic');
}

// 收到 PING 响应
void pong() {
  print('Ping response client callback invoked');
}

pushMqtt(String pubTopic, String content) {
  final builder = MqttClientPayloadBuilder();
  builder.addString(content);
  client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
}

getUid() {
  String s = '';
  var randomList = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  var randomNumber;
  Random random = new Random();
  for (int i = 0; i < 9; i++) {
    randomNumber = random.nextInt(10);
    s += (randomList[randomNumber]);
  }
  return s;
}

encodeToString(s) {
  String encodeName = utf8.decode(s.runes.toList());
  List<int> resName = base64.decode(base64.normalize(encodeName));
  return utf8.decode(resName);
}
