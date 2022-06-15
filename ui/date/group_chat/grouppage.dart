import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/date/group_chat/getgroupperson.dart';
import 'package:ime_new/ui/date/group_chat/getgroupteam.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentindex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: '揪團',
              ),
              Tab(
                text: '揪咖',
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [GetGroup(), GetPerson()],
        ),
      ),
    ));
  }
}
