import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/date/square/upgrade_vip.dart';
import 'package:ime_new/ui/me/profilesetting2.dart';

import 'package:provider/provider.dart';

Color cubecolor = Color(0xffffbbbb);

//新增照片
class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<ChatProvider>(builder: (context, value, child) {
              return Column(
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
                              value.little_profile_pic = [];
                              value.profile_pic = [];
                              // Navigator.pop(context);
                              Get.back();
                            }),
                        Center(
                            child: Text(
                          '編輯資料-新增照片',
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 1
                            GestureDetector(
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: cubecolor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: value.little_profile_pic.isEmpty ||
                                          value.little_profile_pic[0] == ''
                                      ? null
                                      : DecorationImage(
                                          image: NetworkImage(
                                              value.little_profile_pic[0]),
                                          fit: BoxFit.cover),
                                ),
                                child: Center(
                                  child: value.waitinglist[0] == false
                                      ? Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        )
                                      : CircularProgressIndicator(),
                                ),
                              ),
                              onTap: () {
                                value.upload_pic(0);
                              },
                            ),
                            // 2
                            GestureDetector(
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: cubecolor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: value.little_profile_pic.isEmpty ||
                                          value.little_profile_pic[1] == ''
                                      ? null
                                      : DecorationImage(
                                          image: NetworkImage(
                                              value.little_profile_pic[1]),
                                          fit: BoxFit.cover),
                                ),
                                child: Center(
                                  child: value.waitinglist[1] == false
                                      ? Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        )
                                      : CircularProgressIndicator(),
                                ),
                              ),
                              onTap: () {
                                value.upload_pic(1);
                              },
                            ),
                            // 3
                            GestureDetector(
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: cubecolor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: value.little_profile_pic.isEmpty ||
                                          value.little_profile_pic[1] == ''
                                      ? null
                                      : DecorationImage(
                                          image: NetworkImage(
                                              value.little_profile_pic[2]),
                                          fit: BoxFit.cover),
                                ),
                                child: Center(
                                  child: value.waitinglist[2] == false
                                      ? Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        )
                                      : CircularProgressIndicator(),
                                ),
                              ),
                              onTap: () {
                                value.upload_pic(2);
                              },
                            ),
                          ],
                        ),
                        //vip 開放的
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  //456
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: cubecolor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: value.waitinglist[3] == false
                                                ? Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  )
                                                : CircularProgressIndicator(),
                                          ),
                                        ),
                                        onTap: () {
                                          value.upload_pic(3);
                                        },
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: cubecolor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: value.waitinglist[4] == false
                                                ? Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  )
                                                : CircularProgressIndicator(),
                                          ),
                                        ),
                                        onTap: () {
                                          value.upload_pic(4);
                                        },
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: cubecolor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: value.waitinglist[5] == false
                                                ? Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  )
                                                : CircularProgressIndicator(),
                                          ),
                                        ),
                                        onTap: () {
                                          value.upload_pic(5);
                                        },
                                      ),
                                    ],
                                  ),
                                  //789
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: cubecolor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: value.waitinglist[6] ==
                                                      false
                                                  ? Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )
                                                  : CircularProgressIndicator(),
                                            ),
                                          ),
                                          onTap: () {
                                            value.upload_pic(6);
                                          },
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: cubecolor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: value.waitinglist[7] ==
                                                      false
                                                  ? Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )
                                                  : CircularProgressIndicator(),
                                            ),
                                          ),
                                          onTap: () {
                                            value.upload_pic(7);
                                          },
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: cubecolor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                              child: value.waitinglist[8] ==
                                                      false
                                                  ? Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )
                                                  : CircularProgressIndicator(),
                                            ),
                                          ),
                                          onTap: () {
                                            value.upload_pic(9);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // block
                              Container(
                                height: 208,
                                width: MediaQuery.of(context).size.width - 30,
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.7),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: GestureDetector(
                                    child: Container(
                                      height: 50,
                                      width: 260,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.king_bed,
                                            color: Colors.yellow,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Text(
                                              '升級VIP即可解鎖',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpGradeVIP()));
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileSetting2()));
                },
                child: Container(
                  child: Text(
                    '下一步',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
              ),
            ),
            Platform.isIOS
                ? Container(
                    height: 168,
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
