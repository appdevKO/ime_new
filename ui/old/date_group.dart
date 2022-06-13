import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
// import '../../widget/bottom_sheet.dart';
// import 'package:intl/intl.dart';
//
// class DateGroup extends StatefulWidget {
//   const DateGroup({Key? key}) : super(key: key);
//
//   @override
//   State<DateGroup> createState() => _DateGroupState();
// }
//
// class _DateGroupState extends State<DateGroup>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int index = 0;
//   bool checkvalue = false;
//
//   String dropvalue = '3';
//
//   late TextEditingController _titleController;
//
//   late TextEditingController _purposeController;
//
//   late TextEditingController _areaController;
//
//   late TextEditingController _noteController;
//
//   late TextEditingController _ruleController;
//
//   late TextEditingController _quotaController;
//
//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
//     // mqtt
//     Provider.of<ChatProvider>(context, listen: false).connect();
//     Provider.of<ChatProvider>(context, listen: false).initialGCP();
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       Provider.of<ChatProvider>(context, listen: false).readremotemongodb();
//     });
//     _titleController = TextEditingController();
//     _purposeController = TextEditingController();
//     _areaController = TextEditingController();
//     _noteController = TextEditingController();
//     _ruleController = TextEditingController();
//     _quotaController = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _purposeController.dispose();
//     _areaController.dispose();
//     _noteController.dispose();
//     _ruleController.dispose();
//     _quotaController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // JMessage = Provider.of<ChatProvider>(context, listen: false).JMessage;
//     // Provider.of<ChatProvider>(context, listen: false).readremotemongodb();
//     return Stack(
//       children: [
//         Scaffold(
//           appBar: PreferredSize(
//             preferredSize: new Size(MediaQuery.of(context).size.width, 50),
//             child: Container(
//               height: 44,
//               decoration: new BoxDecoration(
//                 color: Colors.white,
//               ),
//               padding: const EdgeInsets.only(
//                 top: 10.0,
//               ),
//               margin: EdgeInsets.symmetric(
//                 horizontal: 25,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   //拿來對齊
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Icon(
//                       Icons.format_list_numbered_rounded,
//                       color: Colors.transparent,
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border: Border.all(width: 1, color: Colors.red),
//                           borderRadius: BorderRadius.circular(8)),
//                       child: TabBar(
//                         controller: _tabController,
//                         unselectedLabelColor: Colors.red,
//                         labelColor: Colors.white,
//                         labelStyle: TextStyle(
//                           fontSize: 10,
//                         ),
//                         unselectedLabelStyle: TextStyle(
//                           fontSize: 10,
//                         ),
//                         indicatorColor: Colors.red,
//                         indicator: BoxDecoration(
//                           gradient: LinearGradient(colors: [
//                             Color(0xffffbbbb),
//                             Colors.red,
//                           ]),
//                           borderRadius: new BorderRadius.circular(7.0),
//                         ),
//                         tabs: [
//                           Tab(
//                             text: '揪團',
//                           ),
//                           Tab(
//                             text: '揪咖',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   //篩選
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: GestureDetector(
//                       child: Icon(
//                         Icons.format_list_numbered_rounded,
//                         color: Colors.red,
//                       ),
//                       onTap: () {
//                         bottomSheet(context,
//                             StatefulBuilder(builder: (context2, sheetstate) {
//                           return Container(
//                             height: 480,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                     topRight: Radius.circular(20))),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 15, vertical: 8),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   //標題
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.close,
//                                             size: 30, color: Colors.red),
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                       ),
//                                       Text(
//                                         "篩選",
//                                         style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w700,
//                                             height: 1),
//                                       ),
//                                       GestureDetector(
//                                         child: Text(
//                                           '儲存',
//                                           style: TextStyle(color: Colors.red),
//                                         ),
//                                         onTap: () {
//                                           Navigator.pop(context);
//                                         },
//                                       )
//                                     ],
//                                   ),
//                                   Divider(
//                                     height: 1,
//                                   ),
//
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 8.0),
//                                     child: Text('目的'),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5, vertical: 8),
//                                     child: TextField(
//                                         decoration: InputDecoration(
//                                       hintText: '輸入目的',
//                                       border: OutlineInputBorder(gapPadding: 2),
//                                     )),
//                                   ),
//                                   Text('區域'),
//                                   Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 5, vertical: 8),
//                                       child: Container(
//                                         height: 50,
//                                         child: DropdownButton(
//                                           value: dropvalue,
//                                           isExpanded: true,
//                                           onChanged: (value) {
//                                             sheetstate(() {
//                                               dropvalue = value.toString();
//                                             });
//                                           },
//                                           items: <DropdownMenuItem<String>>[
//                                             DropdownMenuItem(
//                                               child: Text(
//                                                 "1111",
//                                               ),
//                                               value: "1",
//                                             ),
//                                             DropdownMenuItem(
//                                               child: Text(
//                                                 "2222",
//                                               ),
//                                               value: "2",
//                                             ),
//                                             DropdownMenuItem(
//                                               child: Text(
//                                                 "3333",
//                                               ),
//                                               value: "3",
//                                             ),
//                                             DropdownMenuItem(
//                                               child: Text(
//                                                 "4444",
//                                               ),
//                                               value: "4",
//                                             ),
//                                           ],
//                                         ),
//                                       )),
//                                   Text('人數限制'),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 5, vertical: 8),
//                                     child: TextField(
//                                         keyboardType: TextInputType.number,
//                                         decoration: InputDecoration(
//                                           hintText: '幾個人',
//                                           border:
//                                               OutlineInputBorder(gapPadding: 2),
//                                         )),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }));
//                         // Navigator.push(context,
//                         //     MaterialPageRoute(builder: (context) {
//                         //   return MongoDemoPage();
//                         // }));
//                         // Provider.of<ChatProvider>(context, listen: false)
//                         //     .initial_JM();
//                         // Navigator.push(context,
//                         //     MaterialPageRoute(builder: (context) {
//                         //   return ChatDemo();
//                         // }));
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           body: TabBarView(
//             controller: _tabController,
//             children: [
//               Stack(
//                 children: [
//                   Groupteam(),
//
//                   ///不要刪掉
//                   // Positioned(
//                   //   left: 10,
//                   //   bottom: 8,
//                   //   child: Row(
//                   //     children: [
//                   //       GestureDetector(
//                   //         child: Container(
//                   //             width: 50,
//                   //             height: 30,
//                   //             decoration: BoxDecoration(
//                   //                 gradient: LinearGradient(colors: [
//                   //                   Color(0xffffaaaa),
//                   //                   Color(0xffff0000)
//                   //                 ]),
//                   //                 borderRadius: BorderRadius.circular(15)),
//                   //             child: Center(child: Text('create member'))),
//                   //         onTap: () {
//                   //           Provider.of<ChatProvider>(context, listen: false)
//                   //               .register();
//                   //         },
//                   //       ),
//                   //       // GestureDetector(
//                   //       //   child: Container(
//                   //       //       width: 50,
//                   //       //       height: 30,
//                   //       //       decoration: BoxDecoration(
//                   //       //           gradient: LinearGradient(colors: [
//                   //       //             Colors.orange,
//                   //       //             Color(0xffffbbbb)
//                   //       //           ]),
//                   //       //           borderRadius: BorderRadius.circular(15)),
//                   //       //       child: Center(child: Text('刷新當前聊天室'))),
//                   //       //   onTap: () {
//                   //       //     Provider.of<ChatProvider>(context, listen: false)
//                   //       //         .readremotemongodb();
//                   //       //   },
//                   //       // ),
//                   //       Container(
//                   //         width: 15,
//                   //       ),
//                   //       GestureDetector(
//                   //         child: Container(
//                   //             width: 50,
//                   //             height: 30,
//                   //             decoration: BoxDecoration(
//                   //                 gradient: LinearGradient(colors: [
//                   //                   Colors.green,
//                   //                   Colors.tealAccent
//                   //                 ]),
//                   //                 borderRadius: BorderRadius.circular(15)),
//                   //             child: Center(child: Text('get userinfo'))),
//                   //         onTap: () {
//                   //           Provider.of<ChatProvider>(context, listen: false)
//                   //               .getaccountinfo();
//                   //         },
//                   //       ),
//                   //       // GestureDetector(
//                   //       //   child: Container(
//                   //       //       width: 50,
//                   //       //       height: 30,
//                   //       //       decoration: BoxDecoration(
//                   //       //           gradient: LinearGradient(
//                   //       //               colors: [Colors.blue, Colors.tealAccent]),
//                   //       //           borderRadius: BorderRadius.circular(15)),
//                   //       //       child: Center(child: Text('delete all'))),
//                   //       //   onTap: () {
//                   //       //     Provider.of<ChatProvider>(context, listen: false)
//                   //       //         .deleteAllRoom();
//                   //       //   },
//                   //       // ),
//                   //     ],
//                   //   ),
//                   // ),
//                   Positioned(
//                     right: 10,
//                     bottom: 8,
//                     child: GestureDetector(
//                       child: Container(
//                         width: 100,
//                         height: 30,
//                         decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                                 colors: [Colors.red, Color(0xffffbbbb)]),
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.group_add,
//                               color: Colors.white,
//                               size: 17,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 8.0),
//                               child: Text(
//                                 '我想揪團',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       onTap: () {
//                         setState(() {
//                           index = 1;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               Stack(children: [
//                 GroupPerson(),
//                 Positioned(
//                   right: 10,
//                   bottom: 8,
//                   child: GestureDetector(
//                     child: Container(
//                       width: 100,
//                       height: 30,
//                       decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                               colors: [Colors.red, Color(0xffffbbbb)]),
//                           borderRadius: BorderRadius.circular(15)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.group_add,
//                             color: Colors.white,
//                             size: 17,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text(
//                               '我想揪咖',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         index = 2;
//                       });
//                     },
//                   ),
//                 )
//               ])
//             ],
//           ),
//         ),
//
//         /**
//          *  index == -1 loading頁 index ==0 露出底下tab頁面 index ==1 疊加創建揪團 index ==2 疊加創建揪咖
//          *
//          *  */
//
//         //揪團首頁
//         index == -1
//             ? Container(
//                 height: double.infinity,
//                 width: double.infinity,
//                 color: Colors.white,
//                 child: homepage(),
//               )
//             //創建揪團
//             : index == 1
//                 ? Container(
//                     height: double.infinity,
//                     width: double.infinity,
//                     color: Colors.white,
//                     child: setup2(),
//                   )
//                 //創建揪咖
//                 : index == 2
//                     ? Container(
//                         height: double.infinity,
//                         width: double.infinity,
//                         color: Colors.white,
//                         child: setup2(),
//                       )
//                     //顯示聊天室列表
//                     : Container()
//       ],
//     );
//   }
//
//   //創建房間
//   Widget setup2() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       child: GestureDetector(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'I ME',
//                 style: TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.w700),
//               ),
//               Text(
//                 index == 2 ? '揪咖開設房' : "揪團開設房",
//                 style: TextStyle(fontWeight: FontWeight.w700),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('標題'),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 5, vertical: 8),
//                       child: TextField(
//                           controller: _titleController,
//                           decoration: InputDecoration(
//                             hintText: '輸入標題',
//                             border: OutlineInputBorder(gapPadding: 2),
//                           )),
//                     ),
//                     Text('目的'),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 5, vertical: 8),
//                       child: TextField(
//                           controller: _purposeController,
//                           decoration: InputDecoration(
//                             hintText: '輸入目的',
//                             border: OutlineInputBorder(gapPadding: 2),
//                           )),
//                     ),
//                     Text('區域'),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 5, vertical: 8),
//                       child: TextField(
//                           controller: _areaController,
//                           decoration: InputDecoration(
//                             hintText: '區域',
//                             border: OutlineInputBorder(gapPadding: 2),
//                           )),
//                     ),
//                     index == 2
//                         ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('人數限定'),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 5, vertical: 8),
//                                 child: TextField(
//                                     controller: _quotaController,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       hintText: '輸入人數',
//                                       border: OutlineInputBorder(gapPadding: 2),
//                                     )),
//                               ),
//                             ],
//                           )
//                         : Container(),
//                     Text('房主的話'),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 5, vertical: 8),
//                       child: TextField(
//                           controller: _noteController,
//                           decoration: InputDecoration(
//                             hintText: '輸入房主的話',
//                             border: OutlineInputBorder(gapPadding: 2),
//                           )),
//                     ),
//                     Text('房規'),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 5, vertical: 8),
//                       child: TextField(
//                           controller: _ruleController,
//                           decoration: InputDecoration(
//                             hintText: '輸入房規',
//                             border: OutlineInputBorder(gapPadding: 2),
//                           )),
//                     ),
//                     Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 5, vertical: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Checkbox(
//                                 value: checkvalue,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     checkvalue = value!;
//                                   });
//                                 },
//                                 activeColor: Colors.red),
//                             Text(
//                               '同意並遵守法律相關責任',
//                               style:
//                                   TextStyle(color: Colors.grey, fontSize: 13),
//                             )
//                           ],
//                         )),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             if (checkvalue == true) {
//                               FocusScope.of(context).unfocus();
//                               Provider.of<ChatProvider>(context, listen: false)
//                                   .createchatroom(
//                                       _titleController.text,
//                                       _areaController.text,
//                                       "111.png",
//                                       index == 1
//                                           ? 0
//                                           : int.parse(_quotaController.text),
//                                       _purposeController.text,
//                                       _noteController.text,
//                                       _ruleController.text,
//                                       DateTime.now().add(Duration(hours: 8)))
//                                   .whenComplete(() {
//                                 _titleController.clear();
//                                 _purposeController.clear();
//                                 _areaController.clear();
//                                 _noteController.clear();
//                                 _ruleController.clear();
//                                 _quotaController.clear();
//                               });
//                               setState(() {
//                                 index = -1;
//                               });
//                             }
//                           },
//                           child: Text('創建房間'),
//                           style: ElevatedButton.styleFrom(
//                               minimumSize: Size(115, 40),
//                               primary:
//                                   checkvalue == true ? Colors.red : Colors.grey,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0))),
//                         ),
//                         Container(
//                           width: 15,
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               index = 0;
//                             });
//                           },
//                           style: ElevatedButton.styleFrom(
//                               minimumSize: Size(115, 40),
//                               primary: Colors.grey,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8.0))),
//                           child: Text('取消'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//       ),
//     );
//   }
//
//   Widget homepage() {
//     return Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               fit: BoxFit.cover,
//               image: NetworkImage(
//                 'https://img03.scbao.com/210103/1082149-21010303104670.jpg',
//               ))),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'I ME',
//                 style: TextStyle(
//                     fontSize: 28,
//                     color: Colors.red,
//                     fontWeight: FontWeight.w700),
//               ),
//               Text(
//                 '揪團咖',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 25,
//                   color: Colors.red,
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 20),
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: Center(
//                     child: Text(
//                   '目前有100個聊天室正在揪團揪咖～快點加入吧',
//                   style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
//                 )),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, top: 15),
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(20),
//                             bottomLeft: Radius.circular(20),
//                             bottomRight: Radius.circular(20)),
//                         color: Color(0xffE65551),
//                       ),
//                       child: Text(
//                         '我想揪咖\n開設房間揪咖速約！',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 20, top: 15),
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             bottomLeft: Radius.circular(20),
//                             bottomRight: Radius.circular(20)),
//                         color: Color(0xffE65551),
//                       ),
//                       child: Text(
//                         '我是揪團達人\n開設房間揪團！',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 20),
//                 padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//                 height: 250,
//                 width: 280,
//                 decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(.6),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: ListView.separated(
//                   itemBuilder: (context, index) {
//                     return Container(
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(right: 10),
//                             child: Container(
//                               height: 16,
//                               width: 16,
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                       width: 1.2, color: Colors.red)),
//                               child: Center(
//                                 child: Text(
//                                   '團',
//                                   style:
//                                       TextStyle(color: Colors.red, height: 1),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   '揪團主題 (11)',
//                                   style: TextStyle(fontWeight: FontWeight.w700),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('揪團備註'),
//                                     Text(
//                                       '2分鐘前',
//                                       style: TextStyle(fontSize: 12),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   itemCount: 11,
//                   scrollDirection: Axis.vertical,
//                   separatorBuilder: (context, index) {
//                     return Container(
//                       height: 8,
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       index = 0;
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                       minimumSize: Size(115, 40),
//                       primary: Color(0xffE65551),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       side: BorderSide(width: 1.5, color: Colors.white)),
//                   child: Text('瀏覽房間'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
