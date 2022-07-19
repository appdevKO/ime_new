import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/business_logic/provider/sweetProvider.dart';
import 'package:ime_new/ui/live/sweet/sweetView.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetRoom.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetAudience.dart';
import 'package:ime_new/business_logic/model/sweetModel/sweetAnchor.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:ime_new/ui/live/livepage2.dart';

bool? identity;

class SweetLiveList extends StatefulWidget {
  const SweetLiveList({Key? key}) : super(key: key);

  @override
  State<SweetLiveList> createState() => _SweetLiveListState();
}

class _SweetLiveListState extends State<SweetLiveList> {
  var count;

  @override
  Widget build(BuildContext context) {
    return Consumer<sweetProvider>(builder: (context, _sweetProvider, child) {
      try {
        count = _sweetProvider.rooms.length;
      } catch (error) {
        count = 0;
      }
      return Consumer<ChatProvider>(builder: (context, _ChatProvider, child) {
        return count != 0
            ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0, mainAxisSpacing: 40.0,
                        childAspectRatio: 0.8, //子元素在横轴长度和主轴长度的比例
                      ),
                      itemBuilder: (context, index) {
                        String name =
                            encodeToString(_sweetProvider.rooms[index].name);
                        String explain =
                            encodeToString(_sweetProvider.rooms[index].explain);
                        return Column(
                          children: [
                            Container(
                              height:
                                  MediaQuery.of(context).size.width / 2 - 20,
                              child: InkWell(
                                  onTap: () {
                                    // 觀眾資料 傳給Server
                                    var data = {};
                                    data['"roomId"'] =
                                        ('"${_sweetProvider.rooms[index].id}"');
                                    data['"selfEncodeName"'] =
                                        ('"${strToEncode(_ChatProvider.remoteUserInfo[0].nickname)}"');
                                    data['"selfAccount"'] =
                                        ('"${_ChatProvider.remoteUserInfo[0].account}"');
                                    //print(' audienceJson$audienceJson');
                                    sweetRoomId =
                                        _sweetProvider.rooms[index].id;
                                    identity = false;
                                    var pubTopic = 'imeSweetUser/' + myUid;
                                    final builder = MqttClientPayloadBuilder();
                                    builder.addString(
                                        "joinRoom," + data.toString());
                                    client.publishMessage(pubTopic,
                                        MqttQos.atLeastOnce, builder.payload!);
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(_sweetProvider
                                                  .rooms[index].avatarUrl),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color:
                                                    Colors.pink.withOpacity(.5),
                                                width: 1)),
                                      ),
                                      Container(
                                        height: 25,
                                        width: 75,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomRight:
                                                    Radius.circular(8))),
                                        child: Center(
                                          child: Text(
                                            '直播中',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          right: 5,
                                          top: 3,
                                          child: Container(
                                            height: 20,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xffffbde6),
                                                      Color(0xffff73c7)
                                                    ]),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                '#顏值',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                          left: 5,
                                          bottom: 5,
                                          child: Container(
                                            height: 15,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(.5),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: Text(
                                                '旅遊中',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                              ),
                                            ),
                                          )),
                                      Positioned(
                                          right: 10,
                                          bottom: 5,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.remove_red_eye,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0),
                                                child: Text(
                                                  (_sweetProvider.rooms[index]
                                                      .audienceCount
                                                      .toString()),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          ))
                                    ],
                                  )),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(name),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text(explain)),
                          ],
                        );
                      },
                      itemCount: count,
                    ),
                  ),
                ],
              )
            : Container(
                child: Center(child: Text('目前沒有主播在直播')),
              );
      });
    });
  }
}

/*
          ElevatedButton(*/
Future<Future<String?>> openRoom(
    BuildContext context, avatalUrl, nickName, selfAccount) async {
  String roomName = '';
  String roomExplain = ' ';
  String _hintText = '名稱不可為空';

  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('直播間標題'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  autofocus: true,
                  maxLength: 10,
                  decoration: new InputDecoration(hintText: _hintText),
                  onChanged: (value) {
                    roomName = value;
                  },
                ))
              ],
            ),
            new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(hintText: '直播間說明'),
                  maxLength: 15,
                  onChanged: (value) {
                    if (value != '') {
                      roomExplain = value;
                    }
                  },
                ))
              ],
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffff7090),
            ),
            child: Text('返回'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffff7090),
            ),
            child: Text('送出'),
            onPressed: () {
              if (roomName != '') {
                identity = true;
                String enName = strToEncode(roomName);
                String enExplain = strToEncode(roomExplain);
                String enAnchorName = strToEncode(nickName);
                var audienceJson = {};
                audienceJson['"anchorAvatar"'] = ('"${avatalUrl}"');
                audienceJson['"encodeRoomName"'] = ('"${enName}"');
                audienceJson['"encodeRoomExplain"'] = ('"${enExplain}"');
                audienceJson['"selfEncodeName"'] = ('"${enAnchorName}"');
                audienceJson['"selfAccount"'] = ('"${selfAccount}"');
                print("joinNewRoom," + audienceJson.toString());
                var pubTopic = 'imeSweetUser/' + myUid;
                final builder = MqttClientPayloadBuilder();
                builder.addString("joinNewRoom," + audienceJson.toString());
                client.publishMessage(
                    pubTopic, MqttQos.atLeastOnce, builder.payload!);

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
