// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ime_module/business_logic/provider/chat_provider.dart';
// import 'package:ime_module/utils/jm_config.dart';
//
// // import 'package:jmessage_flutter/jmessage_flutter.dart';
// import 'package:provider/provider.dart';
//
// class ChatDemo extends StatefulWidget {
//   const ChatDemo({Key? key}) : super(key: key);
//
//   @override
//   _ChatDemoState createState() => _ChatDemoState();
// }
//
// class _ChatDemoState extends State<ChatDemo> {
//   String _result = "展示消息";
//   String _result2 = "顯示收到的消息";
//   late TextEditingController usernameTextEC1;
//   late TextEditingController usernameTextEC2;
//
//   // late JmessageFlutter JMessage;
//
//   @override
//   void initState() {
//     usernameTextEC1 = TextEditingController();
//     usernameTextEC2 = TextEditingController();
//     // initial_JM();
//     // addListener();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     usernameTextEC1.dispose();
//     usernameTextEC2.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // JMessage = Provider.of<ChatProvider>(context, listen: false).JMessage;
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('極光demo'),
//         ),
//         body: SingleChildScrollView(
//           child: GestureDetector(
//             // behavior: HitTestBehavior.translucent,
//             onTap: () {
//               FocusScope.of(context).requestFocus(FocusNode());
//             },
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
//                     height: 50,
//                     color: Colors.grey,
//                     child:
//                         // TextField(
//                         //   controller: usernameTextEC1,
//                         //   decoration: InputDecoration(hintText: '请输入登录的 username'),
//                         // )
//                         Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('demo用username\n ${kMockUserName}'),
//                         Text('demo用password\n ${kMockPassword}'),
//                       ],
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {
//                         user_register();
//                       },
//                       child: Text('註冊'),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffffbbbb))),
//                     ),
//                     Container(
//                       width: 10,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Provider.of<ChatProvider>(context, listen: false)
//                             .user_login();
//                       },
//                       child: Text('登入'),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffaaffbb))),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {
//                         getcurrentuserinfo();
//                       },
//                       child: Text('查看用戶訊息'),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xff99ffff))),
//                     ),
//                     Container(
//                       width: 10,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         user_logout();
//                       },
//                       child: Text('登出'),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffaaaaff))),
//                     ),
//                   ],
//                 ),
//                 Consumer<ChatProvider>(
//                   builder: (context, value, child) {
//                     return Container(
//                       margin: EdgeInsets.fromLTRB(5, 5, 5, 20),
//                       color: Colors.grey,
//                       child: Text("${value.jm_result}"),
//                       width: double.infinity,
//                       constraints: BoxConstraints(minHeight: 200),
//                       //height: 300,
//                     );
//                   },
//                 ),
//                 Divider(
//                   height: 2,
//                 ),
//                 Container(
//                     margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
//                     height: 35,
//                     width: double.infinity,
//                     color: Colors.grey,
//                     child: TextField(
//                       controller: usernameTextEC2,
//                       decoration: InputDecoration(hintText: '對方的username'),
//                     )),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {
//                         sendtextmsg();
//                       },
//                       child: Text("發送文字消息"),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffaaaaff))),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text("發送圖片消息"),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xff55aaff))),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         gethistorymsg();
//                       },
//                       child: Text("獲得歷史訊息"),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffaa6aff))),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text(
//                         "发送视频消息",
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffffafff))),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text(
//                         "会话管理界面",
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffaaf29f))),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {},
//                       child: Text(
//                         "群组管理界面",
//                       ),
//                       style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Color(0xffaafaff))),
//                     ),
//                   ],
//                 ),
//                 Container(
//                     margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
//                     height: 50,
//                     width: double.infinity,
//                     color: Colors.greenAccent.withOpacity(.2),
//                     child: Text('$_result2')),
//               ],
//             ),
//           ),
//         ));
//   }
//
//   // Future initial_JM() async {
//   //   //初始
//   //   JMessage = JmessageFlutter.private(jm_channel, const LocalPlatform());
//   //   JMessage.setDebugMode(enable: true); //對外發布的時候關掉
//   //   JMessage.init(isOpenMessageRoaming: false, appkey: kMockAppkey);
//   //   JMessage.applyPushAuthority(
//   //       JMNotificationSettingsIOS(sound: true, alert: true, badge: true));
//   // }
//
//   // void addListener() async {
//   //   print('add listener receive ReceiveMessage');
//   //   //監聽 消息事件
//   //   JMessage.addReceiveMessageListener((msg) {
//   //     print('listener receive event - message ： ${msg.toJson()}');
//   //     if (msg is JMImageMessage) {
//   //       setState(() {
//   //         _result2 = '收到一條圖片  消息';
//   //       });
//   //     } else if (msg is JMTextMessage) {
//   //       setState(() {
//   //         _result2 = '收到一條 ${msg.from.username}的文字消息:${msg.text}';
//   //       });
//   //     }
//   //     /* 下载原图测试
//   //     if (msg is JMImageMessage) {
//   //       print('收到一条图片消息' + 'id='+ msg.id + ',serverMessageId='+msg.serverMessageId);
//   //       print('开始下载图片消息的原图');
//   //       jmessage.downloadOriginalImage(target: msg.from, messageId: msg.id).then((value) {
//   //         print('下载图片--回调-1');
//   //         print('图片消息，filePath = ' + value['filePath']);
//   //         print('图片消息，messageId = ' + value['messageId'].toString());
//   //         print('下载图片--回调-2');
//   //       });
//   //     }
//   //      */
//   //
//   //     setState(() {
//   //       _result = "【收到消息】${msg.toJson()}";
//   //     });
//   //   });
//   //   //監聽 點擊消息通知(android only)
//   //   JMessage.addClickMessageNotificationListener((msg) {
//   //     //+
//   //     print(
//   //         'listener receive event - click message notification ： ${msg.toJson()}');
//   //   });
//   //
//   //   // JMessage.addSyncOfflineMessageListener((conversation, msgs) {
//   //   //   print('listener receive event - sync office message ');
//   //   //
//   //   //   List<Map> list = [];
//   //   //   for (JMNormalMessage msg in msgs) {
//   //   //     print('offline msg: ${msg.toJson()}');
//   //   //     list.add(msg.toJson());
//   //   //   }
//   //   //
//   //   //   setState(() {
//   //   //     _result = "【离线消息】${list.toString()}";
//   //   //   });
//   //   // });
//   //
//   //   // JMessage.addSyncRoamingMessageListener((conversation) {
//   //   //   verifyConversation(conversation);
//   //   //   print('listener receive event - sync roaming message');
//   //   // });
//   //
//   //   //登入狀態變更 例如在別的裝置登入 就會把當前裝置登出
//   //   JMessage.addLoginStateChangedListener((JMLoginStateChangedType type) {
//   //     print('listener receive event -  login state change: $type');
//   //   });
//   //
//   //   JMessage.addContactNotifyListener((JMContactNotifyEvent event) {
//   //     print('listener receive event - contact notify ${event.toJson()}');
//   //   });
//   //
//   //   // JMessage.addMessageRetractListener((msg) {
//   //   //   print('listener receive event - message retract event');
//   //   //   print("${msg.toString()}");
//   //   //   verifyMessage(msg);
//   //   // });
//   //
//   //   // JMessage.addReceiveChatRoomMessageListener(chatRoomMsgListenerID,
//   //   //         (messageList) {
//   //   //       print('listener receive event - chat room message ');
//   //   //     });
//   //
//   //   // JMessage.addReceiveTransCommandListener((JMReceiveTransCommandEvent event) {
//   //   //   expect(event.message, isNotNull,
//   //   //       reason: 'JMReceiveTransCommandEvent.message is null');
//   //   //   expect(event.sender, isNotNull,
//   //   //       reason: 'JMReceiveTransCommandEvent.sender is null');
//   //   //   expect(event.receiver, isNotNull,
//   //   //       reason: 'JMReceiveTransCommandEvent.receiver is null');
//   //   //   expect(event.receiverType, isNotNull,
//   //   //       reason: 'JMReceiveTransCommandEvent.receiverType is null');
//   //   //   print('listener receive event - trans command');
//   //   // });
//   //
//   //   //監聽 接收到入群申請
//   //   JMessage.addReceiveApplyJoinGroupApprovalListener(
//   //       (JMReceiveApplyJoinGroupApprovalEvent event) {
//   //     print("listener receive event - apply join group approval");
//   //   });
//   //
//   //   // JMessage.addReceiveGroupAdminRejectListener(
//   //   //         (JMReceiveGroupAdminRejectEvent event) {
//   //   //       expect(event.groupId, isNotNull,
//   //   //           reason: 'JMReceiveGroupAdminRejectEvent.groupId is null');
//   //   //       verifyUser(event.groupManager);
//   //   //       expect(event.reason, isNotNull,
//   //   //           reason: 'JMReceiveGroupAdminRejectEvent.reason is null');
//   //   //       print('listener receive event - group admin rejected');
//   //   //     });
//   //
//   //   // JMessage.addReceiveGroupAdminApprovalListener(
//   //   //         (JMReceiveGroupAdminApprovalEvent event) {
//   //   //       expect(event.isAgree, isNotNull,
//   //   //           reason: 'addReceiveGroupAdminApprovalListener.isAgree is null');
//   //   //       expect(event.applyEventId, isNotNull,
//   //   //           reason: 'addReceiveGroupAdminApprovalListener.applyEventId is null');
//   //   //       expect(event.groupId, isNotNull,
//   //   //           reason: 'addReceiveGroupAdminApprovalListener.groupId is null');
//   //   //
//   //   //       expect(event.isAgree, isNotNull,
//   //   //           reason: 'addReceiveGroupAdminApprovalListener.isAgree is null');
//   //   //
//   //   //       verifyUser(event.groupAdmin);
//   //   //       for (var user in event.users!) {
//   //   //         verifyUser(user);
//   //   //       }
//   //   //       print('listener receive event - group admin approval');
//   //   //     });
//   //
//   //   // JMessage.addReceiveMessageReceiptStatusChangelistener(
//   //   //         (JMConversationInfo conversation, List<String> serverMessageIdList) {
//   //   //       print("listener receive event - message receipt status change");
//   //   //
//   //   //       //for (var serverMsgId in serverMessageIdList) {
//   //   //       //  jmessage.getMessageByServerMessageId(type: conversation.target, serverMessageId: serverMsgId);
//   //   //       //}
//   //   //     });
//   // }
//
// //設定badge值 會一起設定本地和極光server上面的
//   Future settingberge() async {
//     // await JMessage.setBadge(badge: 5);
//   }
//
//   Future user_register() async {
//     // try {
//     //   await JMessage.userRegister(
//     //       username: kMockUserName,
//     //       password: kMockPassword,
//     //       nickname: kMockNickName);
//     // } catch (e) {
//     //   if (e is PlatformException) {
//     //     demoShowMessage('註冊發生錯誤:${e.message}');
//     //   }
//     // }
//   }
//
//   Future getcurrentuserinfo() async {
//     // JMUserInfo? u = await JMessage.getMyInfo();
//     // if (u == null) {
//     //   demoShowMessage(" ===== 您还未登录账号 ===== \n【获取登录用户信息】null");
//     // } else {
//     //   demoShowMessage(" ===== 您已经登录 ===== \n【获取登录用户信息】${u.toJson()}");
//     // }
//   }
//
//   Future user_logout() async {
//     // await JMessage.logout().then((onValue) {
//     //   demoShowMessage('已退出');
//     // }, onError: (error) {
//     //   demoShowMessage('退出發生問題${error.toString()}');
//     // });
//   }
//
// //送出 文字 傳送
//   Future sendtextmsg() async {
//     if (usernameTextEC2.text.isEmpty) {
//       demoShowMessage("【发消息給对方 username 不能为空");
//     } else {
//       String targetname = usernameTextEC2.text;
//       int textIndex = DateTime.now().millisecondsSinceEpoch;
//       //type會話類型   可以是JMSingle | JMGroup | JMChatRoom
//
//       //消息配送配置參數 设置这条消息的发送是否需要对方发送已读回执，false，默认值
//       //json所有欄位要給值
//       // JMMessageSendOptions option = JMMessageSendOptions.fromJson({
//       //   'isShowNotification': false,
//       //   'isRetainOffline': false,
//       //   'isCustomNotificationEnabled': false,
//       //   'notificationTitle': '這是消息title',
//       //   'notificationText': '這是消息內文',
//       //   'needReadReceipt': true,
//       // });
//       // try {
//       //   JMTextMessage msg = await JMessage.sendTextMessage(
//       //       type: kMockUser,
//       //       text: "send msg current time: $textIndex",
//       //       sendOption: option);
//       //   demoShowMessage('傳送文字消息:${msg.text}');
//       // } catch (e) {
//       //   if (e is PlatformException) {
//       //     demoShowMessage('傳送文字消息error:${e.message}');
//       //   }
//       // }
//     }
//   }
//
//   Future sendimagemsg() async {
//     if (usernameTextEC2.text.isEmpty) {
//       demoShowMessage("【发消息給对方 username 不能为空");
//     } else {
//       String targetname = usernameTextEC2.text;
//       int textIndex = DateTime.now().millisecondsSinceEpoch;
//       //type會話類型   可以是JMSingle | JMGroup | JMChatRoom
//
//       //消息配送配置參數 设置这条消息的发送是否需要对方发送已读回执，false，默认值
//       //json所有欄位要給值
//       // JMMessageSendOptions option = JMMessageSendOptions.fromJson({
//       //   'isShowNotification': false,
//       //   'isRetainOffline': false,
//       //   'isCustomNotificationEnabled': false,
//       //   'notificationTitle': '這是消息title',
//       //   'notificationText': '這是消息內文',
//       //   'needReadReceipt': true,
//       // });
//       // try {
//       //   JMTextMessage msg = await JMessage.sendTextMessage(
//       //       type: kMockUser,
//       //       text: "send msg current time: $textIndex",
//       //       sendOption: option);
//       // } catch (e) {
//       //   if (e is PlatformException) {
//       //     demoShowMessage('傳送文字消息:${e.message}');
//       //   }
//       // }
//     }
//   }
//
//   Future gethistorymsg() async {
//     // try {
//     //   List msgs = await JMessage.getHistoryMessages(
//     //       type: kMockUser, from: 0, limit: 10);
//     //   // for(var msg in msgs){
//     //   //
//     //   // }
//     //
//     //   demoShowMessage('獲得歷史消息:${msgs}');
//     // } catch (e) {
//     //   if (e is PlatformException) {
//     //     demoShowMessage('獲得歷史消息 exception:${e.message}');
//     //   } else {}
//     // }
//   }
//
//   void demoShowMessage(String msg) {
//     setState(() {
//       _result = msg;
//     });
//   }
// }
