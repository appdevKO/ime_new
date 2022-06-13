import 'package:flutter/material.dart';

import 'meet_match.dart';

class MeetPage extends StatefulWidget {
  const MeetPage({Key? key}) : super(key: key);

  @override
  State<MeetPage> createState() => _MeetPageState();
}

class _MeetPageState extends State<MeetPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: new Size(MediaQuery.of(context).size.width, 50),
            child: Container(
              height: 35,
              decoration: new BoxDecoration(color: Colors.white),
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.deepPurpleAccent,
                labelStyle: TextStyle(fontSize: 12),
                unselectedLabelStyle: TextStyle(fontSize: 10),
                indicatorColor: Colors.deepPurpleAccent,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    text: '聯誼活動',
                  ),
                  Tab(
                    text: '愛蜜配對',
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
                MeetMatch(),
                MeetMatch(),
              ],
            ))
          ])),
    );
  }
}
