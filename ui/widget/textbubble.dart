import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/mqtt_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TextBubble extends StatelessWidget {
  TextBubble({Key? key, required this.msg
  })
      : super(key: key);
  MqttMsg msg;



  @override
  Widget build(BuildContext context) {
    double text_radius = 20.0;
    // type檢查樣式
    var memberindex = Provider
        .of<ChatProvider>(context, listen: false)
        .memberlist!
        .indexWhere((element) => element.account == msg.fromid);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: msg.fromid ==
          Provider
              .of<ChatProvider>(context, listen: false)
              .Userinfo
              .userId
      // 檢查左右 我發出的

          ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 泡泡
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              //控制泡泡裡面的大小
              //大小
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * .6,
              ),
              //泡泡顏色
              decoration: BoxDecoration(
                color: Color(0xffEAEFF6),
                // gradient: LinearGradient(
                //     colors: [Color(0xfffd669a), Color(0xffff836a)]),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(text_radius),
                  bottomRight: Radius.circular(text_radius),
                  bottomLeft: Radius.circular(text_radius),
                ),
              ),
              // 泡泡內容
              // 判斷type
              child: msg.type == 1
                  ? Container(child: Text('${msg.text}'))
                  : msg.type == 2
                  ? Container(
                child: Image.network('${msg.text}'),
              )
                  : msg.type == 4
                  ? Container(
                child: Column(
                  children: [
                    Text('已傳送錄音'),
                    IconButton(
                        icon: msg.play == false
                            ? Icon(Icons.play_arrow)
                            : Icon(Icons.pause),
                        onPressed: () {
                          // startplay(msg);
                        })
                  ],
                ),
              )
                  : msg.type == 6
                  ? Container(
                child: Text('通知:${msg.text}'),
              )
                  : Container(),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(Provider
                    .of<ChatProvider>(
                    context,
                    listen: false)
                    .Userinfo
                    .avatar !=
                    null
                    ? '${Provider
                    .of<ChatProvider>(context, listen: false)
                    .Userinfo
                    .avatar}'
                    : 'http://pic.616pic.com/ys_bnew_img/00/23/07/nlWpK5lQd9.jpg'),
              ),
              Text(
                '地區',
                style: TextStyle(
                  // color: Color(0xffa6aFa3),
                    color: Colors.transparent,
                    fontSize: 10),
              )
            ],
          ),
        ],
      )
      //  對方
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(memberindex != -1 &&
                    Provider
                        .of<ChatProvider>(context, listen: false)
                        .memberlist![memberindex]
                        .avatar !=
                        null
                    ? Provider
                    .of<ChatProvider>(context, listen: false)
                    .memberlist![memberindex]
                    .avatar
                    : 'https://img.icons8.com/nolan/344/user.png'),
              ),
              Text(
                '地區',
                style: TextStyle(
                  // color: Color(0xffa6aFa3),
                    color: Colors.transparent,
                    fontSize: 10),
              )
            ],
          ),
          // 泡泡
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${msg.fromid}'),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery
                        .of(context)
                        .size
                        .width * .6,
                  ),
                  //泡泡顏色
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(text_radius),
                      topRight: Radius.circular(text_radius),
                      bottomRight: Radius.circular(text_radius),
                    ),
                  ),
                  // 泡泡內容
                  // 判斷type
                  child: msg.type == 1
                      ? Container(child: Text('${msg.text}'))
                      : msg.type == 2
                      ? Container(
                    child: Image.network('${msg.text}'),
                  )
                      : msg.type == 4
                      ? Container(
                    child: Column(
                      children: [
                        Text('已收到錄音'),
                        IconButton(
                            icon: msg.play == false
                                ? Icon(Icons.play_arrow)
                                : Icon(Icons.pause),
                            onPressed: () {
                              // startplay(msg);
                            })
                      ],
                    ),
                  )
                      : msg.type == 6
                      ? Container(
                    child: Text('通知'),
                  )
                      : Container(),
                  // child: SelectableText(
                  //   message.text, //訊息
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.w600,
                  //       height: 1.2),
                  //   showCursor: true,
                  // ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    //時間
                    msg.time == null
                        ? ''
                        : " ${DateFormat('yyyy/MM/dd  KK:mm a').format(
                        msg.time!)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
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
