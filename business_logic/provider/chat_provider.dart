// import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_picker/image_picker.dart';
import 'package:ime_new/business_logic/model/action_model.dart';
import 'package:ime_new/business_logic/model/action_msg_model.dart';
import 'package:ime_new/business_logic/model/chatroom_model.dart';
import 'package:ime_new/business_logic/model/chatroomsetting_model.dart';
import 'package:ime_new/business_logic/model/dbuserinfo_model.dart';
import 'package:ime_new/business_logic/model/follow_action_model.dart';
import 'package:ime_new/business_logic/model/follow_log_model.dart';
import 'package:ime_new/business_logic/model/mqtt_model.dart';
import 'package:ime_new/business_logic/model/o2ochatroom_model.dart';

import 'package:ime_new/utils/cloud_api.dart';
import 'package:ime_new/utils/mqtt_config.dart';
import 'package:ime_new/utils/mymongo.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:queue/queue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatProvider with ChangeNotifier {
  ///mongo realm
  // MongoRealm _mongoDB = MongoRealm();
  // List<MongoCollection> mycollectionList = [];
  // List<MongoDocument> mychatroom2 = [];

  ///jm
  // late JmessageFlutter JMessage;

  // List<JMGroupInfo>? groups;
  // late bool connected;

  ///gcp
  late CloudApi api;

  //檔案名字和byte
  late Uint8List? _imageBytes;
  late Uint8List? _recordBytes;
  late String? _imageName;
  late String? _recordName;
  late Uint8List? _subimageBytes;

  // List<String> imagePaths = [];
  late FilePickerResult? result; //檔案本檔

  ///sharepreferences
  late var prefs;

  /***
   * mqtt
   */

  //mqtt
  List<String>? already_sucribe_list = [];

  //當前mqtt收到的msglist
  List<ChatMsg>? msglist = [];
  List<MqttMsg>? lastmsglist = [];

  //當前mqtt收到的o2o msglist
  List<O2OChatMsg>? o2o_msglist = [];

  // final mqttclient = MqttServerClient(mqttbroker, clientID);
  final mqttclient = MqttServerClient.withPort('iot.gotcash.me', myid, port);
  int pagesize = 10;
  int actionmsgpagesize = 1000;
  int chatpagesize = 200;

  //按鈕等待 狀態
  bool buttonwaiting = false;

  change_button_waiting() {
    buttonwaiting = !buttonwaiting;
    notifyListeners();
  }

  Future mqtt_connect() async {
    print('登入mqtt');
    mqttclient.port = port;
    mqttclient.setProtocolV311();
    mqttclient.logging(on: true);
    mqttclient.onDisconnected = onDisconnected;
    mqttclient.onConnected = onConnected;
    mqttclient.keepAlivePeriod = 20;
    mqttclient.onSubscribed = onSubscribed;
    mqttclient.autoReconnect = true;
    //嘗試連線
    try {
      await mqttclient.connect(mqtt_username, mqtt_password);
      print('connect成功連線mqtt');
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      mqttclient.disconnect();
    }
    // on SocketException catch (e) {
    //   print('EXAMPLE::socket exception - $e');
    //   mqttclient.disconnect();
    // }

    if (mqttclient.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${mqttclient.connectionStatus}');
      mqttclient.disconnect();
      return -1;
    }
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (mqttclient.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      // print(
      //     'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      // exit(-1);
    }
    // if (pongCount == 3) {
    //   print('EXAMPLE:: Pong count is correct');
    // } else {
    //   print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    // }
  }

  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  var nowchatindex = -1;

  //mqtt訂閱
  Future mqttlistener(topic, mqtttype) async {
    //訂閱1
    // 先加入list
    if (already_sucribe_list!.contains(topic)) {
      print('已監聽此topic $topic');
    } else {
      print('此topic沒有監聽過 加入list $topic');
      if (mqtttype == 'ime_group_chat') {
        msglist?.add(ChatMsg(msg: [], topicid: topic, mqtt_tyype: mqtttype));
      } else if (mqtttype == 'ime_o2o_chat') {}
      //訂閱2
      try {
        await mqttclient.subscribe(topic, MqttQos.atMostOnce);
      } catch (e) {
        print('mqtt subcribe exception $e');
      }

      already_sucribe_list?.add(topic);

      //監聽收到消息 listen 只會在client被銷毀時被銷毀

      await mqttclient.updates!
          .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $payload -->');
        // print('77777777${utf8.decode(payload.codeUnits)}');
        // msglist?.add(mqttMsgFromJson(utf8.decode(payload.codeUnits)));
        // msglist?.insert(0, mqttMsgFromJson(utf8.decode(payload.codeUnits)));

        // print("inddxdex ${msglist?.indexWhere((element) => element.topicid == topic)}");
        //檢查是不是跟自己同一個topic
        if (c[0].topic == topic) {
          print('就是我監聽的topic');
          //判斷整個msg list是不是空的
          if (msglist == []) {
            ///似乎沒用到
            print("test -- 225222222");
            //新增 topic 的 list
            List<MqttMsg> newlist = [
              mqttMsgFromJson(utf8.decode(payload.codeUnits))
            ];
            msglist?.add(
                ChatMsg(msg: newlist, topicid: topic, mqtt_tyype: mqtttype));

            // lastmsglist?.add(
            //     ChatMsg(msg: newlist, topicid: topic, mqtt_tyype: mqtttype));
            // topicindex = 0;
          } else {
            print("test -- 222228888");
            //msg不是空的
            //要找topic 的位置 = 在這個msg中是否有此 topic
            switch (json.decode(utf8.decode(payload.codeUnits))["mqtt_type"]) {
              //判斷mqtt type 獲得訊息的型態 類型 分類 辨別
              case "sys_notify":
                print("系統通知");
                if (json.decode(utf8.decode(payload.codeUnits))["note"] == 1) {
                  print('加入房間');
                  getchatroommember(mongo.ObjectId.fromHexString(topic));
                } else if (json
                        .decode(utf8.decode(payload.codeUnits))["note"] ==
                    2) {
                  print('退出房間');
                  getchatroommember(mongo.ObjectId.fromHexString(topic));
                }
                // else if (json
                //         .decode(utf8.decode(payload.codeUnits))["note"] ==
                //     3) {
                //   print('note 3333');
                //   getchatroommember(mongo.ObjectId.fromHexString(topic));
                // }
                // print(
                //     "sys_notify ${json.decode(utf8.decode(payload.codeUnits))["text"]}"
                //     "....${json.decode(utf8.decode(payload.codeUnits))["note"]}");
                //根據通知 刷新
                break;
              case "ime_group_chat":
                print(
                    "ime_group_chat ${json.decode(utf8.decode(payload.codeUnits))}");
                findindex(topic);
                navigator_redpoint_group = true;
                if (topicindex == -1) {
                  // findindex(topic);
                  print("test -- 222221111 ime_group_chat");
                  List<MqttMsg> newlist = [
                    mqttMsgFromJson(utf8.decode(payload.codeUnits))
                  ];
                  // msg有別的聊天但是沒有這個topic
                  msglist?.add(ChatMsg(
                      msg: newlist,
                      topicid: topic,
                      mqtt_tyype: 'ime_group_chat'));

                  if (lasttopicindex != -1) {
                    print('添加到這個topic最後1');
                  } else {
                    print('這個topic沒看過 直接新增1');

                    lastmsglist?.addAll(newlist);
                  }
                } else {
                  findindex(topic);
                  // msg裡面有這個topic的
                  print("test -- 22222999991 index $topicindex");
                  //add
                  msglist?[topicindex!].msg?.insert(
                      0,
                      MqttMsg(
                        fromid:
                            json.decode(utf8.decode(payload.codeUnits))["from"],
                        text:
                            json.decode(utf8.decode(payload.codeUnits))["text"],
                        type:
                            json.decode(utf8.decode(payload.codeUnits))["type"],
                        id: json.decode(utf8.decode(payload.codeUnits))["id"],
                        play: false,
                        time: json.decode(
                                    utf8.decode(payload.codeUnits))["time"] ==
                                null
                            ? null
                            : DateTime.parse(json.decode(
                                utf8.decode(payload.codeUnits))["time"]),
                        topicid: json
                            .decode(utf8.decode(payload.codeUnits))["topic_id"],
                        sendtopicid: json
                            .decode(utf8.decode(payload.codeUnits))["memberid"],
                        note:
                            json.decode(utf8.decode(payload.codeUnits))["note"],
                      ));

                  if (lasttopicindex != -1) {
                    print('添加到這個topic最後2 index 多少$lasttopicindex');
                    lastmsglist?.removeAt(lasttopicindex);
                    lastmsglist?.add(MqttMsg(
                      fromid:
                          json.decode(utf8.decode(payload.codeUnits))["from"],
                      text: json.decode(utf8.decode(payload.codeUnits))["text"],
                      type: json.decode(utf8.decode(payload.codeUnits))["type"],
                      id: json.decode(utf8.decode(payload.codeUnits))["id"],
                      play: false,
                      time:
                          json.decode(utf8.decode(payload.codeUnits))["time"] ==
                                  null
                              ? null
                              : DateTime.parse(json.decode(
                                  utf8.decode(payload.codeUnits))["time"]),
                      topicid: json
                          .decode(utf8.decode(payload.codeUnits))["topic_id"],
                      sendtopicid: json
                          .decode(utf8.decode(payload.codeUnits))["memberid"],
                      nickname: json
                          .decode(utf8.decode(payload.codeUnits))["nickname"],
                      note: json.decode(utf8.decode(payload.codeUnits))["note"],
                    ));
                  } else {
                    print('這個topic沒看過 直接新增2');
                    lastmsglist?.add(MqttMsg(
                      fromid:
                          json.decode(utf8.decode(payload.codeUnits))["from"],
                      text: json.decode(utf8.decode(payload.codeUnits))["text"],
                      type: json.decode(utf8.decode(payload.codeUnits))["type"],
                      id: json.decode(utf8.decode(payload.codeUnits))["id"],
                      play: false,
                      time:
                          json.decode(utf8.decode(payload.codeUnits))["time"] ==
                                  null
                              ? null
                              : DateTime.parse(json.decode(
                                  utf8.decode(payload.codeUnits))["time"]),
                      topicid: json
                          .decode(utf8.decode(payload.codeUnits))["topic_id"],
                      sendtopicid: json
                          .decode(utf8.decode(payload.codeUnits))["memberid"],
                      nickname: json
                          .decode(utf8.decode(payload.codeUnits))["nickname"],
                      note: json.decode(utf8.decode(payload.codeUnits))["note"],
                    ));
                  }
                }
                break;
              case "ime_o2o_chat":
                //收到私聊
                print(
                    // "ime_o2o_chat::${mqttMsgFromJson(utf8.decode(payload.codeUnits))}"
                    "收到私聊....:${json.decode(utf8.decode(payload.codeUnits))["topic_id"]}"
                    "....${json.decode(utf8.decode(payload.codeUnits))}");

                if (myblocklog?.indexWhere((element) =>
                        element.memberid ==
                        json.decode(
                            utf8.decode(payload.codeUnits))["memberid"]) !=
                    -1) {
                  print('在黑名單');
                } else {
                  //收到私聊
                  navigator_redpoint_o2o = true;
                  //查詢
                  o2omsglist_findindex(
                      json.decode(utf8.decode(payload.codeUnits))["memberid"]);

                  // 用memberid來 辨別 不同人訊息 分類
                  ///是否在黑名單
                  ///沒有就正常add
                  //查別人的id index在msglist中的
                  if (topicindex == -1) {
                    //刷新聊天室列表
                    geto2ochatroomlist();
                    print('還沒有存過這個人的傳的私信');
                    //list index 變紅點
                    // o2ochatroomlist_findindex(
                    //     json.decode(utf8.decode(payload.codeUnits))["memberid"],
                    //     false);
                    o2o_msglist?.add(O2OChatMsg(
                        msg: [
                          MqttMsg(
                            fromid: json
                                .decode(utf8.decode(payload.codeUnits))["from"],
                            text: json
                                .decode(utf8.decode(payload.codeUnits))["text"],
                            type: json
                                .decode(utf8.decode(payload.codeUnits))["type"],
                            id: json
                                .decode(utf8.decode(payload.codeUnits))["id"],
                            play: false,
                            time: json.decode(utf8.decode(payload.codeUnits))[
                                        "time"] ==
                                    null
                                ? null
                                : DateTime.parse(json.decode(
                                    utf8.decode(payload.codeUnits))["time"]),
                            //我的
                            topicid: json.decode(
                                utf8.decode(payload.codeUnits))["topic_id"],
                            //對面
                            sendtopicid: json.decode(
                                utf8.decode(payload.codeUnits))["memberid"],
                            recordtime: '',
                            note: json
                                .decode(utf8.decode(payload.codeUnits))["note"],
                          )
                        ],
                        from:
                            json.decode(utf8.decode(payload.codeUnits))["from"],
                        mqtt_tyype: mqtttype,
                        topicid: json
                            .decode(utf8.decode(payload.codeUnits))["topic_id"],
                        memberid: json
                            .decode(utf8.decode(payload.codeUnits))["memberid"],
                        nickname: json
                            .decode(utf8.decode(payload.codeUnits))["nickname"]
                            .toString()));
                  } else {
                    print('這個人曾經私訊過有存過::$topicindex ');
                    //list index 變紅點
                    // o2ochatroomlist_findindex(
                    //     json.decode(utf8.decode(payload.codeUnits))["memberid"],
                    //     false);
                    o2o_msglist?[topicindex].msg!.insert(
                          0,
                          MqttMsg(
                              fromid: json.decode(
                                  utf8.decode(payload.codeUnits))["from"],
                              text: json.decode(
                                  utf8.decode(payload.codeUnits))["text"],
                              type: json.decode(
                                  utf8.decode(payload.codeUnits))["type"],
                              id: json
                                  .decode(utf8.decode(payload.codeUnits))["id"],
                              play: false,
                              time: json.decode(utf8.decode(payload.codeUnits))["time"] == null
                                  ? null
                                  : DateTime.parse(json.decode(
                                      utf8.decode(payload.codeUnits))["time"]),
                              topicid: json.decode(
                                  utf8.decode(payload.codeUnits))["topic_id"],
                              sendtopicid: json.decode(
                                  utf8.decode(payload.codeUnits))["memberid"],
                              recordtime: '',
                              note: json.decode(
                                  utf8.decode(payload.codeUnits))["note"],
                              nickname: json.decode(
                                  utf8.decode(payload.codeUnits))["nickname"]),
                        );
                  }
                }
                break;
              default:
                print('defaulte');
            }
          }

          notifyListeners();
        } else {
          print("聽到不同topic 不用理");
        }
      });
    }
  }

  var topicindex;
  var lasttopicindex;
  var o2ochatlist_index;

  findindex(id) {
    topicindex = msglist?.indexWhere((element) => element.topicid == id);
    lasttopicindex =
        lastmsglist?.indexWhere((element) => element.topicid == id);
    print("topic topic $id  $topicindex last $lasttopicindex");
  }

  o2omsglist_findindex(id) {
    print('idididid   $id');
    topicindex = o2o_msglist?.indexWhere((element) => element.memberid == id);
    print("o2o msglist find id index $id  $topicindex");
  }

  // o2ochatroomlist_findindex(id, isreaded) {
  //   print('room member idididid   $id');
  //   o2ochatlist_index = o2ochatroomlist?.indexWhere(
  //       (element) => element.chatto_id == mongo.ObjectId.fromHexString(id));
  //   print("o2o chatroomlist find id index $id  $o2ochatlist_index");
  //   o2ochatroomlist![o2ochatlist_index].readed = isreaded;
  //   notifyListeners();
  // }

  //解除訂閱
  Future mqttunlistener(topic) async {
    print('來到了unlisten $topic');

    ///還沒找到解決方法
    // already_sucribe_list?.removeWhere((element) => element == topic);
    // findindex(topic);
    // msglist?.removeWhere((element) => element.topicid == topic);
    // findindex(topic);
    print('找到msglist 把它刪掉');
    // try {
    //   // mqttclient.unsubscribe(topic);
    //   // 改為filter作法
    // } catch (e) {
    //   print('mqtt unsubscribe exception$e');
    // }
  }

  //傳送mqtt消息 送出 聊天
  Future mqttpublish(
      text, chatto_topicid, receiverid, msgtype, chatto_nickname, mqtt_type,
      {note, chatto_avatar}) async {
    ///topic 在這從object 分離出 在哪一個頻道說話
    ///chat to id
    ///只有私聊有紀錄 對象
    ///群聊 系統 都是自己
    final builder = MqttClientPayloadBuilder();

    //type  1 文字 / 2 圖片 / 3 貼圖 / 4 音頻 / 6 通知
    print('json.encode');
    builder.addUTF8String(
      json.encode(
        {
          "from": account_id,
          "text": text,
          "type": msgtype,
          "mqtt_type": mqtt_type,
          "note": note,
          "topic_id": chatto_topicid.toHexString(),
          "memberid": remoteUserInfo[0].memberid.toHexString(),
          "time": DateTime.now().toIso8601String(),
          "nickname": remoteUserInfo[0].nickname,
        },
      ),
    );

    print('EXAMPLE::Publishing our topic $chatto_topicid ');
    try {
      //送出mqtt
      await mqttclient.publishMessage(
          chatto_topicid.toHexString(), MqttQos.atMostOnce, builder.payload!);
      print('送出mqtt ${text}');
      //判斷mqtt是什麼類型
      if (msgtype == 6) {
      } else if (mqtt_type == "ime_group_chat") {
        //聊天加進資料庫
        print('聊天  topic_id, $chatto_topicid,');

        _mongoDB.inserttomongo(
          "groupchatmsg",
          {
            "from": account_id,
            "text": text,
            "type": msgtype,
            "time": DateTime.now().add(Duration(hours: 8)),
            "memberid": remoteUserInfo[0].memberid,
            "topic_id": chatto_topicid,
            "nickname": remoteUserInfo[0].nickname,
            'note': note,
          },
        );
      } else if (mqtt_type == "ime_o2o_chat") {
        print('資料庫加入o2o');
        //建立雙方紀錄
        createo2olog(chatto_topicid, chatto_nickname, chatto_avatar);
        _mongoDB.inserttomongo(
          "o2ochatmsg",
          {
            "from": account_id,
            "text": text,
            "type": msgtype,
            "time": DateTime.now().add(Duration(hours: 8)),
            "memberid": remoteUserInfo[0].memberid,
            "topic_id": chatto_topicid,
            "nickname": chatto_nickname,
            'note': note,
          },
        );
      }
    } catch (e) {
      if (e is ConnectionException) {
        print('ConnectionException    $e');
      }
    }
  }

  Future groupchat(text, topic, msgtype, {note}) async {
    print('發出mqtt 群聊');
    mqttpublish(text, topic, account_id, msgtype, '', "ime_group_chat",
        note: note);
  }

  Future groupchat_system(text, topic, msgtype, {note}) async {
    mqttpublish(text, topic, account_id, msgtype, '', "sys_notify", note: note);
  }

  //私聊 私訊 我發送私訊給別人
  Future o2ochat(
      text, totopic, receiverid, msgtype, memberid, nickname, chatto_avatar,
      {note}) async {
    print('私聊$nickname,$msgtype');
    mqttpublish(text, totopic, receiverid, msgtype, nickname, "ime_o2o_chat",
        note: note, chatto_avatar: chatto_avatar);
    print(
        'o2ochat test ::${account_id} // $text // $msgtype // totopic $totopic //receiverid $receiverid //memberid $memberid  nickname $nickname');
    o2omsglist_findindex(totopic.toHexString());
    if (topicindex != -1) {
      print('曾經私訊這個人過有存過::$topicindex');

      o2o_msglist?[topicindex].msg!.insert(
          0,
          MqttMsg(
              fromid: account_id,
              text: text,
              type: msgtype,
              time: DateTime.now(),
              topicid: totopic.toHexString(),
              sendtopicid: memberid.toHexString(),
              nickname: nickname,
              play: false,
              recordtime: ''));
    } else {
      print('還沒有傳過存過這個人的私訊 ${totopic.toHexString()}');
      o2o_msglist?.add(O2OChatMsg(
        msg: [
          MqttMsg(
              fromid: account_id,
              text: text,
              type: msgtype,
              time: DateTime.now(),
              topicid: totopic.toHexString(),
              sendtopicid: memberid.toHexString(),
              nickname: nickname,
              play: false,
              recordtime: '')
        ],
        from: account_id,
        mqtt_tyype: "ime_o2o_chat",
        topicid: memberid.toHexString(),
        memberid: totopic.toHexString(),
        nickname: nickname,
      ));
    }
    notifyListeners();
  }

  //打招呼按鈕
  Future easyhi(chatroomid, nickname, avatar) async {
    if (remoteUserInfo[0].default_chat_text != null &&
        remoteUserInfo[0].default_chat_text != '') {
      print('${remoteUserInfo[0].default_chat_text} $chatroomid');
      mqttpublish(remoteUserInfo[0].default_chat_text, chatroomid,
          remoteUserInfo[0].memberid, 1, nickname, "ime_o2o_chat",
          chatto_avatar: avatar);
      return true;
    } else {
      print('未設置打招呼');
      return false;
    }
  }

  //監聽個人資料改變
  // Future listenprofilechage() async {
  //   try {
  //     ChatApp.instance()!.archiveHandler.getUser().listen((user) {
  //       print('要插入或是更新個人資料');
  //     });
  //   } catch (e) {
  //     print('個人資料改變mqtt excetion $e');
  //   }
  // }

  /***
   *  gcp
   */

  Future initialGCP() async {
    print('開始初始api');
    try {
      await rootBundle
          .loadString('assets/ccw-dev-18723f5508ae.json')
          .then((json) {
        api = CloudApi(json);
      });
    } catch (e) {
      print('初始api失敗$e');
    }
  }

  // Future uploadImage(topic) async {
  //   try {
  //     final response = await api.save(_imageName!, _imageBytes!);
  //     mqttpublish(response.downloadLink.toString(), topic, 2);
  //     print('圖片在gcp 下載網址位置 ${response.downloadLink}');
  //   } catch (e) {
  //     print('上傳圖片失敗  $e');
  //   }
  // }

  /***
   *  jm
   */
  // Future initial_JM() async {
  //   print('fffff');
  //   try {
  //     //初始
  //     JMessage = JmessageFlutter.private(jm_channel, const LocalPlatform());
  //     JMessage.setDebugMode(enable: true); //對外發布的時候關掉
  //     JMessage.init(isOpenMessageRoaming: false, appkey: kMockAppkey);
  //     JMessage.applyPushAuthority(
  //         JMNotificationSettingsIOS(sound: true, alert: true, badge: true));
  //     print('provider 裡面初始jm成功');
  //   } catch (e) {
  //     print('provider 裡面初始jm錯誤');
  //   }
  // }

  // String jm_result = "展示消息";

  // Future user_login() async {
  //   try {
  //     await JMessage.login(username: kMockUserName, password: kMockPassword)
  //         .then((onValue) {
  //       print('jm_login');
  //       print('登入回傳$onValue');
  //
  //       if (onValue is JMUserInfo) {
  //         JMUserInfo u = onValue;
  //         jm_result = "【登入後】${u.toJson()}";
  //       } else {
  //         jm_result = "【登入後】null}";
  //       }
  //     }, onError: (error) {
  //       if (error is PlatformException) {
  //         PlatformException ex = error;
  //         jm_result = "【登入後】code = ${ex.code},message = ${ex.message}";
  //       } else {
  //         jm_result = "【登入後】code = ${error.toString()}";
  //       }
  //     });
  //   } catch (e) {
  //     if (e is PlatformException) {}
  //   }
  //   notifyListeners();
  // }

  //創建群組 揪團 揪咖
  // Future createGroup() async {
  // try {
  //   String gid = await JMessage.createGroup(
  //       groupType: JMGroupType.public,
  //       name: kMockGroupName,
  //       desc: kMockGroupDesc);
  //   print('創建群組成功  id 是$gid');
  // } catch (e) {
  //   if (e is PlatformException) {
  //     print('11111 創建群組exception $e');
  //   }
  // }
  // }
  //
  // Future getPublicGroup() async {
  //   print('公開群組');
  //   // try {
  //   //   groups = await JMessage.getPublicGroupInfos(
  //   //       appKey: kMockAppkey, start: 0, count: 20);
  //   //   notifyListeners();
  //   // } catch (e) {
  //   //   if (e is PlatformException) {
  //   //     print('獲得公開群組PlatformException exception $e');
  //   //   } else {
  //   //     print('11111 獲得公開群組exception $e');
  //   //   }
  //   // }
  // }

  // JMGroup? groupuser;

  // settinggroupuser(index) {
  //   // groupuser = JMGroup.fromJson({'groupId': groups?[index].id.toString()});
  //   // notifyListeners();
  // }
  //
  // clean() {
  //   // groupuser = null;
  // }

  /**
   *  file picker & recorder android 端需要更改 onActivityResult function 因為有跳轉原生
   *
   */
  Future pickimg() async {
    result = null;
    try {
      result = (await FilePicker.platform
          .pickFiles(type: FileType.media, withData: true))!;
    } catch (e) {
      print('選檔案exception::$e');
    }
  }

  //相機
  //使用image picker
  var pickimg_result;

  Future pickimg2() async {
    pickimg_result = null;
    try {
      final ImagePicker _picker = ImagePicker();

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      pickimg_result = image;
    } catch (e) {
      print('選檔案exception::$e');
    }
  }

  Future pickimg2_camera() async {
    pickimg_result = null;
    try {
      final ImagePicker _picker = ImagePicker();

      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      pickimg_result = image;
    } catch (e) {
      print('選檔案exception::$e');
    }
  }

  // file picker
