import 'package:flutter/material.dart';

class ChatTestPage extends StatefulWidget {
  const ChatTestPage({Key? key}) : super(key: key);

  @override
  _ChatTestPageState createState() => _ChatTestPageState();
}

class _ChatTestPageState extends State<ChatTestPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: Container(
              height: 44, decoration: BoxDecoration(color: Colors.blue)),
        ),
        body: Container(
          color: Color(0xffffbbbb),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: 60,
                ),
                Text('wwwwww'),
                TextField(),
                Container(
                  height: 100,
                  color: Colors.blue,
                ),
                Container(
                  height: 100,
                  color: Colors.yellow,
                ),
                Container(
                  height: 100,
                  color: Colors.blue,
                ),
                Container(
                  height: 100,
                  color: Colors.yellow,
                ),
                TextField(),
                CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: 60,
                ),
                Text('wwwwww'),
                TextField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
