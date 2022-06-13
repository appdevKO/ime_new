import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/widget/showimage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action_detail_page.dart';

class NewestActionList extends StatefulWidget {
  const NewestActionList({Key? key}) : super(key: key);

  @override
  State<NewestActionList> createState() => _NewestActionListState();
}

class _NewestActionListState extends State<NewestActionList> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        return value.newest_actionlist!.isNotEmpty
            ? SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                controller: _refreshController,
                header:
                    WaterDropMaterialHeader(backgroundColor: Color(0xffaCEA00)),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return SingleAction(
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 5,
                      ),
                    );
                  },
                  itemCount: value.newest_actionlist!.length,
                ),
              )
            : Container(
                child: Center(
                  child: Text('目前沒有動態'),
                ),
              );
      },
    );
  }

  Future initData() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .get_new_action_list();
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_new_action_list();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();

    Provider.of<ChatProvider>(context, listen: false).action_plus_page(1);
    await Provider.of<ChatProvider>(context, listen: false)
        .addpage_newest_action();
  }
}

class SingleAction extends StatefulWidget {
  SingleAction({Key? key, required this.index}) : super(key: key);
  int? index;

  @override
  State<SingleAction> createState() => _SingleActionState();
}

class _SingleActionState extends State<SingleAction> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            child: Container(
              height: value.newest_actionlist![widget.index!].image_sub != '' &&
                      value.newest_actionlist![widget.index!].image_sub != null
                  ? 350
                  : 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                                                .newest_actionlist![
                                                    widget.index!]
                                                .avatar ==
                                            '' ||
                                        value.newest_actionlist![widget.index!]
                                                .avatar ==
                                            null
                                    ? AssetImage('assets/default/sex_man.png')
                                        as ImageProvider
                                    : NetworkImage(value
                                        .newest_actionlist![widget.index!]
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
                                  value.newest_actionlist![widget.index!]
                                                  .nickname ==
                                              null ||
                                          value
                                                  .newest_actionlist![
                                                      widget.index!]
                                                  .nickname ==
                                              ''
                                      ? '尚無暱稱'
                                      : '${value.newest_actionlist![widget.index!].nickname}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.grey,
                                        size: 15,
                                      ),
                                      Text(
                                        value.newest_actionlist![widget.index!]
                                                        .area ==
                                                    null ||
                                                value
                                                        .newest_actionlist![
                                                            widget.index!]
                                                        .area ==
                                                    ''
                                            ? '尚無地區'
                                            : '${value.newest_actionlist![widget.index!].area}',
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
                        Text(
                          value.newest_actionlist![widget.index!].createTime !=
                                  null
                              ? '${DateFormat('yyyy/MM/dd').format(value.newest_actionlist![widget.index!].createTime)}'
                              : '--/--/--',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  //內文
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 15, right: 15),
                    child: Container(
                      height: 50,
                      // color: Colors.yellow,
                      width: MediaQuery.of(context).size.width / 2,
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            text: value.newest_actionlist![widget.index!]
                                            .text !=
                                        '' &&
                                    value.newest_actionlist![widget.index!]
                                            .text !=
                                        null
                                ? '${value.newest_actionlist![widget.index!].text}'
                                : '(無內文)'),
                      ),
                    ),
                  ),
                  // //圖片
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: value.newest_actionlist![widget.index!].image_sub !=
                                '' &&
                            value.newest_actionlist![widget.index!].image_sub !=
                                null
                        ? Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${value.newest_actionlist![widget.index!].image_sub}'),
                                  fit: BoxFit.cover)),
                        )
                        : Container(),
                  ),
                  //三個icon
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 15, left: 15),
                    child: Expanded(
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
                                  value.newest_actionlist![widget.index!]
                                                  .like_num !=
                                              '' &&
                                          value
                                                  .newest_actionlist![
                                                      widget.index!]
                                                  .like_num !=
                                              null
                                      ? '${value.newest_actionlist![widget.index!].like_num}'
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
                                    value.newest_actionlist![widget.index!]
                                                    .msg_num !=
                                                '' &&
                                            value
                                                    .newest_actionlist![
                                                        widget.index!]
                                                    .msg_num !=
                                                null
                                        ? '${value.newest_actionlist![widget.index!].msg_num}'
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
                  ),
                ],
              ),
              color: Colors.white,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActionDetailPage(
                            TheAction: value.newest_actionlist![widget.index!],
                          )));
            },
          ),
        );
      },
    );
  }
}
