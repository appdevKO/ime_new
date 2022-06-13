import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';

import 'package:provider/provider.dart';

import '../../../utils/list_config.dart';

class ProfileSetting2 extends StatefulWidget {
  const ProfileSetting2({Key? key}) : super(key: key);

  @override
  _ProfileSetting2State createState() => _ProfileSetting2State();
}

class _ProfileSetting2State extends State<ProfileSetting2> {
  late TextEditingController _nicknamecontroller;
  late String constellation;
  late String bodytype;
  late String personality;
  late String profession;
  late String money;
  late String language;
  late String drink;
  late String smoke;
  late String education;
  late String area;
  late TextEditingController _agecontroller;
  late TextEditingController _heightcontroller;
  late TextEditingController _introductioncontroller;

  late TextEditingController _datecontroller;
  late TextEditingController _lookforcontroller;
  late TextEditingController _voice_introductioncontroller;

  // final FocusNode _focus1 = FocusNode();
  // final FocusNode _focus2 = FocusNode();
  // final FocusNode _focus3 = FocusNode();
  // final FocusNode _focus4 = FocusNode();
  // final FocusNode _focus5 = FocusNode();
  // final FocusNode _focus6 = FocusNode();

  @override
  void initState() {
    initdata();
    // _focus1.addListener(() {
    //   _onFocusChange(_focus1);
    // });
    // _focus2.addListener(() {
    //   _onFocusChange(_focus2);
    // });
    // _focus3.addListener(() {
    //   _onFocusChange(_focus3);
    // });
    // _focus4.addListener(() {
    //   _onFocusChange(_focus4);
    // });
    // _focus5.addListener(() {
    //   _onFocusChange(_focus5);
    // });
    // _focus6.addListener(() {
    //   _onFocusChange(_focus6);
    // });
    super.initState();
  }

  @override
  void dispose() {
    _nicknamecontroller.dispose();
    _agecontroller.dispose();
    _heightcontroller.dispose();
    _introductioncontroller.dispose();
    _datecontroller.dispose();
    _lookforcontroller.dispose();
    _voice_introductioncontroller.dispose();
    // _focus1.removeListener(() {
    //   _onFocusChange(_focus1);
    // });
    // _focus1.dispose();
    // _focus2.removeListener(() {
    //   _onFocusChange(_focus2);
    // });
    // _focus2.dispose();
    // _focus3.removeListener(() {
    //   _onFocusChange(_focus3);
    // });
    // _focus3.dispose();
    // _focus4.removeListener(() {
    //   _onFocusChange(_focus4);
    // });
    // _focus4.dispose();
    // _focus5.removeListener(() {
    //   _onFocusChange(_focus5);
    // });
    // _focus5.dispose();
    // _focus6.removeListener(() {
    //   _onFocusChange(_focus6);
    // });
    // _focus6.dispose();
    super.dispose();
  }

