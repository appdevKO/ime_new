import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/action/action_detail_page.dart';
import 'package:ime_new/ui/otherpage/other_profile_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoriteActionList extends StatefulWidget {
  const FavoriteActionList({Key? key}) : super(key: key);

  @override
  State<FavoriteActionList> createState() => _FavoriteActionListState();
}

class _FavoriteActionListState extends State<FavoriteActionList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        return
            // Container(child: Text('${value.favorite_actionlist}   ${value.favorite_actionlist?.isEmpty}'),);

            SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                controller: _refreshController,
                header:
                    WaterDropMaterialHeader(backgroundColor: Color(0xffffbbbb)),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: value.favorite_actionlist != null &&
                        value.favorite_actionlist!.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return SingleAction2(
                            index: index,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey,
                            thickness: 5,
                          );
                        },
                        itemCount: value.favorite_actionlist!.length,
                      )
                    : Container(
                        child: Center(
                          child: Text('目前關注的人還沒有發布動態'),
                        ),
                      ));
      },
    );
  }

  Future initData() async {
    print('init new action');
    await Provider.of<ChatProvider>(context, listen: false)
        .get_follow_action_list();
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_follow_action_list();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) setState(() {});
    _refreshController.loadComplete();

    await Provider.of<ChatProvider>(context, listen: false)
        .addpage_favorite_action();
  }
}

class SingleAction2 extends StatefulWidget {
  SingleAction2({Key? key, required this.index}) : super(key: key);
  int? index;

  @override
  State<SingleAction2> createState() => _SingleAction2State();
}

class _SingleAction2State extends State<SingleAction2> {
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
                                              .favorite_actionlist![
                                                  widget.index!]
                                              .action
                                              .avatar ==
                                          '' ||
                                      value.favorite_actionlist![widget.index!]
                                              .action.avatar ==
                                          null
                                  ? AssetImage('assets/default/sex_man.png')
                                      as ImageProvider
                                  : NetworkImage(value
                                      .favorite_actionlist![widget.index!]
                                      .action
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
                                value.favorite_actionlist![widget.index!].action
                                                .nickname ==
                                            null ||
                                        value
                                                .favorite_actionlist![
                                                    widget.index!]
                                                .action
                                                .nickname ==
                                            ''
                                    ? '不詳'
                                    : '${value.favorite_actionlist![widget.index!].action.nickname}',
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
                                      value.favorite_actionlist![widget.index!]
                                                      .action.area ==
                                                  null ||
                                              value
                                                      .favorite_actionlist![
                                                          widget.index!]
                                                      .action
                                                      .area ==
                                                  ''
                                          ? '不詳'
                                          : '${value.favorite_actionlist![widget.index!].action.area}',
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
                          value.favorite_actionlist![widget.index!].action
                                      .memberid ==
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
                                                    .favorite_actionlist![
                                                        widget.index!]
                                                    .action
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
                            value.favorite_actionlist![widget.index!].action
                                        .createTime !=
                                    null
                                ? '${DateFormat('yyyy/MM/dd').format(value.favorite_actionlist![widget.index!].action.createTime)}'
                                : '--/--/--',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (value
                          .favorite_actionlist![widget.index!].action.account !=
                      value.remoteUserInfo[0].account) {
                    //成員橫排 點 單一頭像
                    // 改成先進簡介
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtherProfilePage(
                                  chatroomid: value
                                      .favorite_actionlist![widget.index!]
                                      .action
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
                          text: value.favorite_actionlist![widget.index!].action
                                          .text !=
                                      '' &&
                                  value.favorite_actionlist![widget.index!]
                                          .action.text !=
                                      null
                              ? '${value.favorite_actionlist![widget.index!].action.text}'
                              : '(無內文)'),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActionDetailPage(
                                TheAction: value
                                    .favorite_actionlist![widget.index!].action,
                              )));
                },
              ),
              //圖片
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: value.favorite_actionlist![widget.index!].action
                                .image_sub !=
                            '' &&
                        value.favorite_actionlist![widget.index!].action
                                .image_sub !=
                            null
                    ? GestureDetector(
                        child: Center(
                          child: Image.network(
                            '${value.favorite_actionlist![widget.index!].action.image_sub}',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActionDetailPage(
                                        TheAction: value
                                            .favorite_actionlist![widget.index!]
                                            .action,
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
                              color: value.favorite_actionlist![widget.index!]
                                      .action.like_list
                                      .contains(
                                          value.remoteUserInfo[0].memberid)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              if (value.favorite_actionlist![widget.index!]
                                  .action.like_list
                                  .contains(value.remoteUserInfo[0].memberid)) {
                                print('有在list ->點擊就是取消喜歡');
                                value.like_to_action(
                                    value.favorite_actionlist![widget.index!]
                                        .action.id,
                                    widget.index,
                                    true,
                                    value.favorite_actionlist![widget.index!]
                                        .action);
                              } else {
                                print('沒有在list ->點擊喜歡');

                                value.like_to_action(
                                    value.favorite_actionlist![widget.index!]
                                        .action.id,
                                    widget.index,
                                    false,
                                    value.favorite_actionlist![widget.index!]
                                        .action);
                              }
                            }),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            value.favorite_actionlist![widget.index!].action
                                            .like_num !=
                                        '' &&
                                    value.favorite_actionlist![widget.index!]
                                            .action.like_num !=
                                        null
                                ? '${value.favorite_actionlist![widget.index!].action.like_num}'
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
                                      .favorite_actionlist![widget.index!]
                                      .action
                                      .id);
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
                                                                          .favorite_actionlist![
                                                                              widget.index!]
                                                                          .action
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
                                                                            .favorite_actionlist![widget
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
                                                                        .favorite_actionlist![
                                                                            widget.index!]
                                                                        .id);

                                                                await Provider.of<
                                                                            ChatProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .get_action_msg_count(
                                                                        value
                                                                            .favorite_actionlist![widget.index!]
                                                                            .action
                                                                            .id,
                                                                        3);
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
                                                                      .favorite_actionlist![
                                                                          widget
                                                                              .index!]
                                                                      .action
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
                                                                  .favorite_actionlist![
                                                                      widget
                                                                          .index!]
                                                                  .action
                                                                  .id);

                                                          await Provider.of<
                                                                      ChatProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .get_action_msg_count(
                                                                  value
                                                                      .favorite_actionlist![
                                                                          widget
                                                                              .index!]
                                                                      .action
                                                                      .id,
                                                                  3);
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
                              value.favorite_actionlist![widget.index!].action
                                              .msg_num !=
                                          '' &&
                                      value.favorite_actionlist![widget.index!]
                                              .action.msg_num !=
                                          null
                                  ? '${value.favorite_actionlist![widget.index!].action.msg_num}'
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
