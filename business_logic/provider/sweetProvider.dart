import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/dbuserinfo_model.dart';
import 'package:ime_new/ui/live/sweet/sweetView.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetRoom.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetAudience.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetAnchor.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetDbUserInfos.dart';
import 'package:ime_new/business_logic/model/localuserinfo_model.dart';
import 'package:ime_new/business_logic/model/gift.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetGif.dart';
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
final gifQueue = ListQueue<String>();
late List borderList;

///之後要換掉 伺服器
final client = MqttServerClient.withPort('iot.gotcash.me', myUid, 1883);
// const appId = '27e69b885f864b0da5a75265e8c96cdb';

class ChatMessage {
  String account;
  String messageContent;
  ChatMessage({required this.account, required this.messageContent});
}

class sweetProvider with ChangeNotifier {
  var remoteUserInfo;
  var rooms;
  var anchorName;
  var giftList;
  var anchorInfo;
  int? roomCount;
  int anchorID = 0;
  int donateCount = 0;
  int sendCount = 1;
  int previouClick = 0;
  int clicking = 0;
  int audienceCount = 0;
  List accountList = [];
  List audienceList = [];
  String roomNam = '';
  String roomExplain = '';
  String anchorAvatar = '';
  String selfAccount = '';
  String selfName = '';
  String selfEncodeName = '';
  String vipName = '';
  String senderName = '';
  String giftName = '';
  String giftMusicUrl = '';
  String gifUrl = '';
  String encodeAnchorName = '';
  bool vdoStatus = false;
  bool giftAnime = false;
  bool inRoomAnime = false;
  bool giftMusic = false;
  bool vipAnime = false;
  bool cantTalk = false;
  bool musicStop = false;
  bool offStreaming = false;
  bool chatroomRefresh = false;
  MongoDB _mongoDB = MongoDB();

  //List borderList = List.filled(19, false, growable: false);
  List<ChatMessage> messages = [];
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
    client.autoReconnect = true;

    final connMessage = MqttConnectMessage()
        .authenticateAs('username', 'password')
        .keepAliveFor(60)
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        //.startClean()
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
          var anchorJson = Anchor.fromJson(anchorMap);
          //Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          myRoomSeatIndex = 1;
          sweetRoomId = anchorJson.roomId;
          vdoStatus = anchorJson.vdoStatus;
          anchorAvatar = anchorJson.anchorAvatar;
          selfEncodeName = anchorJson.selfEncodeName;

          selfName = encodeToString(selfEncodeName);
          anchorName = selfName;
          selfAccount = anchorJson.selfAccount;

