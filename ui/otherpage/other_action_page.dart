import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/action/action_detail_page.dart';
import 'package:ime_new/ui/action/create_action.dart';
import 'package:ime_new/ui/action/new_actionlist.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'other_profile_page.dart';

class OtherActionPage extends StatefulWidget {
  OtherActionPage(
      {Key? key,
      required this.memberid,
      required this.nickname,
      required this.type})
      : super(key: key);
  final memberid;
  final nickname;
  final int type;

  @override
  State<OtherActionPage> createState() => _OtherActionPageState();
}

class _OtherActionPageState extends State<OtherActionPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_someone_action_list(widget.memberid);
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();

    await Provider.of<ChatProvider>(context, listen: false)
        .addpage_newest_action();
  }

  @override
  void initState() {
    initdata();
    super.initState();
  }

  Future initdata() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .get_someone_action_list(widget.memberid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: new Size(MediaQuery.of(context).size.width, 50),
          child: Container(
            height: 56,
            padding: EdgeInsets.only(top: 5),
            decoration: new BoxDecoration(color: Color(0xffffbbbb)),
            child: Center(child: Text(widget.type == 1 ? '${widget.nickname}的動態' : '我的動態')),
          ),
        ),
        body: Consumer<ChatProvider>(builder: (context, value, child) {
          return CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: widget.type == 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          '${value.remoteUserInfo[0].avatar_sub}')),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value.remoteUserInfo[0].nickname !=
                                                      '' &&
                                                  value.remoteUserInfo[0]
                                                          .nickname !=
                                                      null
                                              ? '${value.remoteUserInfo[0].nickname}'
                                              : '不詳',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            Text(
                                              value.remoteUserInfo[0].area !=
                                                          '' &&
                                                      value.remoteUserInfo[0]
                                                              .area !=
                                                          null
                                                  ? '${value.remoteUserInfo[0].area}'
                                                  : '不詳',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewAction()));
                                  },
                                  child: Text('建立動態')),
                            ],
                          ),
                        )
                      : Container(),
                ),
                SliverFillRemaining(
                  child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    controller: _refreshController,
                    header: WaterDropMaterialHeader(
                        backgroundColor: Color(0xffffbbbb)),
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: value.someone_actionlist != null
                        ? value.someone_actionlist!.isNotEmpty
                            ? ListView.separated(
                                itemBuilder: (context, index) {
                                  return SingleAction3(
                                    index: index,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Colors.grey,
                                    thickness: 5,
                                  );
                                },
                                itemCount: value.someone_actionlist!.length,
                              )
                            : Container(
                                child: Center(
                                  child: Text('這個人目前沒有動態'),
                                ),
                              )
                        : Container(
                            child: Center(
                              child: Text('動態載入中'),
                            ),
                          ),
                  ),
                )
              ]);
        }));
  }
}

class SingleAction3 extends StatefulWidget {
  SingleAction3({Key? key, required this.index}) : super(key: key);
  int? index;

  @override
  State<SingleAction3> createState() => _SingleAction3State();
}

class _SingleAction3State extends State<SingleAction3> {
  final scrollController = ScrollController();
  late TextEditingController _textController;
  final FocusNode _focus = FocusNode();
  late CustomPopupMenuController _controller;

