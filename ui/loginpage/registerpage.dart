import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/loginpage/waitingpage.dart';
import 'package:ime_new/ui/me/profileoption.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _nicknamecontroller;
  DateTime? selectedDateTime;
  int sex = 0;

  @override
  void initState() {
    _nicknamecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nicknamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
            child: SingleChildScrollView(
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
                              color: Colors.transparent,
                            ),
                            onPressed: () {}),
                        Center(
                            child: Text(
                          '請完整填寫資料以繼續使用IME',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 暱稱
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '暱稱',
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              width: 200,
                              child: TextField(
                                // focusNode: _focus1,
                                maxLength: 10,
                                controller: _nicknamecontroller,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Color(0xffD9B3B3)),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Color(0xffE1C4C4),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    fillColor: Colors.white,
                                    filled: true,
                                    // hintText: '暱稱',
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5)),
                              ),
                            )
                          ],
                        ),
                        // 生日
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '生日',
                                style: TextStyle(fontSize: 18),
                              ),
                              GestureDetector(
                                child: Container(
                                    width: 200,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                          width: 1, color: Color(0xffD9B3B3)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selectedDateTime == null
                                            ? '點選生日'
                                            : '${DateFormat('yyyy/MM/dd').format(selectedDateTime!)}',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    )),
                                onTap: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime.now()
                                          .subtract(Duration(days: 365 * 100)),
                                      maxTime: DateTime.now()
                                          .subtract(Duration(days: 365 * 18)),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    setState(() {
                                      selectedDateTime = date;
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.tw);
                                },
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 5.0),
                              //   child: Text(selectedDateTime == null
                              //       ? '尚無選擇日期時間'
                              //       : '${DateFormat('yyyy/MM/dd').format(selectedDateTime!)}'),
                              // ),
                            ],
                          ),
                        ),

                        // 性別
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '性別',
                                style: TextStyle(fontSize: 18),
                              ),
                              Container(
                                  width: 220,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          width: 50,
                                          margin: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 1,
                                              color: sex == 1
                                                  ? Color(0xffFF7575)
                                                  : Colors.black,
                                            ),
                                            color: sex == 1
                                                ? Color(0xffFF7575)
                                                : Colors.white,
                                          ),
                                          child: Center(
                                              child: Text(
                                            '男',
                                            style: TextStyle(
                                                color: sex == 1
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 18),
                                          )),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            sex = 1;
                                          });
                                        },
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: GestureDetector(
                                          child: Container(
                                            width: 50,
                                            margin: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                width: 1,
                                                color: sex == 2
                                                    ? Color(0xffFF7575)
                                                    : Colors.black,
                                              ),
                                              color: sex == 2
                                                  ? Color(0xffFF7575)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                                child: Text(
                                              '女',
                                              style: TextStyle(
                                                  color: sex == 2
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 18),
                                            )),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              sex = 2;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),

                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 40,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (sex == 0 ||
                                    _nicknamecontroller.text == '' ||
                                    selectedDateTime == null) {
                                  print('有東西未填寫完整');
                                } else {
                                  print('儲存個人資料');

                                  // 儲存個人資料
                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .change_simple_profile(
                                          _nicknamecontroller.text,
                                          selectedDateTime,
                                          sex)
                                      .then((value) async => value
                                          ? Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WaitingPage()),
                                              (route) => route == null)
                                          : print('儲存失敗'));
                                }
                              },
                              child: Container(
                                child: Text(
                                  '儲存',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xffFF7575))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      child: Container(
                        child: Text('測試用'),
                        color: Colors.green,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>ProfileOption()));
                      },
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              print('點一點');
              FocusScope.of(context).unfocus();
            }),
      ),
    );
  }
}
