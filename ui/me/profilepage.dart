import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/otherpage/other_action_page.dart';

import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';

//檢視個人檔案
class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late TabController _tabController;

  @override
  void initState() {
    initData();
    _tabController = TabController(
      length: 2,
      vsync: ScrollableState(),
      initialIndex: 0,
    );
    super.initState();
  }

  Future initData() async {
    if (Provider.of<ChatProvider>(context, listen: false).remoteUserInfo !=
            null &&
        Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo
            .isNotEmpty) {
    } else {
      await Provider.of<ChatProvider>(context, listen: false).getaccountinfo();
    }
    Provider.of<ChatProvider>(context, listen: false).find_who_likeme(
        Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .memberid);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                    ),
                    Positioned(
                      top: 0,
                      child: Consumer<ChatProvider>(
                        builder: (context, value, child) {
                          return Container(
                            height: MediaQuery.of(context).size.height * .5,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                image: NetworkImage(
                                    '${value.remoteUserInfo[0].avatar_sub}'),
                                fit: BoxFit.cover,
                              ),
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
                            top: 50.0,
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
                                    Text(
                                      '名字: ',
                                      style: TextStyle(
                                          color: Colors.brown, fontSize: 16),
                                    ),
                                    Consumer<ChatProvider>(
                                        builder: (context, value, child) {
                                      return Container(
                                        width: 250,
                                        child: Text(value.remoteUserInfo[0]
                                                        .nickname !=
                                                    '' &&
                                                value.remoteUserInfo[0]
                                                        .nickname !=
                                                    null
                                            ? '${value.remoteUserInfo[0].nickname}'
                                            : '不詳'),
                                      );
                                    })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '介紹: ',
                                            style: TextStyle(
                                                color: Colors.brown,
                                                fontSize: 16),
                                          ),
                                          Consumer<ChatProvider>(
                                              builder: (context, value, child) {
                                            return Container(
                                              width: 200,
                                              child: Text(value
                                                              .remoteUserInfo[0]
                                                              .introduction !=
                                                          null &&
                                                      value.remoteUserInfo[0]
                                                              .introduction !=
                                                          ''
                                                  ? '${value.remoteUserInfo[0].introduction}'
                                                  : '不詳'),
                                            );
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
                                            value.remoteUserInfo[0].area != null
                                                ? '${ChineseHelper.convertToTraditionalChinese(value.remoteUserInfo[0].area)}'
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      ),
                                      Text(
                                        ' 誰喜歡我: ',
                                        style: TextStyle(height: 1),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(
                                            value.num_likeme != null
                                                ? '${value.num_likeme}'
                                                : '--',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                height: 1),
                                          );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value
                                                      .remoteUserInfo[0].size !=
                                                  null
                                              ? '${value.remoteUserInfo[0].size}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .personality !=
                                                  null
                                              ? '${value.remoteUserInfo[0].personality}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .profession !=
                                                  null
                                              ? '${value.remoteUserInfo[0].profession}'
                                              : '不詳'),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '居住地區: ',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .area !=
                                //                   null
                                //               ? '${ChineseHelper.convertToTraditionalChinese(value.remoteUserInfo[0].area)}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '我的約會安排: ',
                                        style: TextStyle(color: Colors.brown),
                                      ),
                                      Consumer<ChatProvider>(
                                          builder: (context, value, child) {
                                        return Container(
                                          width: 200,
                                          child: Text(value
                                                      .remoteUserInfo[0].date !=
                                                  null
                                              ? '${value.remoteUserInfo[0].date}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .money !=
                                                  null
                                              ? '${value.remoteUserInfo[0].money}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .lookfor !=
                                                  null
                                              ? '${value.remoteUserInfo[0].lookfor}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .education !=
                                                  null
                                              ? '${value.remoteUserInfo[0].education}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .language !=
                                                  null
                                              ? '${value.remoteUserInfo[0].language}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .smoke !=
                                                  null
                                              ? '${value.remoteUserInfo[0].smoke}'
                                              : '不詳'),
                                        );
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
                                        return Container(
                                          width: 250,
                                          child: Text(value.remoteUserInfo[0]
                                                      .drink !=
                                                  null
                                              ? '${value.remoteUserInfo[0].drink}'
                                              : '不詳'),
                                        );
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

                  ],
                ),
                OtherActionPage(memberid:Provider.of<ChatProvider>(context,listen: false).remoteUserInfo[0].memberid,type:2)
              ],
            ),
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
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
                      }),
                  Center(
                      child: Text(
                        '',
                        style: TextStyle(
                            color: Colors.transparent, fontWeight: FontWeight.w700),
                      )),

                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 30,
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            labelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 10),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: '關於我',
              ),
              Tab(
                text: '動態',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