//   Future sendimg(topic) async {
//     print('傳送照片');
//     // await pickimg();
//     await pickimg2();
//     if (result == null) {
//       print('選檔案 空的');
//     } else {
//       _imageName = result!.files.single.path!.split('/').last;
//       _imageBytes = result!.files.single.bytes!;
//       //小圖
//       _subimageBytes = resizeImage(_imageBytes!);
//       try {
//         final response = await api.save(_imageName!, _imageBytes!);
//         final response2 = await api.save(
//             _imageName!.split('.').first + '_2.png', _subimageBytes!);
// //小圖放在正文裡面 原圖放在note
// //         await mqttpublish(
// //             response2.downloadLink.toString(), topic, 2, "ime_group_chat",
// //             note: response.downloadLink.toString());
//         await groupchat(response2.downloadLink.toString(), topic, 2,
//             note: response.downloadLink.toString());
//         print('圖片在gcp 下載網址位置 ${response.downloadLink}');
//       } catch (e) {
//         print('上傳圖片失敗  $e');
//       }
//     }
//   }

  //image picker
  Future sendimg_group(topic, type) async {
    print('傳送照片');
    // await pickimg();
    var name = 'pic/' + Uuid().v1().toString() + '.png';
    await pickimg2();
    if (pickimg_result == null) {
      print('選檔案 空的');
    } else {
      // _imageName = pickimg_result.path!.split('/').last;
      _imageName = name;
      print('pickimg_result ${pickimg_result.runtimeType}');
      // _imageBytes = await pickimg_result!.readAsBytes();
      _imageBytes = resizeImage(await pickimg_result!.readAsBytes(), 1000);

      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      try {
        final response = await api.save2(_imageName!, _imageBytes!);
        final response2 = await api.save2(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        //小圖放在正文裡面 原圖放在note
        //傳送
        if (type == 'ime_o2o_chat') {
        } else if (type == 'ime_group_chat') {
          await groupchat(response2.downloadLink.toString(), topic, 2,
              note: response.downloadLink.toString());
        }

        print('$type  圖片在gcp 下載網址位置 ${response.downloadLink}');
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }
  }

  Future sendimg_o2o(topic, type, memberid, nickname, chatto_avatar) async {
    print('傳送照片');
    // await pickimg();
    var name = 'pic/' + Uuid().v1().toString() + '.png';
    await pickimg2();
    if (pickimg_result == null) {
      print('選檔案 空的');
    } else {
      // _imageName = pickimg_result.path!.split('/').last;
      _imageName = name;
      print('pickimg_result ${pickimg_result.runtimeType}');
      // _imageBytes = await pickimg_result!.readAsBytes();
      _imageBytes = resizeImage(await pickimg_result!.readAsBytes(), 1000);
      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      try {
        final response = await api.save2(_imageName!, _imageBytes!);
        final response2 = await api.save2(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        //小圖放在正文裡面 原圖放在note
        //傳送
        if (type == 'ime_o2o_chat') {
          await o2ochat(
              response2.downloadLink.toString(),
              mongo.ObjectId.fromHexString(topic),
              444,
              2,
              memberid,
              nickname,
              chatto_avatar,
              note: response.downloadLink.toString());
        } else if (type == 'ime_group_chat') {
          await groupchat(response2.downloadLink.toString(), topic, 2,
              note: response.downloadLink.toString());
        }

        print('$type  圖片在gcp 下載網址位置 ${response.downloadLink}');
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }
  }

  Future sendimgwithcamera_group(topic, type) async {
    print('傳送照片');
    // await pickimg();
    var name = 'pic/' + Uuid().v1().toString() + '.png';
    await pickimg2_camera();
    if (pickimg_result == null) {
      print('選檔案 空的');
    } else {
      // _imageName = pickimg_result.path!.split('/').last;
      _imageName = name;
      print('pickimg_result ${pickimg_result.runtimeType}');
      // _imageBytes = await pickimg_result!.readAsBytes();
      _imageBytes = resizeImage(await pickimg_result!.readAsBytes(), 1000);
      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      try {
        final response = await api.save2(_imageName!, _imageBytes!);
        final response2 = await api.save2(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        //小圖放在正文裡面 原圖放在note
        if (type == 'ime_o2o_chat') {
        } else if (type == 'ime_group_chat') {
          await groupchat(response2.downloadLink.toString(), topic, 2,
              note: response.downloadLink.toString());
        }
        print('圖片在gcp 下載網址位置 ${response.downloadLink}');
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }
  }

  Future sendimgwithcamera_o2o(
      topic, type, memberid, nickname, chatto_avatar) async {
    print('傳送照片');
    // await pickimg();
    var name = 'pic/' + Uuid().v1().toString() + '.png';
    await pickimg2_camera();
    if (pickimg_result == null) {
      print('選檔案 空的');
    } else {
      // _imageName = pickimg_result.path!.split('/').last;
      _imageName = name;
      print('pickimg_result ${pickimg_result.runtimeType}');
      // _imageBytes = await pickimg_result!.readAsBytes();
      _imageBytes = resizeImage(await pickimg_result!.readAsBytes(), 1000);
      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      try {
        final response = await api.save2(_imageName!, _imageBytes!);
        final response2 = await api.save2(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        //小圖放在正文裡面 原圖放在note
        if (type == 'ime_o2o_chat') {
          print('小圖放在正文裡面 原圖放在note o2o');
          await o2ochat(
              response2.downloadLink.toString(),
              mongo.ObjectId.fromHexString(topic),
              444,
              2,
              memberid,
              nickname,
              chatto_avatar,
              note: response.downloadLink.toString());
        } else if (type == 'ime_group_chat') {
          await groupchat(response2.downloadLink.toString(), topic, 2,
              note: response.downloadLink.toString());
        }
        print('圖片在gcp 下載網址位置 ${response.downloadLink}');
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }
  }

  /**
   * 動態
   * */
  String action_imgpath = '';
  int action_newest_value = 1;
  int action_someone_value = 1;
  int action_favorite_value = 1;

  void cancelaction_img() {
    action_imgpath = '';
    notifyListeners();
  }

  void action_plus_page(value) {
    // page 1=最新 page 2=關注
    switch (value) {
      case 1:
        action_newest_value = action_newest_value + 1;
        print('最新動態頁數+1 -> $action_newest_value');
        break;
      case 2:
        action_favorite_value = action_favorite_value + 1;
        break;
      case 3:
        action_someone_value = action_someone_value + 1;
    }

    notifyListeners();
  }

  Future load_action_img() async {
    print('上傳動態');
    var name = 'pic/' + Uuid().v1().toString() + '.png';
    await pickimg2();
    if (pickimg_result == null) {
      print('選檔案 空的');
    } else {
      _imageName = name;
      action_imgpath = pickimg_result.path!;
      print('storage name $action_imgpath');
      print('pickimg_result ${pickimg_result.runtimeType}');
      _imageBytes = resizeImage(await pickimg_result!.readAsBytes(), 1000);
      _subimageBytes = resizeImage(_imageBytes!, 300);
    }
    notifyListeners();
  }

  Future load_action_img_camera() async {
    print('上傳動態');
    var name = 'pic/' + Uuid().v1().toString() + '.png';
    await pickimg2_camera();
    if (pickimg_result == null) {
      print('選檔案 空的');
    } else {
      _imageName = name;
      action_imgpath = pickimg_result.path!;
      print('storage name $action_imgpath');
      print('pickimg_result ${pickimg_result.runtimeType}');
      _imageBytes = resizeImage(await pickimg_result!.readAsBytes(), 1000);
      _subimageBytes = resizeImage(_imageBytes!, 500);
    }
    notifyListeners();
  }

  Future uploadimg_action({text}) async {
    try {
      if (action_imgpath == '') {
        if (text == '') {
          print('沒有圖片沒有文字');
        } else {
          print('沒有圖片有字');
          _mongoDB.inserttomongo(
            "action",
            {
              "text": text,
              "image": '',
              "image_sub": '',
              "time": DateTime.now().add(Duration(hours: 8)),
              "memberid": remoteUserInfo[0].memberid,
              "nickname": remoteUserInfo[0].nickname,
              'like_num': 0,
              'msg_num': 0,
              'share_num': 0,
              'like_id_list': [],
              'area': remoteUserInfo[0].area,
              'avatar': remoteUserInfo[0].avatar,
              'account': account_id,
            },
          );
        }
      } else if (text == '') {
        print('沒有文字有圖');
        //傳上雲端
        final response = await api.save2(_imageName!, _imageBytes!);
        final response2 = await api.save2(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        print(' 圖片在gcp 下載網址位置 ${response.downloadLink}');
        //傳上db
        _mongoDB.inserttomongo(
          "action",
          {
            "text": text,
            "image": response.downloadLink.toString(),
            "image_sub": response2.downloadLink.toString(),
            "time": DateTime.now().add(Duration(hours: 8)),
            "memberid": remoteUserInfo[0].memberid,
            "nickname": remoteUserInfo[0].nickname,
            'like_num': 0,
            'msg_num': 0,
            'share_num': 0,
            'like_id_list': [],
            'area': remoteUserInfo[0].area,
            'avatar': remoteUserInfo[0].avatar,
            'account': account_id,
          },
        );
        print('動態上傳資料庫');
      } else {
        //傳上雲端
        final response = await api.save2(_imageName!, _imageBytes!);
        final response2 = await api.save2(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        print(' 圖片在gcp 下載網址位置 ${response.downloadLink}');
        //傳上db
        _mongoDB.inserttomongo(
          "action",
          {
            "text": text,
            "image": response.downloadLink.toString(),
            "image_sub": response2.downloadLink.toString(),
            "time": DateTime.now().add(Duration(hours: 8)),
            "memberid": remoteUserInfo[0].memberid,
            "nickname": remoteUserInfo[0].nickname,
            'like_num': 0,
            'msg_num': 0,
            'share_num': 0,
            'like_id_list': [],
            'area': remoteUserInfo[0].area,
            'avatar': remoteUserInfo[0].avatar,
            'account': account_id,
          },
        );
        print('動態上傳資料庫');
        print('都有');
      }
    } catch (e) {
      print('上傳圖片失敗  $e');
    }
  }

  //刪除動態的留言
  Future delete_action(action_id) async {
    print("delete_action_msg ${action_id}");
    await delete_one_remotemongodb('action', mongo.where.eq('_id', action_id));
    get_new_action_list();
  }

  Future upload_action_msg(action_id, text) async {
    print('送出留言 $action_id /$text');
    try {
      //傳上db
      _mongoDB.inserttomongo(
        "action_msg",
        {
          "action_id": action_id,
          "text": text,
          "time": DateTime.now().add(Duration(hours: 8)),
          "memberid": remoteUserInfo[0].memberid,
          "nickname": remoteUserInfo[0].nickname,
          'avatar': remoteUserInfo[0].avatar,
          'account': account_id,
        },
      );
      // 留言+1
      await _mongoDB.plus_num('action', "_id", action_id, 'msg_num', 1);
    } catch (e) {
      print('上傳動態留言失敗  $e');
    }
  }

  List? newest_actionlist;
  List? someone_actionlist;
  List? favorite_actionlist;
  List? actionmsglist;

  Future get_new_action_list() async {
    action_newest_value = 1;
    print("get_action_list");
    newest_actionlist = await readremotemongodb(ActionModel.fromJson, 'action',
        field: mongo.where.sortBy('time', descending: true).limit(pagesize));
    print("get_action_list $newest_actionlist");
    notifyListeners();
  }

  Future get_someone_action_list(memberid) async {
    action_someone_value = 1;
    print("get_someone_action_list $memberid");
    someone_actionlist = await readremotemongodb(ActionModel.fromJson, 'action',
        field: mongo.where
            .eq('memberid', memberid)
            .sortBy('time', descending: true)
            .limit(pagesize));
    print("get_someone_action_list $someone_actionlist");
    notifyListeners();
  }

  Future get_follow_action_list() async {
    action_favorite_value = 1;
    print("get_follow_action_list  my mongo id ${remoteUserInfo[0].memberid}");
    final pipeline = mongo.AggregationPipelineBuilder()
      ..addStage(mongo.Project({'_id': 0}))
      ..addStage(mongo.Match(mongo.where
          .eq('member_id', remoteUserInfo[0].memberid)
          .map['\$query']))
      ..addStage(mongo.Lookup(
        from: 'action',
        as: 'actionlist',
        // let: {},
        foreignField: 'memberid',
        localField: 'list_id',
        // pipeline: [],
      ))
      ..addStage(mongo.Unwind(mongo.Field('actionlist')))
      ..addStage(mongo.Project({
        'member_id': 0,
        'create_time': 0,
        'list_id': 0,
      }))
      ..addStage(mongo.Sort({'actionlist.time': -1}))
      ..addStage(mongo.Limit(pagesize));
    favorite_actionlist =
        await lookupmongodb(FollowActionModel.fromJson, 'follow_log', pipeline);
    print("get_follow_action_list ${favorite_actionlist!}");
    notifyListeners();
  }

  int action_msg_value = 1;

  Future get_action_msg(action_id) async {
    action_msg_value = 1;
    print("get_action_msg $action_id");
    actionmsglist = await readremotemongodb(
        ActionMsgModel.fromJson, 'action_msg',
        field: mongo.where
            .eq('action_id', action_id)
            .limit(actionmsgpagesize)
            .sortBy('time', descending: false));
    print("get_action_msg $actionmsglist");
    notifyListeners();
  }

  int action_count = 0;

  Future get_action_msg_count(
    id,
    type,
  ) async {
    print('獲得動態留言數量 $id');
    var result = await getcount(
      'action_msg',
      'action_id',
      id,
    );

    if (result is int) {
      if (type == 2) {
        //detail page
        action_count = result;
        print('動態留言數量..detail page內..$action_count');
      } else if (type == 1) {
        // newest list page 更新
        var index =
            newest_actionlist?.indexWhere((element) => element.id == id);
        if (index is int && index != -1) {
          newest_actionlist![index].msg_num = result;
        }
      } else if (type == 3) {
        // favorite list page 更新
        var index = favorite_actionlist
            ?.indexWhere((element) => element.action.id == id);
        if (index is int && index != -1) {
          favorite_actionlist![index].action.msg_num = result;
        }
      } else if (type == 4) {
        // someone list page 更新
        var index =
            someone_actionlist?.indexWhere((element) => element.id == id);
        if (index is int && index != -1) {
          someone_actionlist![index].msg_num = result;
        }
      }
    }
    notifyListeners();
  }

  Future addpage_action_msg(action_id) async {
    var newpage = await readremotemongodb(ActionMsgModel.fromJson, 'action_msg',
        field: mongo.where
            .eq('action_id', action_id)
            .sortBy('time', descending: true)
            .skip(action_msg_value + 1 * actionmsgpagesize)
            .limit(actionmsgpagesize));
    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        actionmsg_plus();
        actionmsglist!.addAll(newpage);
      }
    }

    notifyListeners();
  }

  void actionmsg_plus() {
    action_msg_value++;
    notifyListeners();
  }

  //刪除動態的留言
  Future delete_action_msg(action_id, msg_id) async {
    print("delete_action_msg ${msg_id}");
    await delete_one_remotemongodb('action_msg', mongo.where.eq('_id', msg_id));
    await _mongoDB.plus_num('action', "_id", action_id, 'msg_num', -1);
  }

  Future addpage_newest_action() async {
    var newpage = await readremotemongodb(ActionModel.fromJson, 'action',
        field: mongo.where
            .sortBy('time', descending: true)
            .skip(action_newest_value * pagesize)
            .limit(pagesize));
    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        action_plus_page(1);
        newest_actionlist!.addAll(newpage);
      }
    }

    notifyListeners();
  }

  Future addpage_someone_action(memberid) async {
    var newpage = await readremotemongodb(ActionModel.fromJson, 'action',
        field: mongo.where
            .eq('memberid', memberid)
            .sortBy('time', descending: true)
            .skip(action_someone_value * pagesize)
            .limit(pagesize));
    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        action_plus_page(3);
        someone_actionlist!.addAll(newpage);
      }
    }

    notifyListeners();
  }

  Future addpage_favorite_action() async {
    final pipeline = mongo.AggregationPipelineBuilder()
      ..addStage(mongo.Project({'_id': 0}))
      ..addStage(mongo.Match(mongo.where
          .eq('member_id', remoteUserInfo[0].memberid)
          .map['\$query']))
      ..addStage(mongo.Lookup(
        from: 'action',
        as: 'actionlist',
        // let: {},
        foreignField: 'memberid',
        localField: 'list_id',
        // pipeline: [],
      ))
      ..addStage(mongo.Unwind(mongo.Field('actionlist')))
      ..addStage(mongo.Project({
        'member_id': 0,
        'create_time': 0,
        'list_id': 0,
      }))
      ..addStage(mongo.Sort({'actionlist.time': -1}))
      ..addStage(mongo.Skip(action_favorite_value * pagesize))
      ..addStage(mongo.Limit(pagesize));
    var newpage =
        await lookupmongodb(FollowActionModel.fromJson, 'follow_log', pipeline);
    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        action_plus_page(2);
        someone_actionlist!.addAll(newpage);
      }
    }
    notifyListeners();
  }

  Future like_to_action(action_id, index, islike, TheAction) async {
    print('action id $action_id,${remoteUserInfo[0].memberid}');
    if (islike) {
      print(" 要做的動作->取消喜歡 動態");
      // 取消
      _mongoDB.deleteData(
        "action",
        '_id',
        action_id,
        'like_id_list',
        remoteUserInfo[0].memberid,
      );
      // like 數-1
      await _mongoDB.plus_num('action', "_id", action_id, 'like_num', -1);

      TheAction.like_list.remove(
        remoteUserInfo[0].memberid,
      );
      TheAction.like_num--;
      // newest_actionlist![index!].like_list.remove(
      //       remoteUserInfo[0].memberid,
      //     );
      // newest_actionlist![index!].like_num--;
    } else {
      print("要做的動作->喜歡動態 ");
      //資料庫更新 member
      await _mongoDB.updateData_addSet(
        "action",
        '_id',
        action_id,
        'like_id_list',
        remoteUserInfo[0].memberid,
      );
      // like 數+1
      await _mongoDB.plus_num('action', "_id", action_id, 'like_num', 1);

      TheAction.like_list.add(
        remoteUserInfo[0].memberid,
      );
      TheAction.like_num++;
      // newest_actionlist![index!].like_list.add(
      //       remoteUserInfo[0].memberid,
      //     );
      // newest_actionlist![index!].like_num++;
    }
    notifyListeners();
  }

  /**
   *  特務直播
   */
  Future upload_spy_mission(
    text,
  ) async {
    print('上傳任務到資料庫 $text');
    try {
      //傳上db
      _mongoDB.inserttomongo(
        "spy_mission",
        {
          "text": text,
          "time": DateTime.now().add(Duration(hours: 8)),
          "memberid": remoteUserInfo[0].memberid,
          "nickname": remoteUserInfo[0].nickname,
          'avatar': remoteUserInfo[0].avatar,
        },
      );
    } catch (e) {
      print('上傳動態留言失敗  $e');
    }
  }

  /**
   * notify
   */
  Future notify_chatroom_member_enter(topic, name) async {
    print('通知加入聊天室');

    await groupchat_system("$name加入聊天室", topic, 6, note: 1);
  }

  Future notify_chatroom_member_exit(topic) async {
    // 通知有人退出
    await groupchat_system("${remoteUserInfo[0].nickname}退出聊天室", topic, 6,
        note: 2);
    //解除mqtt訂閱 從list 刪掉
    mqttunlistener(topic.toHexString());

    //資料庫將聊天室去掉
    _mongoDB.deleteData(
      "member",
      "account",
      account_id,
      'chatroomid',
      topic,
    );
    //刷新 userinfo
    await getaccountinfo();
  }

  Uint8List resizeImage(Uint8List data, size) {
    Uint8List resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    print('圖片原本長寬 ${img?.height} ${img?.width}');
    IMG.Image resized = IMG.copyResize(img!,
        width: size, height: (img.height / (img.width / size)).round());
    print('圖片縮放長寬 ${(img.height / (img.width / size)).round()} $size');
    resizedData = IMG.encodeJpg(resized) as Uint8List;
    return resizedData;
  }

//錄音 上傳
  Future groupsendrecord(topic, path, type) async {
    var name = 'audio/' + Uuid().v1().toString() + '.png';
    _recordName = name;
    _recordBytes = File(path).readAsBytesSync();

    try {
      final response = await api.save2(_recordName!, _recordBytes!);

      groupchat(
        response.downloadLink.toString(),
        topic,
        4,
      );
      print(
          '音頻在gcp 下載網址位置 ${response.downloadLink} data長度 ${response.downloadLink}');
    } catch (e) {
      print('上傳音頻失敗  $e');
    }
  }

  Future o2osendrecord(
      topic, path, type, receiverid, memberid, nickname, chatto_avatar) async {
    var name = 'audio/' + Uuid().v1().toString() + '.png';
    _recordName = name;
    _recordBytes = File(path).readAsBytesSync();

    try {
      final response = await api.save2(_recordName!, _recordBytes!);
      if (type == 'ime_o2o_chat') {
        o2ochat(
          response.downloadLink.toString(),
          topic,
          receiverid,
          4,
          memberid,
          nickname,
          chatto_avatar,
        );
      } else if (type == 'ime_group_chat') {
        groupchat(
          response.downloadLink.toString(),
          topic,
          4,
        );
      }
      print(
          '音頻在gcp 下載網址位置 ${response.downloadLink} data長度 ${response.downloadLink}');
    } catch (e) {
      print('上傳音頻失敗  $e');
    }
  }

//播放錄音
  void playaudiomsg(msg) {
    msg.play = !msg.play;
    notifyListeners();
  }

  //
  void showaudiotime(msg, text) {
    msg.recordtime = text;
    notifyListeners();
  }

  void loadaudio_alltime(msg, text) {
    msg.current_play_position = text;
    notifyListeners();
  }

//全部錄音都關閉
  void allplayaudiostop(topicindex) {
    print('全部關閉');
    if (historymsg != null) {
      for (var item in historymsg as List) {
        item.play = false;
      }
    }
    if (msglist![topicindex].msg != null) {
      for (var item in msglist![topicindex].msg as List) {
        item.play = false;
      }
    }

    notifyListeners();
  }

  /**
   * mongo
   */

  String? email;
  String realm_password = "000000";
  var Userinfo; //本地 sharedpreference 存放的資料

  set_accountid(id) {
    account_id = id;
    notifyListeners();
  }

  Future register(account) async {
    print("註冊mongo123 ${account.uid}");
    set_accountid(account.uid);
    if (account != null) {
      await createnewperson(
        account,
      );
    }
  }

  Future pre_Subscribed() async {
    return await getaccountinfo().then((value) async {
      print('預先拿資料$value');
      if (value == false) {
        print('預先要資料失敗');
        return false;
      } else {
        if (remoteUserInfo[0].chatroomId != null) {
          for (var item in remoteUserInfo[0].chatroomId) {
            print('預先 訂閱 userinfo 上面已經有的 $item');
            mqttlistener(item.toHexString(), 'ime_group_chat');
          }
        }
        if (remoteUserInfo[0].memberid != null) {
          print('訂閱自己的私聊頻道/通知頻道');
          mqttlistener(
              remoteUserInfo[0].memberid.toHexString(), 'ime_o2o_chat');
        }

        await createfollowlog();
        await createblocklog();
        await getmyfollowlog();
        await getmyblocklog();

        return true;
      }
    });
  }

  /**
   *   新的mongodb plugin
   */

  var remoteUserInfo; //mongodb 讀遠端的member資料

  ///
  String? account_id;
  bool finishinfo = false;

  Future getaccountinfo() async {
    print('獲得使用者資料 id $account_id');
    return Future.delayed(Duration(seconds: 2), () async {
      var readresult = await readremotemongodb(
          DbUserinfoModel.fromJson, 'member',
          field: mongo.where.eq('account', account_id));
      print('獲得使用者資料$readresult');

      remoteUserInfo = readresult;
      if (remoteUserInfo == null || remoteUserInfo.isEmpty) {
        print("remoteUserInfo :空");
        return false;
      } else {
        if (remoteUserInfo[0].sex == null) {
          print('沒有性別');
          finishinfo = false;
          return false;
        } else {
          finishinfo = true;
          print("remoteUserInfo$remoteUserInfo");
          set_profile_pic();
          set_interest();

          notifyListeners();
          return true;
        }
      }
    });
  }

  Future getaccountinfo2() async {
    print('獲得使用者資料 id $account_id');
    var readresult = await readremotemongodb(DbUserinfoModel.fromJson, 'member',
        field: mongo.where.eq('account', '6zmS6tPgeFOQwvfUMj3YXVYXIQN2'));
    print('獲得使用者資料$readresult');
  }

  //用topic id 查到 某帳號 資料
  Future getuserInfo(topic_id) async {
    var readresult = await readremotemongodb(DbUserinfoModel.fromJson, 'member',
        field: mongo.where.eq('_id', topic_id));
    print('get some one userInfo ${readresult[0].nickname}');
    return readresult;
  }

  List follow_me_user_list = [];
  List my_block_user_list = [];

  Future followme_finduserinfolist() async {
    follow_me_user_list = [];
    for (var item in follow_me_list!) {
      var result = await getuserInfo(item.memberid);
      print('22222222');
      follow_me_user_list.add(result[0]);
    }
    print('find user info list ${follow_me_user_list}');
    notifyListeners();
  }

  Future myblock_finduserinfolist() async {
    my_block_user_list = [];
    for (var item in myblocklog!) {
      var result = await getuserInfo(item.memberid);
      print('22222222');
      my_block_user_list.add(result[0]);
    }
    print('find myblock list ${my_block_user_list}');
    notifyListeners();
  }

  List? groupteamlist;

  List? grouppersonlist;

  int groupteamlist_value = 1;
  int grouppersonlist_value = 1;
  List? o2ochatroomlist;

  ///mongo db
  MongoDB _mongoDB = MongoDB();
  final Queue queue = Queue(delay: Duration(milliseconds: 10));

  /**
   *揪團揪咖
   */
  //揪團
  Future getgroupteam() async {
    groupteamlist_value = 1;
    print('獲得揪團列表');
    groupteamlist = await readremotemongodb(ChatRoomModel.fromJson, 'chatroom',
        field: mongo.where
            .eq('type', 0)
            .sortBy('create_time', descending: true)
            .limit(pagesize));
    print('揪團$groupteamlist');

    notifyListeners();
  }

  Future addpage_getgroupteam() async {
    var newpage = await readremotemongodb(ChatRoomModel.fromJson, 'chatroom',
        field: mongo.where
            .eq('type', 0)
            .sortBy('create_time', descending: true)
            .skip(groupteamlist_value * pagesize)
            .limit(pagesize));
    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        grouppage_plus(1);
        groupteamlist!.addAll(newpage);
      }
    }

    notifyListeners();
  }

  //揪咖
  Future getgroupperson() async {
    grouppersonlist_value = 1;
    print('獲得揪咖列表');
    grouppersonlist = await readremotemongodb(
        ChatRoomModel.fromJson, 'chatroom',
        field: mongo.where
            .eq('type', 1)
            .sortBy('create_time', descending: true)
            .limit(pagesize));
    notifyListeners();
  }

  Future addpage_getgroupperson() async {
    var newpage = await readremotemongodb(ChatRoomModel.fromJson, 'chatroom',
        field: mongo.where
            .eq('type', 1)
            .sortBy('create_time', descending: true)
            .skip(grouppersonlist_value * pagesize)
            .limit(pagesize));

    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        grouppage_plus(2);
        grouppersonlist!.addAll(newpage);
      }
    }

    notifyListeners();
  }

  void grouppage_plus(value) {
    // page 1揪團 page 2=揪咖
    switch (value) {
      case 1:
        groupteamlist_value = groupteamlist_value + 1;
        break;
      case 2:
        grouppersonlist_value = grouppersonlist_value + 1;
        break;
    }

    notifyListeners();
  }

  bool navigator_redpoint_o2o = false;
  bool navigator_redpoint_group = false;

  change_redpoint(type) {
    switch (type) {
      case 1:
        navigator_redpoint_o2o = false;
        break;
      case 2:
        navigator_redpoint_group = false;
        break;
    }
    notifyListeners();
  }

  int o2ochatroomlist_value = 1;

  Future geto2ochatroomlist() async {
    o2ochatroomlist_value = 1;
    print('獲得私聊列表 ${remoteUserInfo[0].memberid} //block id ${myblocklog[0]}');
    o2ochatroomlist = await readremotemongodb(O2ORoomModel.fromJson, 'o2olog',
        field: mongo.where
            .eq('member_id', remoteUserInfo[0].memberid)
            .limit(pagesize)
            .sortBy('last_chat_time', descending: true));
    if (myblocklog[0].list_id != null) {
      //用黑名單列表 將私聊列表篩選出來
      print('黑名單篩選');
      o2ochatroomlist?.removeWhere(
          (element) => myblocklog[0].list_id.contains(element.chatto_id));
    }
    notifyListeners();
  }

  Future addpage_geto2ochatroom() async {
    var newpage = await readremotemongodb(O2ORoomModel.fromJson, 'o2olog',
        field: mongo.where
            .eq('member_id', remoteUserInfo[0].memberid)
            .sortBy('last_chat_time', descending: true)
            .skip(o2ochatroomlist_value * pagesize)
            .limit(pagesize));

    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        o2ochatroomlist_value++;
        o2ochatroomlist!.addAll(newpage);
      }
    }

    notifyListeners();
  }

  bool isgroupperson_filter = false;
  bool isgroupteam_filter = false;
  List? historymsg;
  List? o2ohistorymsg;

  void change_filter(num) {
    if (num == 2) {
      if (isgroupperson_filter) getgroupperson();
      isgroupperson_filter = !isgroupperson_filter;
    } else {
      if (isgroupteam_filter) getgroupteam();
      isgroupteam_filter = !isgroupteam_filter;
    }
    notifyListeners();
  }

  var filter_grouppersonlist;
  var filter_groupteamlist;

  Future setfilter_chatroom(
    num, {
    area,
  }) async {
    print("filter filter");
    if (num == 2) {
      if (area != null) {
        if (purposelist.isNotEmpty) {
          print('有目的 有地區');
          filter_grouppersonlist = await readremotemongodb(
              ChatRoomModel.fromJson, 'chatroom',
              field: mongo.where
                  .eq('area', area)
                  .and(mongo.where.eq('purpose', purposelist[0]))
                  .and(mongo.where.eq('type', 1))
                  .sortBy('create_time', descending: true));
        } else {
          print('沒目的 有地區');
          filter_grouppersonlist = await readremotemongodb(
              ChatRoomModel.fromJson, 'chatroom',
              field: mongo.where
                  .eq('area', area)
                  .and(mongo.where.eq('type', 1))
                  .sortBy('create_time', descending: true));
        }
      } else {
        print('有目的 沒地區');
        if (purposelist.isNotEmpty) {
          filter_grouppersonlist = await readremotemongodb(
              ChatRoomModel.fromJson, 'chatroom',
              field: mongo.where
                  .eq('purpose', purposelist[0])
                  .and(mongo.where.eq('type', 1))
                  .sortBy('create_time', descending: true));
        } else {
          filter_grouppersonlist = [];
        }
      }
    } else {
      if (area != null) {
        if (purposelist.isNotEmpty) {
          print('有目的 有地區');
          filter_groupteamlist = await readremotemongodb(
              ChatRoomModel.fromJson, 'chatroom',
              field: mongo.where
                  .eq('area', area)
                  .and(mongo.where.eq('purpose', purposelist[0]))
                  .and(mongo.where.eq('type', 0))
                  .sortBy('create_time', descending: true));
        } else {
          print('沒目的 有地區');
          filter_groupteamlist = await readremotemongodb(
              ChatRoomModel.fromJson, 'chatroom',
              field: mongo.where
                  .eq('area', area)
                  .and(mongo.where.eq('type', 0))
                  .sortBy('create_time', descending: true));
        }
      } else {
        if (purposelist.isNotEmpty) {
          print('有目的 沒地區 ${purposelist[0]}');
          filter_groupteamlist = await readremotemongodb(
              ChatRoomModel.fromJson, 'chatroom',
              field: mongo.where
                  .eq('purpose', purposelist[0])
                  .and(mongo.where.eq('type', 0))
                  .sortBy('create_time', descending: true));
        } else {
          filter_groupteamlist = [];
        }
      }
    }
    notifyListeners();
  }

  //獲得聊天記錄 歷史訊息
  Future gethismsg(topic) async {
    grouphis_value = 1;
    print("get history $topic");
    historymsg = null;
    historymsg = await readremotemongodb(MqttMsg.fromJson, 'groupchatmsg',
        field: mongo.where.eq('topic_id', topic).limit(chatpagesize));
    // .whenComplete(() => mqttlistener(topic.toHexString()));
    if (historymsg != null) {
      historymsg = historymsg!.reversed.toList();
    }

    var index = msglist
        ?.indexWhere((element) => element.topicid == topic.toHexString());
    print("get history $historymsg");
    msglist![index!].msg = [];
    notifyListeners();
  }

  int grouphis_value = 1;

  groupp_his_value_plus() {
    grouphis_value++;
    notifyListeners();
  }

  Future add_group_his_page(topic) async {
    var newpage = await readremotemongodb(MqttMsg.fromJson, 'groupchatmsg',
        field: mongo.where
            .eq('topic_id', topic)
            .skip(grouphis_value * chatpagesize)
            .limit(chatpagesize));
    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        if (newpage != null) {
          newpage = newpage.reversed.toList();
          historymsg!.addAll(newpage);
        }
        groupp_his_value_plus();
      }
    }
  }

  int o2ohis_value = 1;

  o2o_his_value_plus() {
    o2ohis_value++;
    notifyListeners();
  }

  Future geto2ohismsg(topic) async {
    o2ohis_value = 1;
    print("get 444 o2ohistory $topic ");
    o2ohistorymsg = null;
    o2ohistorymsg = await readremotemongodb(MqttMsg.fromJson, 'o2ochatmsg',
        field: mongo.where
            .eq('topic_id', topic)
            .eq('memberid', remoteUserInfo[0].memberid)
            .or(mongo.where
                .eq('topic_id', remoteUserInfo[0].memberid)
                .eq('memberid', topic))
            .sortBy('time')
            .limit(chatpagesize));
    // .whenComplete(() => mqttlistener(topic.toHexString()));
    if (o2ohistorymsg != null) {
      o2ohistorymsg = o2ohistorymsg!.reversed.toList();
    }
    //進頁面的時候request 歷史紀錄 檢查o2o對話紀錄中有沒有這個topic對應的list 有就刪掉
    var index = o2o_msglist
        ?.indexWhere((element) => element.memberid == topic.toHexString());
    print("get o2o history $o2ohistorymsg #index $index");
    if (index != null && index != -1) {
      o2o_msglist![index].msg = [];
    }
    notifyListeners();
  }

  Future add_o2o_his_page(topic) async {
    var newpage = await readremotemongodb(MqttMsg.fromJson, 'o2ochatmsg',
        field: mongo.where
            .eq('topic_id', topic)
            .eq('memberid', remoteUserInfo[0].memberid)
            .or(mongo.where
                .eq('topic_id', remoteUserInfo[0].memberid)
                .eq('memberid', topic))
            .sortBy('time')
            .skip(o2ohis_value * chatpagesize)
            .limit(chatpagesize));
    if (newpage is List) {
      if (newpage.isEmpty) {
      } else {
        if (newpage != null) {
          newpage = newpage.reversed.toList();
          o2ohistorymsg!.addAll(newpage);
        }
        o2o_his_value_plus();
      }
    }
  }

  List? memberlist = [];
  List? o2omemberlist;

  Future getchatroommember(topic) async {
    print("get member $topic");
    memberlist = await readremotemongodb(DbUserinfoModel.fromJson, 'member',
        field: mongo.where.eq('chatroomid', topic));
    print("get member $memberlist");
    notifyListeners();
  }

  //獲得某特定id 查到的使用者資料 (他人)
  Future getmemberinfo(memberid) async {
    print("get one member info $memberid");
    o2omemberlist = await readremotemongodb(DbUserinfoModel.fromJson, 'member',
        field: mongo.where.eq('_id', mongo.ObjectId.fromHexString(memberid)));
    print("get member data $o2omemberlist");
    notifyListeners();
  }

  Future readremotemongodb(func, table, {field}) async {
    print('provider read mongo ::table name $func $table ');
    final readresult =
        await queue.add(() => _mongoDB.readdb(func, table, field: field));
    print("readreadread $readresult");
    return readresult;
  }

  Future delete_one_remotemongodb(table, field) async {
    print('provider delete one  mongo ::table name $table $field ');
    final readresult = await queue.add(() => _mongoDB.delete_one(table, field));
    print("delete_onedelete_onedelete_one $readresult");
    return readresult;
  }

  //get near
  Future getnearmongodb(func, table, loc, field) async {
    print('provider read mongo ::table name $func $table ');
    final readresult =
        await queue.add(() => _mongoDB.readdb_near(func, table, field: field));
    print("readreadread $readresult");
    return readresult;
  }

  //look up
  Future lookupmongodb(func, collname, pipeline) async {
    print('provider look up  mongo :: ');
    final readresult =
        await queue.add(() => _mongoDB.lookup2(func, collname, pipeline));
    print("lookuplookuplookup $readresult");
    return readresult;
  }

  //創建聊天室 建立 群聊
  Future createchatroom(
      String title,
      String? area,
      String imgurl,
      int type,
      String purpose,
      String note,
      String rule,
      DateTime createtime,
      DateTime datetime) async {
    print("點增加聊天室 sex 1男 2女 type 0揪團  1約會 2私聊 設定約會時間$datetime");

    print('輸入匡沒輸入');
    await _mongoDB.inserttomongo(
      "chatroom",
      {
        "imgurl": imgurl,
        "type": type,
        "title": title,
        "purpose": purpose == '' ? purposelist[0] : purpose,
        "note": note,
        "area": area,
        "rule": rule,
        "owner_id": account_id,
        "create_time": createtime,
        // "owner_sex": remoteUserInfo[0].sex,
        "datetime": datetime,
      },
    );

    Future.delayed(Duration(seconds: 1), () async {
      if (type == 0) {
        getgroupteam();
      } else {
        getgroupperson();
      }
    });
  }

  Future deleteAllRoom() async {
    print('all delete');
    await _mongoDB.deletealltable('chatmsg');
    await _mongoDB.deletealltable('action');
    await _mongoDB.deletealltable('action_msg');
    await _mongoDB.deletealltable('groupchatmsg');
    await _mongoDB.deletealltable('o2ochatmsg');
    await _mongoDB.deletealltable('o2olog');
    await _mongoDB.deletealltable('block_log');
    await _mongoDB.deletealltable('follow_log');
    await _mongoDB.deletealltable('chatroom');
    await _mongoDB.deletealltable('member');
  }

  void dbclose() {
    _mongoDB.dbclose();
  }

  List chatroomsetting = [];

  Future getchatroomsetting(id) async {
    // print('idididid  $id');
    chatroomsetting = await readremotemongodb(
        ChatroomSettingModel.fromJson, 'chatroom',
        field: mongo.where.eq('_id', id)
        // .fields(['imgurl', 'note', 'rule', 'purpose'])

        );
    print('setting image $chatroomsetting');
    notifyListeners();
  }

  // Future trylookup() async {
  //   print('account if$account_id ${remoteUserInfo[0].memberid}');
  //   var result = await lookupmongodb(
  //     DbUserinfoModel.fromJson,
  //     'member',
  //     {
  //       '\$project': {
  //         'account': 1,
  //       },
  //     },
  //     {
  //       '\$match': {'_id': remoteUserInfo[0].memberid}
  //     },
  //     {
  //       '\$lookup': {
  //         'from': 'follow_log',
  //         'localField': '_id',
  //         'foreignField': 'member_id',
  //         'as': 'follow_log',
  //         'pipeline': [
  //           {
  //             '\$project': {
  //               'list_id': 1,
  //               '_id': 0,
  //             }
  //           }
  //         ],
  //       }
  //     },
  //     //
  //     // 'member',
  //     // 'member_id',remoteUserInfo[0].memberid,
  //     // 'follow_log',
  //
  //     // mongo.Match(mongo.where
  //     //     .eq('member_id', remoteUserInfo[0].memberid)
  //     //     .map['\$query']),
  //
  //     // {},
  //     // [
  //     //   mongo.Project({
  //     //     'list_id': 1,
  //     //     '_id': 0,
  //     //   }),
  //     // mongo.Match(mongo.Expr(mongo.And(
  //     //   [
  //     //     mongo.Eq(
  //     //       mongo.Field('member_id'),
  //     //       mongo.Field('_id'),
  //     //     ),
  //     //   ],
  //     // )
  //     // ))
  //     // ],
  //     // 'text_list'
  //   );
  //
  //   // print('numbe fofofof ${result.length}');
  // }

  Future trylookup2() async {
    // final result = await lookupmongodb(
    //     DbUserinfoModel.fromJson,
    //     'member',
    //     mongo.Project({
    //       'account': 1,
    //     }),
    //     mongo.Match(
    //         mongo.where.eq('_id', remoteUserInfo[0].memberid).map['\$query']),
    //     mongo.Lookup(
    //       from: 'follow_log',
    //       as: 'follow_log',
    //       // let: {},
    //       foreignField: 'member_id',
    //       localField: '_id',
    //       // pipeline: [],
    //     ));
    // print('numbe fofofof $result');
    // print('numbe y7y7y7y ${result[0].follow_log_list[0]}');
    return result;
  }

  Future addchatroom(chatroomid) async {
    print("點在個人資料加入訂閱的聊天室");
    //資料庫更新 member
    await _mongoDB.updateData_addSet(
      "member",
      "account",
      account_id,
      'chatroomid',
      chatroomid,
    );
    await getaccountinfo();
  }

  getaddress() async {
    print('獲得地址');
    try {
      var result = await Geolocator.getCurrentPosition();
      print('地址1$result');
      List<Placemark> placemarks =
          await placemarkFromCoordinates(result.latitude, result.longitude);

      print('地址2${placemarks[0].administrativeArea}');
    } catch (e) {
      print('get device position exception $e');
    }
  }

  Future createnewperson(account) async {
    // create member table on mongo
    // 註冊ime
    print("註冊ime - insert user info  ");
    //獲得地址
    // var location;
    // List<Placemark> placemarks = [];
    // try {
    //   LocationPermission permission;
    //   permission = await Geolocator.checkPermission();
    //   if (permission == LocationPermission.denied) {
    //     permission = await Geolocator.requestPermission();
    //     if (permission == LocationPermission.deniedForever) {
    //       return Future.error('Location Not Available');
    //     }
    //   } else {
    //     var result = await Geolocator.getCurrentPosition();
    //     print('獲得地址 ${result}結果');
    //     location = result;
    //     placemarks =
    //         await placemarkFromCoordinates(result.latitude, result.longitude);
    //   }
    // } catch (e) {
    //   print('get device position exception $e');
    //   location = null;
    // }
    //
    print("登入時建立 /更新 member資料 ");

    Future.delayed(Duration(seconds: 3), () async {
      ///---- 注意 index 這條  只在mongodb做一次  ----
      // await _mongoDB.create_locationindex("member");

      /// !!!!!!! 預設都是男的 需要在找性別 !!帶改 第三方登入要求資料
      /// role 1 玩家 2直播主
      // 存在即不更新
      //  = 第一次才會建立
      // role = 1 =玩家
      await _mongoDB.updateData_single2("member", 'account', account.uid, {
        'create_time': DateTime.now().add(
          Duration(hours: 8),
        ),
        'follow_num': 0,
        'nickname': account.displayName,
        'avatar': account.photoURL,
        'avatar_sub': account.photoURL,
        'introduction': '',
        'little_profile_pic': [
          account.photoURL,
          '',
          '',
        ],
        'profile_pic': [account.photoURL, '', ''],
        'role': 1,
        'default_chat': '',
        'vip': false,
        'get_donate_count': 0,
      });

      // 每次登入都刷新
      print('每次登入都刷新');
      // if (location != null && placemarks.isNotEmpty) {
      //   // print('placemarks${placemarks}');
      //
      //   ///在改 測試
      //   await _mongoDB.upsertData2(
      //     "member",
      //     'account',
      //     account.uid,
      //     {
      //       'position': {
      //         'coordinates': [
      //           location.longitude,
      //           location.latitude,
      //         ],
      //         'type': 'Point',
      //       },
      //       'lastlogin': DateTime.now().add(Duration(hours: 8)),
      //       'area': placemarks[0].administrativeArea,
      //       'introduction': '',
      //     },
      //   );
      // } else {
      //   await _mongoDB.upsertData2(
      //     "member",
      //     'account',
      //     account,
      //     {
      //       'lastlogin': DateTime.now().add(Duration(hours: 8)),
      //       // 'area': placemarks[0].administrativeArea,
      //       'introduction': '',
      //     },
      //   );
      // }

      await _mongoDB.upsertData2(
        "member",
        'account',
        account.uid,
        {
          'lastlogin': DateTime.now().add(Duration(hours: 8)),
          // 'area': placemarks[0].administrativeArea,
        },
      );
    });
  }

  //雙方私聊紀錄 資訊
  Future createo2olog(chatto_id, chatto_nickname, chatto_avatar) async {
    print("createo2olog  $chatto_id");
    //紀錄 我的對象訊息
    await _mongoDB.upsertData("o2olog", 'member_id', remoteUserInfo[0].memberid,
        'chatto_id', chatto_id, {
      'nickname': chatto_nickname,
      'avatar': chatto_avatar,
      'last_chat_time': DateTime.now().add(Duration(hours: 8)),
    });
    //我的對象要看的 我的資訊
    await _mongoDB.upsertData("o2olog", 'chatto_id', remoteUserInfo[0].memberid,
        'member_id', chatto_id, {
      'nickname': remoteUserInfo[0].nickname,
      'avatar': remoteUserInfo[0].avatar,
      'avatar_sub': remoteUserInfo[0].avatar_sub,
      'last_chat_time': DateTime.now().add(Duration(hours: 8)),
    });
  }

  Future createfollowlog() async {
    await _mongoDB.updateData_single2(
        "follow_log", 'member_id', remoteUserInfo[0].memberid, {
      'create_time': DateTime.now().add(
        Duration(hours: 8),
      ),
      'list_id': [],
    });
  }

  Future createblocklog() async {
    await _mongoDB.updateData_single2(
        "block_log", 'member_id', remoteUserInfo[0].memberid, {
      'create_time': DateTime.now().add(
        Duration(hours: 8),
      ),
      'list_id': [],
    });
  }

  var myfollowlog;
  var follow_me_list;

  Future getmyfollowlog() async {
    print('查詢我的追蹤跟追蹤我的');
    //我的追蹤
    myfollowlog = await readremotemongodb(FollowLogModel.fromJson, 'follow_log',
        field: mongo.where.eq('member_id', remoteUserInfo[0].memberid)) as List;

    //追蹤我的
    follow_me_list = await readremotemongodb(
        FollowLogModel.fromJson, 'follow_log',
        field: mongo.where.eq('list_id', remoteUserInfo[0].memberid)) as List;
    print('getmyfollowlog $myfollowlog');
    //自己的不會空 會為1

    print('get follow me list  $follow_me_list');

    notifyListeners();
  }

  // Future getyfollowme_num() async {
  //   var result = await readremotemongodb(FollowLogModel.fromJson, 'follow_log',
  //       field: mongo.where.eq('memberid', remoteUserInfo[0].memberid)) as List;
  //   print('getmyfollowl num myid:${remoteUserInfo[0].memberid} /-/ $result');
  //   if (result != null) {
  //     print('幾個人喜歡我${result.length}');
  //   }
  //   notifyListeners();
  // }

  //點擊 加入關注
  Future addfollowlog(follow_id) async {
    print("add followlog");

    var index;
    if (myfollowlog[0].list_id == null) {
      index = -1;
      myfollowlog[0].list_id = [];
    } else {
      index =
          myfollowlog[0].list_id.indexWhere((element) => element == follow_id);
    }
    print('follow log index $index');

    if (index == -1) {
      print('加入關住');
      //沒關注 ->要關注
      // 加入log
      await _mongoDB.updateData_addSet(
        "follow_log",
        "member_id",
        remoteUserInfo[0].memberid,
        'list_id',
        follow_id,
      );
      // follow數+1
      await _mongoDB.plus_num('member', "_id", follow_id, 'follow_num', 1);
      myfollowlog[0].list_id.add(follow_id);
    } else {
      //在關注 ->取消關注
      print('取消關住 $follow_id');
      myfollowlog[0].list_id.remove(follow_id);

      //資料庫將聊天室去掉
      _mongoDB.deleteData(
        "follow_log",
        "member_id",
        remoteUserInfo[0].memberid,
        'list_id',
        follow_id,
      );

      // follow數-1
      await _mongoDB.plus_num('member', "_id", follow_id, 'follow_num', -1);
    }
    notifyListeners();
  }

  var myblocklog;

  Future getmyblocklog() async {
    myblocklog = await readremotemongodb(FollowLogModel.fromJson, 'block_log',
        field: mongo.where.eq('member_id', remoteUserInfo[0].memberid));
    print('my blocklist $myblocklog');
    if (myblocklog.isNotEmpty) {
      print('getmyblocklog ${myblocklog[0].list_id}');
    } else {
      print('getmyblocklog 空');
    }

    notifyListeners();
  }

  List changeblocklist = [];

  void addblocklist(block_id) {
    print('addblock');
    if (changeblocklist.contains(block_id) == false) {
      changeblocklist.add(block_id);
    } else {
      changeblocklist.remove(block_id);
      if (changeblocklist == null) {
        changeblocklist = [];
      }
    }
    notifyListeners();
  }

  Future addblocklog(block_id) async {
    print("add blocklog");
    var index;
    if (myblocklog[0].list_id == null) {
      index = -1;
      myblocklog[0].list_id = [];
    } else {
      index =
          myblocklog[0].list_id.indexWhere((element) => element == block_id);
    }
    print('blocklog index $index');
    if (index == -1) {
      print('加入黑名單');
      //沒關注 ->要關注
      await _mongoDB.updateData_addSet(
        "block_log",
        "member_id",
        remoteUserInfo[0].memberid,
        'list_id',
        mongo.ObjectId.fromHexString(block_id),
      );
      myblocklog[0].list_id.add(block_id);
    } else {
      //在關注 ->取消關注
      print('取消黑名單 $block_id');
      myblocklog[0].list_id.remove(block_id);

      //資料庫將聊天室去掉
      _mongoDB.deleteData(
        "block_log",
        "member_id",
        remoteUserInfo[0].memberid,
        'list_id',
        mongo.ObjectId.fromHexString(block_id),
      );
    }
    notifyListeners();
  }

  void removeblocklist() {
    for (var item in changeblocklist) {
      print('將預設的item $item 從 myblocklog remove');
      myblocklog[0].list_id.remove(item);
      //資料庫將聊天室去掉
      _mongoDB.deleteData(
        "block_log",
        "member_id",
        remoteUserInfo[0].memberid,
        'list_id',
        item,
      );
    }
  }

  Future change_avatar() async {
    await pickimg();
    if (result == null) {
      print('選檔案 空的');
    } else {
      _imageName = Uuid().v1().toString() + '.png';
      // _imageBytes = result!.files.single.bytes!;
      _imageBytes = resizeImage(result!.files.single.bytes!, 1000);
      _subimageBytes = resizeImage(_imageBytes!, 300);

      try {
        final response = await api.save(_imageName!, _imageBytes!);
        final response2 = await api.save(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        print(
            '改變avatar ${response.downloadLink.toString()}  avatar sub ${response2.downloadLink.toString()}');
        await _mongoDB.updateData_single(
          "member",
          "account",
          account_id,
          {
            'avatar': response.downloadLink.toString(),
            'avatar_sub': response2.downloadLink.toString()
          },
        );
        print('圖片在gcp 下載網址位置 ${response.downloadLink}');
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }

    await getaccountinfo();
  }

  Future change_datesetting(distance_range, age_range) async {
    try {
      await _mongoDB.updateData_single(
        "member",
        "account",
        account_id,
        {
          'distance_range': distance_range,
          'age_range': age_range,
        },
      );
    } catch (e) {
      print('上傳圖片失敗  $e');
    }

    await getaccountinfo();
  }

  List profile_pic = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  List little_profile_pic = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  List<bool> waitinglist = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  //更改 list 圖片 個人資料設定
  Future upload_pic(index) async {
    print('點擊上傳三張圖片中的$index');
    await pickimg();
    if (result == null) {
      print('選檔案 空的');
    } else {
      _imageName = result!.files.single.path!.split('/').last;
      // 大圖
      // _imageBytes = result!.files.single.bytes!;
      _imageBytes = resizeImage(result!.files.single.bytes!, 1000);
      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      waitinglist[index] = true;
      notifyListeners();
      try {
        final response = await api.save(_imageName!, _imageBytes!);
        final response2 = await api.save(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        print(
            '圖片在gcp 圖片的位置 ${response.downloadLink}///${response2.downloadLink}');
        profile_pic[index] = response.downloadLink.toString();
        little_profile_pic[index] = response2.downloadLink.toString();
        waitinglist[index] = false;
        notifyListeners();
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }
  }

  Future upload_pic_camera(index) async {
    print('點擊上傳三張圖片中的$index');
    var name = 'pic/' + Uuid().v1().toString() + '.png';
    await pickimg2_camera();
    if (pickimg_result == null) {
      print('選檔案 空的');
    } else {
      // _imageName = pickimg_result.path!.split('/').last;
      _imageName = name;
      print('pickimg_result ${pickimg_result.runtimeType}');
      // _imageBytes = await pickimg_result!.readAsBytes();
      _imageBytes = resizeImage(await pickimg_result!.readAsBytes(), 1000);
      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      waitinglist[index] = true;
      notifyListeners();
      try {
        final response = await api.save2(_imageName!, _imageBytes!);
        final response2 = await api.save2(
            _imageName!.split('.').first + '_2.png', _subimageBytes!);
        print(
            '圖片在gcp 圖片的位置 ${response.downloadLink}///${response2.downloadLink}');
        profile_pic[index] = response.downloadLink.toString();
        little_profile_pic[index] = response2.downloadLink.toString();
        waitinglist[index] = false;
        notifyListeners();
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }
  }

  set_profile_pic() {
    if (remoteUserInfo[0].profilepic_list != null &&
        remoteUserInfo[0].little_profilepic_list != null) {
      for (int i = 0;
          i < remoteUserInfo[0].little_profilepic_list.length;
          i++) {
        profile_pic[i] = remoteUserInfo[0].profilepic_list[i];
        little_profile_pic[i] = remoteUserInfo[0].profilepic_list[i];
      }
      notifyListeners();
    }
  }

  Future change_chatroom_img(id) async {
    await pickimg();
    if (result == null) {
      print('選檔案 空的');
    } else {
      _imageName = result!.files.single.path!.split('/').last;
      _imageBytes = resizeImage(result!.files.single.bytes!, 1000);
      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      try {
        final response = await api.save(_imageName!, _imageBytes!);
        print('改變chatroom_img ${response.downloadLink.toString()}');
        await _mongoDB.updateData_single(
          "chatroom",
          "_id",
          id,
          {'imgurl': response.downloadLink.toString()},
        );
        print('圖片在gcp 下載網址位置 ${response.downloadLink}');
        changenowroomimg(response.downloadLink.toString());
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }

    await getaccountinfo();
  }

  Future change_chatroom_info(
    id,
    title,
    purpose,
    note,
    rule,
  ) async {
    print('改變chatroom_info $id $title $purpose $note $rule}');
    await _mongoDB.updateData_single(
      "chatroom",
      "_id",
      id,
      {
        "title": title,
        "purpose": purpose,
        "note": note,
        "rule": rule,
      },
    );
  }

  changenowroomimg(img) {
    chatroomsetting[0].imgurl = img;
    notifyListeners();
  }

  Future change_cover() async {
    await pickimg();
    if (result == null) {
      print('選檔案 空的');
    } else {
      _imageName = result!.files.single.path!.split('/').last;
      _imageBytes = resizeImage(result!.files.single.bytes!, 1000);
      //小圖
      _subimageBytes = resizeImage(_imageBytes!, 300);
      try {
        final response = await api.save(_imageName!, _imageBytes!);
        print('改變cover ${response.downloadLink.toString()}');
        await _mongoDB.updateData_single(
          "member",
          "account",
          account_id,
          {'cover': response.downloadLink.toString()},
        );
        print('圖片在gcp 下載網址位置 ${response.downloadLink}');
      } catch (e) {
        print('上傳圖片失敗  $e');
      }
    }

    await getaccountinfo();
  }

  Future change_profile(
      nickname,
      constellation,
      age,
      height,
      introduction,
      size,
      personality,
      profession,
      area,
      date,
      money,
      lookfor,
      education,
      language,
      smoke,
      drink,
      voice_introduction) async {
    try {
      await _mongoDB.updateData_single(
        "member",
        "account",
        account_id,
        {
          'nickname': nickname,
          'constellation': constellation,
          'age': age,
          'height': height,
          'introduction': introduction,
          'size': size,
          'interest_list': interestlist,
          'personality': personality,
          'profession': profession,
          'area': area,
          'date': date,
          'money': money,
          'lookfor': lookfor,
          'education': education,
          'language': language,
          'smoke': smoke,
          'drink': drink,
          'voice_introduction': voice_introduction,
          'profile_pic': profile_pic,
          'little_profile_pic': little_profile_pic,
          'avatar': profile_pic[0],
          'avatar_sub': little_profile_pic[0],
        },
      );
      print('change_profile ${nickname}');
    } catch (e) {
      print('更改個人資料 error exception  $e');
    }

    await getaccountinfo();
  }

  Future change_simple_profile(nickname, birthday, sex) async {
    try {
      await _mongoDB.updateData_single(
        "member",
        "account",
        account_id,
        {
          'nickname': nickname,
          'birthday': birthday,
          'sex': sex == 1 ? '男' : '女'
        },
      );

      print('註冊填寫 簡單資料 ${nickname}');
      return true;
    } catch (e) {
      print('填寫註冊基本資料時錯誤 error exception  $e');
      return false;
    }
  }

  List interestlist = [];

  set_interest() {
    print('set_interest');
    interestlist = [];
    if (remoteUserInfo[0].interest_list != null) {
      for (int i = 0; i < remoteUserInfo[0].interest_list.length; i++) {
        print('interest::${remoteUserInfo[0].interest_list[i]}');
        interestlist.add(remoteUserInfo[0].interest_list[i]);
      }
      notifyListeners();
    }
  }

  add_interest(item) {
    if (interestlist.contains(item)) {
      interestlist.remove(item);
    } else {
      if (interestlist.length > 2) {
        interestlist.removeAt(0);
        interestlist.add(item);
      } else {
        interestlist.add(item);
      }
    }
    notifyListeners();
  }

//加入目的列表
  List purposelist = [];

  add_purposelist(item) {
    print('加入 或移出 $purposelist');
    if (purposelist.contains(item)) {
      purposelist.remove(item);
      // purposelist.clear();
    } else {
      if (purposelist.length > 0) {
        purposelist.removeAt(0);
        purposelist.add(item);
      } else {
        purposelist.add(item);
      }
    }
    notifyListeners();
  }

  // Future saveinterest() async {
  //   await _mongoDB.upsertData2(
  //     "interest",
  //     'memberid',
  //     remoteUserInfo[0].memberid,
  //     {
  //       'interest_list': interestlist,
  //       'age': remoteUserInfo[0].age,
  //       'nickname': remoteUserInfo[0].nickname,
  //       'area': remoteUserInfo[0].area,
  //       'intro': remoteUserInfo[0].introduction
  //     },
  //   );
  // }

  Future change_hello(sentence) async {
    try {
      await _mongoDB.updateData_single(
        "member",
        "account",
        account_id,
        {
          'default_chat': sentence,
        },
      );
      print('change_hello ${sentence}');
    } catch (e) {
      print('更改打招呼 error exception $e');
    }

    await getaccountinfo();
  }

//讀本地檔案
  Future readlocaldata(key, formatfun) async {
    prefs = await SharedPreferences.getInstance();
    var result = prefs.get(key);

    print('read local111 type $result');
    print('read local111 format  ${formatfun(result)}');

    return formatfun(result);
  }

  /**
   * 廣場
   */

  int find_newest_register_value = 1;
  int find_last_login_people_value = 1;
  int find_near_people_value = 1;
  int find_recommend_people_value = 1;

  List? nearpeoplelist;
  bool locate_permission = false;

  Future find_near_people() async {
    find_near_people_value = 1;
    print('find near people');

    var location;
    List<Placemark> placemarks = [];
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          locate_permission = false;
          print('使用者不開gps');
          return Future.error('Location Not Available');
        }
      } else {
        locate_permission = true;
        var result = await Geolocator.getCurrentPosition();
        print('獲得地址 ${result}結果');
        location = result;
        placemarks =
            await placemarkFromCoordinates(result.latitude, result.longitude);
        print('my location ${location.longitude}/ ${location.latitude}');
        var _loc = {
          'type': 'Point',
          'coordinates': [location.longitude, location.latitude]
        };
        nearpeoplelist = await getnearmongodb(
            DbUserinfoModel.fromJson,
            'member',
            _loc,
            mongo.where
                .near('position', _loc)
                .and(mongo.where
                    .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                .limit(pagesize));
        //把自己刪掉
        nearpeoplelist?.removeWhere(
            (element) => element.memberid == remoteUserInfo[0].memberid);

        notifyListeners();
      }
    } catch (e) {
      print('get device position exception $e');
      location = null;
    }
  }

  Future addpage_find_near_people() async {
    find_near_people_value = 1;
    var location = await Geolocator.getCurrentPosition();
    print('my location ${location.longitude}/ ${location.latitude}');
    var _loc = {
      'type': 'Point',
      'coordinates': [location.longitude, location.latitude]
    };
    var newpage = await getnearmongodb(
        DbUserinfoModel.fromJson,
        'member',
        _loc,
        mongo.where
            .near('position', _loc)
            .and(
                mongo.where.eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
            .skip(find_near_people_value * pagesize)
            .limit(pagesize));
    //把自己刪掉
    newpage?.removeWhere(
        (element) => element.memberid == remoteUserInfo[0].memberid);
    nearpeoplelist!.addAll(newpage);
    notifyListeners();
  }

  List? last_login_memberlist;

  Future find_last_login_people() async {
    find_last_login_people_value = 1;
    last_login_memberlist =
        await readremotemongodb(DbUserinfoModel.fromJson, 'member',
            field: mongo.where
                // .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
                .limit(pagesize)
                .sortBy('lastlogin', descending: true));
    print("find_last_login $last_login_memberlist");
    //把自己刪掉
    last_login_memberlist?.removeWhere(
        (element) => element.memberid == remoteUserInfo[0].memberid);
    notifyListeners();
  }

  Future addpage_find_last_login_people() async {
    var newpage = await readremotemongodb(DbUserinfoModel.fromJson, 'member',
        field: mongo.where
            .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
            .skip(find_last_login_people_value * pagesize)
            .limit(pagesize)
            .sortBy('lastlogin', descending: true));
    newpage?.removeWhere(
        (element) => element.memberid == remoteUserInfo[0].memberid);
    print('last newpage ${newpage}');
    last_login_memberlist!.addAll(newpage);
    notifyListeners();
  }

  void plus_page(value) {
    // page 1=推薦 page 2=最近登入 page 3=最新註冊 page 4= 附近會員
    switch (value) {
      case 1:
        find_recommend_people_value = find_recommend_people_value + 1;
        break;
      case 2:
        find_last_login_people_value = find_last_login_people_value + 1;
        break;
      case 3:
        find_newest_register_value = find_newest_register_value + 1;
        break;
      case 4:
        find_near_people_value = find_near_people_value + 1;
        break;
    }

    notifyListeners();
  }

//最新註冊
  List? newest_register_memberlist;

  Future find_newest_register_people() async {
    find_newest_register_value = 1;
    newest_register_memberlist = await readremotemongodb(
        DbUserinfoModel.fromJson, 'member',
        field: mongo.where
            .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
            .limit(pagesize)
            .sortBy('create_time', descending: true));
    print("newest_register $memberlist 多少$find_newest_register_value");
    //把自己刪掉
    newest_register_memberlist?.removeWhere(
        (element) => element.memberid == remoteUserInfo[0].memberid);
    notifyListeners();
  }

  Future addpage_find_newest_register_people() async {
    var newpage = await readremotemongodb(DbUserinfoModel.fromJson, 'member',
        field: mongo.where
            .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
            .skip(find_newest_register_value * pagesize)
            .limit(pagesize)
            .sortBy('create_time', descending: true));
    print('newpage $newpage value $find_newest_register_value');
    newpage?.removeWhere(
        (element) => element.memberid == remoteUserInfo[0].memberid);
    newest_register_memberlist!.addAll(newpage);
    notifyListeners();
  }

  //推薦
  List? recommend_memberlist;

  Future find_recommend_people() async {
    find_recommend_people_value = 1;
    if (remoteUserInfo != null) {
      // print('找到推薦 我的${remoteUserInfo[0].sex} 年紀${remoteUserInfo[0].age}');
      if (remoteUserInfo[0].age == null) {
        if (remoteUserInfo[0].sex != null) {
          print('mongo db沒有 年齡有性別');
          recommend_memberlist = await readremotemongodb(
              DbUserinfoModel.fromJson, 'member',
              field: mongo.where
                  // .oneFrom('interest_list', remoteUserInfo[0].interest_list)
                  // .and(mongo.where
                  //     .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))

                  .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
                  .sortBy('follow_num')
                  .limit(pagesize));
          recommend_memberlist?.removeWhere(
              (element) => element.memberid == remoteUserInfo[0].memberid);
        } else {
          print('mongo db沒有 年齡 沒有性別');
          recommend_memberlist = null;
        }
      } else {
        print('mongo db 有 年齡');
        recommend_memberlist = await readremotemongodb(
            DbUserinfoModel.fromJson, 'member',
            field: mongo.where
                .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
                .sortBy('follow_num', descending: true)
                .limit(pagesize));
        recommend_memberlist?.removeWhere(
            (element) => element.memberid == remoteUserInfo[0].memberid);
        // field:
        // mongo.where
        //     .oneFrom('interest_list', remoteUserInfo[0].interest_list)
        //     .and(mongo.where.gte('age', remoteUserInfo[0].age - 5))
        //     .and(mongo.where.lte('age', remoteUserInfo[0].age + 5))
        //     .and(mongo.where
        //     .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
        //     .limit(pagesize)
        // );
      }
    } else {
      print('沒有userinfo資料');
    }

    print("find_recommend $recommend_memberlist");
    notifyListeners();
  }

  Future addpage_find_recommend_people() async {
    if (remoteUserInfo != null) {
      print('找到推薦 我的${remoteUserInfo[0].sex} 年紀${remoteUserInfo[0].age}');
      if (remoteUserInfo[0].age != null) {
        print('mongo db 有 年齡');
        var newpage = await readremotemongodb(
            DbUserinfoModel.fromJson, 'member',
            field: mongo.where
                // .oneFrom('interest_list', remoteUserInfo[0].interest_list)
                // .and(mongo.where.gte('age', remoteUserInfo[0].age - 5))
                // .and(mongo.where.lte('age', remoteUserInfo[0].age + 5))
                // .and(mongo.where
                //     .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
                .sortBy('follow_num', descending: true)
                .skip(find_recommend_people_value * pagesize)
                .limit(pagesize));
        newpage?.removeWhere(
            (element) => element.memberid == remoteUserInfo[0].memberid);
        recommend_memberlist!.addAll(newpage);
      } else {
        print('mongo db沒有 年齡');
        var newpage = await readremotemongodb(
            DbUserinfoModel.fromJson, 'member',
            field: mongo.where
                // .oneFrom('interest_list', remoteUserInfo[0].interest_list)
                // .and(mongo.where
                //     .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女')
                .sortBy('follow_num', descending: true)
                .skip(find_recommend_people_value * pagesize)
                .limit(pagesize));
        newpage?.removeWhere(
            (element) => element.memberid == remoteUserInfo[0].memberid);
        recommend_memberlist!.addAll(newpage);
      }
    } else {
      print('沒有userinfo資料');
    }
    notifyListeners();
  }

  int? num_likeme;

  Future find_who_likeme(member_id) async {
    print('find_who_likeme');
    var result = await readremotemongodb(DbUserinfoModel.fromJson, 'follow_log',
        field: mongo.where.eq('list_id', member_id));
    if (result is List) {
      // print('find like me ${result.length}');
      num_likeme = result.length;
    }
    notifyListeners();
  }

  bool search = false;

  open_search() {
    search = true;
    notifyListeners();
  }

  var search_memberlist;

  Future get_search({area, age, height}) async {
    print('get_search area $area age $age height $height');
    //身高
    int a = 0;
    int b = 0;
    // 年齡
    int c = 0;
    int d = 0;

    if (area == '') {
      if (age == '') {
        if (height == '') {
          //什麼都沒有
        } else {
          //只有身高
          print('列出身高條件$height');
          if (height == '200公分以上') {
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('height', 200)
                    .and(mongo.where
                        .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                    .sortBy('lastlogin', descending: true));
          } else {
            a = int.parse(height.split('-')[0]);
            b = int.parse(height.split('-')[1]);
            print('aaaa$a');
            print('bbbb$b');
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('height', a)
                    .and(mongo.where.lte('height', b))
                    .and(mongo.where
                        .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                    .sortBy('lastlogin', descending: true));
          }
        }
      } else {
        if (height == '') {
          //只有年齡
          print('列出年齡條件$age');

          c = int.parse(age.split('-')[0]);
          d = int.parse(age.split('-')[1]);
          print('cccc$c');
          print('dddd$d');
          search_memberlist = await readremotemongodb(
              DbUserinfoModel.fromJson, 'member',
              field: mongo.where
                  .gte('age', c)
                  .and(mongo.where.lte('age', d))
                  .and(mongo.where
                      .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                  .sortBy('lastlogin', descending: true));
        } else {
          //年齡跟身高
          print('列出年齡 跟身高條件$age $height');
          c = int.parse(age.split('-')[0]);
          d = int.parse(age.split('-')[1]);
          print('cccc$c');
          print('dddd$d');
          if (height == '200公分以上') {
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('age', c)
                    .and(mongo.where.lte('age', d))
                    .and(mongo.where.gte('height', 200))
                    .and(mongo.where
                        .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                    .sortBy('lastlogin', descending: true));
          } else {
            a = int.parse(height.split('-')[0]);
            b = int.parse(height.split('-')[1]);
            print('uuuuu');
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('age', c)
                    .and(mongo.where.lte('age', d))
                    .and(mongo.where.gte('height', a))
                    .and(mongo.where.lte('height', b))
                // .and(mongo.where
                //     .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                // .sortBy('lastlogin', descending: true)

                );
          }
        }
      }
    } else {
      if (age == '') {
        if (height == '') {
          // 只有地區
          print('列出地區 條件$area ');
          search_memberlist = await readremotemongodb(
              DbUserinfoModel.fromJson, 'member',
              field: mongo.where
                  .eq('area', area)
                  .and(mongo.where
                      .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                  .sortBy('lastlogin', descending: true));
        } else {
          // 地區跟身高
          print('列出地區 身高條件$area $height');
          if (height == '200公分以上') {
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('height', 200)
                    .and(mongo.where.eq('area', area))
                    .and(mongo.where
                        .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                    .sortBy('lastlogin', descending: true));
          } else {
            a = int.parse(height.split('-')[0]);
            b = int.parse(height.split('-')[1]);
            print('aaaa$a');
            print('bbbb$b');
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('height', a)
                    .and(mongo.where.lte('height', b))
                    .and(mongo.where.eq('area', area))
                    .and(mongo.where
                        .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                    .sortBy('lastlogin', descending: true));
          }
        }
      } else {
        if (height == '') {
          // 地區跟年齡
          print('列出地區年齡條件$area $age');

          c = int.parse(age.split('-')[0]);
          d = int.parse(age.split('-')[1]);
          print('cccc$c');
          print('dddd$d');
          search_memberlist = await readremotemongodb(
              DbUserinfoModel.fromJson, 'member',
              field: mongo.where
                  .gte('age', c)
                  .and(mongo.where.lte('age', d))
                  .and(mongo.where.eq('area', area))
                  .and(mongo.where
                      .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                  .sortBy('lastlogin', descending: true));
        } else {
          // 地區年齡身高都有

          print('列出地區 年齡 跟身高條件$area $age $height');
          c = int.parse(age.split('-')[0]);
          d = int.parse(age.split('-')[1]);
          print('cccc$c');
          print('dddd$d');
          if (height == '200公分以上') {
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('age', c)
                    .and(mongo.where.lte('age', d))
                    .and(mongo.where.gte('height', 200))
                    .and(mongo.where.eq('area', area))
                    .and(mongo.where
                        .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                    .sortBy('lastlogin', descending: true));
          } else {
            a = int.parse(height.split('-')[0]);
            b = int.parse(height.split('-')[1]);
            search_memberlist = await readremotemongodb(
                DbUserinfoModel.fromJson, 'member',
                field: mongo.where
                    .gte('age', c)
                    .and(mongo.where.lte('age', d))
                    .and(mongo.where.gte('height', a))
                    .and(mongo.where.lte('height', b))
                    .and(mongo.where.eq('area', area))
                    .and(mongo.where
                        .eq('sex', remoteUserInfo[0].sex == '女' ? '男' : '女'))
                    .sortBy('lastlogin', descending: true));
          }
        }
      }
      notifyListeners();
    }

    // var result = await readremotemongodb(DbUserinfoModel.fromJson, 'follow_log',
    //     field: mongo.where.eq('list_id', member_id));
    // if (result is List) {
    //   // print('find like me ${result.length}');
    //   num_likeme = result.length;
    // }
  }

  close_search() {
    search = false;
    notifyListeners();
  }

  Future getcount(
    collection,
    con_field,
    con_value,
  ) async {
    final readresult = await queue.add(() => _mongoDB.count(
          collection,
          con_field,
          con_value,
        ));
    print("countcountcount $readresult");
    return readresult;
  }

  /**.
   *  設定
   */

  void set_o2ochat_text(text) {
    _mongoDB.updateData_single(
        "member", "account", account_id, {'default_chat': text});

    notifyListeners();
  }
}
