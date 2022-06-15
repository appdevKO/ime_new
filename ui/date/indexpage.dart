import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/date/group_chat/getgroupperson.dart';
import 'package:ime_new/ui/date/group_chat/getgroupteam.dart';
import 'package:ime_new/ui/date/one2one_chat/o2o_chatroomlist.dart';
import 'package:ime_new/ui/date/square/date_square.dart';
import 'package:ime_new/ui/date/square/search_result.dart';
import 'package:ime_new/ui/me/profileoption.dart';
import 'package:ime_new/ui/widget/bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../utils/list_config.dart';
import '../../utils/viewconfig.dart';

/**
 * 交友 第一頁
 */
class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int currentindex = 0;
  // late List menuItems;
  CustomPopupMenuController _controller = CustomPopupMenuController();
  String area = '';
  String age = '';
  String height = '';

  // //mongodb
  // late MongoRealmClient client;
  // late RealmApp app;
  // late CoreRealmUser mongoUser;
  // late List<MongoCollection> collectionlist;

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
      vsync: ScrollableState(),
      initialIndex: 0,
    );
    // inimongo_login();
    /// ios--後改
    /// mongodb
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      initdata();
    });
    // mqtt
    Provider.of<ChatProvider>(context, listen: false).mqtt_connect();
    Provider.of<ChatProvider>(context, listen: false).initialGCP();

    // menuItems = ['123', '456', '777'];
    super.initState();
  }

  Future initdata() async {
    // print('init 111 index data');

    await Provider.of<ChatProvider>(context, listen: false)
        .pre_Subscribed()
        .whenComplete(() async {
      await Provider.of<ChatProvider>(context, listen: false)
          .find_recommend_people();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: new Size(MediaQuery.of(context).size.width, 50),
          child: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(colors: colorlist[currentindex]),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //     icon: Icon(
                  //       Icons.person,
                  //       color: Colors.white,
                  //     ),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => ProfileOption()));
                  //     }),

                  Expanded(
                      child: TabBar(
                    isScrollable: true,
                    onTap: setcolorindex,
                    controller: _tabController,
                    unselectedLabelColor: Colors.white.withOpacity(.7),
                    labelStyle: TextStyle(fontSize: 18),
                    unselectedLabelStyle: TextStyle(fontSize: 14),
                    indicator: BoxDecoration(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    tabs: [
                      Tab(
                        child: Text(
                          '廣場',
                          maxLines: 1,
                        ),
                      ),
                      Tab(
                        child: Text(
                          '揪團',
                          maxLines: 1,
                        ),
                      ),
                      Tab(
                        child: Text(
                          '徵約會',
                          maxLines: 1,
                        ),
                      ),
                      Tab(
                        child: Text(
                          '私聊',
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )),
                  _tabController.index == 0
                      ? Consumer<ChatProvider>(
                          builder: (context, value, child) {
                          return GestureDetector(
                            onTap: () {
                              bottomSheet(context, StatefulBuilder(
                                  builder: (context2, sheetstate) {
                                return Container(
                                  height: 480,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //標題
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 35,
                                              child: IconButton(
                                                icon: Icon(Icons.close,
                                                    size: 30,
                                                    color: Colors.red),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            Text(
                                              "探索",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1),
                                            ),
                                            GestureDetector(
                                              child: Container(
                                                width: 35,
                                                child: Text(
                                                  '儲存',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 17),
                                                ),
                                              ),
                                              onTap: () {
                                                value.get_search(
                                                    area: area,
                                                    age: age,
                                                    height: height);
                                                value.open_search();
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                        Divider(
                                          height: 1,
                                        ),
                                        //居住地區
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '居住地區',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        width: 1,
                                                        color:
                                                            Color(0xffE1C4C4),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      area == ''
                                                          ? '居住地區'
                                                          : area,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('居住地區'),
                                                          content: Container(
                                                            height: 300,
                                                            width: 300,
                                                            child: ListView
                                                                .builder(
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      ListTile(
                                                                title: Text(
                                                                    '${citylist[index]}'),
                                                                onTap: () {
                                                                  sheetstate(
                                                                      () {
                                                                    area = citylist[
                                                                        index];
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              itemCount:
                                                                  citylist
                                                                      .length,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              )
                                            ],
                                          ),
                                        ),

                                        // 年齡
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '年齡',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        width: 1,
                                                        color:
                                                            Color(0xffE1C4C4),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      age == '' ? '年齡' : age,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('年齡'),
                                                          content: Container(
                                                            height: 300,
                                                            width: 300,
                                                            child: ListView
                                                                .builder(
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      ListTile(
                                                                title: Text(
                                                                    '${agelist[index]}'),
                                                                onTap: () {
                                                                  sheetstate(
                                                                      () {
                                                                    age = agelist[
                                                                        index];
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              itemCount: agelist
                                                                  .length,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        // 身高
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '身高',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              GestureDetector(
                                                child: Container(
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        width: 1,
                                                        color:
                                                            Color(0xffE1C4C4),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Text(
                                                      height == ''
                                                          ? '身高'
                                                          : height,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text('身高'),
                                                          content: Container(
                                                            height: 300,
                                                            width: 300,
                                                            child: ListView
                                                                .builder(
                                                              itemBuilder:
                                                                  (context,
                                                                          index) =>
                                                                      ListTile(
                                                                title: Text(
                                                                    '${heightlist[index]}'),
                                                                onTap: () {
                                                                  sheetstate(
                                                                      () {
                                                                    height =
                                                                        heightlist[
                                                                            index];
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              itemCount:
                                                                  heightlist
                                                                      .length,
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: value.search
                                      ? Color(0xff77cc77)
                                      : Colors.transparent,
                                  shape: BoxShape.circle),
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                          );
                        })
                      : IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.transparent,
                          ),
                          onPressed: () {})
                  // CustomPopupMenu(
                  //   // child: IconButton(
                  //   //     icon: Icon(
                  //   //       Icons.notifications_none_sharp,
                  //   //       color: Colors.white,
                  //   //     ),
                  //   //     onPressed: () async {
                  //   //       Provider.of<ChatProvider>(context, listen: false)
                  //   //           .register();
                  //   //     }),
                  //   child: Icon(Icons.notifications_none_sharp,
                  //       color: Colors.white),
                  //   menuBuilder: () => ClipRRect(
                  //     borderRadius: BorderRadius.circular(5),
                  //     child: Container(
                  //       color: const Color(0xFF4C4C4C),
                  //       child: IntrinsicWidth(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.stretch,
                  //           children: menuItems
                  //               .map(
                  //                 (item) => GestureDetector(
                  //                   behavior: HitTestBehavior.translucent,
                  //                   onTap: () {
                  //                     print("onTap");
                  //                     _controller.hideMenu();
                  //
                  //                     ///
                  //                     // _tabController.animateTo(3);
                  //                     // setcolorindex(3);
                  //                   },
                  //                   child: Container(
                  //                     height: 20,
                  //                     width: 100,
                  //                     child: Text("$item"),
                  //                   ),
                  //                 ),
                  //               )
                  //               .toList(),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  //   pressType: PressType.singleClick,
                  //   verticalMargin: -10,
                  //   controller: _controller,
                  // ),
                ],
              ),
            ),
          ),
        ),
        body: Consumer<ChatProvider>(
          builder: (context, value, child) {
            return Container(
              color: Colors.white,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  value.search ? SearchResult() : DateSquare(),
                  GetTeam(),
                  GetPerson(),
                  OneChat()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void setcolorindex(int index) {
    setState(() {
      currentindex = index;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

// Future<void> inimongo_login() async {
//
// }

// Future<void> ini_collection() async {
//   collectionlist.add(client.getDatabase("ime").getCollection("chatmsg"));
//   collectionlist.add(client.getDatabase("ime").getCollection("chatroom"));
// }

// Future<void> clientlistener(client) async {
//   try {
//     //監聽 chatmsg
//     Stream stream1 = await collectionlist[0].watch();
//     stream1.listen((event) {
//       print("stream chatmag listen中 發生$event");
//       var fullDocument = MongoDocument.parse(event);
//       print("fulldocument $fullDocument");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("listener 收到一個chatmag事件$event"),
//         duration: Duration(milliseconds: 1000),
//       ));
//     });
//
//     //監聽 chatroom
//     Stream stream2 = await collectionlist[1].watch();
//     stream2.listen((event) {
//       print("stream chatroom listen中 發生$event");
//       var fullDocument = MongoDocument.parse(event);
//       print("fulldocument $fullDocument");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("listener 收到一個chatroom事件$event"),
//         duration: Duration(milliseconds: 1000),
//       ));
//     });
//   } on PlatformException catch (e) {
//     debugPrint("listener Error! ${e.message}");
//   }
//
//   // return StreamBuilder(
//   //   stream: stream,
//   //   builder: (context, AsyncSnapshot snapshot) {
//   //     switch (snapshot.connectionState) {
//   //       case ConnectionState.none:
//   //       case ConnectionState.waiting:
//   //         return CircularProgressIndicator();
//   //
//   //       case ConnectionState.active:
//   //         // log error to console
//   //         if (snapshot.error != null) {
//   //           print("error");
//   //           return Container(
//   //             alignment: Alignment.center,
//   //             child: Text(
//   //               snapshot.error.toString(),
//   //               style: TextStyle(
//   //                 fontSize: 18,
//   //                 color: Colors.white,
//   //                 fontFamily: "ariel",
//   //               ),
//   //             ),
//   //           );
//   //         }
//   //
//   //         // redirect to the proper page
//   //         return snapshot.hasData
//   //             ? Container(
//   //                 child: Text('登入了有資料'),
//   //               )
//   //             : Container(
//   //                 child: Text('沒有登入沒資料'),
//   //               );
//   //
//   //       default:
//   //         return Container();
//   //     }
//   //   },
//   // );
// }
}
