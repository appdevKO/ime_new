import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/business_logic/provider/sweetProvider.dart';
import 'package:ime_new/ui/live/sweet/sweetView.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:provider/provider.dart';
import 'package:ime_new/business_logic/model/sweetRoom.dart';

bool? identity;

class SweetLiveList extends StatefulWidget {
  const SweetLiveList({Key? key}) : super(key: key);

  @override
  State<SweetLiveList> createState() => _SweetLiveListState();
}

class _SweetLiveListState extends State<SweetLiveList> {
  var count;
  String avatar = "https://i.ibb.co/cFFSzdK/sex-man.png";
  String nickName = "";
  @override
  Widget build(BuildContext context) {
    return Consumer<sweetProvider>(builder: (context, _sweetProvider, child) {
      try {
        count = _sweetProvider.rooms.length;
      } catch (error) {
        count = 0;
      }
      return Consumer<ChatProvider>(builder: (context, ChatProvider1, child) {
        try {
          if (ChatProvider1.remoteUserInfo[0].avatar == null) {
            if ((ChatProvider1.remoteUserInfo[0].sex) == '男') {
              avatar = "https://i.ibb.co/cFFSzdK/sex-man.png";
            } else if ((ChatProvider1.remoteUserInfo[0].sex) == '女') {
              avatar = "https://i.ibb.co/kJxyvc4/sex-woman.png";
            }
          } else {
            avatar = ChatProvider1.remoteUserInfo[0].avatar;
            nickName = ChatProvider1.remoteUserInfo[0].nickname;
          }
        } catch (err) {}
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
                        print(' name ${_sweetProvider.rooms[index].name}');
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
                                    var audienceJson = {};
                                    audienceJson['"rid"'] =
                                        ('"${_sweetProvider.rooms[index].id}"');
                                    audienceJson['"avatarUrl"'] =
                                        ('"${avatar}"');
                                    audienceJson['"nickname"'] =
                                        ('"${nickName}"');
                                    //print(' audienceJson$audienceJson');
                                    sweetRoomId =
                                        _sweetProvider.rooms[index].id;
                                    identity = false;
                                    var pubTopic = 'imeSweetUser/' + myUid;
                                    final builder = MqttClientPayloadBuilder();
                                    builder.addString(
                                        "joinRoom," + audienceJson.toString());
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
                                                  '2',
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
    BuildContext context, avatalUrl, nickName) async {
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
                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String enName = stringToBase64.encode(roomName);
                String enExplain = stringToBase64.encode(roomExplain);
                String enAnchorName = stringToBase64.encode(nickName);
                var audienceJson = {};
                audienceJson['"avatarUrl"'] = ('"${avatalUrl}"');
                audienceJson['"enName"'] = ('"${enName}"');
                audienceJson['"enExplain"'] = ('"${enExplain}"');
                audienceJson['"anchorName"'] = ('"${enAnchorName}"');
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
