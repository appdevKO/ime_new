import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/spylive/spy_anchor_live.dart';
import 'package:ime_new/ui/live/spylive/spy_player_live.dart';

class SpyLivePage extends StatefulWidget {
  const SpyLivePage({Key? key}) : super(key: key);

  @override
  State<SpyLivePage> createState() => _SpyLivePageState();
}

class _SpyLivePageState extends State<SpyLivePage> {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: ScrollableState(),
      initialIndex: 0,
    );
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
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.pink,
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  text: '玩家',
                ),
                Tab(
                  text: '直播主',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SpyPlayerLive(), SpyAnchorLive()
                // SweetLiveList(),
                // SweetLiveList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
