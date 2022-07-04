import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/widget/switch_button.dart';

import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';

class DateSetting extends StatefulWidget {
  const DateSetting({Key? key}) : super(key: key);

  @override
  _DateSettingState createState() => _DateSettingState();
}

class _DateSettingState extends State<DateSetting> {
  bool seen_myprofile = false;
  bool chatroom_notify = false;
  int index = 0;
  double? _distance_value;

  double? _age_value;

  @override
  void initState() {
    _distance_value = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .distance_range ??
        0;
    _age_value = Provider.of<ChatProvider>(context, listen: false)
                .remoteUserInfo[0]
                .age_range !=
            null
        ? Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .age_range
            .toDouble()
        : 18;
    initdata();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initdata() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .myblock_finduserinfolist();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            //appbar
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffFF2D2D), Color(0xffFF9797)])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          index = 0;
                        });
                      }),
                  Center(
                      child: Text(
                    '交友設定',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                  Container(
                    child: IconButton(
                      icon: Text(
                        '儲存',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
                                  title: Text('更改設定中 請稍候'),
                                  content: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Center(
                                          child: CircularProgressIndicator())));
                            });
                        Provider.of<ChatProvider>(context, listen: false)
                            .change_datesetting(
                                _distance_value, _age_value!.round())
                            .whenComplete(() =>
                                Future.delayed(Duration(seconds: 1), () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Icon(Icons.remove_red_eye_outlined),
                    onTap: () {
                      // Provider.of<ChatProvider>(context,listen: false).getaccountinfo2();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('黑名單'),
                  )
                ],
              ),
            ),
            index == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          )),
                                      Text('黑名單')
                                    ],
                                  ),
                                  GestureDetector(
                                    child: Container(child: Text('編輯')),
                                    onTap: () {
                                      print('編輯 黑名單');
                                      setState(() {
                                        index = 1;
                                      });
                                    },
                                  )
                                ],
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          )),
                                      Text('有人看過我的個人檔案')
                                    ],
                                  ),
                                  Switch(
                                      value: seen_myprofile,
                                      onChanged: (value) {
                                        setState(() {
                                          seen_myprofile = value;
                                        });
                                      })
                                ],
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          )),
                                      Text('聊天室新訊息通知')
                                    ],
                                  ),
                                  Container(
                                    child: Switch(
                                        value: chatroom_notify,
                                        onChanged: (value) {
                                          setState(() {
                                            chatroom_notify = value;
                                          });
                                        }),
                                  )
                                ],
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          )),
                                      Text('目前定位')
                                    ],
                                  ),
                                  Text('xx地區')
                                ],
                              ),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          )),
                                      Text('推薦距離設定')
                                    ],
                                  ),
                                  Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                      return Text('$_distance_value 公里');
                                    },
                                  ),
                                ],
                              ),
                              _distance_value != null
                                  ? Slider(
                                      min: 0.0,
                                      max: 100.0,
                                      divisions: 10,
                                      value: _distance_value!,
                                      onChanged: (value) {
                                        setState(() {
                                          _distance_value = value;
                                        });
                                      },
                                    )
                                  : Container(),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.error,
                                            color: Colors.grey,
                                          )),
                                      Text('年齡偏好設定')
                                    ],
                                  ),
                                  Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                      return Text(
                                          '18歲~${(_age_value!).round()}歲');
                                    },
                                  ),
                                ],
                              ),
                              _age_value != null
                                  ? Slider(
                                      min: 18,
                                      max: 99,
                                      divisions: 81,
                                      value: _age_value!,
                                      onChanged: (value) {
                                        setState(() {
                                          _age_value = value;
                                        });
                                      },
                                    )
                                  : Container(),
                              Divider(
                                height: 1,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : index == 1
                    ? Consumer<ChatProvider>(
                        builder: (context, value, child) {
                          // return Container(child: Text('${value.my_block_user_list[0].nickname}'),);
                          return Container(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      height: 400,
                                      child: value.myblocklog != null &&
                                              value.myblocklog[0].list_id !=
                                                  null
                                          ? value.myblocklog[0].list_id
                                                  .isNotEmpty
                                              ? ListView.builder(
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            child: value.changeblocklist
                                                                        .isEmpty ||
                                                                    value.changeblocklist.indexWhere((element) =>
                                                                            value.myblocklog[0].list_id[index] ==
                                                                            element) ==
                                                                        -1
                                                                ? EmptyCircle(
                                                                    thecolor:
                                                                        Colors
                                                                            .blue,
                                                                    radius: 30,
                                                                  )
                                                                : FullCircle(
                                                                    bigradius:
                                                                        30,
                                                                    smallradius:
                                                                        15,
                                                                    thecolor:
                                                                        Colors
                                                                            .blue,
                                                                    width: 2,
                                                                  ),
                                                          ),
                                                          onTap: () {
                                                            Provider.of<ChatProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addblocklist(value
                                                                    .myblocklog[
                                                                        0]
                                                                    .list_id[index]);
                                                          },
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20.0),
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.blue,
                                                            radius: 30,
                                                            backgroundImage:
                                                                NetworkImage(value
                                                                    .my_block_user_list[
                                                                        index]
                                                                    .avatar_sub),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20.0),
                                                          child: Container(
                                                            width: 130,
                                                            // color: Colors.red,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  value.my_block_user_list[index]
                                                                              .nickname !=
                                                                          null
                                                                      ? '${value.my_block_user_list[index].nickname}'
                                                                      : '姓名不詳',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .brown),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3.0),
                                                                  child: Text(value
                                                                              .my_block_user_list[index]
                                                                              .constellation !=
                                                                          null
                                                                      ? '${value.my_block_user_list[index].constellation}'
                                                                      : '星座不詳'),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3.0),
                                                                  child: Text(value
                                                                              .my_block_user_list[index]
                                                                              .age !=
                                                                          null
                                                                      ? '${value.my_block_user_list[index].age}'
                                                                      : '年齡不詳'),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3.0),
                                                                  child: Text(value
                                                                              .my_block_user_list[index]
                                                                              .height !=
                                                                          null
                                                                      ? '${value.my_block_user_list[index].height}'
                                                                      : '身高不詳'),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(Icons
                                                                          .location_on_outlined),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: 5),
                                                                        child: Text(value.my_block_user_list[index].area != null &&
                                                                                value.my_block_user_list[index].area != ''
                                                                            ? '${ChineseHelper.convertToTraditionalChinese(value.my_block_user_list[index].area)}'
                                                                            : '所在地不詳'),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                  itemCount: value.myblocklog[0]
                                                      .list_id.length,
                                                )
                                              : Text('現在沒有黑名單')
                                          : Text('加載中')),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 40,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                              child: Text(
                                            '取消',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            index = 0;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: GestureDetector(
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Center(
                                                child: Text(
                                              '解除封鎖',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                          onTap: () {
                                            Provider.of<ChatProvider>(context,
                                                    listen: false)
                                                .removeblocklist();
                                            print('222222');
                                            setState(() {
                                              index = 0;
                                            });
                                            print('222222');
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Container()
          ],
        ),
      )),
    );
  }
}
