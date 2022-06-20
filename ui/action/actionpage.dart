import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';

import 'favorite_actionlist.dart';
import 'package:provider/provider.dart';

import 'create_action.dart';
import 'new_actionlist.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  late TabController _tabController;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: ScrollableState(),
      initialIndex: 0,
    );
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: new Size(MediaQuery.of(context).size.width, 50),
              child: Container(
                height: 30,
                decoration: new BoxDecoration(color: Colors.white),
                child: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.red,
                  labelStyle: TextStyle(fontSize: 12),
                  unselectedLabelStyle: TextStyle(fontSize: 10),
                  indicatorColor: Colors.red,

                  tabs: [
                    Tab(
                      child: Text(
                        '最新',
                        maxLines: 1,
                      ),
                    ),
                    Tab(
                      child: Text(
                        '關注',
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
                // color: Colors.white,
                child: CustomScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          child: Container(
                            color: Colors.white,
                            child: Consumer<ChatProvider>(
                                builder: (context, value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    '${value.remoteUserInfo[0].avatar_sub}')),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    value.remoteUserInfo[0]
                                                                    .nickname !=
                                                                '' &&
                                                            value.remoteUserInfo[0]
                                                                    .nickname !=
                                                                null
                                                        ? '${value.remoteUserInfo[0].nickname}'
                                                        : '不詳',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.grey,
                                                        size: 15,
                                                      ),
                                                      Text(
                                                        value.remoteUserInfo[0]
                                                                        .area !=
                                                                    '' &&
                                                                value.remoteUserInfo[0]
                                                                        .area !=
                                                                    null
                                                            ? '${value.remoteUserInfo[0].area}'
                                                            : '不詳',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewAction()));
                                            },
                                            child: Text('建立動態')),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //     padding: const EdgeInsets.only(
                                  //         right: 20, left: 20, bottom: 10),
                                  //     child: TextField(
                                  //       controller: _textEditingController,
                                  //       decoration: InputDecoration(
                                  //         enabledBorder: const OutlineInputBorder(
                                  //           borderSide: const BorderSide(
                                  //               color: Colors.grey, width: 0.0),
                                  //         ),
                                  //         // border: OutlineInputBorder(
                                  //         //   borderRadius: BorderRadius.circular(22),
                                  //         // ),
                                  //         border: OutlineInputBorder(
                                  //           borderSide: const BorderSide(
                                  //               color: Colors.blue, width: 0.0),
                                  //         ),
                                  //         fillColor: Colors.white,
                                  //         filled: true,
                                  //         hintText: '你在做什麼?',
                                  //         contentPadding: EdgeInsets.symmetric(
                                  //             horizontal: 12, vertical: 5),
                                  //       ),
                                  //     )),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Divider(
                                      height: 1,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.symmetric(vertical: 2),
                                  //   child: Container(
                                  //     height: 35,
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Container(
                                  //           width: 1,
                                  //         ),
                                  //         GestureDetector(
                                  //           child: Row(
                                  //             children: [
                                  //               Icon(Icons.camera_alt),
                                  //               Text('拍照')
                                  //             ],
                                  //           ),
                                  //           onTap: () {
                                  //             value.load_action_img();
                                  //           },
                                  //         ),
                                  //         VerticalDivider(
                                  //           thickness: 1,
                                  //         ),
                                  //         Row(
                                  //           children: [
                                  //             Icon(Icons.photo),
                                  //             Text('照片')
                                  //           ],
                                  //         ),
                                  //         Container(
                                  //           width: 1,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Divider(
                                    height: 1,
                                  )
                                ],
                              );
                            }),
                          ),
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      SliverFillRemaining(
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [NewestActionList(), FavoriteActionList()],
                        ),
                      )
                    ]))));
  }
}
