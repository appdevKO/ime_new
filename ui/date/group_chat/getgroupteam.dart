import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/widget/bottom_sheet.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/list_config.dart';
import '../../../utils/viewconfig.dart';
import 'chatroom2.dart';

class GetTeam extends StatefulWidget {
  const GetTeam({Key? key}) : super(key: key);

  @override
  _GetTeamState createState() => _GetTeamState();
}

class _GetTeamState extends State<GetTeam> {
  bool checkvalue = false;
  int index = 0;
  late TextEditingController _titleController;

  late TextEditingController _purposeController;

  late TextEditingController _areaController;

  late TextEditingController _noteController;

  late TextEditingController _ruleController;

  late TextEditingController _quotaController;
  late TextEditingController _filter_quotaController;
  String? dropvalue2;
  String? dropvalue;
  DateTime? selectedDateTime;

  @override
  void initState() {
    _titleController = TextEditingController();
    _purposeController = TextEditingController();
    _areaController = TextEditingController();
    _noteController = TextEditingController();
    _ruleController = TextEditingController();
    _quotaController = TextEditingController();
    _filter_quotaController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      initdata();
    });
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _purposeController.dispose();
    _areaController.dispose();
    _noteController.dispose();
    _ruleController.dispose();
    _quotaController.dispose();
    _filter_quotaController.dispose();
    super.dispose();
  }

  Future initdata() async {
    if (mounted) {
      /// 複製檢查
      if (Provider.of<ChatProvider>(context, listen: false).remoteUserInfo !=
              null &&
          Provider.of<ChatProvider>(context, listen: false)
              .remoteUserInfo
              .isNotEmpty) {
        await Provider.of<ChatProvider>(context, listen: false).getgroupteam();
      } else {
        await Provider.of<ChatProvider>(context, listen: false)
            .getaccountinfo();
        await Provider.of<ChatProvider>(context, listen: false).getgroupteam();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Groupteam(),

        ///不要刪掉
        Positioned(
          left: 10,
          bottom: 8,
          child: Row(
            children: [
              // GestureDetector(
              //   child: Container(
              //       width: 50,
              //       height: 30,
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(colors: [
              //             Color(0xffffaaaa),
              //             Color(0xffff0000)
              //           ]),
              //           borderRadius: BorderRadius.circular(15)),
              //       child: Center(child: Text('create member'))),
              //   onTap: () {
              //     Provider.of<ChatProvider>(context, listen: false)
              //         .register();
              //   },
              // ),
              // GestureDetector(
              //   child: Container(
              //       width: 50,
              //       height: 30,
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //               colors: [Colors.orange, Color(0xffffbbbb)]),
              //           borderRadius: BorderRadius.circular(15)),
              //       child: Center(child: Text('揪團數量'))),
              //   onTap: () {
              //     print(
              //         "groupteamlist ${Provider.of<ChatProvider>(context, listen: false).groupteamlist.length}"
              //         "grouppersonlist ${Provider.of<ChatProvider>(context, listen: false).grouppersonlist.length}");
              //   },
              // ),
              // GestureDetector(
              //   child: Container(
              //       width: 50,
              //       height: 30,
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //               colors: [Colors.orange, Color(0xffffbbbb)]),
              //           borderRadius: BorderRadius.circular(15)),
              //       child: Center(child: Text('刷新揪咖'))),
              //   onTap: () async {
              //     //加上await-> stream會混一起
              //     await Provider.of<ChatProvider>(context, listen: false)
              //         .getgroupteam();
              //     await Provider.of<ChatProvider>(context, listen: false)
              //         .getgroupperson();
              //   },
              // ),
              // Container(
              //   width: 15,
              // ),
              // GestureDetector(
              //   child: Container(
              //       width: 50,
              //       height: 30,
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //               colors: [Colors.green, Colors.tealAccent]),
              //           borderRadius: BorderRadius.circular(15)),
              //       child: Center(child: Text('get userinfo'))),
              //   onTap: () {
              //     print(
              //         "remoteUserInfo${Provider.of<ChatProvider>(context, listen: false).remoteUserInfo}");
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatTestPage()));
              //   },
              // ),
              // GestureDetector(
              //   child: Container(
              //       width: 50,
              //       height: 30,
              //       decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //               colors: [Colors.blue, Colors.tealAccent]),
              //           borderRadius: BorderRadius.circular(15)),
              //       child: Center(child: Text('delete all'))),
              //   onTap: () {
              //     Provider.of<ChatProvider>(context, listen: false)
              //         .deleteAllRoom();
              //   },
              // ),
            ],
          ),
        ),
        // Positioned(
        //   right: 10,
        //   bottom: 8,
        //   child: GestureDetector(
        //     child: Container(
        //       width: 135,
        //       height: 35,
        //       decoration: BoxDecoration(
        //           gradient:
        //               LinearGradient(colors: [Colors.red, Color(0xffffbbbb)]),
        //           borderRadius: BorderRadius.circular(15)),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Icon(
        //             Icons.group_add,
        //             color: Colors.white,
        //             size: 24,
        //           ),
        //           Padding(
        //             padding: const EdgeInsets.only(left: 8.0),
        //             child: Text(
        //               '我想揪團',
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w600),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     onTap: () {
        //       setState(() {
        //         index = 1;
        //       });
        //     },
        //   ),
        // ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //篩選
                Consumer<ChatProvider>(builder: (context, value, child) {
                  return GestureDetector(
                    child: Container(
                        width: 100,
                        height: 35,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.blue, Color(0xff9ebbeb)]),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          value.isgroupteam_filter == true ? '取消篩選' : '篩選',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ))),
                    onTap: () {
                      if (value.isgroupteam_filter == true) {
                        value.change_filter(1);
                        Provider.of<ChatProvider>(context, listen: false)
                            .purposelist
                            .clear();
                      } else {
                        bottomSheet(context,
                            StatefulBuilder(builder: (context2, sheetstate) {
                          return Container(
                            height: 480,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //標題
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 35,
                                        child: IconButton(
                                          icon: Icon(Icons.close,
                                              size: 30, color: Colors.red),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Text(
                                        "篩選",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            height: 1),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          width: 35,
                                          child: Text(
                                            '儲存',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        onTap: () {
                                          //儲存篩選狀態
                                          value.change_filter(1);
                                          if (value.purposelist.isNotEmpty) {
                                            value.setfilter_chatroom(1,
                                                area: dropvalue2);
                                          } else {
                                            value.setfilter_chatroom(1,
                                                area: dropvalue2);
                                          }

                                          //重新載入篩選後的結果

                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  Text('區域'),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 8),
                                      child: Container(
                                        height: 50,
                                        child: DropdownButton<String>(
                                          value: dropvalue2,
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            sheetstate(() {
                                              dropvalue2 = value;
                                            });
                                          },
                                          items: citylist
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Container(
                                                  child: Text(value),
                                                ));
                                          }).toList(),
                                          underline: Container(
                                            height: 2.0,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )),
                                  Text('目的篩選'),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 8),
                                      child: Container(
                                        height: purposelist.length / 4 * 32,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        child: Wrap(
                                          children: List.generate(
                                              purposelist.length,
                                              (index) => GestureDetector(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 4),
                                                      child: Text(
                                                        '${purposelist[index]}',
                                                        style: TextStyle(
                                                            color: value
                                                                    .purposelist
                                                                    .contains(
                                                                        purposelist[
                                                                            index])
                                                                ? Colors.orange
                                                                : Colors.black),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          border: Border.all(
                                                              width: 1,
                                                              color: value
                                                                      .purposelist
                                                                      .contains(
                                                                          purposelist[
                                                                              index])
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors
                                                                      .black)),
                                                    ),
                                                    onTap: () {
                                                      sheetstate(() {
                                                        value.add_purposelist(
                                                            purposelist[index]);
                                                      });
                                                    },
                                                  )),
                                          spacing: 10,
                                          runSpacing: 5,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }));
                      }
                    },
                  );
                }),
                //建立房間
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: GestureDetector(
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue, Color(0xff9ebbeb)]),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group_add,
                            color: Colors.white,
                            size: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '我想揪團',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Provider.of<ChatProvider>(context, listen: false)
                          .purposelist
                          .clear();
                      setState(() {
                        index = 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        index == 1
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: setup2(),
              )
            : Container()
      ],
    );
  }

  Widget setup2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: GestureDetector(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'I ME',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "揪團開設房",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('標題'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: '輸入標題',
                        ),
                        maxLength: 15,
                      ),
                    ),
                    Text('目的'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Consumer<ChatProvider>(
                          builder: (context, value, child) {
                        return Container(
                          height: purposelist.length / 4 * 32,
                          width: MediaQuery.of(context).size.width - 100,
                          child: Wrap(
                            children: List.generate(
                                purposelist.length,
                                (index) => GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        child: Text(
                                          '${purposelist[index]}',
                                          style: TextStyle(
                                              color: value.purposelist.contains(
                                                      purposelist[index])
                                                  ? Colors.orange
                                                  : Colors.black),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                width: 1,
                                                color: value.purposelist
                                                        .contains(
                                                            purposelist[index])
                                                    ? Colors.orange
                                                    : Colors.black)),
                                      ),
                                      onTap: () {
                                        value.add_purposelist(
                                            purposelist[index]);
                                      },
                                    )),
                            spacing: 10,
                            runSpacing: 5,
                          ),
                        );
                      }),
                    ),
                    Text('區域'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      child: Container(
                        height: 50,
                        child: DropdownButton<String>(
                          value: dropvalue,
                          isExpanded: true,
                          onChanged: (String? value) {
                            setState(() {
                              dropvalue = value;
                            });
                          },
                          items: citylist
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  child: Text(value),
                                ));
                          }).toList(),
                          underline: Container(
                            height: 2.0,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('日期:'),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(selectedDateTime == null
                              ? '尚無選擇日期時間'
                              : '${DateFormat('yyyy/MM/dd KK:mm a ').format(selectedDateTime!)}'),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () async {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime:
                                    DateTime.now().add(Duration(days: 365)),
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
                          child: Text('選擇日期'),
                        )),
                    Text('房主的話'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      child: TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          hintText: '輸入房主的話',
                        ),
                        maxLength: 15,
                      ),
                    ),
                    Text('房規'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      child: TextField(
                        controller: _ruleController,
                        decoration: InputDecoration(
                          hintText: '輸入房規',
                        ),
                        maxLength: 15,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8),
                        child: Row(
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
                              '同意並遵守法律相關責任',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              index = 0;
                              selectedDateTime = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(115, 40),
                              primary: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                          child: Text('取消'),
                        ),
                        Container(
                          width: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //送出 創建房間 條件
                            if (checkvalue == true &&
                                dropvalue != null &&
                                selectedDateTime != null &&
                                _titleController.text != '' &&
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .purposelist
                                    .isNotEmpty) {
                              FocusScope.of(context).unfocus();
                              Provider.of<ChatProvider>(context, listen: false)
                                  .createchatroom(
                                      _titleController.text,
                                      dropvalue,
                                      Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .remoteUserInfo[0]
                                              .avatar_sub ??
                                          '',
                                      0,
                                      _noteController.text,
                                      _ruleController.text,
                                      DateTime.now().add(Duration(hours: 8)),
                                      selectedDateTime!.add(Duration(hours: 8)))
                                  .whenComplete(() {
                                _titleController.clear();
                                _purposeController.clear();
                                _areaController.clear();
                                _noteController.clear();
                                _ruleController.clear();
                                _quotaController.clear();
                              });
                              setState(() {
                                selectedDateTime = null;
                                index = 0;
                              });

                              Provider.of<ChatProvider>(context, listen: false)
                                  .purposelist
                                  .clear();
                            } else {
                              print('沒反應');
                            }
                          },
                          child: Text('創建房間'),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(115, 40),
                              primary: checkvalue == true &&
                                      dropvalue != null &&
                                      selectedDateTime != null &&
                                      _titleController.text != '' &&
                                      Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .purposelist
                                          .isNotEmpty
                                  ? Colors.red
                                  : Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

//揪團
class Groupteam extends StatefulWidget {
  const Groupteam({Key? key}) : super(key: key);

  @override
  _GroupteamState createState() => _GroupteamState();
}

class _GroupteamState extends State<Groupteam> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 10,
        ),
        //房間列表
        Expanded(child: Consumer<ChatProvider>(
          builder: (context, value, child) {
            return value.remoteUserInfo != null
                ? value.remoteUserInfo?.isNotEmpty
                    ? value.isgroupteam_filter
                        ? value.filter_groupteamlist != null
                            ? value.filter_groupteamlist!.isNotEmpty
                                ? SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    header: WaterDropMaterialHeader(),
                                    // footer: CustomFooter(
                                    //   builder: (BuildContext context,
                                    //       LoadStatus? mode) {
                                    //     Widget body;
                                    //     if (mode == LoadStatus.idle) {
                                    //       body = Text("pull up load");
                                    //     } else if (mode == LoadStatus.loading) {
                                    //       // body = CupertinoActivityIndicator();
                                    //       body = Text("等待 旋轉");
                                    //     } else if (mode == LoadStatus.failed) {
                                    //       body =
                                    //           Text("Load Failed!Click retry!");
                                    //     } else if (mode ==
                                    //         LoadStatus.canLoading) {
                                    //       body = Text("release to load more");
                                    //     } else {
                                    //       body = Text("No more Data");
                                    //     }
                                    //     return Container(
                                    //       height: 55.0,
                                    //       child: Center(child: body),
                                    //     );
                                    //   },
                                    // ),
                                    controller: _refreshController,
                                    onRefresh: _onRefresh,
                                    onLoading: _onLoading,
                                    child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          //單一群組 設定

                                          var laseindex = value.lastmsglist
                                              ?.indexWhere((element) {
                                            return element.topicid ==
                                                value
                                                    .filter_groupteamlist![
                                                        index]
                                                    .id
                                                    .toHexString();
                                          });
                                          var newmsgindex = value.msglist
                                              ?.indexWhere((element) {
                                            return element.topicid ==
                                                value
                                                    .filter_groupteamlist![
                                                        index]
                                                    .id
                                                    .toHexString();
                                          });
                                          return GestureDetector(
                                            child: Container(
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 3,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              backgroundImage: NetworkImage(value
                                                                              .filter_groupteamlist![
                                                                                  index]
                                                                              .imgurl !=
                                                                          '' &&
                                                                      value.filter_groupteamlist![index]
                                                                              .imgurl !=
                                                                          ''
                                                                  ? ''
                                                                  : default_roomimg),
                                                            ),
                                                            Text(
                                                                '${value.filter_groupteamlist![index].area}')
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 160,
                                                                child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  strutStyle:
                                                                      StrutStyle(
                                                                          fontSize:
                                                                              12.0),
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            16,
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black),
                                                                    text:
                                                                        '標題:${value.filter_groupteamlist![index].title}',
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            3.0),
                                                                child:
                                                                    Container(
                                                                  width: 160,
                                                                  child:
                                                                      RichText(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    strutStyle: StrutStyle(
                                                                        fontSize:
                                                                            12.0),
                                                                    text:
                                                                        TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          height:
                                                                              1,
                                                                          color:
                                                                              Colors.black),
                                                                      text:
                                                                          '目的:${value.filter_groupteamlist![index].purpose}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            3.0),
                                                                child: laseindex !=
                                                                        -1
                                                                    ? Container(
                                                                        width:
                                                                            180,
                                                                        child:
                                                                            RichText(
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          strutStyle:
                                                                              StrutStyle(fontSize: 12.0),
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                TextStyle(color: Colors.grey, height: 1),
                                                                            text: value.lastmsglist?[laseindex!].type == 1
                                                                                ? '${value.lastmsglist?[laseindex!].nickname} 說: ${value.lastmsglist?[laseindex!].text}'
                                                                                : value.lastmsglist?[laseindex!].type == 2
                                                                                    ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個圖片'
                                                                                    : value.lastmsglist?[laseindex!].type == 3
                                                                                        ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個貼圖'
                                                                                        : value.lastmsglist?[laseindex!].type == 4
                                                                                            ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個錄音'
                                                                                            : value.lastmsglist?[laseindex!].type == 5
                                                                                                ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個影片'
                                                                                                //6
                                                                                                : '聊天室收到通知',
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: value.remoteUserInfo[0].chatroomId == null
                                                                      ? Color(0xff9f9f9f)
                                                                      : value.remoteUserInfo[0].chatroomId.indexWhere((element) => element == value.filter_groupteamlist![index].id) != -1
                                                                          ? Color(0xff3b9fff)
                                                                          : Color(0xff9f9f9f),
                                                                  borderRadius: BorderRadius.circular(10)),
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              child: Center(
                                                                child: Text(value
                                                                            .remoteUserInfo[
                                                                                0]
                                                                            .chatroomId ==
                                                                        null
                                                                    ? '未加入'
                                                                    : value.remoteUserInfo[0].chatroomId.indexWhere((element) =>
                                                                                element ==
                                                                                value.filter_groupteamlist![index].id) !=
                                                                            -1
                                                                        ? '已加入'
                                                                        : '未加入'),
                                                              ),
                                                            ),
                                                            Text(value
                                                                        .filter_groupteamlist![
                                                                            index]
                                                                        .datetime !=
                                                                    null
                                                                ? '${DateFormat('yyyy/MM/dd').format(value.filter_groupteamlist![index].datetime)}'
                                                                : '無')
                                                          ],
                                                        ),
                                                        //新消息紅點
                                                        CircleAvatar(
                                                          backgroundColor: newmsgindex !=
                                                                  -1
                                                              ? value
                                                                      .msglist![
                                                                          newmsgindex!]
                                                                      .msg!
                                                                      .isNotEmpty
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .transparent
                                                              : Colors
                                                                  .transparent,
                                                          radius: 5,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              //進入聊天室
                                              Provider.of<ChatProvider>(context,
                                                      listen: false)
                                                  .addchatroom(value
                                                      .filter_groupteamlist![
                                                          index]
                                                      .id);
                                              if (value.remoteUserInfo[0]
                                                      .chatroomId ==
                                                  null) {
                                                //沒加入過
                                                // 通知聊天室內的 新加入
                                                value.notify_chatroom_member_enter(
                                                    value
                                                        .filter_groupteamlist![
                                                            index]
                                                        .id,
                                                    value.remoteUserInfo[0]
                                                        .nickname);
                                              } else if (value.remoteUserInfo[0]
                                                      .chatroomId
                                                      .indexWhere((element) =>
                                                          element ==
                                                          value
                                                              .filter_groupteamlist![
                                                                  index]
                                                              .id) ==
                                                  -1) {
                                                //沒加入過
                                                // 通知聊天室內的 新加入
                                                value.notify_chatroom_member_enter(
                                                    value
                                                        .filter_groupteamlist![
                                                            index]
                                                        .id,
                                                    value.remoteUserInfo[0]
                                                        .nickname);
                                              }
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              GroupChatRoom2(
                                                                chatroomid: value
                                                                    .filter_groupteamlist![
                                                                        index]
                                                                    .id,
                                                                title: value
                                                                    .filter_groupteamlist![
                                                                        index]
                                                                    .title,
                                                                chattype: 1,
                                                                own: value.filter_groupteamlist![index]
                                                                            .ownerId !=
                                                                        value.account_id
                                                                    ? false
                                                                    : true,
                                                              )));
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Container(
                                            height: 10,
                                          );
                                        },
                                        itemCount:
                                            value.filter_groupteamlist!.length))
                                : Container(
                                    child: Text('目前符合條件的揪團群組'),
                                  )
                            : Container(
                                child: Text('揪團群組加載中'),
                              )
                        : value.groupteamlist != null
                            ? value.groupteamlist!.isNotEmpty
                                ? SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    header: WaterDropMaterialHeader(),
                                    // footer: CustomFooter(
                                    //   builder: (BuildContext context,
                                    //       LoadStatus? mode) {
                                    //     Widget body;
                                    //     if (mode == LoadStatus.idle) {
                                    //       body = Text("pull up load");
                                    //     } else if (mode == LoadStatus.loading) {
                                    //       // body = CupertinoActivityIndicator();
                                    //       body = Text("等待 旋轉");
                                    //     } else if (mode == LoadStatus.failed) {
                                    //       body =
                                    //           Text("Load Failed!Click retry!");
                                    //     } else if (mode ==
                                    //         LoadStatus.canLoading) {
                                    //       body = Text("release to load more");
                                    //     } else {
                                    //       body = Text("No more Data");
                                    //     }
                                    //     return Container(
                                    //       height: 55.0,
                                    //       child: Center(child: body),
                                    //     );
                                    //   },
                                    // ),
                                    controller: _refreshController,
                                    onRefresh: _onRefresh,
                                    onLoading: _onLoading,
                                    child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          var laseindex = value.lastmsglist
                                              ?.indexWhere((element) {
                                            return element.topicid ==
                                                value.groupteamlist![index].id
                                                    .toHexString();
                                          });
                                          var newmsgindex = value.msglist
                                              ?.indexWhere((element) {
                                            return element.topicid ==
                                                value.groupteamlist![index].id
                                                    .toHexString();
                                          });
                                          //單一群組 設定
                                          return GestureDetector(
                                            child: Container(
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 1,
                                                    blurRadius: 3,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              backgroundImage: NetworkImage(value
                                                                              .groupteamlist![
                                                                                  index]
                                                                              .imgurl !=
                                                                          null &&
                                                                      value.groupteamlist![index].imgurl !=
                                                                          ''
                                                                  ? value
                                                                      .groupteamlist![
                                                                          index]
                                                                      .imgurl
                                                                  : default_roomimg),
                                                            ),
                                                            Text(
                                                                '${value.groupteamlist![index].area}')
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: 160,
                                                                child: RichText(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  strutStyle:
                                                                      StrutStyle(
                                                                          fontSize:
                                                                              12.0),
                                                                  text:
                                                                      TextSpan(
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            16,
                                                                        height:
                                                                            1,
                                                                        color: Colors
                                                                            .black),
                                                                    text:
                                                                        '標題:${value.groupteamlist![index].title}',
                                                                  ),
                                                                ),
                                                              ),

                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            3.0),
                                                                child:
                                                                    Container(
                                                                  width: 160,
                                                                  child:
                                                                      RichText(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    strutStyle: StrutStyle(
                                                                        fontSize:
                                                                            12.0),
                                                                    text:
                                                                        TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          height:
                                                                              1,
                                                                          color:
                                                                              Colors.black),
                                                                      text:
                                                                          '目的:${value.groupteamlist![index].purpose}',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              //最後 最新 對話
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            3.0),
                                                                child: laseindex !=
                                                                        -1
                                                                    ? Container(
                                                                        width:
                                                                            180,
                                                                        child:
                                                                            RichText(
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          strutStyle:
                                                                              StrutStyle(fontSize: 12.0),
                                                                          text:
                                                                              TextSpan(
                                                                            style:
                                                                                TextStyle(color: Colors.grey, height: 1),
                                                                            text: value.lastmsglist?[laseindex!].type == 1
                                                                                ? '${value.lastmsglist?[laseindex!].nickname} 說: ${value.lastmsglist?[laseindex!].text}'
                                                                                : value.lastmsglist?[laseindex!].type == 2
                                                                                    ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個圖片'
                                                                                    : value.lastmsglist?[laseindex!].type == 3
                                                                                        ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個貼圖'
                                                                                        : value.lastmsglist?[laseindex!].type == 4
                                                                                            ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個錄音'
                                                                                            : value.lastmsglist?[laseindex!].type == 5
                                                                                                ? '${value.lastmsglist?[laseindex!].nickname} 傳送了一個影片'
                                                                                                //6
                                                                                                : '聊天室收到通知',
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: value.remoteUserInfo[0].chatroomId == null
                                                                      ? Color(0xff9f9f9f)
                                                                      : value.remoteUserInfo[0].chatroomId.indexWhere((element) => element == value.groupteamlist![index].id) != -1
                                                                          ? Color(0xff3b9fff)
                                                                          : Color(0xff9f9f9f),
                                                                  borderRadius: BorderRadius.circular(10)),
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              child: Center(
                                                                child: Text(value
                                                                            .remoteUserInfo[
                                                                                0]
                                                                            .chatroomId ==
                                                                        null
                                                                    ? '未加入'
                                                                    : value.remoteUserInfo[0].chatroomId.indexWhere((element) =>
                                                                                element ==
                                                                                value.groupteamlist![index].id) !=
                                                                            -1
                                                                        ? '已加入'
                                                                        : '未加入'),
                                                              ),
                                                            ),
                                                            Text(value
                                                                        .groupteamlist![
                                                                            index]
                                                                        .datetime !=
                                                                    null
                                                                ? '${DateFormat('yyyy/MM/dd').format(value.groupteamlist![index].datetime)}'
                                                                : '無')
                                                          ],
                                                        ),
                                                        //新消息紅點
                                                        CircleAvatar(
                                                          backgroundColor: newmsgindex !=
                                                                  -1
                                                              ? value
                                                                      .msglist![
                                                                          newmsgindex!]
                                                                      .msg!
                                                                      .isNotEmpty
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .transparent
                                                              : Colors
                                                                  .transparent,
                                                          radius: 5,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              //進入聊天室
                                              Provider.of<ChatProvider>(context,
                                                      listen: false)
                                                  .addchatroom(value
                                                      .groupteamlist![index]
                                                      .id);
                                              if (value.remoteUserInfo[0]
                                                      .chatroomId ==
                                                  null) {
                                                value
                                                    .notify_chatroom_member_enter(
                                                        value
                                                            .groupteamlist![
                                                                index]
                                                            .id,
                                                        value.remoteUserInfo[0]
                                                            .nickname);
                                              } else if (value.remoteUserInfo[0]
                                                      .chatroomId
                                                      .indexWhere((element) =>
                                                          element ==
                                                          value
                                                              .groupteamlist![
                                                                  index]
                                                              .id) ==
                                                  -1) {
                                                print('資料庫中沒有訂閱過');
                                                //沒加入過
                                                // 通知聊天室內的 新加入
                                                value
                                                    .notify_chatroom_member_enter(
                                                        value
                                                            .groupteamlist![
                                                                index]
                                                            .id,
                                                        value.remoteUserInfo[0]
                                                            .nickname);
                                              } else {
                                                print('訂閱過');
                                              }
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              GroupChatRoom2(
                                                                chatroomid: value
                                                                    .groupteamlist![
                                                                        index]
                                                                    .id,
                                                                title: value
                                                                    .groupteamlist![
                                                                        index]
                                                                    .title,
                                                                chattype: 1,
                                                                own: value.groupteamlist![index]
                                                                            .ownerId !=
                                                                        value.account_id
                                                                    ? false
                                                                    : true,
                                                              )));
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Container(
                                            height: 10,
                                          );
                                        },
                                        itemCount: value.groupteamlist!.length))
                                : Container(
                                    child: Text('目前沒有揪團群組'),
                                  )
                            : Container(
                                child: Text('揪團群組加載中'),
                              )
                    : Container(
                        child: Center(
                          child: Text('獲取使用者資料失敗1'),
                        ),
                      )
                : Container(
                    child: Center(
                      child: Text('獲取使用者資料失敗2'),
                    ),
                  );
          },
        )),
        Container(
          height: 10,
        ),
        Platform.isIOS
            ? Container(
                height: 168,
              )
            : Container()
      ],
    );
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    await Provider.of<ChatProvider>(context, listen: false).getgroupteam();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();

    Provider.of<ChatProvider>(context, listen: false).grouppage_plus(1);
    await Provider.of<ChatProvider>(context, listen: false)
        .addpage_getgroupteam();
  }
}
