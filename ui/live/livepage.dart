import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/live/spylive.dart';
import 'package:ime_new/ui/live/sweetlivepage.dart';
import 'package:ime_new/ui/live/truth_or_dare/truth_or_dare_page.dart';
import 'package:provider/provider.dart';

class LivePage extends StatefulWidget {
  const LivePage({Key? key}) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  int currentindex = 0;
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: new Size(MediaQuery.of(context).size.width, 50),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Color(0xffff7090), Color(0xfff0c0c0)]),
            ),
            child: TabBar(
              isScrollable: true,
              // onTap: setcolorindex,
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
                    '甜心直播',
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: Text(
                    '特務直播',
                    maxLines: 1,
                  ),
                ),
                Tab(
                  child: Text(
                    '真心話大冒險',
                    maxLines: 1,
                  ),
                ),
              ],
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
                children: [SweetLivePage(), SpyLivePage(), TurthOrDare()],
              ),
            );
          },
        ),
      ),
    );
  }
}
