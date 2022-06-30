import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/utils/viewconfig.dart';

import 'package:provider/provider.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class ChatroomInfo extends StatefulWidget {
  ChatroomInfo({
    Key? key,
    required this.chatroomId,
    required this.own,
  }) : super(key: key);
  final mongo.ObjectId chatroomId;
  final bool own;

  @override
  _ChatroomInfoState createState() => _ChatroomInfoState();
}

class _ChatroomInfoState extends State<ChatroomInfo> {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Container(
                            child: Text(
                                value.chatroomsetting[0].purpose == null ||
                                        value.chatroomsetting[0].purpose == ''
                                    ? '目的:'
                                    : '目的:${value.chatroomsetting[0].purpose}'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            bottom: 10,
                          ),
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

class ChatroomSetting extends StatefulWidget {
  ChatroomSetting({
    Key? key,
    required this.chatroomId,
  }) : super(key: key);
  final mongo.ObjectId chatroomId;

  @override
  State<ChatroomSetting> createState() => _ChatroomSettingState();
}

class _ChatroomSettingState extends State<ChatroomSetting> {
  late TextEditingController _purposecontroller;
  late TextEditingController _titlecontroller;
  late TextEditingController _rulecontroller;
  late TextEditingController _notecontroller;
  bool edit = false;

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false)
        .getchatroomsetting(widget.chatroomId);
    _purposecontroller = TextEditingController(
      text: Provider.of<ChatProvider>(context, listen: false)
          .chatroomsetting[0]
          .purpose,
    );
    _titlecontroller = TextEditingController(
      text: Provider.of<ChatProvider>(context, listen: false)
          .chatroomsetting[0]
          .title,
    );
    _rulecontroller = TextEditingController(
      text: Provider.of<ChatProvider>(context, listen: false)
          .chatroomsetting[0]
          .rule,
    );
    _notecontroller = TextEditingController(
      text: Provider.of<ChatProvider>(context, listen: false)
          .chatroomsetting[0]
          .note,
    );
    Provider.of<ChatProvider>(context, listen: false)
        .getchatroomsetting(widget.chatroomId);
    super.initState();
  }

  @override
  void dispose() {
    _purposecontroller.dispose();
    _titlecontroller.dispose();
    _rulecontroller.dispose();
    _notecontroller.dispose();
    super.dispose();
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
                    if(edit){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                        content: Text("請先儲存或取消變更"),
                      ));
                    }else{
                      Navigator.pop(context);
                    }

                  }),
              Center(
                  child: Text(
                '聊天設定',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              )),
              IconButton(
                  icon: Text(
                    edit ? '取消' : '編輯',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (edit) {
                      setState(() {
                        edit = !edit;
                      });
                    } else {
                      setState(() {
                        edit = !edit;
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Consumer<ChatProvider>(
          builder: (context, value, child) {
            return GestureDetector(
              child: SingleChildScrollView(
                child: Column(
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
                          Stack(
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
                        ],
                      ),
                      onTap: () {
                        value.change_chatroom_img(widget.chatroomId);
                      },
                    ),
                    edit
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          '房間名稱',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextField(
                                          cursorHeight: 1,
                                          textAlign: TextAlign.end,
                                          controller: _titlecontroller,
                                          style: TextStyle(
                                              height: 1, fontSize: 18),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '目的',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          child: TextField(
                                            textAlign: TextAlign.end,
                                            controller: _purposecontroller,
                                            style: TextStyle(
                                                height: 1, fontSize: 18),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '房規',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          child: TextField(
                                            textAlign: TextAlign.end,
                                            controller: _rulecontroller,
                                            style: TextStyle(
                                                height: 1, fontSize: 18),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '房主的話',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          child: TextField(
                                            textAlign: TextAlign.end,
                                            controller: _notecontroller,
                                            style: TextStyle(
                                                height: 1, fontSize: 18),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 48,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          '房間名稱',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Text(
                                        '${value.chatroomsetting[0].title}',
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 10),
                                  child: Container(
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '目的',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Text(
                                          '${value.chatroomsetting[0].purpose}',
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '房規',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Text(
                                          '${value.chatroomsetting[0].rule}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            '房主的話',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Text(
                                          '${value.chatroomsetting[0].note}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 38.0),
                      child: !edit
                          ? ElevatedButton(
                              onPressed: () {
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .notify_chatroom_member_exit(
                                        widget.chatroomId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('退出聊天室'))
                          : ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return AlertDialog(
                                          title: Text('儲存變更中 請稍候刷新'),
                                          content: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator())));
                                    });
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .change_chatroom_info(
                                      widget.chatroomId,
                                      _titlecontroller.text,
                                      _purposecontroller.text,
                                      _notecontroller.text,
                                      _rulecontroller.text,
                                    )
                                    .whenComplete(() => Future.delayed(
                                            Duration(seconds: 2), () async {
                                          Navigator.pop(context);
                                          Provider.of<ChatProvider>(context, listen: false)
                                              .getchatroomsetting(widget.chatroomId);
                                          setState(() {
                                            edit = false;
                                          });
                                        }));
                              },
                              child: Text('儲存')),
                    )
                  ],
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
              },
            );
          },
        ),
      ),
    ));
  }
}
