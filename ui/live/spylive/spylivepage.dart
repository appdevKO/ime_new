import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/spylive/anchor/spy_anchor_live.dart';
import 'package:ime_new/ui/live/spylive/player/spy_player_live.dart';
import 'package:ime_new/ui/live/spylive/player/spy_player_missionlist.dart';

import 'anchor/spy_anchor_missionlist.dart';
import 'createmission.dart';

class SpyLivePage extends StatefulWidget {
  const SpyLivePage({Key? key}) : super(key: key);

  @override
  State<SpyLivePage> createState() => _SpyLivePageState();
}

class _SpyLivePageState extends State<SpyLivePage> {
  late TabController _tabController;
  bool positive = false;

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedToggleSwitch<bool>.dual(
                  current: positive,
                  first: false,
                  second: true,
                  dif: 50.0,
                  borderColor: Colors.transparent,
                  borderWidth: 2.0,
                  height: 35,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1.5),
                    ),
                  ],
                  onChanged: (value) => setState(() => positive = value),
                  colorBuilder: (b) => b ? Color(0xffffbbbb) : Colors.blue,
                  iconBuilder: (value) => value
                      ? Icon(Icons.coronavirus_rounded)
                      : Icon(Icons.tag_faces_rounded),
                  textBuilder: (value) => value
                      ? Center(child: Text('任務欄'))
                      : Center(child: Text('直播')),
                ),
                GestureDetector(
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          '我要發任務',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateMission()));
                  },
                )
              ],
            ),
          ),
          Container(
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
                  text: '玩家',
                ),
                Tab(
                  text: '直播主',
                ),
              ],
            ),
          ),
          positive
              ? Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [SpyPlayerMission(), SpyAnchorMission()],
                  ),
                )
              : Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [SpyPlayerLive(), SpyAnchorLive()],
                  ),
                ),
        ],
      ),
    );
  }
}
