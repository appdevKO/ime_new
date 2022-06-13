// import 'package:flutter/material.dart';
// import 'package:ime_module/business_logic/provider/chat_provider.dart';
//
// import 'package:provider/provider.dart';
//
// import '../../../business_logic/model/chat_model.dart';
//
// class GroupChatRoom1 extends StatefulWidget {
//   const GroupChatRoom1(
//       {Key? key, required this.chatroomid, required this.title})
//       : super(key: key);
//
//   final String chatroomid;
//   final String title;
//
//   @override
//   _GroupChatRoom1State createState() => _GroupChatRoom1State();
// }
//
// class _GroupChatRoom1State extends State<GroupChatRoom1> {
//   late TextEditingController _textController;
//
//   @override
//   void initState() {
//     _textController = new TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: new Size(MediaQuery.of(context).size.width, 50),
//           child: Container(
//             height: 44,
//             decoration: new BoxDecoration(
//               gradient: LinearGradient(colors: [
//                 Color(0xffe37c7c),
//                 Color(0xffeecfea),
//               ]),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 //拿來對齊
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10),
//                   child: GestureDetector(
//                     child: Icon(
//                       Icons.arrow_back,
//                       color: Colors.white,
//                     ),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 Center(
//                     child: Text(
//                   '${widget.title}',
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.w700),
//                 )),
//                 Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Text(
//                       '退出',
//                       style: TextStyle(color: Colors.white),
//                     )),
//               ],
//             ),
//           ),
//         ),
//         body: GestureDetector(
//           child: Container(
//             color: Color(0xffF6F6F6),
//             child: Column(
//               children: [
//                 topMember(),
//                 Expanded(child: Container(
//                   child: Consumer<ChatProvider>(
//                     builder: (context, value, child) {
//                       return value.historymsg == null ||
//                               value.historymsg!.isEmpty
//                           ? Center(
//                               child: Container(
//                                 child: Text('目前沒有聊天記錄'),
//                               ),
//                             )
//                           : ListView.builder(
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 10,
//                                   ),
//                                   child: index.isOdd
//                                       ? bobble(
//                                           true,
//                                           1,
//                                           ChatInfo(
//                                               text: value
//                                                   .historymsg?[index].text))
//                                       : bobble(
//                                           false,
//                                           2,
//                                           ChatInfo(
//                                               text: value
//                                                   .historymsg?[index].text)),
//                                 );
//                               },
//                               itemCount: value.historymsg!.length,
//                             );
//                     },
//                   ),
//                 )),
//                 bottomEnter()
//               ],
//             ),
//           ),
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget bottomEnter() {
//     return Container(
//       height: 50,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Color(0xffF9F9F9),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 7,
//             offset: Offset(0, 5), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: Icon(Icons.add),
//           ),
//           //文字輸入框
//           Flexible(
//             child: Stack(
//               children: [
//                 Container(
//                     constraints:
//                         BoxConstraints(minHeight: 60.0, maxHeight: 150.0),
//                     padding: const EdgeInsets.only(
//                         top: 10, bottom: 10, right: 2, left: 2),
//                     child: TextField(
//                       //限制輸入文字多長
//                       // maxLength: 75,
//                       //換行
//                       // maxLines: null,
//                       // keyboardType: TextInputType.multiline,
//                       controller: _textController,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(20)),
//                           fillColor: Colors.white,
//                           filled: true,
//                           hintText: '輸入想說的話',
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 5)),
//                       style: TextStyle(height: 1),
//                     )),
//               ],
//             ),
//           ),
//           //文字送出按鈕
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 5),
//             child: GestureDetector(
//               child: Icon(Icons.send),
//               onTap: () {
//                 if (_textController.text != '') {
//                   // Provider.of<ChatProvider>(context, listen: false)
//                   //     .sendtextmsg(_textController.text);
//                   _textController.clear();
//                 }
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget topMember() {
//     return Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Color(0xffF9F9F9),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: Offset(0, 2), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 5),
//         child: ListView.separated(
//           itemBuilder: (context, index) {
//             return CircleAvatar(
//               backgroundColor: Colors.grey,
//               backgroundImage: NetworkImage(
//                   'http://i1.kknews.cc/QLyKgGAjFJ5m0w6wfgVlbKGAArvxyFvX4MS8YnKmj88/0.jpg'),
//             );
//           },
//           itemCount: 12,
//           separatorBuilder: (context, index) {
//             return Container(
//               width: 3,
//             );
//           },
//           scrollDirection: Axis.horizontal,
//         ),
//       ),
//     );
//   }
//
//   //泡泡樣式
//   Widget bobble(bool isme, int type, ChatInfo bobble_content) {
//     double text_radius = 20.0;
//     // type檢查樣式
//     // isme檢查左右
//     return isme == true
//         ? Container(
//             margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//                     //控制泡泡裡面的大小
//                     //大小
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * .6,
//                     ),
//                     //泡泡顏色
//                     decoration: BoxDecoration(
//                       color: Color(0xffEAEFF6),
//                       // gradient: LinearGradient(
//                       //     colors: [Color(0xfffd669a), Color(0xffff836a)]),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(text_radius),
//                         bottomRight: Radius.circular(text_radius),
//                         bottomLeft: Radius.circular(text_radius),
//                       ),
//                     ),
//                     // 泡泡文字
//                     child: Container(child: Text('${bobble_content.text}')),
//                   ),
//                 ),
//                 // SizedBox(
//                 //   width: 5.0,
//                 // ),
//                 // //時間-已讀
//                 // Container(
//                 //   child: Column(
//                 //     crossAxisAlignment: CrossAxisAlignment.start,
//                 //     children: <Widget>[
//                 //       Container(
//                 //         height: 5,
//                 //       ),
//                 //       // Text(
//                 //       //   //時間
//                 //       //   message.sendtime == null
//                 //       //       ? ''
//                 //       //       : formatTime(message.sendtime.toLocal().hour) +
//                 //       //           ':' +
//                 //       //           formatTime(message.sendtime.toLocal().minute),
//                 //       //   style: TextStyle(
//                 //       //     color: Colors.white,
//                 //       //     fontSize: 12,
//                 //       //   ),
//                 //       // ),
//                 //       Container(
//                 //         height: 5,
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.grey,
//                       backgroundImage: NetworkImage(
//                           'http://pic.616pic.com/ys_bnew_img/00/23/07/nlWpK5lQd9.jpg'),
//                     ),
//                     Text(
//                       '//',
//                       style: TextStyle(color: Colors.transparent),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           )
//         //  對方
//         : Container(
//             margin: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 5),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.grey,
//                       backgroundImage: NetworkImage(
//                           'http://pic.616pic.com/ys_bnew_img/00/04/53/4gZ4jGaD47.jpg'),
//                     ),
//                     Text('地區')
//                   ],
//                 ),
//                 // 泡泡
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Container(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//                     constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * .6,
//                     ),
//                     //泡泡顏色
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(text_radius),
//                         topRight: Radius.circular(text_radius),
//                         bottomRight: Radius.circular(text_radius),
//                       ),
//                     ),
//                     // 泡泡文字
//                     child: Container(
//                       child: Text('${bobble_content.text}'),
//                       // child: SelectableText(
//                       //   message.text, //訊息
//                       //   style: TextStyle(
//                       //       color: Colors.white,
//                       //       fontSize: 16.0,
//                       //       fontWeight: FontWeight.w600,
//                       //       height: 1.2),
//                       //   showCursor: true,
//                       // ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5.0,
//                 ),
//                 //時間-已讀
//                 Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Container(
//                         height: 5,
//                       ),
//                       // Text(
//                       //   //時間
//                       //   message.sendtime == null
//                       //       ? ''
//                       //       : formatTime(message
//                       //               .sendtime
//                       //               .toLocal()
//                       //               .hour) +
//                       //           ':' +
//                       //           formatTime(message
//                       //               .sendtime
//                       //               .toLocal()
//                       //               .minute),
//                       //   style: TextStyle(
//                       //     color: Colors.white,
//                       //     fontSize: 12,
//                       //   ),
//                       // ),
//                       Container(
//                         height: 5,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }
