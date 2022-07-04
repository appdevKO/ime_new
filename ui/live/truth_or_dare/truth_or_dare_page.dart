import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/TD_game.dart';
import 'package:ime_new/ui/live/truth_or_dare/roomListTable.dart';

import 'package:provider/provider.dart';

class TurthOrDare extends StatefulWidget {
  const TurthOrDare({Key? key}) : super(key: key);

  @override
  State<TurthOrDare> createState() => _TurthOrDareState();
}

class _TurthOrDareState extends State<TurthOrDare> {
  bool checkvalue = false;

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xfffdf0ef),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [Color(0xffff9494), Color(0xfffdf0f0)])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 70,
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                          ),
                          Text(
                            '真心話大冒險',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('遊戲規則，請仔細閱讀',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.red)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Text(
                      '1.不可以使用暴力',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '2.不可以口出穢言',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '3.不可以人身攻擊',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '4.不可以有商業行為',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '5.抽中國王的玩家會有皇冠標誌',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '6.被選到的玩家決定要選擇真心話或是大冒險(選擇大冒險請打開鏡頭)',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '7.當玩家無法回答真心話或是無法完成大冒險，將進入到懲罰階段',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      '8.由國王判斷懲罰是否完成並進入到下一輪遊戲',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
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
                      GestureDetector(
                        child: Text(
                          '同意並遵守法律相關責任',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        onTap: () {
                          setState(() {
                            checkvalue = !checkvalue;
                          });
                        },
                      )
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (checkvalue == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      roomListTable(title: '真心話大冒險')));
                        }
                      },
                      child: Text('進入遊玩'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(115, 40),
                          primary:
                              checkvalue == true ? Colors.red : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                    ),
                  ),
                  Platform.isIOS ? Container(height: 168) : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
