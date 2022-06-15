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

class GetPerson extends StatefulWidget {
  const GetPerson({Key? key}) : super(key: key);

  @override
  _GetPersonState createState() => _GetPersonState();
}

class _GetPersonState extends State<GetPerson> {
  bool checkvalue = false;
  int index = 0;
  late TextEditingController _titleController;

  late TextEditingController _purposeController;

  late TextEditingController _areaController;

  late TextEditingController _noteController;

  late TextEditingController _ruleController;

  // late TextEditingController _quotaController;
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
    // _quotaController = TextEditingController();
    // _filter_quotaController = TextEditingController();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      initdata();
    });
    super.initState();
  }

  Future initdata() async {
    if (Provider.of<ChatProvider>(context, listen: false).remoteUserInfo !=
            null &&
        Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo
            .isNotEmpty) {
      await Provider.of<ChatProvider>(context, listen: false).getgroupperson();
    } else {
      await Provider.of<ChatProvider>(context, listen: false).getaccountinfo();
      await Provider.of<ChatProvider>(context, listen: false).getgroupperson();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _purposeController.dispose();
    _areaController.dispose();
    _noteController.dispose();
    _ruleController.dispose();
    // _quotaController.dispose();
    // _filter_quotaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('get group person build ');
    return Stack(children: [
      GroupPerson(),
      Positioned(
        bottom: 8,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Consumer<ChatProvider>(builder: (context, value, child) {
                return GestureDetector(
                  child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.red, Color(0xffffbbbb)]),
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text(
                        value.isgroupperson_filter == true ? '取消篩選' : '篩選',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ))),
                  onTap: () {
                    if (value.isgroupperson_filter == true) {
                      //取消篩選
                      value.change_filter(2);
                      Provider.of<ChatProvider>(context, listen: false)
                          .purposelist
                          .clear();
                    } else {
                      //打開篩選
                      bottomSheet(context,
                          StatefulBuilder(builder: (context2, sheetstate) {
                        return Container(
                          height: 480,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                                        value.change_filter(2);
                                        value.setfilter_chatroom(2,
                                            area: dropvalue2);
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
                                      width: MediaQuery.of(context).size.width -
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
                                                                ? Colors.orange
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
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: GestureDetector(
                  child: Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.red, Color(0xffffbbbb)]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group_add,
                          color: Colors.white,
                          size: 24,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '我想約會',
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
                      index = 2;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      index == 2
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: setup2(),
            )
          //顯示聊天室列表
          : Container()
    ]);
  }

  //創建房間
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
                '約會開設房',
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
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text('人數限定'),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 5, vertical: 8),
                    //       child: TextField(
                    //           controller: _quotaController,
                    //           keyboardType: TextInputType.number,
                    //           decoration: InputDecoration(
                    //             hintText: '輸入人數',
                    //           )),
                    //     ),
                    //   ],
                    // ),
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
                          maxLength: 15),
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
                                      1,
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
                                // _quotaController.clear();
                              });
                              setState(() {
                                index = 0;
                                selectedDateTime = null;
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

//揪咖
class GroupPerson extends StatefulWidget {
  const GroupPerson({Key? key}) : super(key: key);

  @override
  _GroupPersonState createState() => _GroupPersonState();
}

class _GroupPersonState extends State<GroupPerson> {
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
                    ? value.isgroupperson_filter
                        ? value.filter_grouppersonlist != null
                            ? !value.filter_grouppersonlist!.isEmpty
                                ? SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    header: WaterDropMaterialHeader(
                                        backgroundColor: Color(0xffffbbbb)),
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
                                                    .filter_grouppersonlist![
                                                        index]
                                                    .id
                                                    .toHexString();
                                          });
                                          var newmsgindex = value.msglist
                                              ?.indexWhere((element) {
                                            return element.topicid ==
                                                value
                                                    .filter_grouppersonlist![
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
                                                                  Colors.white,
                                                              backgroundImage: NetworkImage(value
                                                                              .filter_grouppersonlist![
                                                                                  index]
                                                                              .imgurl !=
                                                                          null &&
                                                                      value.filter_grouppersonlist![index].imgurl !=
                                                                          ''
                                                                  ? value
                                                                      .filter_grouppersonlist![
                                                                          index]
                                                                      .imgurl
                                                                  : default_roomimg),
                                                            ),
                                                            Text(
                                                                '${value.filter_grouppersonlist![index].area}')
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
                                                                        '標題:${value.filter_grouppersonlist![index].title}',
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
                                                                          '目的:${value.filter_grouppersonlist![index].purpose}',
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

                                                                    // Text(
                                                                    //         '${value.lastmsglist?[laseindex!].nickname} 說: ${value.lastmsglist?[laseindex!].text}',
                                                                    //         style: TextStyle(
                                                                    //             color:
                                                                    //                 Colors.grey,
                                                                    //             height: 1),
                                                                    //       )
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
                                                                      : value.remoteUserInfo[0].chatroomId.indexWhere((element) => element == value.filter_grouppersonlist![index].id) != -1
                                                                          ? Color(0xffffbbbb)
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
                                                                                value.filter_grouppersonlist![index].id) !=
                                                                            -1
                                                                        ? '已加入'
                                                                        : '未加入'),
                                                              ),
                                                            ),
                                                            Text(value
                                                                        .filter_grouppersonlist![
                                                                            index]
                                                                        .datetime !=
                                                                    null
                                                                ? '${DateFormat('yyyy/MM/dd').format(value.filter_grouppersonlist![index].datetime)}'
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
                                                      .filter_grouppersonlist![
                                                          index]
                                                      .id);
                                              if (value.remoteUserInfo[0]
                                                      .chatroomId ==
                                                  null) {
                                                value.notify_chatroom_member_enter(
                                                    value
                                                        .filter_grouppersonlist![
                                                            index]
                                                        .id,
                                                    value.remoteUserInfo[0]
                                                        .nickname);
                                              } else if (value.remoteUserInfo[0]
                                                      .chatroomId
                                                      .indexWhere((element) =>
                                                          element ==
                                                          value
                                                              .filter_grouppersonlist![
                                                                  index]
                                                              .id) ==
                                                  -1) {
                                                //沒加入過
                                                // 通知聊天室內的 新加入
                                                value.notify_chatroom_member_enter(
                                                    value
                                                        .filter_grouppersonlist![
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
                                                                    .filter_grouppersonlist![
                                                                        index]
                                                                    .id,
                                                                title: value
                                                                    .filter_grouppersonlist![
                                                                        index]
                                                                    .title,
                                                                chattype: 2,
                                                                own: value.filter_grouppersonlist![index]
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
                                        itemCount: value
                                            .filter_grouppersonlist!.length))
                                : Container(
                                    child: Text('目前沒有符合條件的約會'),
                                  )
                            : Container(
                                child: Text('約會加載中'),
                              )
                        : value.grouppersonlist != null
                            ? value.grouppersonlist!.isNotEmpty
                                ? SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    header: WaterDropMaterialHeader(
                                        backgroundColor: Color(0xffffbbbb)),
                                    controller: _refreshController,
                                    onRefresh: _onRefresh,
                                    onLoading: _onLoading,
                                    child: ListView.separated(
                                        itemBuilder: (context, index) {
                                          //單一群組 設定
                                          var laseindex = value.lastmsglist
                                              ?.indexWhere((element) {
                                            return element.topicid ==
                                                value.grouppersonlist![index].id
                                                    .toHexString();
                                          });
                                          var newmsgindex = value.msglist
                                              ?.indexWhere((element) {
                                            return element.topicid ==
                                                value.grouppersonlist![index].id
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
                                                                              .grouppersonlist![
                                                                                  index]
                                                                              .imgurl !=
                                                                          null &&
                                                                      value.grouppersonlist![index].imgurl !=
                                                                          ''
                                                                  ? value
                                                                      .grouppersonlist![
                                                                          index]
                                                                      .imgurl
                                                                  : default_roomimg),
                                                            ),
                                                            Text(
                                                                '${value.grouppersonlist![index].area}')
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
                                                                        '標題:${value.grouppersonlist![index].title}',
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
                                                                          '目的:${value.grouppersonlist![index].purpose}',
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
                                                                      : value.remoteUserInfo[0].chatroomId.indexWhere((element) => element == value.grouppersonlist![index].id) != -1
                                                                          ? Color(0xffffbbbb)
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
                                                                                value.grouppersonlist![index].id) !=
                                                                            -1
                                                                        ? '已加入'
                                                                        : '未加入'),
                                                              ),
                                                            ),
                                                            Text(value
                                                                        .grouppersonlist![
                                                                            index]
                                                                        .datetime !=
                                                                    null
                                                                ? '${DateFormat('yyyy/MM/dd').format(value.grouppersonlist![index].datetime)}'
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
                                                      .grouppersonlist![index]
                                                      .id);
                                              if (value.remoteUserInfo[0]
                                                      .chatroomId ==
                                                  null) {
                                                value
                                                    .notify_chatroom_member_enter(
                                                        value
                                                            .grouppersonlist![
                                                                index]
                                                            .id,
                                                        value.remoteUserInfo[0]
                                                            .nickname);
                                              } else if (value.remoteUserInfo[0]
                                                      .chatroomId
                                                      .indexWhere((element) =>
                                                          element ==
                                                          value
                                                              .grouppersonlist![
                                                                  index]
                                                              .id) ==
                                                  -1) {
                                                //沒加入過
                                                // 通知聊天室內的 新加入
                                                value
                                                    .notify_chatroom_member_enter(
                                                        value
                                                            .grouppersonlist![
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
                                                                    .grouppersonlist![
                                                                        index]
                                                                    .id,
                                                                title: value
                                                                    .grouppersonlist![
                                                                        index]
                                                                    .title,
                                                                chattype: 2,
                                                                own: value.grouppersonlist![index]
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
                                            value.grouppersonlist!.length))
                                : Container(
                                    child: Text('目前沒有約會'),
                                  )
                            : Container(
                                child: Text('約會加載中'),
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

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
    await Provider.of<ChatProvider>(context, listen: false).getgroupperson();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();

    Provider.of<ChatProvider>(context, listen: false).grouppage_plus(2);
    await Provider.of<ChatProvider>(context, listen: false)
        .addpage_getgroupperson();
  }
}
