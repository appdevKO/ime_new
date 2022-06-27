import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/truth_or_dare/roomListTable.dart';
import 'package:ime_new/ui/live/truth_or_dare/theRoom.dart';
import 'package:ime_new/business_logic/model/TD_room.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

String myUid = getUid();
String myAgoraUid = myUid;
String king = '';
String channelToken = '';
String roomName = '';

///之後要換掉 伺服器
final client = MqttServerClient.withPort('iot.gotcash.me', myUid, 1883);
const appId = '27e69b885f864b0da5a75265e8c96cdb';

var myRoomId;
var pos;
var punish_list = [
  '三回合不能當國王',
  // '要套醜臉VR',
  '清唱一首歌',
  '開鏡頭扮鬼臉',
  '學丟丟妹樓頂揪樓咖。\n阿母揪阿爸',
  '學亞洲空幹王跳空幹舞',
  '對在場的一位真心告白',
  '開合跳10下',
  '用屁股寫名字',
  '大象鼻子轉10圈',
  '聞自己的腳丫子10秒',
  '分享人生最糗的事',
  '模仿大猩猩',
  '擺一個你認為\n異性最具代表性的姿勢',
  '頭頂一樣物品10秒不能掉',
  '表演喜怒哀樂',
  '做一個最性感的動作',
  '說一個笑話',
  '分享一個最難忘的戀人',
  '深蹲十秒鐘',
  '講一個鬼故事',
  '分享你喜歡的異性類型',
  '說出你的三圍',
  '選任一玩家對看十秒',
  '分享到目前為止的人生觀',
  '分享自己的秘密嗜好',
  '聞自己腋下十秒',
  '青蛙跳五下',
  '選任一玩家撒嬌',
  '用豬鼻子學豬叫三下'
];

