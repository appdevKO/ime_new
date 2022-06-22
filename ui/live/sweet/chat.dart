import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ime_new/ui/live/sweet/sweetlive_list.dart';

bool a = false;

class ChatMessage {
  String account;
  String messageContent;
  ChatMessage({required this.account, required this.messageContent});
}

class Chat extends StatefulWidget {
  const Chat({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Chat> createState() => _Chat();
}

class _Chat extends State<Chat> {
  final TextEditingController _chatController = new TextEditingController();
  var myuid;
  String msg = "";
  ScrollController _controller = new ScrollController();

  void _submitText(String text) {
    print(text);
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> _imageList = <List<String>>[
      <String>['wild', '6D', '7D', '8D', '9D', '10D', 'QD', 'KD', 'AD', 'wild'],
      <String>['5D', '3H', '2H', '2S', '3S', '4S', '5S', '6S', '7S', 'AC'],
    ];

    List<ChatMessage> messages = [
      ChatMessage(account: "123", messageContent: "Hello, Will"),
      ChatMessage(account: "456", messageContent: "How have you been?"),
    ];
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              //color: Colors.green,
              ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      //聊天列表
                      height: 150,
                      child: ListView.builder(
                        itemCount: messages.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () async {
                                (await userInfo(
                                    context, messages[index].account));
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 16, right: 8, top: 1, bottom: 1),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue[200],
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      messages[index].account +
                                          " " +
                                          messages[index].messageContent,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                    if (identity == true)
                      ...[]
                    else if (identity == false) ...[
                      a //送禮清單
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 150,
                                    decoration: new BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      //设置四周边框
                                      border: new Border.all(
                                          width: 1, color: Colors.red),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      for (var i in _imageList)
                                        IconButton(
                                          icon: Image.asset(
                                              'assets/images/bag.png'),
                                          iconSize: 3,
                                          onPressed: () {},
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            )
                    ]
                  ],
                ),
                //輸入欄
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        if (identity == true) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                a = !a;
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://i.ibb.co/mBhTmgL/image.png")),
                              ),
                            ),
                          ),
                        ] else if (identity == false) ...[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                a = !a;
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://i.ibb.co/mBhTmgL/image.png")),
                              ),
                            ),
                          ),
                        ],
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "輸入訊息",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                            controller: _chatController,
                            onSubmitted: _submitText,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            messages.addAll([
                              ChatMessage(
                                  account: "asdsad",
                                  messageContent: _chatController.text),
                            ]);
                            _submitText(_chatController.text);
                            FocusScope.of(context).requestFocus(FocusNode());
                            for (var i in messages)
                              print('1111 ${i.messageContent} ${i.account}');
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: Colors.blue,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<Future<String?>> userInfo(BuildContext context, account) async {
  //回頭補
  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(account),
        content: new Row(
          children: <Widget>[new Text('')],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffff7090),
            ),
            onPressed: () {
              var pubTopic = 'imeSweetRoom/';
              Navigator.of(context).pop();
              FocusScope.of(context).unfocus();
            },
            child: Text('禁言'),
          ),
        ],
      );
    },
  );
}
