import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/me/upgrade_vip.dart';
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
                              value.little_profile_pic = value
                                  .remoteUserInfo[0].little_profilepic_list;
                              value.profile_pic =
                                  value.remoteUserInfo[0].profilepic_list;
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
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .55,
                        padding: EdgeInsets.all(15),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20.0, mainAxisSpacing: 20.0,
                            childAspectRatio: 1, //子元素在横轴长度和主轴长度的比例
                          ),
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cubecolor,
                                      borderRadius: BorderRadius.circular(10),
                                      image: value.little_profile_pic.isEmpty ||
                                              value.little_profile_pic[index] ==
                                                  ''
                                          ? null
                                          : DecorationImage(
                                              image: NetworkImage(value
                                                  .little_profile_pic[index]),
                                              fit: BoxFit.cover),
                                    ),
                                    child: Center(
                                      child: value.waitinglist[index] == false
                                          ? Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            )
                                          : CircularProgressIndicator(),
                                    ),
                                  ),
                                  onTap: () {
                                    showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        ),
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 200,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      children: [
                                                        GestureDetector(
                                                          child: Container(
                                                            color: Colors
                                                                .transparent,
                                                            height: 50,
                                                            child: Center(
                                                                child: Text(
                                                                    '打開相機')),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            value
                                                                .upload_pic_camera(
                                                                    index);
                                                          },
                                                        ),
                                                        Container(
                                                          height: 1,
                                                          color: Colors.grey,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                        GestureDetector(
                                                          child: Container(
                                                            color: Colors
                                                                .transparent,
                                                            height: 50,
                                                            child: Center(
                                                                child: Text(
                                                                    '從相簿裡選擇')),
                                                          ),
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            value.upload_pic(
                                                                index);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: GestureDetector(
                                                      child: Container(
                                                        height: 50,
                                                        child: Center(
                                                            child: Text('取消')),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffffbbbb),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ],
                            );
                          },
                          itemCount: 9,
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top:
                            (MediaQuery.of(context).size.height * .55 - 20) / 3,
                        child: Container(
                          // 寬度-兩個空-padding/3*2+中間空
                          height:
                              (MediaQuery.of(context).size.width - 40 - 30) /
                                      3 *
                                      2 +
                                  20,
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
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => UpGradeVIP()));
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 15.0, vertical: 20),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           // 1
                  //           GestureDetector(
                  //             child: Container(
                  //               height: 100,
                  //               width: 100,
                  //               decoration: BoxDecoration(
                  //                 color: cubecolor,
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 image: value.little_profile_pic.isEmpty ||
                  //                         value.little_profile_pic[0] == ''
                  //                     ? null
                  //                     : DecorationImage(
                  //                         image: NetworkImage(
                  //                             value.little_profile_pic[0]),
                  //                         fit: BoxFit.cover),
                  //               ),
                  //               child: Center(
                  //                 child: value.waitinglist[0] == false
                  //                     ? Icon(
                  //                         Icons.add,
                  //                         color: Colors.white,
                  //                       )
                  //                     : CircularProgressIndicator(),
                  //               ),
                  //             ),
                  //             onTap: () {
                  //               showModalBottomSheet<void>(
                  //                   isScrollControlled: true,
                  //                   context: context,
                  //                   backgroundColor: Colors.transparent,
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20)),
                  //                   ),
                  //                   builder: (BuildContext context) {
                  //                     return Container(
                  //                       height: 200,
                  //                       width:
                  //                           MediaQuery.of(context).size.width,
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.symmetric(
                  //                             horizontal: 15),
                  //                         child: Column(
                  //                           mainAxisAlignment:
                  //                               MainAxisAlignment.start,
                  //                           children: [
                  //                             Container(
                  //                               decoration: BoxDecoration(
                  //                                   color: Colors.white,
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                           10)),
                  //                               child: Column(
                  //                                 children: [
                  //                                   GestureDetector(
                  //                                     child: Container(
                  //                                       color:
                  //                                           Colors.transparent,
                  //                                       height: 50,
                  //                                       child: Center(
                  //                                           child:
                  //                                               Text('打開相機')),
                  //                                     ),
                  //                                     onTap: () {
                  //                                       Navigator.pop(context);
                  //                                       value.upload_pic_camera(
                  //                                           0);
                  //                                     },
                  //                                   ),
                  //                                   Container(
                  //                                     height: 1,
                  //                                     color: Colors.grey,
                  //                                     width:
                  //                                         MediaQuery.of(context)
                  //                                             .size
                  //                                             .width,
                  //                                   ),
                  //                                   GestureDetector(
                  //                                     child: Container(
                  //                                       color:
                  //                                           Colors.transparent,
                  //                                       height: 50,
                  //                                       child: Center(
                  //                                           child:
                  //                                               Text('從相簿裡選擇')),
                  //                                     ),
                  //                                     onTap: () {
                  //                                       Navigator.pop(context);
                  //                                       value.upload_pic(0);
                  //                                     },
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                             Padding(
                  //                               padding:
                  //                                   EdgeInsets.only(top: 10),
                  //                               child: GestureDetector(
                  //                                 child: Container(
                  //                                   height: 50,
                  //                                   child: Center(
                  //                                       child: Text('取消')),
                  //                                   decoration: BoxDecoration(
                  //                                     color: Color(0xffffbbbb),
                  //                                     borderRadius:
                  //                                         BorderRadius.circular(
                  //                                             10),
                  //                                   ),
                  //                                 ),
                  //                                 onTap: () {
                  //                                   Navigator.pop(context);
                  //                                 },
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     );
                  //                   });
                  //               // value.upload_pic(0);
                  //             },
                  //           ),
                  //           // 2
                  //           GestureDetector(
                  //             child: Container(
                  //               height: 100,
                  //               width: 100,
                  //               decoration: BoxDecoration(
                  //                 color: cubecolor,
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 image: value.little_profile_pic.isEmpty ||
                  //                         value.little_profile_pic[1] == ''
                  //                     ? null
                  //                     : DecorationImage(
                  //                         image: NetworkImage(
                  //                             value.little_profile_pic[1]),
                  //                         fit: BoxFit.cover),
                  //               ),
                  //               child: Center(
                  //                 child: value.waitinglist[1] == false
                  //                     ? Icon(
                  //                         Icons.add,
                  //                         color: Colors.white,
                  //                       )
                  //                     : CircularProgressIndicator(),
                  //               ),
                  //             ),
                  //             onTap: () {
                  //               value.upload_pic(1);
                  //             },
                  //           ),
                  //           // 3
                  //           GestureDetector(
                  //             child: Container(
                  //               height: 100,
                  //               width: 100,
                  //               decoration: BoxDecoration(
                  //                 color: cubecolor,
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 image: value.little_profile_pic.isEmpty ||
                  //                         value.little_profile_pic[1] == ''
                  //                     ? null
                  //                     : DecorationImage(
                  //                         image: NetworkImage(
                  //                             value.little_profile_pic[2]),
                  //                         fit: BoxFit.cover),
                  //               ),
                  //               child: Center(
                  //                 child: value.waitinglist[2] == false
                  //                     ? Icon(
                  //                         Icons.add,
                  //                         color: Colors.white,
                  //                       )
                  //                     : CircularProgressIndicator(),
                  //               ),
                  //             ),
                  //             onTap: () {
                  //               value.upload_pic(2);
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //       //vip 開放的
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 8.0),
                  //         child: Stack(
                  //           children: [
                  //             Column(
                  //               children: [
                  //                 //456
                  //                 Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     GestureDetector(
                  //                       child: Container(
                  //                         height: 100,
                  //                         width: 100,
                  //                         decoration: BoxDecoration(
                  //                             color: cubecolor,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10)),
                  //                         child: Center(
                  //                           child: value.waitinglist[3] == false
                  //                               ? Icon(
                  //                                   Icons.add,
                  //                                   color: Colors.white,
                  //                                 )
                  //                               : CircularProgressIndicator(),
                  //                         ),
                  //                       ),
                  //                       onTap: () {
                  //                         value.upload_pic(3);
                  //                       },
                  //                     ),
                  //                     GestureDetector(
                  //                       child: Container(
                  //                         height: 100,
                  //                         width: 100,
                  //                         decoration: BoxDecoration(
                  //                             color: cubecolor,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10)),
                  //                         child: Center(
                  //                           child: value.waitinglist[4] == false
                  //                               ? Icon(
                  //                                   Icons.add,
                  //                                   color: Colors.white,
                  //                                 )
                  //                               : CircularProgressIndicator(),
                  //                         ),
                  //                       ),
                  //                       onTap: () {
                  //                         value.upload_pic(4);
                  //                       },
                  //                     ),
                  //                     GestureDetector(
                  //                       child: Container(
                  //                         height: 100,
                  //                         width: 100,
                  //                         decoration: BoxDecoration(
                  //                             color: cubecolor,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(10)),
                  //                         child: Center(
                  //                           child: value.waitinglist[5] == false
                  //                               ? Icon(
                  //                                   Icons.add,
                  //                                   color: Colors.white,
                  //                                 )
                  //                               : CircularProgressIndicator(),
                  //                         ),
                  //                       ),
                  //                       onTap: () {
                  //                         value.upload_pic(5);
                  //                       },
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 //789
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(top: 8.0),
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       GestureDetector(
                  //                         child: Container(
                  //                           height: 100,
                  //                           width: 100,
                  //                           decoration: BoxDecoration(
                  //                               color: cubecolor,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10)),
                  //                           child: Center(
                  //                             child: value.waitinglist[6] ==
                  //                                     false
                  //                                 ? Icon(
                  //                                     Icons.add,
                  //                                     color: Colors.white,
                  //                                   )
                  //                                 : CircularProgressIndicator(),
                  //                           ),
                  //                         ),
                  //                         onTap: () {
                  //                           value.upload_pic(6);
                  //                         },
                  //                       ),
                  //                       GestureDetector(
                  //                         child: Container(
                  //                           height: 100,
                  //                           width: 100,
                  //                           decoration: BoxDecoration(
                  //                               color: cubecolor,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10)),
                  //                           child: Center(
                  //                             child: value.waitinglist[7] ==
                  //                                     false
                  //                                 ? Icon(
                  //                                     Icons.add,
                  //                                     color: Colors.white,
                  //                                   )
                  //                                 : CircularProgressIndicator(),
                  //                           ),
                  //                         ),
                  //                         onTap: () {
                  //                           value.upload_pic(7);
                  //                         },
                  //                       ),
                  //                       GestureDetector(
                  //                         child: Container(
                  //                           height: 100,
                  //                           width: 100,
                  //                           decoration: BoxDecoration(
                  //                               color: cubecolor,
                  //                               borderRadius:
                  //                                   BorderRadius.circular(10)),
                  //                           child: Center(
                  //                             child: value.waitinglist[8] ==
                  //                                     false
                  //                                 ? Icon(
                  //                                     Icons.add,
                  //                                     color: Colors.white,
                  //                                   )
                  //                                 : CircularProgressIndicator(),
                  //                           ),
                  //                         ),
                  //                         onTap: () {
                  //                           value.upload_pic(9);
                  //                         },
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             // block
                  //             Container(
                  //               height: 208,
                  //               width: MediaQuery.of(context).size.width - 30,
                  //               decoration: BoxDecoration(
                  //                   color: Colors.black.withOpacity(.7),
                  //                   borderRadius: BorderRadius.circular(10)),
                  //               child: Center(
                  //                 child: GestureDetector(
                  //                   child: Container(
                  //                     height: 50,
                  //                     width: 260,
                  //                     decoration: BoxDecoration(
                  //                         color: Colors.red,
                  //                         borderRadius:
                  //                             BorderRadius.circular(10)),
                  //                     child: Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.center,
                  //                       children: [
                  //                         Icon(
                  //                           Icons.king_bed,
                  //                           color: Colors.yellow,
                  //                         ),
                  //                         Padding(
                  //                           padding: EdgeInsets.only(left: 20),
                  //                           child: Text(
                  //                             '升級VIP即可解鎖',
                  //                             style: TextStyle(
                  //                                 color: Colors.white,
                  //                                 fontSize: 15),
                  //                           ),
                  //                         )
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   onTap: () {
                  //                     Navigator.push(
                  //                         context,
                  //                         MaterialPageRoute(
                  //                             builder: (context) =>
                  //                                 UpGradeVIP()));
                  //                   },
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
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
          ],
        ),
      ),
    );
  }
}