  void initdata() {
    _nicknamecontroller = TextEditingController(
        text: Provider.of<ChatProvider>(context, listen: false)
                .remoteUserInfo[0]
                .nickname ??
            '');
    constellation = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .constellation ??
        '';
    bodytype = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .size ??
        '';

    profession = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .profession ??
        '';
    personality = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .personality ??
        '';
    _agecontroller = TextEditingController(
        text: Provider.of<ChatProvider>(context, listen: false)
                    .remoteUserInfo[0]
                    .age !=
                null
            ? Provider.of<ChatProvider>(context, listen: false)
                .remoteUserInfo[0]
                .age
                .toString()
            : '');
    _heightcontroller = TextEditingController(
        text: Provider.of<ChatProvider>(context, listen: false)
                    .remoteUserInfo[0]
                    .height !=
                null
            ? Provider.of<ChatProvider>(context, listen: false)
                .remoteUserInfo[0]
                .height
                .toString()
            : '');
    _introductioncontroller = TextEditingController();
    // _introductioncontroller = TextEditingController(
    //     text: Provider.of<ChatProvider>(context, listen: false)
    //             .remoteUserInfo[0]
    //             .introduction ??
    //         '');

    area = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .area ??
        '';
    _datecontroller = TextEditingController(
        text: Provider.of<ChatProvider>(context, listen: false)
                .remoteUserInfo[0]
                .date ??
            '');
    money = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .money ??
        '';
    education = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .education ??
        '';
    language = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .language ??
        '';
    _lookforcontroller = TextEditingController(
        text: Provider.of<ChatProvider>(context, listen: false)
                .remoteUserInfo[0]
                .lookfor ??
            '');
    smoke = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .smoke ??
        '';
    drink = Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo[0]
            .drink ??
        '';

    _voice_introductioncontroller = TextEditingController(text: ''
        // Provider.of<ChatProvider>(context, listen: false)
        //     .remoteUserInfo[0]
        //     .voice_introduction
        );
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
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Center(
                        child: Text(
                      '編輯資料',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    borderRadius: BorderRadius.circular(15)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xffE1C4C4),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                fillColor: Colors.white,
                                filled: true,
                                // hintText: '暱稱',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5)),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '星座',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  constellation == '' ? '星座' : '$constellation',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('星座'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text(
                                                '${constellationlist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                constellation =
                                                    constellationlist[index];
                                              });
                                              print('wwwwwwww$constellation');
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: constellationlist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '年齡',
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            width: 200,
                            child: TextField(
                              // focusNode: _focus2,
                              controller: _agecontroller,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],maxLength: 2,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xffD9B3B3)),
                                      borderRadius: BorderRadius.circular(15)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xffE1C4C4),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '身高',
                            style: TextStyle(fontSize: 18),
                          ),
                          Container(
                            width: 200,
                            child: TextField(
                              controller: _heightcontroller,
                              keyboardType: TextInputType.number,inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],maxLength: 3,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0xffD9B3B3)),
                                      borderRadius: BorderRadius.circular(15)),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: Color(0xffE1C4C4),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5)),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '簡單介紹自己',
                        style: TextStyle(fontSize: 18),
                      ),
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
                          controller: _introductioncontroller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xffD9B3B3)),
                                borderRadius: BorderRadius.circular(12)),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Color(0xffE1C4C4),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '體型',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  bodytype == '' ? '體型' : '$bodytype',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('體型'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title:
                                                Text('${bodytypelist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                bodytype = bodytypelist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: bodytypelist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Text(
                              '興趣',
                              style: TextStyle(fontSize: 18),
                            ),
                            onTap: () {
                              print(
                                  '興趣長度${Provider.of<ChatProvider>(context, listen: false).interestlist.length}');
                              Provider.of<ChatProvider>(context, listen: false)
                                  .set_interest();
                            },
                          ),
                          Consumer<ChatProvider>(
                              builder: (context, value, child) {
                            return Container(
                              height: interestlist.length / 4 * 32,
                              width: MediaQuery.of(context).size.width - 100,
                              child: Wrap(
                                children: List.generate(
                                    interestlist.length,
                                    (index) => GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            child: Text(
                                              '${interestlist[index]}',
                                              style: TextStyle(
                                                  color: value.interestlist
                                                          .contains(
                                                              interestlist[
                                                                  index])
                                                      ? Colors.orange
                                                      : Colors.black),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    width: 1,
                                                    color: value.interestlist
                                                            .contains(
                                                                interestlist[
                                                                    index])
                                                        ? Colors.orange
                                                        : Colors.black)),
                                          ),
                                          onTap: () {
                                            value.add_interest(
                                                interestlist[index]);
                                          },
                                        )),
                                spacing: 10,
                                runSpacing: 5,
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '個性',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  personality == '' ? '個性' : '$personality',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('個性'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text(
                                                '${personalitylist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                personality =
                                                    personalitylist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: personalitylist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '職業',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  profession == '' ? '職業' : '$profession',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('職業'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text(
                                                '${professionlist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                profession =
                                                    professionlist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: professionlist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '居住地區',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  area == '' ? '居住地區' : '$area',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('居住地區'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text('${citylist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                area = citylist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: citylist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '我的約會安排',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            // focusNode: _focus5,
                            controller: _datecontroller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffD9B3B3)),
                                    borderRadius: BorderRadius.circular(12)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xffE1C4C4),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5)),maxLines: null,maxLength: 150,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '零用錢預算',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  money == '' ? '零用錢預算' : '$money',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('零用錢預算'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text('${moneylist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                money = moneylist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: moneylist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    //我在尋找
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '我在尋找',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            // focusNode: _focus6,
                            controller: _lookforcontroller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xffD9B3B3)),
                                    borderRadius: BorderRadius.circular(15)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color(0xffE1C4C4),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5)),maxLength: 150,maxLines: null,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '最高學歷',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  education == '' ? '學歷' : '$education',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('學歷'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title:
                                                Text('${educationlist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                education =
                                                    educationlist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: educationlist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '慣用語言',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  language == '' ? '慣用語言' : '$language',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('慣用語言'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title:
                                                Text('${languagelist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                language = languagelist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: languagelist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '吸菸習慣',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  smoke == '' ? '吸菸習慣' : '$smoke',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('吸菸習慣'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text('${smokelist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                smoke = smokelist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: smokelist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '飲酒習慣',
                            style: TextStyle(fontSize: 18),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xffE1C4C4),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  drink == '' ? '飲酒習慣' : '$drink',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('飲酒習慣'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            title: Text('${drinklist[index]}'),
                                            onTap: () {
                                              setState(() {
                                                drink = drinklist[index];
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                          itemCount: drinklist.length,
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
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
                            // if (_agecontroller.text == '' ||
                            //     _heightcontroller.text == '') {
                            // } else {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            // print('儲存 印出${Provider
                            //     .of<ChatProvider>(context, listen: false)
                            //     .profile_pic[0]}');
                            //儲存個人資料
                            Provider.of<ChatProvider>(context, listen: false)
                                .change_profile(
                              _nicknamecontroller.text == ''
                                  ? ''
                                  : _nicknamecontroller.text,
                              constellation,
                              _agecontroller.text == ''
                                  ? 0
                                  : int.parse(_agecontroller.text),
                              _heightcontroller.text == ''
                                  ? 0
                                  : int.parse(_heightcontroller.text),
                              _introductioncontroller.text,
                              bodytype,
                              personality,
                              profession,
                              area,
                              _datecontroller.text == ''
                                  ? ''
                                  : _datecontroller.text,
                              money,
                              _lookforcontroller.text == ''
                                  ? ''
                                  : _lookforcontroller.text,
                              education,
                              language,
                              smoke,
                              drink,
                              _voice_introductioncontroller.text == ''
                                  ? ''
                                  : _voice_introductioncontroller.text,
                            );
                            //存到興趣表中
                            Provider.of<ChatProvider>(context, listen: false)
                                .saveinterest();
                            await Provider.of<ChatProvider>(context,
                                    listen: false)
                                .getaccountinfo();
                          },
                          child: Container(
                            child: Text(
                              '儲存',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffFF7575))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Platform.isIOS
                  ? Container(
                      height: 168,
                    )
                  : Container(),
              // //墊鍵盤
              // Container(
              //   height: bottominsetheight,
              //   color: Colors.white,
              // )
            ],
          ),
        ),
        onTap: () {
          print('點一點');
          FocusScope.of(context).unfocus();
          // _focus1.unfocus();
          // _focus2.unfocus();
          // _focus3.unfocus();
          // _focus4.unfocus();
          // _focus5.unfocus();
          // _focus6.unfocus();
        },
      )),
    );
  }

// void _onFocusChange(node) {
//   debugPrint("Focus:111111111 ${node.hasFocus.toString()}");
//   if (node.hasFocus) {
//     print('keyboard open');
//     setState(() {
//       bottominsetheight = MediaQuery.of(context).size.height / 2;
//     });
//   } else {
//     print('keyboard close');
//     setState(() {
//       bottominsetheight = 0;
//     });
//   }
// }
}
