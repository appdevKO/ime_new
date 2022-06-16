import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/loginpage/registerpage.dart';
import 'package:provider/provider.dart';

import '../indexpage2.dart';

class WaitingPage extends StatefulWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {
    // mqtt
    Provider.of<ChatProvider>(context, listen: false).mqtt_connect();
    Provider.of<ChatProvider>(context, listen: false).initialGCP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Provider.of<ChatProvider>(context, listen: false)
              .pre_Subscribed(),
          builder: (context, snapshot) {
            print("snapshot: $snapshot");
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == false) {
                Future.delayed(Duration.zero, () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                      (route) => route == null);
                });
              } else {
                print('成功要到資料');
                Future.delayed(Duration.zero, () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => IndexPage2()),
                      (route) => route == null);
                });
              }
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('獲取資料中請稍候'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
