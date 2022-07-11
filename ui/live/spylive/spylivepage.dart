import 'package:flutter/material.dart';

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
          textAlign: TextAlign.center,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.88,
          child: Column(
            children: [
              //上面按鈕
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 150,
                        height: 50,
                        child: Center(
                            child: Text(
                          'Mission',
                          style: TextStyle(color: Colors.white),
                        )),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              width: 2.5,
                              color: Color(0xff35B4CF),
                            )),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MissionPage()));
                      },
                    ),
                    Container(
                      width: 150,
                      height: 50,
                      child: Center(
                        child: Text(
                          'ShowTime',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
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
                                blurRadius: 3,
                                color: Color(0x20000000),
                                offset: Offset(0, 1),
                              )
                            ],
                            color: Colors.white,
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
                                          color: Colors.grey,
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
                                              color: Colors.black,
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
                                              color: Colors.black,
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
                                              color: Colors.black,
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
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0, 5, 0, 0),
                                              child: Text(
                                                'Mission',
                                                textAlign: TextAlign.center,
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
                    )

                    // ListView(
                    //   padding: EdgeInsets.zero,
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.vertical,
                    //   children: [
                    //
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 150,
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               blurRadius: 3,
                    //               color: Color(0x20000000),
                    //               offset: Offset(0, 1),
                    //             )
                    //           ],
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Padding(
                    //           padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsetsDirectional.fromSTEB(
                    //                         16, 0, 0, 0),
                    //                     child: Image.network(
                    //                       'https://picsum.photos/seed/556/600',
                    //                       width: 100,
                    //                       height: 100,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 100,
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.only(
                    //                         bottomLeft: Radius.circular(12),
                    //                         bottomRight: Radius.circular(0),
                    //                         topLeft: Radius.circular(0),
                    //                         topRight: Radius.circular(12),
                    //                       ),
                    //                     ),
                    //                     child: Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 5, 0, 0),
                    //                       child: Text(
                    //                         '觀看人數',
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Expanded(
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 10, 0, 0),
                    //                       child: Text(
                    //                         '任務標題',
                    //                         textAlign: TextAlign.start,
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 0, 0, 0),
                    //                       child: Text(
                    //                         '任務內容',
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 0, 10, 0),
                    //                       child: Text(
                    //                         '懸賞獎金\$6666666',
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.end,
                    //                       children: [
                    //                         Container(
                    //                           width: 100,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                             borderRadius: BorderRadius.only(
                    //                               bottomLeft: Radius.circular(0),
                    //                               bottomRight:
                    //                                   Radius.circular(12),
                    //                               topLeft: Radius.circular(12),
                    //                               topRight: Radius.circular(0),
                    //                             ),
                    //                           ),
                    //                           child: Padding(
                    //                             padding: EdgeInsetsDirectional
                    //                                 .fromSTEB(0, 5, 0, 0),
                    //                             child: Text(
                    //                               'ShowTime',
                    //                               textAlign: TextAlign.center,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 150,
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               blurRadius: 3,
                    //               color: Color(0x20000000),
                    //               offset: Offset(0, 1),
                    //             )
                    //           ],
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Padding(
                    //           padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsetsDirectional.fromSTEB(
                    //                         16, 0, 0, 0),
                    //                     child: Image.network(
                    //                       'https://picsum.photos/seed/556/600',
                    //                       width: 100,
                    //                       height: 100,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 100,
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.only(
                    //                         bottomLeft: Radius.circular(12),
                    //                         bottomRight: Radius.circular(0),
                    //                         topLeft: Radius.circular(0),
                    //                         topRight: Radius.circular(12),
                    //                       ),
                    //                     ),
                    //                     child: Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 5, 0, 0),
                    //                       child: Text(
                    //                         '觀看人數',
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Expanded(
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 10, 0, 0),
                    //                       child: Text(
                    //                         '任務標題',
                    //                         textAlign: TextAlign.start,
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 0, 0, 0),
                    //                       child: Text(
                    //                         '任務內容',
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 0, 10, 0),
                    //                       child: Text(
                    //                         '懸賞獎金\$6666666',
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.end,
                    //                       children: [
                    //                         Container(
                    //                           width: 100,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                             borderRadius: BorderRadius.only(
                    //                               bottomLeft: Radius.circular(0),
                    //                               bottomRight:
                    //                                   Radius.circular(12),
                    //                               topLeft: Radius.circular(12),
                    //                               topRight: Radius.circular(0),
                    //                             ),
                    //                           ),
                    //                           child: Padding(
                    //                             padding: EdgeInsetsDirectional
                    //                                 .fromSTEB(0, 5, 0, 0),
                    //                             child: Text(
                    //                               'ShowTime',
                    //                               textAlign: TextAlign.center,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 150,
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               blurRadius: 3,
                    //               color: Color(0x20000000),
                    //               offset: Offset(0, 1),
                    //             )
                    //           ],
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Padding(
                    //           padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsetsDirectional.fromSTEB(
                    //                         16, 0, 0, 0),
                    //                     child: Image.network(
                    //                       'https://picsum.photos/seed/556/600',
                    //                       width: 100,
                    //                       height: 100,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 100,
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.only(
                    //                         bottomLeft: Radius.circular(12),
                    //                         bottomRight: Radius.circular(0),
                    //                         topLeft: Radius.circular(0),
                    //                         topRight: Radius.circular(12),
                    //                       ),
                    //                     ),
                    //                     child: Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 5, 0, 0),
                    //                       child: Text(
                    //                         '觀看人數',
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Expanded(
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 10, 0, 0),
                    //                       child: Text(
                    //                         '任務標題',
                    //                         textAlign: TextAlign.start,
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 0, 0, 0),
                    //                       child: Text(
                    //                         '任務內容',
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 0, 10, 0),
                    //                       child: Text(
                    //                         '懸賞獎金\$6666666',
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.end,
                    //                       children: [
                    //                         Container(
                    //                           width: 100,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                             borderRadius: BorderRadius.only(
                    //                               bottomLeft: Radius.circular(0),
                    //                               bottomRight:
                    //                                   Radius.circular(12),
                    //                               topLeft: Radius.circular(12),
                    //                               topRight: Radius.circular(0),
                    //                             ),
                    //                           ),
                    //                           child: Padding(
                    //                             padding: EdgeInsetsDirectional
                    //                                 .fromSTEB(0, 5, 0, 0),
                    //                             child: Text(
                    //                               'ShowTime',
                    //                               textAlign: TextAlign.center,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 150,
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               blurRadius: 3,
                    //               color: Color(0x20000000),
                    //               offset: Offset(0, 1),
                    //             )
                    //           ],
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Padding(
                    //           padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsetsDirectional.fromSTEB(
                    //                         16, 0, 0, 0),
                    //                     child: Image.network(
                    //                       'https://picsum.photos/seed/556/600',
                    //                       width: 100,
                    //                       height: 100,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 100,
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.only(
                    //                         bottomLeft: Radius.circular(12),
                    //                         bottomRight: Radius.circular(0),
                    //                         topLeft: Radius.circular(0),
                    //                         topRight: Radius.circular(12),
                    //                       ),
                    //                     ),
                    //                     child: Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 5, 0, 0),
                    //                       child: Text(
                    //                         '觀看人數',
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Expanded(
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 10, 0, 0),
                    //                       child: Text(
                    //                         '任務標題',
                    //                         textAlign: TextAlign.start,
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 0, 0, 0),
                    //                       child: Text(
                    //                         '任務內容',
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 0, 10, 0),
                    //                       child: Text(
                    //                         '懸賞獎金\$6666666',
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.end,
                    //                       children: [
                    //                         Container(
                    //                           width: 100,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                             borderRadius: BorderRadius.only(
                    //                               bottomLeft: Radius.circular(0),
                    //                               bottomRight:
                    //                                   Radius.circular(12),
                    //                               topLeft: Radius.circular(12),
                    //                               topRight: Radius.circular(0),
                    //                             ),
                    //                           ),
                    //                           child: Padding(
                    //                             padding: EdgeInsetsDirectional
                    //                                 .fromSTEB(0, 5, 0, 0),
                    //                             child: Text(
                    //                               'ShowTime',
                    //                               textAlign: TextAlign.center,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 150,
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               blurRadius: 3,
                    //               color: Color(0x20000000),
                    //               offset: Offset(0, 1),
                    //             )
                    //           ],
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Padding(
                    //           padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsetsDirectional.fromSTEB(
                    //                         16, 0, 0, 0),
                    //                     child: Image.network(
                    //                       'https://picsum.photos/seed/556/600',
                    //                       width: 100,
                    //                       height: 100,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 100,
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.only(
                    //                         bottomLeft: Radius.circular(12),
                    //                         bottomRight: Radius.circular(0),
                    //                         topLeft: Radius.circular(0),
                    //                         topRight: Radius.circular(12),
                    //                       ),
                    //                     ),
                    //                     child: Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 5, 0, 0),
                    //                       child: Text(
                    //                         '觀看人數',
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Expanded(
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 10, 0, 0),
                    //                       child: Text(
                    //                         '任務標題',
                    //                         textAlign: TextAlign.start,
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 0, 0, 0),
                    //                       child: Text(
                    //                         '任務內容',
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 0, 10, 0),
                    //                       child: Text(
                    //                         '懸賞獎金\$6666666',
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.end,
                    //                       children: [
                    //                         Container(
                    //                           width: 100,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                             borderRadius: BorderRadius.only(
                    //                               bottomLeft: Radius.circular(0),
                    //                               bottomRight:
                    //                                   Radius.circular(12),
                    //                               topLeft: Radius.circular(12),
                    //                               topRight: Radius.circular(0),
                    //                             ),
                    //                           ),
                    //                           child: Padding(
                    //                             padding: EdgeInsetsDirectional
                    //                                 .fromSTEB(0, 5, 0, 0),
                    //                             child: Text(
                    //                               'ShowTime',
                    //                               textAlign: TextAlign.center,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 150,
                    //         decoration: BoxDecoration(
                    //           boxShadow: [
                    //             BoxShadow(
                    //               blurRadius: 3,
                    //               color: Color(0x20000000),
                    //               offset: Offset(0, 1),
                    //             )
                    //           ],
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Padding(
                    //           padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.max,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsetsDirectional.fromSTEB(
                    //                         16, 0, 0, 0),
                    //                     child: Image.network(
                    //                       'https://picsum.photos/seed/556/600',
                    //                       width: 100,
                    //                       height: 100,
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                   Container(
                    //                     width: 100,
                    //                     height: 30,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.only(
                    //                         bottomLeft: Radius.circular(12),
                    //                         bottomRight: Radius.circular(0),
                    //                         topLeft: Radius.circular(0),
                    //                         topRight: Radius.circular(12),
                    //                       ),
                    //                     ),
                    //                     child: Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 5, 0, 0),
                    //                       child: Text(
                    //                         '觀看人數',
                    //                         textAlign: TextAlign.center,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Expanded(
                    //                 child: Column(
                    //                   mainAxisSize: MainAxisSize.max,
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.center,
                    //                   children: [
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 10, 0, 0),
                    //                       child: Text(
                    //                         '任務標題',
                    //                         textAlign: TextAlign.start,
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           10, 0, 0, 0),
                    //                       child: Text(
                    //                         '任務內容',
                    //                       ),
                    //                     ),
                    //                     Padding(
                    //                       padding: EdgeInsetsDirectional.fromSTEB(
                    //                           0, 0, 10, 0),
                    //                       child: Text(
                    //                         '懸賞獎金\$6666666',
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.end,
                    //                       children: [
                    //                         Container(
                    //                           width: 100,
                    //                           height: 30,
                    //                           decoration: BoxDecoration(
                    //                             borderRadius: BorderRadius.only(
                    //                               bottomLeft: Radius.circular(0),
                    //                               bottomRight:
                    //                                   Radius.circular(12),
                    //                               topLeft: Radius.circular(12),
                    //                               topRight: Radius.circular(0),
                    //                             ),
                    //                           ),
                    //                           child: Padding(
                    //                             padding: EdgeInsetsDirectional
                    //                                 .fromSTEB(0, 5, 0, 0),
                    //                             child: Text(
                    //                               'ShowTime',
                    //                               textAlign: TextAlign.center,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
