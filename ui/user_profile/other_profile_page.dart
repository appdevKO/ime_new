import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/date/one2one_chat/o2ochatroom.dart';
import 'package:provider/provider.dart';
import '../../../utils/viewconfig.dart';
import 'package:lpinyin/lpinyin.dart';

class OtherProfilePage extends StatefulWidget {
  OtherProfilePage({
    Key? key,
    required this.chatroomid,
  }) : super(key: key);
  final chatroomid;

  @override
  _OtherProfilePagePageState createState() => _OtherProfilePagePageState();
}

class _OtherProfilePagePageState extends State<OtherProfilePage> {
  @override
  void initState() {
    initdata();
    super.initState();
  }

  Future initdata() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .getmemberinfo(widget.chatroomid.toHexString());
    await Provider.of<ChatProvider>(context, listen: false)
        .find_who_likeme(widget.chatroomid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      //背景
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        // child: Text('封面 ${widget.chatroomid}'),
                      ),
                      Positioned(
                        top: 0,
                        child: Consumer<ChatProvider>(
                          builder: (context, value, child) {
                            return Container(
                              height: MediaQuery.of(context).size.height * .5,
                              width: MediaQuery.of(context).size.width,
                              child: CachedNetworkImage(
                                width: 100,
                                height: 50,
                                fit: BoxFit.cover,
                                imageUrl: default_cover,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: value.o2omemberlist != null &&
                                              value.o2omemberlist!.isNotEmpty &&
                                              value.o2omemberlist![0]
                                                      .avatar_sub !=
                                                  null &&
                                              value.o2omemberlist![0]
                                                      .avatar_sub !=
                                                  ''
                                          ? NetworkImage(
                                              '${value.o2omemberlist![0].avatar_sub}')
                                          : AssetImage(
                                                  'assets/default/sex_man.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                // errorWidget: (context, url, error) =>
                                //     Text('沒有封面圖'),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * .42,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .58,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 60.0,
                              left: 15,
                              right: 15,
                              bottom: 50.0,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        child: Text(
                                          '名字: ',
                                          style: TextStyle(
                                              color: Colors.brown,
                                              fontSize: 16),
                                        ),
                                        onTap: () {
                                          Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .getuserInfo(widget.chatroomid);
                                        },
                                      ),
                                      Consumer<ChatProvider>(
                                          builder: (context, value, child) {
                                        return Text(value.o2omemberlist![0]
                                                    .nickname !=
                                                null
                                            ? '${value.o2omemberlist![0].nickname}'
                                            : '不詳');
                                      })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              '介紹: ',
                                              style: TextStyle(
                                                  color: Colors.brown,
                                                  fontSize: 16),
                                            ),
                                            Consumer<ChatProvider>(builder:
                                                (context, value, child) {
                                              return Text(value
                                                          .o2omemberlist![0]
                                                          .introduction !=
                                                      null
                                                  ? '${value.o2omemberlist![0].introduction}'
                                                  : '不詳');
                                            }),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 15,
                                            color: Colors.grey,
                                          ),
                                          Consumer<ChatProvider>(
                                              builder: (context, value, child) {
                                            return Text(
                                              value.o2omemberlist![0].area !=
                                                      null
                                                  ? '${ChineseHelper.convertToTraditionalChinese(value.o2omemberlist![0].area)}'
                                                  : '不詳',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            );
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.pink,
                                        ),
                                        Text('誰喜歡我'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Consumer<ChatProvider>(
                                              builder: (context, value, child) {
                                            return Text('${value.num_likeme}');
                                          }),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '體型: ',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value
                                                      .o2omemberlist![0].size !=
                                                  null
                                              ? '${value.o2omemberlist![0].size}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '個性: ',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .personality !=
                                                  null
                                              ? '${value.o2omemberlist![0].personality}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '職業: ',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .profession !=
                                                  null
                                              ? '${value.o2omemberlist![0].profession}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '居住地區: ',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value
                                                      .o2omemberlist![0].area !=
                                                  null
                                              ? '${ChineseHelper.convertToTraditionalChinese(value.o2omemberlist![0].area)}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '我的約會安排: ',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value
                                                      .o2omemberlist![0].date !=
                                                  null
                                              ? '${value.o2omemberlist![0].date}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '零用錢預算:',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .money !=
                                                  null
                                              ? '${value.o2omemberlist![0].money}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '我在尋找: ',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .lookfor !=
                                                  null
                                              ? '${value.o2omemberlist![0].lookfor}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '學歷:',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .education !=
                                                  null
                                              ? '${value.o2omemberlist![0].education}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '慣用語言:',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .language !=
                                                  null
                                              ? '${value.o2omemberlist?[0].language}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '吸菸習慣:',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .smoke !=
                                                  null
                                              ? '${value.o2omemberlist![0].smoke}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '飲酒習慣:',
                                          style: TextStyle(color: Colors.brown),
                                        ),
                                        Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(value.o2omemberlist![0]
                                                      .drink !=
                                                  null
                                              ? '${value.o2omemberlist![0].drink}'
                                              : '不詳');
                                        })
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: MediaQuery.of(context).size.height * .39,
                          right: 20,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: CircleAvatar(
                                  child: Container(
                                    margin: EdgeInsets.all(7),
                                    child: Image.asset(
                                      'assets/icon/navigator/action01.png',color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: Color(0xffffbbbb),
                                ),
                              ),
                              Consumer<ChatProvider>(
                                  builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      child: Container(
                                        margin: EdgeInsets.all(7),
                                        child: Image.asset(
                                          'assets/icon/navigator/action01.png',
                                        ),
                                      ),
                                      backgroundColor: Colors.amber,
                                    ),
                                    onTap: () async {
                                      Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .easyhi(
                                              widget.chatroomid,
                                              value.o2omemberlist![0].nickname,
                                              value.o2omemberlist![0]
                                                  .avatar_sub);
                                    },
                                  ),
                                );
                              }),
                              Consumer<ChatProvider>(
                                  builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: GestureDetector(
                                    child: CircleAvatar(
                                      child: Container(
                                        margin: EdgeInsets.all(7),
                                        child: Image.asset(
                                          'assets/icon/navigator/chat01.png',color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Color(0xff32cd32),
                                    ),
                                    onTap: () {
                                      print('進入聊天室');
                                      if (value.o2omemberlist != null) {
                                        print(
                                            'o2omemberlist ${value.remoteUserInfo[0].memberid}');
                                        print(
                                            'o2o list to memberid ${value.remoteUserInfo[0].memberid},chatroom id ${widget.chatroomid.toHexString()}');
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    O2OChatroom(
                                                      memberid: value
                                                          .remoteUserInfo[0]
                                                          .memberid,
                                                      chatroomid: widget
                                                          .chatroomid
                                                          .toHexString(),
                                                      nickname: value
                                                          .o2omemberlist![0]
                                                          .nickname,
                                                      avatar: value
                                                          .o2omemberlist![0]
                                                          .avatar_sub,
                                                    )));
                                      } else {
                                        print('empty');
                                      }
                                    },
                                  ),
                                );
                              }),
                              Consumer<ChatProvider>(
                                  builder: (context, value, child) {
                                return GestureDetector(
                                  child: CircleAvatar(
                                    backgroundColor: value.myfollowlog != null
                                        ? value.myfollowlog[0].list_id != null
                                            ? value.myfollowlog[0].list_id
                                                        .indexWhere((element) =>
                                                            element ==
                                                            widget
                                                                .chatroomid) !=
                                                    -1
                                                ? Colors.red
                                                : Colors.grey
                                            : Colors.grey
                                        : Colors.grey,
                                    child: Icon(Icons.favorite,
                                        color: Colors.white),
                                  ),
                                  onTap: () async {
                                    value.addfollowlog(widget.chatroomid);
                                    value.find_who_likeme(widget.chatroomid);
                                    // await value.getmemberinfo(
                                    //     widget.chatroomid.toHexString());
                                  },
                                );
                              })
                            ],
                          )),
                      // //頭像
                      // Positioned(
                      //     top: MediaQuery.of(context).size.height * .33,
                      //     left: 43,
                      //     child: Consumer<ChatProvider>(
                      //         builder: (context, value, child) {
                      //       return Stack(
                      //         children: [
                      //           CircleAvatar(
                      //             backgroundColor: Colors.black.withOpacity(.4),
                      //             radius: 61,
                      //           ),
                      //           // Positioned(
                      //           //   top: 1,
                      //           //   left: 1,
                      //           //   child: CircleAvatar(
                      //           //     backgroundColor: Colors.grey,
                      //           //     radius: 60,
                      //           //     backgroundImage: value.o2omemberlist![0]
                      //           //                     .avatar_sub !=
                      //           //                 null &&
                      //           //             value.o2omemberlist![0]
                      //           //                     .avatar_sub !=
                      //           //                 ''
                      //           //         ? NetworkImage(
                      //           //             '${value.o2omemberlist![0].avatar_sub}',
                      //           //           )
                      //           //         : AssetImage(value.o2omemberlist![0]
                      //           //                             .sex ==
                      //           //                         null ||
                      //           //                     value.o2omemberlist![0]
                      //           //                             .sex ==
                      //           //                         '男'
                      //           //                 ? 'assets/default/sex_man.png'
                      //           //                 : 'assets/default/sex_woman.png')
                      //           //             as ImageProvider,
                      //           //   ),
                      //           // ),
                      //           Positioned(
                      //               top: 0,
                      //               right: -5,
                      //               child: Icon(
                      //                 value.o2omemberlist![0].sex == '男'
                      //                     ? Icons.male
                      //                     : Icons.female,
                      //                 color: value.o2omemberlist![0].sex == '男'
                      //                     ? Colors.blue
                      //                     : Colors.pink,
                      //                 size: 45,
                      //               ))
                      //         ],
                      //       );
                      //     }))
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 1.0,
                          top: 2.0,
                          child: Icon(Icons.arrow_back, color: Colors.black54),
                        ),
                        Icon(Icons.arrow_back, color: Colors.white),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Icon(Icons.arrow_back, color: Colors.transparent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
