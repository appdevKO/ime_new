import 'package:flutter/material.dart';

class SweetLivePage extends StatefulWidget {
  const SweetLivePage({Key? key}) : super(key: key);

  @override
  State<SweetLivePage> createState() => _SweetLivePageState();
}

class _SweetLivePageState extends State<SweetLivePage> {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
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
                  text: '追蹤中',
                ),
                Tab(
                  text: '熱門',
                ),
                Tab(
                  text: '才藝',
                ),
                Tab(
                  text: '新人',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SweetLiveList(),
                SweetLiveList(),
                SweetLiveList(),
                SweetLiveList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SweetLiveList extends StatefulWidget {
  const SweetLiveList({Key? key}) : super(key: key);

  @override
  State<SweetLiveList> createState() => _SweetLiveListState();
}

class _SweetLiveListState extends State<SweetLiveList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0, mainAxisSpacing: 10.0,
          childAspectRatio: 1, //子元素在横轴长度和主轴长度的比例
        ),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.pink.withOpacity(.5), width: 1)),
              ),
              Container(
                height: 25,
                width: 75,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(8))),
                child: Center(
                  child: Text(
                    '直播中',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                  right: 5,
                  top: 3,
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xffffbde6), Color(0xffff73c7)]),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        '#顏值',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  )),
              Positioned(
                  left: 5,
                  bottom: 5,
                  child: Container(
                    height: 15,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        '旅遊中',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  )),
              Positioned(
                  right: 10,
                  bottom: 5,
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 14,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ))
            ],
          );
        },
        itemCount: 15,
      ),
    );
  }
}
