// import 'package:flutter/material.dart';
//
// import 'group/date_group.dart';
// import 'index/date_square.dart';
//
// //交友
// class DatePage extends StatefulWidget {
//   const DatePage({Key? key}) : super(key: key);
//
//   @override
//   State<DatePage> createState() => _DatePageState();
// }
//
// class _DatePageState extends State<DatePage> {
//   int _currentIndex = 2;
//   final List<Widget> _children = [
//     Container(
//       child: Text('待定'),
//     ),
//     DateGroup(),
//     DateSquare(),
//     Container(
//       child: Text('待定'),
//     ),
//     Container(
//       child: Text('待定'),
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // bottomNavigationBar: BottomNavigationBar(
//       //   currentIndex: _currentIndex,
//       //   onTap: onTabTapped,
//       //   unselectedItemColor: Colors.grey,
//       //   selectedItemColor: Colors.red,
//       //   items: [
//       //     BottomNavigationBarItem(icon: Icon(Icons.message), label: '聊天室'),
//       //     BottomNavigationBarItem(
//       //         icon: Icon(Icons.supervisor_account_sharp), label: '揪團咖'),
//       //     BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
//       //     BottomNavigationBarItem(icon: Icon(Icons.lock_clock), label: '我的動態'),
//       //     BottomNavigationBarItem(
//       //         icon: Icon(Icons.local_fire_department), label: '真心話大冒險'),
//       //   ],
//       // ),
//       body: DateGroup(),
//       // _children[_currentIndex]
//     );
//   }
//
//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
// }