          giftList = await _mongoDB.sweetGetAllGift('gift', Gift.fromJson);
          borderList = List.filled(giftList.length, false, growable: false);
          Map<String, dynamic> dbInfoMap =
              await _mongoDB.sweetGetUserInfo('member', selfAccount);
          anchorInfo = sweetDbUserInfos.fromJson(dbInfoMap);
          donateCount = anchorInfo.get_donate_count;
          client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);
          notifyListeners();
          Get.to(sweetView(
            title: sweetRoomId,
          ));
        } else if ('$pt'.startsWith('audience,')) {
          //觀眾用
          print('audience $pt');
          Map<String, dynamic> audienceMap =
              jsonDecode("{" + pt.split(',{')[1]);
          var audience = Audience.fromJson(audienceMap);
          anchorID = await int.parse(audience.anchorId);

          if (audience.vdoStatus == 'true') {
            vdoStatus = true;
          }
          sweetRoomId = audience.roomId;
          anchorAvatar = audience.anchorAvatar;
          client.subscribe("imeSweetRoom/" + sweetRoomId, MqttQos.atLeastOnce);
          pushMqtt('imeSweetRoom/' + sweetRoomId, 'get/allAudience');
          selfAccount = audience.selfAccount;
          selfEncodeName = audience.selfEncodeName;
          selfName = encodeToString(selfEncodeName);
          anchorName = encodeToString((audience.encodeAnchorName));
          String anchorAccount = (audience.anchorAccount);
          donateCount =
              (await _mongoDB.sweetGetDonate("member", anchorAccount));
          giftList = await _mongoDB.sweetGetAllGift('gift', Gift.fromJson);
          borderList = List.filled(giftList.length, false, growable: false);
          Map<String, dynamic> dbInfoMap =
              await _mongoDB.sweetGetUserInfo('member', anchorAccount);
          anchorInfo = sweetDbUserInfos.fromJson(dbInfoMap);
          // if (json["vip"] == 'true') {
          //   pushMqtt('imeSweetRoom/' + sweetRoomId, 'vipIn,'+strToEncode(selfName));
          // }
          Get.to(sweetView(
            title: sweetRoomId,
          ));
          notifyListeners();
          pushMqtt('imeSweetRoom/' + sweetRoomId,
              'addChatMsg,' + selfEncodeName + ',5bey5Yqg5YWl');
        }
      } else if ('${c[0].topic}' == ('imeSweetRoom/' + sweetRoomId)) {
        if ('$pt'.startsWith('post/allAudience')) {
          print(pt);
          Map<String, dynamic> info;
          Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          print('list json $json');
          List accountJsonList = json["accountList"].split(',');
          for (var account in accountJsonList) {
            info = await _mongoDB.sweetGetUserInfo('member', account);
            audienceList.add(info);
          }
          audienceCount = audienceList.length;
          print('audienceList ${audienceList}');
          print('audienceList ${audienceList[0]["avatar_sub"]}');
          print('audienceCount ${audienceCount}');
          notifyListeners();
        } else if ('$pt'.startsWith('leaveRoom,')) {
          if (pt.split(',')[1] == 'true') {
            donateCount = 0;
            sendCount = 1;
            accountList = [];
            audienceList = [];
            audienceCount = 0;
            roomNam = '';
            roomExplain = '';
            anchorAvatar = '';
            selfAccount = '';
            selfName = '';
            selfEncodeName = '';
            vipName = '';
            senderName = '';
            giftName = '';
            giftMusicUrl = '';
            gifUrl = '';
            vdoStatus = false;
            giftAnime = false;
            giftMusic = false;
            vipAnime = false;
            cantTalk = false;
            musicStop = false;
            chatroomRefresh = false;
            messages = [];
            gifQueue.clear();
            offStreaming = true;
            notifyListeners();
            offStreaming = false;
          } else if (pt.split(',')[2] == selfAccount) {
            //self 變數歸0 觀眾數量-1
            //other 由java運算扣除後 get/allAudience 傳給所有in room 所有人
            donateCount = 0;
            sendCount = 1;
            accountList = [];
            audienceList = [];
            audienceCount = 0;
            roomNam = '';
            roomExplain = '';
            anchorAvatar = '';
            selfAccount = '';
            selfName = '';
            selfEncodeName = '';
            vipName = '';
            senderName = '';
            giftName = '';
            giftMusicUrl = '';
            gifUrl = '';
            vdoStatus = false;
            giftAnime = false;
            giftMusic = false;
            vipAnime = false;
            cantTalk = false;
            musicStop = false;
            chatroomRefresh = false;

            messages = [];
            gifQueue.clear();
          } else {
            audienceList.removeWhere(
                (element) => element["account"] == pt.split(',')[2]);
            audienceCount = audienceList.length;
            //print('cccc ${audienceCount}');
          }
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
          //print('addChatMsg $msg');
          messages.addAll([
            ChatMessage(
                account: encodeToString(msg[1]) + " : ",
                messageContent: encodeToString(msg[2])),
          ]);
          notifyListeners();
          pushMqtt("imeSweetRoom/" + sweetRoomId, "chatroom/refresh");
        } else if ('$pt'.startsWith('vdoHide,')) {
          String _vdosta = '$pt'.split(',')[1];
          //print('vdoHide $_vdosta');
          if (_vdosta == 'true') {
            vdoStatus = true;
          } else if (_vdosta == 'false') {
            vdoStatus = false;
          }
          notifyListeners();
        } else if ('$pt'.startsWith('gif/enQue')) {
          //if (pt.split(',')[3] == encodeAnchorName) {
            gifQueue.add("{" + pt.split(',{')[1]);
            notifyListeners();
          //}
        } else if ('$pt'.startsWith('put/donateCount')) {
          //donateCount = pt.split(',')[1];
          //notifyListeners();
        } else if ('$pt'.startsWith('gif/play')) {
          Map<String, dynamic> json = jsonDecode("{" + pt.split(',{')[1]);
          var gifJson = SweetGif.fromJson(json);
          gifUrl = 'https://storage.googleapis.com/ime-gift/gif/' +
              (await encodeToString(gifJson.giftName)) +
              '.gif';
          giftAnime = true;
          print('go');
          notifyListeners();
          giftMusicUrl = await encodeToString(gifJson.musicUrl);
          if (giftMusicUrl.length > 0) {
            giftMusic = true;
          }
          notifyListeners();
          int ms = int.parse(encodeToString(gifJson.ms)) + 2000;

          Timer(Duration(milliseconds: ms), () {
            giftAnime = false;
            musicStop = true;
            notifyListeners();
          });
        } else if ('$pt'.startsWith('ban/talk,')) {
          String bannedName = encodeToString('$pt'.split(',')[1]);
          if (bannedName == selfName) {
            cantTalk = true;
            notifyListeners();
          }
        } else if ('$pt'.startsWith('chatroom/refresh')) {
          chatroomRefresh = true;
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
  for (int i = 0; i < 10; i++) {
    if (i == 0) {
      randomNumber = random.nextInt(4) + 1;
    } else {
      randomNumber = random.nextInt(10);
    }
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
