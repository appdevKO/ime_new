import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:provider/provider.dart';

class CreateMission extends StatefulWidget {
  const CreateMission({Key? key}) : super(key: key);

  @override
  State<CreateMission> createState() => _CreateMissionState();
}

class _CreateMissionState extends State<CreateMission> {
  bool checkvalue = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 56,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: colorlist[0])),
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
                        '建立新任務',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.transparent,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                    '此帳號是${Provider.of<ChatProvider>(context, listen: false).remoteUserInfo[0].role}'),
                Text('1=玩家 2=直播主'),
                Text('發起內容'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Color(0xffBEBEBE)),
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xffBEBEBE),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                  ),
                ),
                Text('發起時間'),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime:
                                    DateTime.now().add(Duration(days: 365)),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.tw);
                          },
                          child: Text('選擇日期'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              DatePicker.showTimePicker(context,
                                  showTitleActions: true,
                                  showSecondsColumn: false, onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                setState(() {});
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.tw);
                            },
                            child: Text('選擇時間'),
                          ),
                        ),
                      ],
                    )),
                Text('終止時間'),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime:
                                    DateTime.now().add(Duration(days: 365)),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.tw);
                          },
                          child: Text('選擇日期'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              DatePicker.showTimePicker(context,
                                  showTitleActions: true,
                                  showSecondsColumn: false, onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                setState(() {});
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.tw);
                            },
                            child: Text('選擇時間'),
                          ),
                        ),
                      ],
                    )),
                Row(
                  children: [
                    Text('發起任務獎金'),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xffBEBEBE)),
                              borderRadius: BorderRadius.circular(5)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xffBEBEBE),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.monetization_on_sharp,
                      color: Colors.amber,
                    )
                  ],
                ),
                Text('發起的任務需經過平台的審核，如審核通過，系統將會通知並可以到任務欄查詢'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: checkvalue,
                        onChanged: (value) {
                          setState(() {
                            checkvalue = value!;
                          });
                        },
                        activeColor: Colors.red),
                    Text(
                      '我已了解規範並同意遵守',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(115, 40),
                          primary: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: Text('發起任務'),
                    ),
                    Container(),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }
}
