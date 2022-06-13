import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/mqtt_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

import './room.dart';
import 'dart:convert';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
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
        // appBar: AppBar(
        //   title: Text('真心話大冒險'),
        // ),
        key: scaffoldKey,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xffff7090), Color(0xfff0c0c0)]),
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
                    Text('真心話大冒險-房間列表',style: TextStyle(color: Colors.white,fontSize: 18),),
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
                        var encode = utf8
                            .decode((rx.roomsList[index].name)!.runes.toList());
                        List<int> res = base64.decode(base64.normalize(encode));
                        return Card(
                            child: ListTile(
                          title: Text(
                            '${utf8.decode(res)}',
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            '${rx.roomsList[index].count.toString()}/4 ${rx.roomsList[index].count == 4 ? '已滿員' : ''} ${rx.roomsList[index].isStart ? '進行中' : ''}',
                            textAlign: TextAlign.right,
                          ),
                          leading: Container(
                            width: (MediaQuery.of(context).size.width) * 0.4,
                            child: Stack(
                              children: [
                                rx.roomsList[index].count > 0
                                    ? Positioned(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.blue,
                                        ),
                                      )
                                    : Container(),
                                rx.roomsList[index].count > 1
                                    ? Positioned(
                                        left: 20,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                        ),
                                      )
                                    : Container(),
                                rx.roomsList[index].count > 2
                                    ? Positioned(
                                        left: 40,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.yellow,
                                        ),
                                      )
                                    : Container(),
                                rx.roomsList[index].count > 3
                                    ? Positioned(
                                        left: 60,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          onTap: () {
                            var pubTopic = 'imedotUser/' + myUid;
                            final builder = MqttClientPayloadBuilder();
                            builder.addString("joinRoom," +
                                rx.roomsList[index].id.toString());
                            client.publishMessage(pubTopic, MqttQos.atLeastOnce,
                                builder.payload!);
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
                    onPressed: () async {
                      (await inputDialog(context));
                    },
                    child: Text('開新房間'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      var pubTopic = 'imedotUser/' + myUid;
                      final builder = MqttClientPayloadBuilder();
                      builder.addString("joinRandomRoom");
                      client.publishMessage(
                          pubTopic, MqttQos.atLeastOnce, builder.payload!);
                    },
                    child: Text('隨機加入'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Future<String?>> inputDialog(BuildContext context) async {
  String roomName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('房間名稱'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(hintText: '名稱不可為空'),
              onChanged: (value) {
                roomName = value;
              },
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('返回'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('送出'),
            onPressed: () {
              if (roomName != '') {
                String credentials = roomName;
                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String encoded = stringToBase64.encode(credentials);
                var pubTopic = 'imedotUser/' + myUid;
                final builder = MqttClientPayloadBuilder();
                builder.addString("joinNewRoom," + encoded);
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