class TD_game with ChangeNotifier {
  String BeChosen = '';
  String Punish = '';
  int? TDseatId1 = null;
  int? TDseatId2 = null;
  int? TDseatId3 = null;
  int? TDseatId4 = null;
  String avatarUrl1 = '';
  String avatarUrl2 = '';
  String avatarUrl3 = '';
  String avatarUrl4 = '';
  bool roulette_wheel_view = false;
  bool scepter = false;
  bool youOut = false;
  bool crown_view_1 = false;
  bool crown_view_2 = false;
  bool crown_view_3 = false;
  bool crown_view_4 = false;
  bool hat_view_1 = false;
  bool hat_view_2 = false;
  bool hat_view_3 = false;
  bool hat_view_4 = false;
  bool out_view_2 = false;
  bool out_view_3 = false;
  bool out_view_4 = false;
  bool vdoSta_1 = false; //T=隱藏 F=打開 , theRoom isSelfHide
  bool vdoSta_2 = false;
  bool vdoSta_3 = false;
  bool vdoSta_4 = false;
  bool choose_button_view_1 = false;
  bool choose_button_view_2 = false;
  bool choose_button_view_3 = false;
  bool choose_button_view_4 = false;
  bool truth_dare_view_1 = false;
  bool truth_dare_view_2 = false;
  bool truth_dare_view_3 = false;
  bool truth_dare_view_4 = false;
  bool pass_view_1 = false;
  bool pass_view_2 = false;
  bool pass_view_3 = false;
  bool pass_view_4 = false;
  bool next_view = false;
  bool text_view_start = false;
  bool text_view_be_choose = false;
  bool text_view_choose_T = false;
  bool text_view_choose_D = false;
  bool text_view_punish = false;
  bool text_view_notify_king = false;
  bool stopGame = false;
  bool firstOut = true;
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
      //print('Exception: $e');
      client.disconnect();
    }

    client.subscribe("imedot/info", MqttQos.atLeastOnce);
    client.subscribe("imedotUser/" + myUid, MqttQos.atLeastOnce);
    client.updates!.listen((dynamic c) {
      final MqttPublishMessage recMess = c[0].payload;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      //print('topic is <${c[0].topic}>, payload is <-- $pt -->');

      if ('${c[0].topic}' == 'imedot/info') {
        RoomListController rx = Get.put(RoomListController());

        Iterable l = json.decode('$pt');
        var rooms = RxList<Room>.from(l.map((model) => Room.fromJson(model)));
        rx.roomsList.clear();
        for (Room r in rooms) {
          rx.roomsList.add(r);
        }
      } else if ('${c[0].topic}' == 'imedotUser/' + myUid) {
        // print('$pt');
        if ('$pt' == 'joinFail') {
          //print('沒位子');
        } else if ('$pt'.startsWith('join,')) {
          //print('data $pt');
          myRoomSeatIndex = int.parse('$pt'.split(',')[2]);
          myRoomId = '$pt'.split(',')[1];

          var encode = utf8.decode(('$pt'.split(',')[3]).runes.toList());
          List<int> res = base64.decode(base64.normalize(encode));
          roomName = (utf8.decode(res));
          pushMqtt("imedotUser/" + myUid, "getToken," + myRoomId);
          client.subscribe("imedotRoom/" + myRoomId, MqttQos.atLeastOnce);
          client.subscribe(
              "imedotRoom/" + myRoomId + "/game", MqttQos.atLeastOnce);

          Get.to(theRoom(
            title: myRoomId,
          ));
          BeChosen = '';
          Punish = '';
          roulette_wheel_view = false;
          scepter = false;
          crown_view_1 = false;
          crown_view_2 = false;
          crown_view_3 = false;
          crown_view_4 = false;
          hat_view_1 = false;
          hat_view_2 = false;
          hat_view_3 = false;
          hat_view_4 = false;
          choose_button_view_1 = false;
          choose_button_view_2 = false;
          choose_button_view_3 = false;
          choose_button_view_4 = false;
          truth_dare_view_1 = false;
          truth_dare_view_2 = false;
          truth_dare_view_3 = false;
          truth_dare_view_4 = false;
          pass_view_1 = false;
          pass_view_2 = false;
          pass_view_3 = false;
          pass_view_4 = false;
          text_view_start = false;
          text_view_be_choose = false;
          text_view_choose_T = false;
          text_view_choose_D = false;
          text_view_punish = false;
          text_view_notify_king = false;
          firstOut = true;
          notifyListeners();
        } else if ('$pt'.startsWith('postToken,')) {
          channelToken = '$pt'.split(',')[1];
          //print('getToken $channelToken');
        }
      } else if ('${c[0].topic}' == ('imedotRoom/' + myRoomId)) {
        // 從MQTT收新人入房消息，改變瀏覽器網址
        if ('$pt'.startsWith('getid,')) {
          var dataList = '$pt'.split(',');
          //print('dataList $dataList');
          if (dataList[2] != 'null') {
            TDseatId1 = int.parse(dataList[2].replaceAll(' ', ''));
            avatarUrl1 = dataList[10];
            if (dataList[6] == 'true') {
              vdoSta_1 = true;
            } else if (dataList[6] == 'false') {
              vdoSta_1 = false;
            }
          }
          if (dataList[3] != 'null') {
            avatarUrl2 = dataList[11];
            TDseatId2 = int.parse(dataList[3].replaceAll(' ', ''));
            if (dataList[7] == 'true') {
              vdoSta_2 = true;
            } else if (dataList[7] == 'false') {
              vdoSta_2 = false;
            }
          }
          if (dataList[4] != 'null') {
            avatarUrl3 = dataList[12];
            TDseatId3 = int.parse(dataList[4].replaceAll(' ', ''));
            if (dataList[8] == 'true') {
              vdoSta_3 = true;
            } else if (dataList[8] == 'false') {
              vdoSta_3 = false;
            }
          }
          if (dataList[5] != 'null') {
            avatarUrl4 = dataList[13];
            TDseatId4 = int.parse(dataList[5].replaceAll(' ', ''));
            if (dataList[9] == 'true') {
              vdoSta_4 = true;
            } else if (dataList[9] == 'false') {
              vdoSta_4 = false;
            }
          }
          //print('更新房間 $pt');
          notifyListeners();
        } else if ('$pt'.startsWith('leaveRoom,')) {
          var getSeatIndex = '$pt'.split(',')[1];
          String kicked = '$pt'.split(',')[2];
          if (myRoomSeatIndex.toString() == getSeatIndex) {
            TDseatId1 = null;
            TDseatId2 = null;
            TDseatId3 = null;
            TDseatId4 = null;
            avatarUrl1 = '';
            avatarUrl2 = '';
            avatarUrl3 = '';
            avatarUrl4 = '';

            if (kicked == 'true') {
              Get.back();
            }
          } else {
            if (getSeatIndex == '1') {
              vdoSta_1 = false;
              TDseatId1 = null;
            } else if (getSeatIndex == '2') {
              vdoSta_2 = false;
              TDseatId2 = null;
            } else if (getSeatIndex == '3') {
              vdoSta_3 = false;
              TDseatId3 = null;
            } else if (getSeatIndex == '4') {
              vdoSta_4 = false;
              TDseatId4 = null;
            }
          }
          stopGame = true;
          BeChosen = '';
          Punish = '';
          roulette_wheel_view = false;
          scepter = false;
          crown_view_1 = false;
          crown_view_2 = false;
          crown_view_3 = false;
          crown_view_4 = false;
          hat_view_1 = false;
          hat_view_2 = false;
          hat_view_3 = false;
          hat_view_4 = false;
          choose_button_view_1 = false;
          choose_button_view_2 = false;
          choose_button_view_3 = false;
          choose_button_view_4 = false;
          truth_dare_view_1 = false;
          truth_dare_view_2 = false;
          truth_dare_view_3 = false;
          truth_dare_view_4 = false;
          pass_view_1 = false;
          pass_view_2 = false;
          pass_view_3 = false;
          pass_view_4 = false;
          next_view = false;
          text_view_start = false;
          text_view_be_choose = false;
          text_view_choose_T = false;
          text_view_choose_D = false;
          text_view_punish = false;
          text_view_notify_king = false;
          notifyListeners();
        } else if ('$pt'.startsWith('go,')) {
          stopGame = false;
          BeChosen = '';
          Punish = '';
          roulette_wheel_view = false;
          scepter = false;
          crown_view_1 = false;
          crown_view_2 = false;
          crown_view_3 = false;
          crown_view_4 = false;
          hat_view_1 = false;
          hat_view_2 = false;
          hat_view_3 = false;
          hat_view_4 = false;
          choose_button_view_1 = false;
          choose_button_view_2 = false;
          choose_button_view_3 = false;
          choose_button_view_4 = false;
          truth_dare_view_1 = false;
          truth_dare_view_2 = false;
          truth_dare_view_3 = false;
          truth_dare_view_4 = false;
          pass_view_1 = false;
          pass_view_2 = false;
          pass_view_3 = false;
          pass_view_4 = false;
          next_view = false;
          text_view_start = false;
          text_view_be_choose = false;
          text_view_choose_T = false;
          text_view_choose_D = false;
          text_view_punish = false;
          text_view_notify_king = false;
          notifyListeners();
          king = '$pt'.split(',')[1]; //測試用
          //print('開始遊戲 $king');
          if (king == '0') {
            pos = 13.75;
          } else if (king == '1') {
            pos = 12.25;
          } else if (king == '2') {
            pos = 13.25;
          } else if (king == '3') {
            pos = 12.75;
          }
          Timer(const Duration(milliseconds: 500), () async {
            await pushMqtt("imedotRoom/" + (myRoomId) + "/game", 'start_text,');
          });
          Timer(const Duration(milliseconds: 2000 + 2000), () async {
            await pushMqtt(
                "imedotRoom/" + (myRoomId) + "/game", 'start_text_end,');
          });
          Timer(const Duration(milliseconds: 2200 + 2000), () async {
            await pushMqtt("imedotRoom/" + (myRoomId) + "/game", 'start,');
          });
          Timer(const Duration(milliseconds: 5200 + 2000), () async {
            await pushMqtt(
                "imedotRoom/" + (myRoomId) + "/game", 'pointer_end,');
          });
          Timer(const Duration(milliseconds: 5200 + 2000), () async {
            pushMqtt("imedotRoom/" + (myRoomId) + "/game", 'notify_king,');

            pushMqtt("imedotRoom/" + (myRoomId) + "/game", 'choose_one,');
          });
        } else if ('$pt'.startsWith('next_game,')) {
          BeChosen = '';
          Punish = '';
          roulette_wheel_view = false;
          scepter = false;
          crown_view_1 = false;
          crown_view_2 = false;
          crown_view_3 = false;
          crown_view_4 = false;
          hat_view_1 = false;
          hat_view_2 = false;
          hat_view_3 = false;
          hat_view_4 = false;
          choose_button_view_1 = false;
          choose_button_view_2 = false;
          choose_button_view_3 = false;
          choose_button_view_4 = false;
          truth_dare_view_1 = false;
          truth_dare_view_2 = false;
          truth_dare_view_3 = false;
          truth_dare_view_4 = false;
          pass_view_1 = false;
          pass_view_2 = false;
          pass_view_3 = false;
          pass_view_4 = false;
          next_view = false;
          text_view_start = false;
          text_view_be_choose = false;
          text_view_choose_T = false;
          text_view_choose_D = false;
          text_view_punish = false;
          text_view_notify_king = false;
          notifyListeners();
        } else if ('$pt'.startsWith('vdoHide,')) {
          String hidePlayer = '$pt'.split(',')[1];
          //print('hidePlayer $hidePlayer');
          //print('myRoomSeatIndex $myRoomSeatIndex');
          //print('$pt'.split(',')[2]);
          if (myRoomSeatIndex.toString() != hidePlayer) {
            var val = '$pt'.split(',')[2];
            if (val == 'false') {
              if (hidePlayer == '1') {
                vdoSta_1 = false;
              } else if (hidePlayer == '2') {
                vdoSta_2 = false;
              } else if (hidePlayer == '3') {
                vdoSta_3 = false;
              } else if (hidePlayer == '4') {
                vdoSta_4 = false;
              }
            } else if (val == 'true') {
              if (hidePlayer == '1') {
                vdoSta_1 = true;
              } else if (hidePlayer == '2') {
                vdoSta_2 = true;
              } else if (hidePlayer == '3') {
                vdoSta_3 = true;
              } else if (hidePlayer == '4') {
                vdoSta_4 = true;
              }
            }

            notifyListeners();
          }
        }
      } else if ('${c[0].topic}' == 'imedotRoom/' + myRoomId + "/game") {
        if ('$pt'.startsWith('start_text,')) {
          if (stopGame == false) {
            text_view_start = true;
            notifyListeners();
          }
        } else if ('$pt'.startsWith('start_text_end,')) {
          if (stopGame == false) {
            text_view_start = false;
            notifyListeners();
          }
        } else if ('$pt'.startsWith('start,')) {
          if (stopGame == false) {
            roulette_wheel_view = true;
            notifyListeners();
          }
        } else if ('$pt'.startsWith('notify_king,')) {
          if (stopGame == false) {
            text_view_notify_king = true;
            notifyListeners();
          }
        } else if ('$pt'.startsWith('pointer_end,')) {
          if (stopGame == false) {
            if (king == '0') {
              crown_view_1 = true;
            } else if (king == '1') {
              crown_view_2 = true;
            } else if (king == '2') {
              crown_view_3 = true;
            } else if (king == '3') {
              crown_view_4 = true;
            }
          }
          roulette_wheel_view = false;
          notifyListeners();
        } else if ('$pt'.startsWith('choose_one,')) {
          if (myRoomSeatIndex == (int.parse(king!) + 1)) {
            if (king == '0') {
              text_view_notify_king = false;
              choose_button_view_1 = true;
            } else if (king == '1') {
              text_view_notify_king = false;
              choose_button_view_2 = true;
            } else if (king == '2') {
              text_view_notify_king = false;
              choose_button_view_3 = true;
            } else if (king == '3') {
              text_view_notify_king = false;
              choose_button_view_4 = true;
            }
            notifyListeners();
          }
        } else if ('$pt'.startsWith('choose_this,')) {
          text_view_notify_king = false;
          text_view_be_choose = true;
          BeChosen = pt.split(',')[1];
          if (BeChosen == '1') {
            hat_view_1 = true;
          } else if (BeChosen == '2') {
            hat_view_2 = true;
          } else if (BeChosen == '3') {
            hat_view_3 = true;
          } else if (BeChosen == '4') {
            hat_view_4 = true;
          }
          choose_button_view_1 = false;
          choose_button_view_2 = false;
          choose_button_view_3 = false;
          choose_button_view_4 = false;
          notifyListeners();
          pushMqtt("imedotRoom/" + (myRoomId) + "/game", 'truth_dare_view,');
        } else if ('$pt'.startsWith('truth_dare_view,')) {
          if (BeChosen == (myRoomSeatIndex.toString())) {
            if (BeChosen == '1') {
              truth_dare_view_1 = true;
            } else if (BeChosen == '2') {
              truth_dare_view_2 = true;
            } else if (BeChosen == '3') {
              truth_dare_view_3 = true;
            } else if (BeChosen == '4') {
              truth_dare_view_4 = true;
            }
            notifyListeners();
          }
        } else if ('$pt'.startsWith('truth,')) {
          truth_dare_view_1 = false;
          truth_dare_view_2 = false;
          truth_dare_view_3 = false;
          truth_dare_view_4 = false;
          text_view_choose_T = true;
          text_view_be_choose = false;
          notifyListeners();
          if (int.parse(king) + 1 == myRoomSeatIndex) {
            if (myRoomSeatIndex == 1) {
              pass_view_1 = true;
            } else if (myRoomSeatIndex == 2) {
              pass_view_2 = true;
            } else if (myRoomSeatIndex == 3) {
              pass_view_3 = true;
            } else if (myRoomSeatIndex == 4) {
              pass_view_4 = true;
            }
            notifyListeners();
          }
        } else if ('$pt'.startsWith('dare,')) {
          truth_dare_view_1 = false;
          truth_dare_view_2 = false;
          truth_dare_view_3 = false;
          truth_dare_view_4 = false;
          text_view_choose_D = true;
          text_view_be_choose = false;
          notifyListeners();
          if (int.parse(king) + 1 == myRoomSeatIndex) {
            if (myRoomSeatIndex == 1) {
              pass_view_1 = true;
            } else if (myRoomSeatIndex == 2) {
              pass_view_2 = true;
            } else if (myRoomSeatIndex == 3) {
              pass_view_3 = true;
            } else if (myRoomSeatIndex == 4) {
              pass_view_4 = true;
            }
            notifyListeners();
          }
        } else if ('$pt'.startsWith('punish,')) {
          text_view_choose_T = false;
          text_view_choose_D = false;
          var index = int.parse('$pt'.split(',')[1]);
          Punish = punish_list[index];
          text_view_punish = true;
          notifyListeners();
          if (int.parse(king) + 1 == myRoomSeatIndex) {
            if (myRoomSeatIndex == 1) {
              pass_view_1 = true;
            } else if (myRoomSeatIndex == 2) {
              pass_view_2 = true;
            } else if (myRoomSeatIndex == 3) {
              pass_view_3 = true;
            } else if (myRoomSeatIndex == 4) {
              pass_view_4 = true;
            }
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
  print('tdgame Connected');
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

GetKing() {
  return king;
}

GetPos() {
  return pos;
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
