import 'package:flutter/material.dart';
import 'package:ime_new/ui/date/square/square_near.dart';
import 'package:ime_new/ui/date/square/square_new_login.dart';
import 'package:ime_new/ui/date/square/square_new_register.dart';
import 'package:ime_new/ui/date/square/square_recommend.dart';

import 'package:swipeable_card_stack/swipeable_card_stack.dart';

//交友廣場 方塊
class DateSquare extends StatefulWidget {
  const DateSquare({Key? key}) : super(key: key);

  @override
  State<DateSquare> createState() => _DateSquareState();
}

class _DateSquareState extends State<DateSquare>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SwipeableCardSectionController _cardController =
  SwipeableCardSectionController();

  // List<SwipeItem> _swipeItems = <SwipeItem>[];
  //
  // MatchEngine? _matchEngine;
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  // List<Color> _colors = [
  //   Colors.red,
  //   Colors.blue,
  //   Colors.green,
  //   Colors.yellow,
  //   Colors.orange
  // ];

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    // for (int i = 0; i < _names.length; i++) {
    //   _swipeItems.add(SwipeItem(
    //       content: Content(text: _names[i], color: _colors[i]),
    //       likeAction: () {
    //         _scaffoldKey.currentState?.showSnackBar(SnackBar(
    //           content: Text("Liked ${_names[i]}"),
    //           duration: Duration(milliseconds: 500),
    //         ));
    //       },
    //       nopeAction: () {
    //         _scaffoldKey.currentState?.showSnackBar(SnackBar(
    //           content: Text("Nope ${_names[i]}"),
    //           duration: Duration(milliseconds: 500),
    //         ));
    //       },
    //       superlikeAction: () {
    //         _scaffoldKey.currentState?.showSnackBar(SnackBar(
    //           content: Text("Superliked ${_names[i]}"),
    //           duration: Duration(milliseconds: 500),
    //         ));
    //       },
    //       onSlideUpdate: (SlideRegion? region) async {
    //         print("Region $region");
    //       }));
    // }
    //
    // _matchEngine = MatchEngine(swipeItems: _swipeItems);
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
        appBar: PreferredSize(
          preferredSize: new Size(MediaQuery.of(context).size.width, 50),
          child: Container(
            height: 35,
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
                  text: '推薦會員',
                ),
                Tab(
                  text: '最近登入',
                ),
                Tab(
                  text: '最新註冊',
                ),
                Tab(
                  text: '附近會員',
                ),
              ],
            ),
          ),
        ),
        body: CustomScrollView(slivers: <Widget>[
          SliverFillRemaining(
              child: TabBarView(
            controller: _tabController,
            children: [
              DateRecommend(),
              Datelastlogin(),
              DateNewRegister(),
              DateNear(),
            ],
          )),
        ]));

    // return Scaffold(
    //     body:
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //       SwipeableCardsSection(
    //         cardController: _cardController,
    //         context: context,
    //         //add the first 3 cards (widgets)
    //         items: [
    //           Container(
    //             height: 400,
    //             width: 300,
    //             color: Colors.blue,
    //             child: Text('111'),
    //           ),
    //           Container(
    //             height: 400,
    //             width: 300,
    //             color: Colors.pink,
    //             child: Text('222'),
    //           ),
    //           Container(
    //             height: 400,
    //             width: 300,
    //             color: Colors.red,
    //             child: Text('333'),
    //           ),
    //           Container(
    //             height: 400,
    //             width: 300,
    //             color: Colors.yellow,
    //             child: Text('555'),
    //           ),
    //           // CardView(text: "First card"),
    //           // CardView(text: "Second card"),
    //           // CardView(text: "Third card"),
    //         ],
    //         //Get card swipe event callbacks
    //         onCardSwiped: (dir, index, widget) {
    //           //Add the next card using _cardController
    //           _cardController.addItem(
    //             Container(
    //               height: 400,
    //               width: 300,
    //               color: Colors.blue,
    //               child: Text('下一章'),
    //             ),
    //           );
    //
    //           //Take action on the swiped widget based on the direction of swipe
    //           //Return false to not animate cards
    //         },
    //         //
    //         enableSwipeUp: true,
    //         enableSwipeDown: false,
    //       ),
    //       //other children
    //     ]));
  }
}

class Content {
  final String text;
  final Color color;

  Content({required this.text, required this.color});
}
