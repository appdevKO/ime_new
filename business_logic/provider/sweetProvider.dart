import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/dbuserinfo_model.dart';
import 'package:ime_new/ui/live/sweet/sweetView.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:ime_new/business_logic/model/sweetRoom.dart';
import 'package:ime_new/business_logic/model/audience.dart';
import 'package:ime_new/business_logic/model/anchor.dart';
import 'package:ime_new/business_logic/model/gift.dart';
import 'package:ime_new/business_logic/model/sweetGif.dart';
import 'package:ime_new/utils/mymongo.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:queue/queue.dart';

String myUid = getUid();
String myAgoraUid = myUid;
String channelToken = '';
String roomName = '';
var sweetRoomId;
final gifQueue = ListQueue<int>();

///之後要換掉 伺服器
final client = MqttServerClient.withPort('iot.gotcash.me', myUid, 1883);
const appId = '27e69b885f864b0da5a75265e8c96cdb';

class ChatMessage {
  String account;
  String messageContent;
  ChatMessage({required this.account, required this.messageContent});
}

class sweetProvider with ChangeNotifier {
  var remoteUserInfo;
  var rooms;
  var anchorID;
  var anchorName;
  var giftList;
  int? roomCount;
  int donateCount = 0;
  int sendCount = 1;
  List accountList = [];
  List audienceList = [];
  String audienceCount = '0';
  String roomNam = '';
  String roomExplain = '';
  String inRoomAvatar = '';
  String selfAccount = '';
  String selfName = '';
  String selfEncodeName = '';
  String vipName = '';
  String senderName = '';
  String giftName = '';
  String giftMusicUrl = '';
  bool vdoStatus = false;
  bool imAnchor = false;
  bool giftAnime = false;
  bool giftMusic = false;
  bool vipAnime = false;
  bool cantTalk = false;
  MongoDB _mongoDB = MongoDB();

