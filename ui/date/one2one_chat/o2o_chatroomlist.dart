import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';

import 'package:provider/provider.dart';

import 'o2ochatroom.dart';

//
// const appId = "c421171e1dce40e284a036768d9d6449";
// const token =
//     "006c421171e1dce40e284a036768d9d6449IABOFDcakUr5LWfOXb6lurHXeWdAPCxNK/RxmgDhQ3m6WQx+f9gAAAAAEADjTvSOZcE5YgEAAQBlwTli";

class OneChat extends StatefulWidget {
  const OneChat({Key? key}) : super(key: key);

  @override
  _OneChatState createState() => _OneChatState();
}

class _OneChatState extends State<OneChat> {
  int? topicindex = -1;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      initdata();
    });
    super.initState();
  }

  Future initdata() async {
    await Provider.of<ChatProvider>(context, listen: false).getmyblocklog();
    await Provider.of<ChatProvider>(context, listen: false)
        .geto2ochatroomlist();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 10,
        ),
        Expanded(
          child: Consumer<ChatProvider>(builder: (context, value, child) {
            return value.o2ochatroomlist != null &&
                    value.o2ochatroomlist!.isNotEmpty
                ? value.o2ochatroomlist![0]!.chatto_id != null
                    ? Container(
                        child: ListView.separated(
                        itemBuilder: (context, index) {
                          var newmsgindex =
                              value.o2o_msglist?.indexWhere((element) {
                            print(
                                'o2oo2oo2oo2oo2o ${element.memberid}//  ${value.o2ochatroomlist![index].chatto_id.toHexString()}');
                            return element.memberid ==
                                value.o2ochatroomlist![index].chatto_id
                                    .toHexString();
                          });
                          // print('長度  $index  value.o2ochatroomlist ${value.o2o_msglist?[newmsgindex!].msg?.length}');

                          return GestureDetector(
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          backgroundImage: value
                                                          .o2ochatroomlist![
                                                              index]
                                                          .avatar ==
                                                      '' ||
                                                  value.o2ochatroomlist![index]
                                                          .avatar ==
                                                      null
                                              ? AssetImage(
                                                      'assets/default/sex_man.png')
                                                  as ImageProvider
                                              : NetworkImage(value
                                                  .o2ochatroomlist![index]
                                                  .avatar),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 13),
                                          child: Text(
                                              '跟${value.o2ochatroomlist![index].nickname}的私聊'),
                                        ),
                                      ],
                                    ), //新消息紅點
                                    CircleAvatar(
                                      backgroundColor: newmsgindex != -1
                                          ? value.o2o_msglist![newmsgindex!]
                                          .msg!.isNotEmpty
                                          ? Colors.red
                                          : Colors.transparent
                                          : Colors.transparent,
                                      radius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              print(
                                  'o2o list to memberid ${value.o2ochatroomlist?[index]!.memberid},chatroom id ${value.o2ochatroomlist?[index]!.chatto_id.toHexString()}');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => O2OChatroom(
                                        memberid: value
                                            .o2ochatroomlist?[index]!.memberid,
                                        chatroomid: value
                                            .o2ochatroomlist?[index]!.chatto_id
                                            .toHexString(),
                                        nickname: value
                                            .o2ochatroomlist![index].nickname,
                                        avatar: value
                                            .o2ochatroomlist![index].avatar,
                                      )));
                            },
                          );
                        },
                        itemCount: value.o2ochatroomlist!.length,
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 10,
                          );
                        },
                      ))
                    : Center(
                        child: Container(
                          child: Text('沒有私聊紀錄01'),
                        ),
                      )
                : Center(
                    child: Container(
                      child: Text('沒有私聊紀錄'),
                    ),
                  );
          }),
        ),
        Container(
          height: 10,
        ),
      ],
    );
    // return Container();
  }
}
