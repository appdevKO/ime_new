import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/action_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/widget/showimage.dart';
import 'package:ime_new/utils/color_config.dart';
import 'package:ime_new/utils/viewconfig.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActionDetailPage extends StatefulWidget {
  ActionDetailPage({Key? key, required this.TheAction}) : super(key: key);
  ActionModel TheAction;

  @override
  State<ActionDetailPage> createState() => _ActionDetailPageState();
}

class _ActionDetailPageState extends State<ActionDetailPage> {
  final FocusNode _focus = FocusNode();
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();

    initdata();
    // 帶動態id
    super.initState();
  }

  Future initdata() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .get_action_msg(widget.TheAction.id);
  }

  @override
  void dispose() {
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                ),
                //文字 內文
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(fontSize: 12.0),
                      text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          text: widget.TheAction.text != '' &&
                                  widget.TheAction.text != null
                              ? '${widget.TheAction.text}'
                              : '(無內文)'),
                    ),
                  ),
                ),
                // //圖片
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: widget.TheAction.image_sub != '' &&
                          widget.TheAction.image_sub != null
                      ? GestureDetector(
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${widget.TheAction.image_sub}'),
                                    fit: BoxFit.cover)),
                          ),
                          onTap: () {
                            print('大圖${widget.TheAction.image}');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowImage(
                                          img: '${widget.TheAction.image}',
                                        )));
                          },
                        )
                      : Container(
                          height: 150,
                        ),
                ),
                //三個icon
                Container(
                  padding: const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 18,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              widget.TheAction.like_num != '' &&
                                      widget.TheAction.like_num != null
                                  ? '${widget.TheAction.like_num}'
                                  : '-',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 38.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.message,
                              size: 18,
                              color: Colors.green,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                widget.TheAction.msg_num != '' &&
                                        widget.TheAction.msg_num != null
                                    ? '${widget.TheAction.msg_num}'
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

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Divider(
                    thickness: 5,
                  ),
                ),
                //留言
                Container(
                  height: 265,
                  color: Colors.white,
                  child: Consumer<ChatProvider>(
                    builder: (context, value, child) {
                      return value.actionmsglist!.isNotEmpty
                          ? ListView.separated(
                              itemBuilder: (context, index) {
                                return SingleActionMsg(
                                  index: index,
                                  isme: value.actionmsglist![index].memberid ==
                                          value.remoteUserInfo[0].memberid
                                      ? true
                                      : false,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                );
                              },
                              itemCount: value.actionmsglist!.length,
                            )
                          : Center(child: Text('此動態尚無留言'));
                    },
                  ),
                ),
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xffF9F9F9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, -2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                            constraints: BoxConstraints(
                                minHeight: 60.0, maxHeight: 150.0),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, right: 2, left: 15),
                            child: TextField(
                              focusNode: _focus,
                              //限制輸入文字多長
                              // maxLength: 75,
                              //換行
                              // maxLines: null,
                              keyboardType: TextInputType.text,
                              onSubmitted: (val) async {
                                if (_textController.text != '') {
                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .upload_action_msg(widget.TheAction.id,
                                          _textController.text);
                                  _textController.clear();

                                  await Provider.of<ChatProvider>(context,
                                          listen: false)
                                      .get_action_msg(widget.TheAction.id);
                                }
                                _focus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              controller: _textController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20)),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: '輸入留言',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                              ),
                              style: TextStyle(height: 1),
                            )),
                      ),
                      //傳送 發送 文字 箭頭 送出
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          if (_textController.text != '') {
                            await Provider.of<ChatProvider>(context,
                                    listen: false)
                                .upload_action_msg(
                                    widget.TheAction.id, _textController.text);
                            _textController.clear();
                            await Provider.of<ChatProvider>(context,
                                    listen: false)
                                .get_action_msg(widget.TheAction.id);
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
          Container(
            height: 150,
            color: Colors.white,
            child: Consumer<ChatProvider>(builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                          Text('title'),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.close,
                              color: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Padding(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.TheAction.nickname != '' &&
                                            widget.TheAction.nickname != null
                                        ? '${widget.TheAction.nickname}'
                                        : '尚無設定暱稱',
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
                                        widget.TheAction.area != '' &&
                                                widget.TheAction.area != null
                                            ? '${widget.TheAction.area}'
                                            : '尚無設定位置',
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
                        Text('分享')
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ]),
      ),
    );
  }
}

class SingleActionMsg extends StatefulWidget {
  SingleActionMsg({Key? key, required this.index, required this.isme})
      : super(key: key);
  int index;
  bool isme;

  @override
  _SingleActionMsgState createState() => _SingleActionMsgState();
}

class _SingleActionMsgState extends State<SingleActionMsg> {
  late CustomPopupMenuController _controller;

  @override
  void initState() {
    _controller = CustomPopupMenuController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: value.actionmsglist![widget.index].avatar ==
                              '' ||
                          value.actionmsglist![widget.index].avatar == null
                      ? AssetImage('assets/default/sex_man.png')
                          as ImageProvider
                      : NetworkImage(value.actionmsglist![widget.index].avatar),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: MediaQuery.of(context).size.width * .62,
                      decoration: BoxDecoration(
                          color: Color(0xffffF1F2F4),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //名字
                          Text(
                            '${value.actionmsglist![widget.index].nickname}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          //內文
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                                '${value.actionmsglist![widget.index].text}'),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${DateFormat('yyyy/MM/dd').format(value.actionmsglist![widget.index].createTime)}',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              //留言 選單
              widget.isme
                  ? Expanded(
                      child: Container(
                        height: 40, width: 40,
                        // color: Colors.red,
                        child: CustomPopupMenu(
                          child: Icon(Icons.more_vert),
                          menuBuilder: () => ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  color: Colors.white,
                                  child: IntrinsicWidth(
                                      child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      await Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .delete_action_msg(value
                                              .actionmsglist![widget.index]
                                              .msgid)
                                          .whenComplete(() => Provider.of<
                                                      ChatProvider>(context,
                                                  listen: false)
                                              .get_action_msg(value
                                                  .actionmsglist![widget.index]
                                                  .action_id));
                                      _controller.hideMenu();
                                    },
                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.all(20),
                                      child: Text(
                                        "刪除留言",
                                        style: TextStyle(fontSize: 15),
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
                          // IconButton(
                          //   onPressed: () async {
                          //     await Provider.of<ChatProvider>(
                          //             context,
                          //             listen: false)
                          //         .delete_action_msg(value
                          //             .actionmsglist![index].id)
                          //         .whenComplete(() =>
                          //             Provider.of<ChatProvider>(
                          //                     context,
                          //                     listen: false)
                          //                 .get_action_msg(
                          //                     widget.TheAction.id));
                          //   },
                          //   icon: ,
                          // ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
