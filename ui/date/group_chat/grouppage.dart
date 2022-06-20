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
          height: 40,
          padding: EdgeInsets.only(top: 5),
          decoration: new BoxDecoration(color: Colors.white),
          child: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.redAccent,
            labelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14),
            unselectedLabelStyle:
                TextStyle(fontSize: 14, color: Colors.redAccent),
            indicatorColor: Colors.red,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 1,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                    colors: [Color(0xfffa8072), Color(0xffdc344c)])),
            tabs: [
              Tab(
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "揪團",
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.redAccent, width: 1)),
                ),
              ),
              Tab(
                child: Container(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "揪咖",
                      )),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.redAccent, width: 1)),
                ),
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
          children: [GetTeam(), GetPerson()],
        ),
      ),
    ));
  }
}