  @override
  void initState() {
    _textController = TextEditingController();
    _controller = CustomPopupMenuController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 31,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 30,
                              backgroundImage: value
                                              .someone_actionlist![
                                                  widget.index!]
                                              .avatar ==
                                          '' ||
                                      value.someone_actionlist![widget.index!]
                                              .avatar ==
                                          null
                                  ? AssetImage('assets/default/sex_man.png')
                                      as ImageProvider
                                  : NetworkImage(value
                                      .someone_actionlist![widget.index!]
                                      .avatar),
                            ),
                          ),
                          Container(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                value.someone_actionlist![widget.index!]
                                                .nickname ==
                                            null ||
                                        value.someone_actionlist![widget.index!]
                                                .nickname ==
                                            ''
                                    ? '不詳'
                                    : '${value.someone_actionlist![widget.index!].nickname}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.grey,
                                      size: 15,
                                    ),
                                    Text(
                                      value.someone_actionlist![widget.index!]
                                                      .area ==
                                                  null ||
                                              value
                                                      .someone_actionlist![
                                                          widget.index!]
                                                      .area ==
                                                  ''
                                          ? '不詳'
                                          : '${value.someone_actionlist![widget.index!].area}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          //是我的動態 要可以編輯 或是刪除
                          value.someone_actionlist![widget.index!].memberid ==
                                  value.remoteUserInfo[0].memberid
                              ? Container(
                                  height: 40, width: 40,
                                  // color: Colors.red,
                                  child: CustomPopupMenu(
                                    child: Icon(Icons.more_vert),
                                    menuBuilder: () => ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            color: Colors.white,
                                            child: IntrinsicWidth(
                                                child: GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () async {
                                                value.delete_action(value
                                                    .someone_actionlist![
                                                        widget.index!]
                                                    .id);
                                                _controller.hideMenu();
                                              },
                                              child: Container(
                                                width: 150,
                                                margin: EdgeInsets.all(20),
                                                child: Text(
                                                  "刪除動態",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    pressType: PressType.singleClick,
                                    verticalMargin: -10,
                                    controller: _controller,
                                  ),
                                )
                              : Container(),
                          Text(
                            value.someone_actionlist![widget.index!]
                                        .createTime !=
                                    null
                                ? '${DateFormat('yyyy/MM/dd').format(value.someone_actionlist![widget.index!].createTime)}'
                                : '--/--/--',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (value.someone_actionlist![widget.index!].account !=
                      value.remoteUserInfo[0].account) {
                    //成員橫排 點 單一頭像
                    // 改成先進簡介
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtherProfilePage(
                                  chatroomid: value
                                      .someone_actionlist![widget.index!]
                                      .memberid,
                                )));
                  } else {
                    print('同一人');
                  }
                },
              ),
              //內文
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
                  child: Container(
                    height: 50,
                    // color: Colors.yellow,
                    width: MediaQuery.of(context).size.width,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(fontSize: 12.0),
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          text: value.someone_actionlist![widget.index!].text !=
                                      '' &&
                                  value.someone_actionlist![widget.index!]
                                          .text !=
                                      null
                              ? '${value.someone_actionlist![widget.index!].text}'
                              : '(無內文)'),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActionDetailPage(
                                TheAction:
                                    value.someone_actionlist![widget.index!],
                              )));
                },
              ),
              //圖片
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: value.someone_actionlist![widget.index!].image_sub !=
                            '' &&
                        value.someone_actionlist![widget.index!].image_sub !=
                            null
                    ? GestureDetector(
                        child: Center(
                          child: Image.network(
                            '${value.someone_actionlist![widget.index!].image_sub}',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActionDetailPage(
                                        TheAction: value
                                            .someone_actionlist![widget.index!],
                                      )));
                        },
                      )
                    : Container(),
              ),
              //三個icon
              Container(
                padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                height: 40,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //愛心
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 18,
                              color: value.someone_actionlist![widget.index!]
                                      .like_list
                                      .contains(
                                          value.remoteUserInfo[0].memberid)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              if (value
                                  .someone_actionlist![widget.index!].like_list
                                  .contains(value.remoteUserInfo[0].memberid)) {
                                print('有在list ->點擊就是取消喜歡');
                                value.like_to_action(
                                    value.someone_actionlist![widget.index!].id,
                                    widget.index,
                                    true,
                                    value.someone_actionlist![widget.index!]);
                              } else {
                                print('沒有在list ->點擊喜歡');

                                value.like_to_action(
                                    value.someone_actionlist![widget.index!].id,
                                    widget.index,
                                    false,
                                    value.someone_actionlist![widget.index!]);
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            value.someone_actionlist![widget.index!].like_num !=
                                        '' &&
                                    value.someone_actionlist![widget.index!]
                                            .like_num !=
                                        null
                                ? '${value.someone_actionlist![widget.index!].like_num}'
                                : '-',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    //留言數
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.message,
                              size: 18,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              await Provider.of<ChatProvider>(context,
                                      listen: false)
                                  .get_action_msg(value
                                      .someone_actionlist![widget.index!].id);
                              showModalBottomSheet<void>(
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return Padding(
                                      padding:
                                          MediaQuery.of(context).viewInsets,
                                      child: Container(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //標題
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 35,
                                                    child: IconButton(
                                                      icon: Icon(Icons.close,
                                                          size: 30,
                                                          color: Colors.red),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    "留言",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1),
                                                  ),
                                                  GestureDetector(
                                                    child: Container(
                                                      width: 35,
                                                      child: Text(
                                                        '儲存',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                    ),
                                                    onTap: () {},
                                                  )
                                                ],
                                              ),
                                              Divider(
                                                height: 1,
                                              ),

                                              Container(
                                                  height: 300,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Consumer<ChatProvider>(
                                                    builder: (context, value,
                                                        child) {
                                                      return value.actionmsglist !=
                                                              null
                                                          ? value.actionmsglist!
                                                                  .isNotEmpty
                                                              ? ListView
                                                                  .separated(
                                                                  controller:
                                                                      scrollController,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return SingleActionMsg(
                                                                      index:
                                                                          index,
                                                                      isme: value.actionmsglist![index].memberid ==
                                                                              value.remoteUserInfo[0].memberid
                                                                          ? true
                                                                          : false,
                                                                      actionid: value
                                                                          .someone_actionlist![
                                                                              widget.index!]
                                                                          .id,
                                                                    );
                                                                  },
                                                                  separatorBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              5),
                                                                    );
                                                                  },
                                                                  itemCount: value
                                                                      .actionmsglist!
                                                                      .length,
                                                                )
                                                              : Center(
                                                                  child: Text(
                                                                      '此動態尚無留言'))
                                                          : Center(
                                                              child: Text(
                                                                  '此動態尚無留言'));
                                                    },
                                                  )),
                                              // 輸入匡
                                              Container(
                                                height: 70,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffF9F9F9),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          -2), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight:
                                                                      60.0,
                                                                  maxHeight:
                                                                      150.0),
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  right: 2,
                                                                  left: 15),
                                                          child: TextField(
                                                            focusNode: _focus,
                                                            //限制輸入文字多長
                                                            // maxLength: 75,
                                                            //換行
                                                            // maxLines: null,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            onSubmitted:
                                                                (val) async {
                                                              if (_textController
                                                                      .text !=
                                                                  '') {
                                                                await Provider.of<
                                                                            ChatProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .upload_action_msg(
                                                                        value
                                                                            .someone_actionlist![widget
                                                                                .index!]
                                                                            .id,
                                                                        _textController
                                                                            .text);
                                                                _textController
                                                                    .clear();

                                                                await Provider.of<
                                                                            ChatProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .get_action_msg(value
                                                                        .someone_actionlist![
                                                                            widget.index!]
                                                                        .id);

                                                                await Provider.of<
                                                                            ChatProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .get_action_msg_count(
                                                                        value
                                                                            .someone_actionlist![widget.index!]
                                                                            .id,
                                                                        4);
                                                              } else {
                                                                print('空空');
                                                              }
                                                              _focus.unfocus();
                                                            },
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            controller:
                                                                _textController,
                                                            decoration:
                                                                InputDecoration(
                                                              border: OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              fillColor:
                                                                  Colors.white,
                                                              filled: true,
                                                              hintText: '輸入留言',
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          5),
                                                            ),
                                                            style: TextStyle(
                                                                height: 1),
                                                          )),
                                                    ),
                                                    //傳送 發送 文字 箭頭 送出
                                                    IconButton(
                                                      icon: Icon(Icons.send),
                                                      onPressed: () async {
                                                        if (_textController
                                                                .text !=
                                                            '') {
                                                          await Provider.of<
                                                                      ChatProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .upload_action_msg(
                                                                  value
                                                                      .someone_actionlist![
                                                                          widget
                                                                              .index!]
                                                                      .id,
                                                                  _textController
                                                                      .text);
                                                          _textController
                                                              .clear();
                                                          Timer(
                                                              Duration(
                                                                  milliseconds:
                                                                      500), () {
                                                            print(
                                                                'maxamx${scrollController.position.maxScrollExtent}');
                                                            //滾動到最下面
                                                            scrollController
                                                                .animateTo(
                                                              scrollController
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                              curve: Curves
                                                                  .fastOutSlowIn,
                                                            );
                                                          });

                                                          await Provider.of<
                                                                      ChatProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .get_action_msg(value
                                                                  .someone_actionlist![
                                                                      widget
                                                                          .index!]
                                                                  .id);

                                                          await Provider.of<
                                                                      ChatProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .get_action_msg_count(
                                                                  value
                                                                      .someone_actionlist![
                                                                          widget
                                                                              .index!]
                                                                      .id,
                                                                  4);
                                                        } else {
                                                          print('空空');
                                                        }
                                                        _focus.unfocus();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              value.someone_actionlist![widget.index!]
                                              .msg_num !=
                                          '' &&
                                      value.someone_actionlist![widget.index!]
                                              .msg_num !=
                                          null
                                  ? '${value.someone_actionlist![widget.index!].msg_num}'
                                  : '-',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 15,
                            color: Colors.transparent,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              '分享',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.transparent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
