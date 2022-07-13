import 'package:flutter/material.dart';
import 'package:ime_new/utils/color_config.dart';

class CreateShowTime extends StatefulWidget {
  const CreateShowTime({Key? key}) : super(key: key);

  @override
  State<CreateShowTime> createState() => _CreateShowTimeState();
}

class _CreateShowTimeState extends State<CreateShowTime> {
  late TextEditingController _nicknamecontroller;
  DateTime? selectedDateTime;
  int type = 0;
  bool checkvalue = false;

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
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
                                  style: TextStyle(height: 1),
                                  keyboardType: TextInputType.multiline,

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
                                  style: TextStyle(height: 1),
                                  keyboardType: TextInputType.multiline,

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
                              '任務獎金',
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
                                  style: TextStyle(height: 1),
                                  keyboardType: TextInputType.multiline,

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
                                    Transform.scale(scale: 1.5,
                                      child: Checkbox(
                                        value: checkvalue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkvalue = value!;
                                          });
                                        },
                                        activeColor: spy_gradient_light_purple,
                                        side: BorderSide(color: Color(0xff808080)),
                                      ),
                                    ),
                                    Text(
                                      '我已閱讀並同意以上規範',
                                      style: TextStyle(
                                          color: Colors.grey,  fontSize: 20,),
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
                                    colors: [
                                      spy_gradient_light_purple,
                                      spy_gradient_light_blue,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                '開始直播',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
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
