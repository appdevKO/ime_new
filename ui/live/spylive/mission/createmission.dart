import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateMission extends StatefulWidget {
  const CreateMission({Key? key}) : super(key: key);

  @override
  State<CreateMission> createState() => _CreateMissionState();
}

class _CreateMissionState extends State<CreateMission> {
  late TextEditingController _titlecontroller;
  late TextEditingController _contentcontroller;
  late TextEditingController _pricecontroller;

  DateTime? startDateTime;
  DateTime? endDateTime;
  int type = 0;
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
              title: Text('發起Mission'),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color(
                                            0xff808080,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: startDateTime == null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '開始日期',
                                                style: TextStyle(
                                                  color: Color(
                                                    0xff808080,
                                                  ),
                                                ),
                                              ),
                                              Icon(
                                                Icons.date_range,
                                                color: Color(
                                                  0xff808080,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text(
                                              '${DateFormat('yyyy/MM/dd').format(startDateTime!)}',
                                              style: TextStyle(
                                                color: Color(
                                                  0xff808080,
                                                ),
                                              ),
                                            ),
                                        ),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now()
                                            .add(Duration(days: 365)),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      setState(() {
                                        startDateTime = date;
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.tw);
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Color(
                                            0xff808080,
                                          ),
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: endDateTime == null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '結束日期',
                                                style: TextStyle(
                                                  color: Color(
                                                    0xff808080,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Icon(
                                                  Icons.date_range,
                                                  color: Color(
                                                    0xff808080,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4),
                                          child: Text(
                                              '${DateFormat('yyyy/MM/dd').format(endDateTime!)}',
                                              style: TextStyle(
                                                color: Color(
                                                  0xff808080,
                                                ),
                                              ),
                                            ),
                                        ),
                                  ),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime.now()
                                            .add(Duration(days: 365)),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      setState(() {
                                        endDateTime = date;
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.tw);
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: type == 1
                                                ? [
                                                    Color(0xffcb27f7),
                                                    Color(0xff24d7f7),
                                                  ]
                                                : [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                  ],
                                          ),
                                          border: Border.all(
                                              width: type == 1 ? 0 : 1,
                                              color: Color(0xff808080)),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              Icons.person,
                                              color: type == 1
                                                  ? Colors.white
                                                  : Color(0xff808080),
                                            ),
                                          ),
                                          Text(
                                            '獨樂樂-私人觀看',
                                            style: TextStyle(
                                              color: type == 1
                                                  ? Colors.white
                                                  : Color(0xff808080),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        type = 1;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: type == 2
                                                ? [
                                                    Color(0xffcb27f7),
                                                    Color(0xff24d7f7),
                                                  ]
                                                : [
                                                    Colors.transparent,
                                                    Colors.transparent,
                                                  ],
                                          ),
                                          border: Border.all(
                                              width: type == 2 ? 0 : 1,
                                              color: Color(0xff808080)),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              Icons.group,
                                              color: type == 2
                                                  ? Colors.white
                                                  : Color(0xff808080),
                                            ),
                                          ),
                                          Text(
                                            '眾樂樂-公開觀看',
                                            style: TextStyle(
                                              color: type == 2
                                                  ? Colors.white
                                                  : Color(0xff808080),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        type = 2;
                                      });
                                    },
                                  ),
                                ],
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
                                            startDateTime != null &&
                                            endDateTime != null &&
                                            type != 0 &&
                                            checkvalue
                                        ? [
                                            spy_gradient_light_purple,
                                            spy_gradient_light_blue,
                                          ]
                                        : [Colors.grey, Colors.grey],
                                  ),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                '發起任務',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) {
                                    return AlertDialog(
                                        title: Text('任務上傳中 請稍候'),
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
                                    type,
                                    _titlecontroller.text,
                                    _contentcontroller.text,
                                    _pricecontroller.text,
                                    starttime: startDateTime,
                                    endtime: endDateTime,
                                  )
                                  .whenComplete(() => Future.delayed(
                                          Duration(seconds: 2), () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }));
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
