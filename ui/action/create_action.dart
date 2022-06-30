import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class NewAction extends StatefulWidget {
  const NewAction({Key? key}) : super(key: key);

  @override
  State<NewAction> createState() => _NewActionState();
}

class _NewActionState extends State<NewAction> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text('建立貼文'),),
        body: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: CustomScrollView(slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          color: Colors.white,
                        ),
                        GestureDetector(
                          child: Container(
                            height: 80,
                            padding: EdgeInsets.only(top: 8),
                            color: Colors.transparent,
                            child: Consumer<ChatProvider>(
                                builder: (context, value, child) {
                              return Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          '${value.remoteUserInfo[0].avatar_sub}')),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      value.remoteUserInfo[0].nickname != '' &&
                                              value.remoteUserInfo[0]
                                                      .nickname !=
                                                  null
                                          ? '${value.remoteUserInfo[0].nickname}'
                                          : '不詳',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                  )
                                ],
                              );
                            }),
                          ),
                          onTap: () {
                            print('關掉鍵盤');
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              // color: Color(0xffffbbbb),
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  hintText: '在想什麼:',
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLength: 150,
                                maxLines: null,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Consumer<ChatProvider>(
                            builder: (context, value, child) {
                              return value.action_imgpath == ''
                                  ? Container()
                                  : Container(
                                      height: 250,
                                      width: MediaQuery.of(context).size.width,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Stack(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.close,
                                                size: 24,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                value.cancelaction_img();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          image: DecorationImage(
                                              image: FileImage(File(
                                                  '${value.action_imgpath}')),
                                              fit: BoxFit.cover)),
                                    );
                            },
                          ),
                        ),
                        Container(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ])),
            //appbar
            GestureDetector(
              child: Container(
                height: 60,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //離開 出去
                      IconButton(
                          onPressed: () {
                            Provider.of<ChatProvider>(context, listen: false)
                                .cancelaction_img();
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close)),
                      Text('編輯貼文'),
                      Consumer<ChatProvider>(
                        builder: (context, value, child) {
                          return GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(7)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '發送',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Icon(Icons.send,
                                        size: 15, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              if (value.action_imgpath != '' ||
                                  _textEditingController.text != '') {
                                print('dialogdialogdialogdialogdialog');
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return AlertDialog(
                                          title: Text('動態上傳中 請稍候'),
                                          content: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator())));
                                    });
                                await value
                                    .uploadimg_action(
                                        text: _textEditingController.text)
                                    .whenComplete(() => Future.delayed(
                                            Duration(seconds: 2), () async {
                                          await value.get_new_action_list();
                                          await value.get_someone_action_list(
                                              value.remoteUserInfo[0].memberid);
                                          value.cancelaction_img();
                                          _textEditingController.clear();
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }));
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                print('關掉鍵盤');
                FocusScope.of(context).unfocus();
              },
            ),
            //底部按鈕
            Positioned(
                bottom: 0,
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.camera_alt_outlined),
                            onPressed: () {
                              Provider.of<ChatProvider>(context, listen: false)
                                  .load_action_img_camera();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.photo),
                            onPressed: () {
                              Provider.of<ChatProvider>(context, listen: false)
                                  .load_action_img();
                            },
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.keyboard_hide),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                        },
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
