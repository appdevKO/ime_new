import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:provider/provider.dart';

import 'fakestream.dart';

class CreateShowTime extends StatefulWidget {
  const CreateShowTime({Key? key}) : super(key: key);

  @override
  State<CreateShowTime> createState() => _CreateShowTimeState();
}

class _CreateShowTimeState extends State<CreateShowTime> {
  late TextEditingController _titlecontroller;
  late TextEditingController _contentcontroller;
  late TextEditingController _pricecontroller;

  bool checkvalue = false;

  @override
  void initState() {
    _titlecontroller = TextEditingController();
    _contentcontroller = TextEditingController();
    _pricecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _contentcontroller.dispose();
    _pricecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('發起ShowTime'),
              backgroundColor: Color(0xff1A1A1A),
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                color: Color(0xff1A1A1A),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color(0xff336666),
                          Color(0xff9900cc),
                        ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '任務標題',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  // focusNode: _focus4,
                                  maxLength: 150,
                                  maxLines: null,
                                  style:
                                      TextStyle(height: 1, color: Colors.white),
                                  keyboardType: TextInputType.multiline,
                                  controller: _titlecontroller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff808080),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff808080),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    filled: true,
                                    hintText: '任務標題',
                                    hintStyle: TextStyle(
                                        color: Color(
                                          0xff808080,
                                        ),
                                        fontSize: 18),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '任務內容',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  // focusNode: _focus4,
                                  maxLength: 150,
                                  maxLines: null,
                                  style:
                                      TextStyle(height: 1, color: Colors.white),
                                  keyboardType: TextInputType.multiline,
                                  controller: _contentcontroller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff808080),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff808080),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    filled: true,
                                    hintText: '任務內容',
                                    hintStyle: TextStyle(
                                        color: Color(
                                          0xff808080,
                                        ),
                                        fontSize: 18),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '目標獎金',
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: TextField(
                                  // focusNode: _focus4,
                                  maxLength: 150,
                                  maxLines: null,
                                  style:
                                      TextStyle(height: 1, color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  toolbarOptions: ToolbarOptions(paste: false),
                                  controller: _pricecontroller,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff808080),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xff808080),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    filled: true,
                                    hintText: '金額',
                                    hintStyle: TextStyle(
                                        color: Color(
                                          0xff808080,
                                        ),
                                        fontSize: 18),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                '任務規範',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  '任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範任務規範',
                                  style: TextStyle(color: Color(0xff808080)),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.5,
                                      child: Checkbox(
                                        value: checkvalue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkvalue = value!;
                                          });
                                        },
                                        activeColor: spy_gradient_light_purple,
                                        side: BorderSide(
                                            color: Color(0xff808080)),
                                      ),
                                    ),
                                    Text(
                                      '我已閱讀並同意以上規範',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 20,
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _titlecontroller.text != '' &&
                                            _contentcontroller.text != '' &&
                                            _pricecontroller.text != '' &&
                                            checkvalue
                                        ? [
                                            spy_gradient_light_purple,
                                            spy_gradient_light_blue,
                                          ]
                                        : [Colors.grey, Colors.grey],
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                '開始直播',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () async {
                              if (_titlecontroller.text != '' &&
                                  _contentcontroller.text != '' &&
                                  _pricecontroller.text != '' &&
                                  checkvalue) {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) {
                                      return AlertDialog(
                                          title: Text('建立showtime 請稍候'),
                                          content: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator())));
                                    });
                                await Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .upload_spy_mission(
                                      3,
                                      _titlecontroller.text,
                                      _contentcontroller.text,
                                      int.parse(_pricecontroller.text),
                                    )
                                    .whenComplete(
                                        () => Future.delayed(
                                                Duration(seconds: 2), () async {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Provider.of<ChatProvider>(context,
                                                      listen: false)
                                                  .find_missiondetail(
                                                      _titlecontroller.text)
                                                  .whenComplete(() =>
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      FakeStream(
                                                                        TheMission:
                                                                            Provider.of<ChatProvider>(context, listen: false).mission_detail[0],
                                                                      ))));
                                            }));
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
