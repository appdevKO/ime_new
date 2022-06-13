import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/utils/viewconfig.dart';

import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ChatroomSetting extends StatefulWidget {
  ChatroomSetting({
    Key? key,
    required this.chatroomId,
    required this.own,
  }) : super(key: key);
  final mongo.ObjectId chatroomId;
  final bool own;

  @override
  _ChatroomSettingState createState() => _ChatroomSettingState();
}

class _ChatroomSettingState extends State<ChatroomSetting> {
  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .getchatroomsetting(widget.chatroomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: new Size(MediaQuery.of(context).size.width, 50),
          child: Container(
            height: 44,
            decoration: BoxDecoration(color: Color(0xffF8D353)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //拿來對齊
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Center(
                    child: Text(
                  '聊天設定',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                )),
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.transparent,
                    ),
                    onPressed: () {}),
              ],
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Consumer<ChatProvider>(
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                  ),
                  GestureDetector(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        value.chatroomsetting.isEmpty
                            ? Container()
                            : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    value.chatroomsetting[0].imgurl != null &&
                                            value.chatroomsetting[0].imgurl !=
                                                ''
                                        ? value.chatroomsetting[0].imgurl
                                        : default_roomimg),
                              ),
                        widget.own
                            ? Stack(
                                children: [
                                  Text(
                                    '設定照片',
                                    style: TextStyle(
                                      fontSize: 20,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '設定照片',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  Text(
                                    '聊天室照片',
                                    style: TextStyle(
                                      fontSize: 20,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 2
                                        ..color = Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '聊天室照片',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              )
                      ],
                    ),
                    onTap: () {
                      if (widget.own) {
                        value.change_chatroom_img(widget.chatroomId);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 10),
                          child: Container(
                            child: Text(value.chatroomsetting[0].note == null ||
                                    value.chatroomsetting[0].note == ''
                                ? '目的:'
                                : '目的:${value.chatroomsetting[0].purpose}'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 10, ),
                          child: Container(
                            height: 20,
                            child: Text(value.chatroomsetting[0].note == null ||
                                    value.chatroomsetting[0].note == ''
                                ? '房主沒有留下訊息'
                                : '房主的話:${value.chatroomsetting[0].note}'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 20,
                            child: Text(value.chatroomsetting[0].rule == null ||
                                    value.chatroomsetting[0].rule == ''
                                ? '房主沒有留下規定'
                                : '房規:${value.chatroomsetting[0].rule}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context, listen: false)
                            .notify_chatroom_member_exit(widget.chatroomId);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('退出聊天室'))
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
