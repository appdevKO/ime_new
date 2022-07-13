import 'package:flutter/material.dart';
import 'package:ime_new/ui/live/spylive/showtime/showtimepage.dart';
import 'package:ime_new/utils/color_config.dart';
import 'package:provider/provider.dart';
import 'mission/missionpage.dart';

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
      appBar: AppBar(
        title: Text(
          '特務直播',
        ),
        backgroundColor: Color(0xff1A1A1A),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          color: Color(0xff1A1A1A),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height ,
          child: Column(
            children: [
              Container(
                height: 3,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  spy_bar_blue,
                  spy_bar_purple,
                ])),
              ),
              //上面按鈕
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 150,
                        height: 45,
                        child: Center(
                            child: Text(
                          'Mission',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        )),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2.5,
                              color: spy_button_blue,
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MissionPage()));
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        width: 150,
                        height: 45,
                        child: Center(
                          child: Text(
                            'ShowTime',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2.5,
                              color: spy_gradient_light_purple,
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowTimePage()));
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                color: index % 2 == 0
                                    ? Color(0xff00CCFF)
                                    : Color(0xff9900CC),
                                offset: Offset(index % 2 == 0 ? 2 : -2, 0),
                              )
                            ],
                            color: spy_card_background,
                            border: Border.all(
                                width: 1, color: spy_card_border_background),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 0, 0),
                                        child: Image.network(
                                          'https://picsum.photos/seed/556/600',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(12),
                                          ),
                                          gradient: LinearGradient(colors: [
                                            spy_gradient_light_blue,
                                            spy_gradient_light_purple
                                          ]),
                                          shape: BoxShape.rectangle,
                                        ),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 0, 0),
                                          child: Text(
                                            '觀看人數',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ]),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 0, 0),
                                        child: Text(
                                          '任務標題',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          '任務內容',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 10, 0),
                                        child: Text(
                                          '懸賞獎金\$6666666',
                                          style: TextStyle(
                                              color: spy_mission_money,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(12),
                                                topLeft: Radius.circular(12),
                                                topRight: Radius.circular(0),
                                              ),
                                              color: spy_gradient_light_blue,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 5, 0, 0),
                                              child: Text(
                                                'Mission',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      itemCount: 12,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
