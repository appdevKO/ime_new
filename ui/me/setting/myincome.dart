import 'package:flutter/material.dart';

class Myincome extends StatefulWidget {
  const Myincome({Key? key}) : super(key: key);

  @override
  State<Myincome> createState() => _MyincomeState();
}

class _MyincomeState extends State<Myincome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffFF2D2D), Color(0xffFF9797)])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Center(
                          child: Text(
                            'ime收益',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.transparent,
                          ),
                          onPressed: () {
                            // print(
                            //     'default_chat_text:${Provider.of<ChatProvider>(context, listen: false).remoteUserInfo[0].default_chat_text}');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                  child: Column(
                    children: [],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
