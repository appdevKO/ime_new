import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/otherpage/other_action_page.dart';
import 'package:intl/intl.dart';

import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';

//檢視個人檔案
class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late TabController _tabController;
  int _current = 0;
  final CarouselController _controller = CarouselController();

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
                //關於我
                Stack(
                  children: [
                    //最底下 決定範圍
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                    //背景照片
                    Positioned(
                      top: 0,
                      child: Consumer<ChatProvider>(
                        builder: (context, value, child) {
                          return Container(
                            height: MediaQuery.of(context).size.height * .5,
                            width: MediaQuery.of(context).size.width,
                            child: CarouselSlider.builder(
                              options: CarouselOptions(
                                  height: 400.0,
                                  viewportFraction: 1.0, //放最大
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                              carouselController: _controller,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Container(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.grey,
                                child: ClipRRect(
                                  child: value.remoteUserInfo[0]
                                                  .little_profilepic_list[
                                              itemIndex] !=
                                          ''
                                      ? Image.network(
                                          value.remoteUserInfo[0]
                                                  .little_profilepic_list[
                                              itemIndex],
                                          fit: BoxFit.cover,
                                        )
                                      : Center(child: Text('無照片')),
                                ),
                              ),
                              itemCount: value.remoteUserInfo[0]
                                  .little_profilepic_list.length,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: Text(
                          '${_current + 1}',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
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
                            top: 20.0,
                            left: 15,
                            right: 15,
                            bottom: 80.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //暱稱
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return Container(
                                    width: 250,
                                    child: Text(
                                      value.remoteUserInfo[0].nickname != '' &&
                                              value.remoteUserInfo[0]
                                                      .nickname !=
                                                  null
                                          ? '${value.remoteUserInfo[0].nickname}'
                                          : '不詳',
                                      style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  );
                                }),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.cake,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(
                                            value.remoteUserInfo[0].birthday !=
                                                        null &&
                                                    value.remoteUserInfo[0]
                                                            .birthday !=
                                                        ''
                                                ? '${DateFormat('yyyy-MM-dd').format(value.remoteUserInfo[0].birthday)}'
                                                : '生日不詳',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Consumer<ChatProvider>(
                                            builder: (context, value, child) {
                                          return Text(
                                            value.remoteUserInfo[0].area !=
                                                        null &&
                                                    value.remoteUserInfo[0]
                                                            .area !=
                                                        ''
                                                ? '${ChineseHelper.convertToTraditionalChinese(value.remoteUserInfo[0].area)}'
                                                : '不詳',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 14,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    '關於我',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                //介紹
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return Container(
                                    width: 200,
                                    child: Text(value.remoteUserInfo[0]
                                                    .introduction !=
                                                null &&
                                            value.remoteUserInfo[0]
                                                    .introduction !=
                                                ''
                                        ? '${value.remoteUserInfo[0].introduction}'
                                        : '沒有留下介紹'),
                                  );
                                }),
                                //誰喜歡我
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.center,
                                //     children: [
                                //       Icon(
                                //         Icons.favorite,
                                //         color: Colors.pink,
                                //       ),
                                //       Text(
                                //         ' 誰喜歡我: ',
                                //         style: TextStyle(height: 1),
                                //       ),
                                //       Padding(
                                //         padding:
                                //             const EdgeInsets.only(left: 8.0),
                                //         child: Consumer<ChatProvider>(
                                //             builder: (context, value, child) {
                                //           return Text(
                                //             value.num_likeme != null
                                //                 ? '${value.num_likeme}'
                                //                 : '--',
                                //             style: TextStyle(
                                //                 color: Colors.black,
                                //                 fontSize: 15,
                                //                 height: 1),
                                //           );
                                //         }),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                      return Wrap(
                                        children: List.generate(
                                            value.remoteUserInfo[0].tag.length,
                                            (index) => Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  width: value
                                                              .remoteUserInfo[0]
                                                              .tag[index]
                                                              .length *
                                                          16.0 +
                                                      45,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.mail,
                                                        color: Colors.grey,
                                                      ),
                                                      Text(
                                                        '${value.remoteUserInfo[0].tag[index]}',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey)),
                                                )),
                                        spacing: 10,
                                        runSpacing: 5,
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    '我的興趣',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                      return value.remoteUserInfo[0]
                                              .interest_list.isNotEmpty
                                          ? Wrap(
                                              children: List.generate(
                                                  value.remoteUserInfo[0]
                                                      .interest_list.length,
                                                  (index) => Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 4),
                                                        width: value
                                                                    .remoteUserInfo[
                                                                        0]
                                                                    .interest_list[
                                                                        index]
                                                                    .length *
                                                                16.0 +
                                                            45,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.mail,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            Text(
                                                              '${value.remoteUserInfo[0].interest_list[index]}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey)),
                                                      )),
                                              spacing: 10,
                                              runSpacing: 5,
                                            )
                                          : Text('還未設定興趣');
                                    },
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '體型: ',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value
                                //                       .remoteUserInfo[0].size !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].size}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '個性: ',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .personality !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].personality}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '職業: ',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .profession !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].profession}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    '我的約會安排',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return Container(
                                    width: 200,
                                    child: Text(
                                        value.remoteUserInfo[0].date != null
                                            ? '${value.remoteUserInfo[0].date}'
                                            : '不詳'),
                                  );
                                }),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '零用錢預算:',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .money !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].money}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    '我在尋找',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return Container(
                                    width: 250,
                                    child: Text(value
                                                .remoteUserInfo[0].lookfor !=
                                            null
                                        ? '${value.remoteUserInfo[0].lookfor}'
                                        : '不詳'),
                                  );
                                }),

                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '學歷:',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .education !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].education}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '慣用語言:',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .language !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].language}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '吸菸習慣:',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .smoke !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].smoke}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 8.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         '飲酒習慣:',
                                //         style: TextStyle(color: Colors.brown),
                                //       ),
                                //       Consumer<ChatProvider>(
                                //           builder: (context, value, child) {
                                //         return Container(
                                //           width: 250,
                                //           child: Text(value.remoteUserInfo[0]
                                //                       .drink !=
                                //                   null
                                //               ? '${value.remoteUserInfo[0].drink}'
                                //               : '不詳'),
                                //         );
                                //       })
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //動態
                OtherActionPage(
                  memberid: Provider.of<ChatProvider>(context, listen: false)
                      .remoteUserInfo[0]
                      .memberid,
                  type: 2,
                  nickname: '',
                )
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
