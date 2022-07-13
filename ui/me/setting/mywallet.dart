import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/me/setting/store.dart';
import 'package:provider/provider.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  @override
  void initState() {
    initdata();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initdata() {}

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
                    '我的錢包',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                  Container(
                    child: IconButton(
                      icon: Text(
                        '儲值',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FakeStore()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '目前點數',
              style: TextStyle(fontSize: 30),
            ),
            Consumer<ChatProvider>(
              builder: (context, value, child) {
                return Text(
                  '${value.remoteUserInfo[0].icoin}',
                  style: TextStyle(fontSize: 30),
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
