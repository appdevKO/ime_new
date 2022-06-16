import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/live/livepage2.dart';
import 'package:ime_new/ui/me/profileoption.dart';
import 'package:ime_new/ui/meet/meet_page.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:provider/provider.dart';

import 'date/datepage.dart';

class IndexPage2 extends StatefulWidget {
  const IndexPage2({Key? key}) : super(key: key);

  @override
  State<IndexPage2> createState() => _IndexPage2State();
}

class _IndexPage2State extends State<IndexPage2> {
  late TabController _tabController;
  int currentindex = 0;

  // late List menuItems;
  CustomPopupMenuController _controller = CustomPopupMenuController();
  String area = '';
  String age = '';
  String height = '';

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: ScrollableState(),
      initialIndex: 0,
    );
    // inimongo_login();
    /// ios--後改
    /// mongodb
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      initdata();
    });
    // // mqtt
    // Provider.of<ChatProvider>(context, listen: false).mqtt_connect();
    // Provider.of<ChatProvider>(context, listen: false).initialGCP();

    // menuItems = ['123', '456', '777'];
    super.initState();
  }

  Future initdata() async {
    // print('init 111 index data');
    //
    // await Provider.of<ChatProvider>(context, listen: false)
    //     .pre_Subscribed()
    //     .whenComplete(() async {
    //   await Provider.of<ChatProvider>(context, listen: false)
    //       .find_recommend_people();
    // });

    await Provider.of<ChatProvider>(context, listen: false)
        .find_recommend_people();
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileOption()));
                      }),
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
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
                            '直播',
                            maxLines: 1,
                          ),
                        ),
                        Tab(
                          child: Text(
                            '交友',
                            maxLines: 1,
                          ),
                        ),
                        Tab(
                          child: Text(
                            '聯誼',
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  )),
                  // _tabController.index == 0
                  //     ? Consumer<ChatProvider>(
                  //         builder: (context, value, child) {
                  //         return GestureDetector(
                  //           onTap: () {},
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //                 color: value.search
                  //                     ? Color(0xff77cc77)
                  //                     : Colors.transparent,
                  //                 shape: BoxShape.circle),
                  //             padding: EdgeInsets.all(4),
                  //             child: Icon(
                  //               Icons.search,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         );
                  //       })
                  //     :
                  IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.transparent,
                          ),
                          onPressed: () {})
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
                children: [LivePage2(), DatePage(), MeetPage()],
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
}