  List borderList = List.filled(19, false, growable: true);
  List<ChatMessage> messages = [];
  List giftIcon = [
    "bag",
    "bridal_sedan_chair",
    "cupid",
    "flower",
    "helicopter",
    "love99",
    "necklace",
    "perfume",
    "private_aircraft",
    "pumpkin_carriage",
    'ring',
    "shoes",
    "sports_car",
    "ten_thousand_years",
    "victorias_secret",
    'villa',
    'whole_world',
    'wrist_watch',
    'yacht'
  ];
  List giftText = [
    "包包",
    "花轎",
    "cupid",
    "flower",
    "helicopter",
    "love99",
    "necklace",
    "perfume",
    "private_aircraft",
    "pumpkin_carriage",
    'ring',
    "shoes",
    "sports_car",
    "ten_thousand_years",
    "victorias_secret",
    'villa',
    'whole_world',
    'wrist_watch',
    'yacht'
  ];
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
    client.updates!.listen((dynamic c) async {
      final MqttPublishMessage recMess = c[0].payload;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      // print('topic is <${c[0].topic}>, payload is <-- $pt -->');

      if ('${c[0].topic}' == 'imeSweet/info') {
        // print('myUid $myUid');
        Iterable l = json.decode('$pt');
        rooms =
            RxList<sweetRoom>.from(l.map((model) => sweetRoom.fromJson(model)));
        notifyListeners();
      } else if ('${c[0].topic}' == 'imeSweetUser/' + myUid) {
        if ('$pt'.startsWith('anchor')) {
          //主播用
          print('anchor $pt');
          Map<String, dynamic> anchorMap = jsonDecode("{" + pt.split(',{')[1]);
          var anchor = Anchor.fromJson(anchorMap);
          //Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          myRoomSeatIndex = 1;
          sweetRoomId = anchor.roomId;
          vdoStatus = anchor.vdoStatus;
          notifyListeners();
          print(sweetRoomId);
          inRoomAvatar = anchor.selfAvatar;
          selfEncodeName = anchor.selfEncodeName;

          selfName = encodeToString(selfEncodeName);
          anchorName = selfName;
          selfAccount = anchor.selfAccount;

          donateCount = (await _mongoDB.sweetGetDonate("member", selfAccount));
          print('donateCount ${donateCount}');
          client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);

          Get.to(sweetView(
            title: sweetRoomId,
          ));
          notifyListeners();
          imAnchor = true;
        } else if ('$pt'.startsWith('audience,')) {
          //觀眾用
          print('audience $pt');
          Map<String, dynamic> audienceMap =
              jsonDecode("{" + pt.split(',{')[1]);
          var audience = Audience.fromJson(audienceMap);
          anchorID = int.parse(audience.anchorId);
          if (audience.vdoStatus == 'true') {
            vdoStatus = true;
          }
          notifyListeners();
          print('audience json $json');
          sweetRoomId = audience.roomId;
          inRoomAvatar = audience.anchorAvatar;
          client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);
          pushMqtt('imeSweetRoom/' + sweetRoomId, 'get/allAudience');
          selfAccount = audience.selfAccount;
          selfEncodeName = audience.selfEncodeName;
          anchorName = encodeToString((audience.encodeAnchorName));
          String anchorAccount = (audience.anchorAccount);
          donateCount =
              (await _mongoDB.sweetGetDonate("member", anchorAccount));
          giftList = await _mongoDB.sweetGetAllGift('gift', Gift.fromJson);
          for (int i = 0; i < 2; i++) {
            print(giftList[i].icon_url);
          }
          // if (json["vip"] == 'true') {
          //   pushMqtt('imeSweetRoom/' + sweetRoomId, 'vipIn,'+strToEncode(selfName));
          // }
          Get.to(sweetView(
            title: sweetRoomId,
          ));
          notifyListeners();
        }
      } else if ('${c[0].topic}' == ('imeSweetRoom/' + sweetRoomId)) {
        if ('$pt'.startsWith('post/allAudience')) {
          Map<String, dynamic> info;
          Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          print('list json $json');
          audienceCount = json["count"];
          List accountJsonList = json["accountList"].split(',');
          for (var item in accountJsonList) {
            //print('aaa $item');
            info = await _mongoDB.sweetGetUserList('member', item);
            //print('cccc $info');
            audienceList.add(info);
          }
          //print('bbbb ${accountList}');
          notifyListeners();
        } else if ('$pt'.startsWith('leaveRoom,')) {
          if (pt.split(',')[2] == selfAccount) {
            //self 變數歸0 觀眾數量-1
            //other 由java運算扣除後 get/allAudience 傳給所有in room 所有人
            donateCount = 0;
            sendCount = 1;
            accountList = [];
            audienceList = [];
            messages = [];
            audienceCount = '0';
            roomNam = '';
            roomExplain = '';
            inRoomAvatar = '';
            selfAccount = '';
            selfName = '';
            selfEncodeName = '';
            vipName = '';
            senderName = '';
            giftName = '';
            giftMusicUrl = '';
            giftMusic = false;
            giftMusic = false;
            vdoStatus = false;
            giftAnime = false;
            vipAnime = false;
            cantTalk = false;
            borderList = List.filled(19, false, growable: true);
          } else {}
          notifyListeners();
        } else if ('$pt'.startsWith('vip,')) {
          vipName = encodeToString(pt.split(',')[1]);
          vipAnime = true;
          notifyListeners();

          Timer(const Duration(milliseconds: 9400), () async {
            vipAnime = false;
            notifyListeners();
          });
        } else if ('$pt'.startsWith('addChatMsg')) {
          List msg = pt.split(',');
          print('addChatMsg $msg');
          messages.addAll([
            ChatMessage(
                account: encodeToString(msg[1]) + " : ",
                messageContent: encodeToString(msg[2])),
          ]);
          notifyListeners();
        } else if ('$pt'.startsWith('vdoHide,')) {
          String _vdosta = '$pt'.split(',')[1];
          print('vdoHide $_vdosta');
          if (_vdosta == 'true') {
            vdoStatus = true;
          } else if (_vdosta == 'false') {
            vdoStatus = false;
          }
          notifyListeners();
        } else if ('$pt'.startsWith('gif/enQue')) {
          Map<String, dynamic> gifMap = jsonDecode("{" + pt.split(',{')[1]);
          print('gif/enQue $gifMap');
          var gif = SweetGif.fromJson(gifMap);
          print('gif/enQue' + json.toString());
          donateCount = gif.afterValue;
          notifyListeners();
          gifQueue.add(jsonDecode("{" + pt.split(',{')[1]));
          print(gifQueue);
        } else if ('$pt'.startsWith('gif/play')) {
          gifQueue.removeFirst();
          Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          print('gif/play' + json.toString());
          senderName = encodeToString(json["senderName"]);
          giftName = encodeToString(json["giftName"]);
          giftMusicUrl = await encodeToString(json["musicUrl"]);
          if ((giftMusicUrl.length) > 0) {
            giftMusic = true;
          }
          giftAnime = true;
          notifyListeners();
        } else if ('$pt'.startsWith('ban/talk,')) {
          String bannedName = encodeToString('$pt'.split(',')[1]);
          if (bannedName == selfName) {
            cantTalk = true;
            notifyListeners();
          }
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

encodeToString(encode) {
  String encodeName = utf8.decode(encode.runes.toList());
  List<int> resName = base64.decode(base64.normalize(encodeName));
  return utf8.decode(resName);
}

strToEncode(s) {
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  return stringToBase64.encode(s);
}
