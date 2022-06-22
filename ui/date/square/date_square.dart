import 'package:flutter/material.dart';
import 'package:ime_new/ui/date/square/square_near.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'square_new_login.dart';
import 'square_new_register.dart';
import 'square_recommend.dart';

//交友廣場 方塊
class DateSquare extends StatefulWidget {
  const DateSquare({Key? key}) : super(key: key);

  @override
  State<DateSquare> createState() => _DateSquareState();
}

class _DateSquareState extends State<DateSquare>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: new Size(MediaQuery.of(context).size.width, 50),
      //   child: Container(
      //     height: 35,
      //     decoration: new BoxDecoration(color: Colors.white),
      //     child: TabBar(
      //       controller: _tabController,
      //       unselectedLabelColor: Colors.grey,
      //       labelColor: Colors.red,
      //       labelStyle: TextStyle(fontSize: 12),
      //       unselectedLabelStyle: TextStyle(fontSize: 10),
      //       indicatorColor: Colors.red,
      //       tabs: [
      //         Tab(
      //           text: '推薦會員',
      //         ),
      //         Tab(
      //           text: '最近登入',
      //         ),
      //         Tab(
      //           text: '最新註冊',
      //         ),
      //         Tab(
      //           text: '附近會員',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // body: CustomScrollView(slivers: <Widget>[
      //   SliverFillRemaining(
      //       child: TabBarView(
      //     controller: _tabController,
      //     children: [
      //       DateRecommend(),
      //       Datelastlogin(),
      //       DateNewRegister(),
      //       DateNear(),
      //     ],
      //   )),
      // ])
      body: Container(child: SwipeCards(
        matchEngine: <MatchEngine>,
        itemBuilder: (BuildContext context, int index) {},
        onStackFinished: () {},
        itemChanged: (SwipeItem item, int index) {},
        upSwipeAllowed: false,
        fillSpace: false,
      )),

    );
  }
}
