import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/TD_game.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:ime_new/business_logic/model/TD_room.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class RoomListController extends GetxController {
  RxList<Room> roomsList = List<Room>.from([]).obs;
}

class roomListTable extends StatefulWidget {
  const roomListTable({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<roomListTable> createState() => _roomListTableState();
}

class _roomListTableState extends State<roomListTable> {
  String avatar =
      "https://180dc.org/wp-content/uploads/2022/04/Blank-Avatar.png";
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<TD_game>(context, listen: false).connect();
    super.initState();
  }

  @override
  void dispose() {
    client.unsubscribe("imedot/info");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RoomListController rx = Get.put(RoomListController());

    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(
        //  title: Text('真心話大冒險'),
        //),
          key: scaffoldKey,
          body: Stack(children: [
            Consumer<ChatProvider>(builder: (context, ChatProvider1, child) {
              if (ChatProvider1.remoteUserInfo == null) {
                if ((ChatProvider1.remoteUserInfo[0].sex) == '男') {
                  avatar = "https://i.ibb.co/cFFSzdK/sex-man.png";
                } else {
                  avatar = "https://i.ibb.co/kJxyvc4/sex-woman.png";
                }
              } else {
                avatar = ChatProvider1.remoteUserInfo[0].avatar;
              }

              return Stack(children: <Widget>[
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffff7090), Color(0xfff0c0c0)]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                )),
                            Text(
                              '真心話大冒險-房間列表',
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.transparent,
                                ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Obx(() => ListView.builder(
                          itemCount: rx.roomsList.length,
                          itemBuilder: (context, index) {
                            var encodeName = utf8.decode(
                                (rx.roomsList[index].name)!.runes.toList());
                            List<int> resName =
                            base64.decode(base64.normalize(encodeName));
                            var name = utf8.decode(resName);

                            var encodeExplain = utf8.decode(
                                (rx.roomsList[index].explain)!
                                    .runes
                                    .toList());
                            List<int> resExplain = base64
                                .decode(base64.normalize(encodeExplain));
                            var explain = utf8.decode(resExplain);
                            //print('encodeName $name');
                            //print('encodeExplain $encodeExplain');
                            //print('Explain $explain');
                            return Card(
                                child: ListTile(
                                  title: Text(
                                    '${utf8.decode(resName)}',
                                    textAlign: TextAlign.right,
                                  ),
                                  subtitle: Text(
                                    '${rx.roomsList[index].count.toString()}/4 ${rx.roomsList[index].count == 4 ? '已滿員' : ''} ${rx.roomsList[index].isStart ? '進行中' : ''} 備註：${explain}',
                                    textAlign: TextAlign.right,
                                  ),
                                  leading: Container(
                                    width: (MediaQuery.of(context).size.width) *
                                        0.4,
                                    child: Stack(
                                      children: [
                                        rx.roomsList[index].count > 0
                                            ? Positioned(
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(rx
                                                  .roomsList[index]
                                                  .avatarUrl1!),
                                            ))
                                            : Container(),
                                        rx.roomsList[index].count > 1
                                            ? Positioned(
                                          left: 20,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                rx.roomsList[index]
                                                    .avatarUrl2!),
                                          ),
                                        )
                                            : Container(),
                                        rx.roomsList[index].count > 2
                                            ? Positioned(
                                          left: 40,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                rx.roomsList[index]
                                                    .avatarUrl3!),
                                          ),
                                        )
                                            : Container(),
                                        rx.roomsList[index].count > 3
                                            ? Positioned(
                                          left: 60,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                rx.roomsList[index]
                                                    .avatarUrl4!),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    (await enterRoom(
                                        context,
                                        name,
                                        explain,
                                        (rx.roomsList[index].id.toString()),
                                        avatar));
                                  },
                                ));
                          },
                        )),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffff7090),
                            ),
                            onPressed: () async {
                              (await inputDialog(context, avatar));
                            },
                            child: Text('開新房間'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffff7090),
                            ),
                            onPressed: () {
                              var pubTopic = 'imedotUser/' + myUid;
                              final builder = MqttClientPayloadBuilder();
                              builder.addString("joinRandomRoom," + avatar);
                              client.publishMessage(pubTopic,
                                  MqttQos.atLeastOnce, builder.payload!);
                            },
                            child: Text('隨機加入'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]);
            })
          ])),
    );
  }
}

Future<Future<String?>> inputDialog(BuildContext context, avatalUrl) async {
  String roomName = '';
  String roomExplain = ' ';
  String _hintText = '名稱不可為空';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('房間名稱'),
        content: Column(
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
                      decoration: new InputDecoration(hintText: '房間說明'),
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
                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String enName = stringToBase64.encode(roomName);
                String enExplain = stringToBase64.encode(roomExplain);
                var msg = enName + "," + enExplain + ',' + avatalUrl;
                print('msg $msg');
                var pubTopic = 'imedotUser/' + myUid;
                final builder = MqttClientPayloadBuilder();
                builder.addString("joinNewRoom," + msg);
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

Future<Future<String?>> enterRoom(
    BuildContext context, roomName, explain, roomId, avatalUrl) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(roomName),
        content: new Row(
          children: <Widget>[new Text(explain)],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffff7090),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('返回'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffff7090),
            ),
            onPressed: () {
              var pubTopic = 'imedotUser/' + myUid;
              final builder = MqttClientPayloadBuilder();
              builder.addString("joinRoom," + roomId + "," + avatalUrl);
              client.publishMessage(
                  pubTopic, MqttQos.atLeastOnce, builder.payload!);
              Navigator.of(context).pop();
            },
            child: Text('加入'),
          ),
        ],
      );
    },
  );
}
