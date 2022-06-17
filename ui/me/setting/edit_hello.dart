import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class EditHello extends StatefulWidget {
  const EditHello({Key? key}) : super(key: key);

  @override
  _EditHelloState createState() => _EditHelloState();
}

class _EditHelloState extends State<EditHello> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    initdata();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void initdata() {
    _textEditingController = TextEditingController(
        text: Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .default_chat_text);
  }

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
                    '編輯打招呼',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        print(
                            'default_chat_text:${Provider.of<ChatProvider>(context, listen: false).remoteUserInfo[0].default_chat_text}');
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
                children: [
                  Text('請描述一段你想跟別人打招呼的開場白，每次跟新的對象聊天時會自動出現在聊天室視窗'),
                  TextField(
                    controller: _textEditingController,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<ChatProvider>(context, listen: false)
                            .change_hello(_textEditingController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        child: Text(
                          '儲存',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
