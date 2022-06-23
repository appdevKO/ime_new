import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/otherpage/other_profile_page.dart';


import 'package:ime_new/ui/widget/stack_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lpinyin/lpinyin.dart';

class DateNear extends StatefulWidget {
  const DateNear({Key? key}) : super(key: key);

  @override
  State<DateNear> createState() => _DateNearState();
}

class _DateNearState extends State<DateNear> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    await Provider.of<ChatProvider>(context, listen: false).find_near_people();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
        child: Consumer<ChatProvider>(builder: (context, value, child) {
          return value.locate_permission
              ? value.nearpeoplelist == null
                  ? Container(child: Center(child: Text('正在幫你搜尋附近的人02')))
                  : value.nearpeoplelist!.isEmpty
                      ? Container(child: Center(child: Text('正在幫你搜尋附近的人01')))
                      : SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: WaterDropMaterialHeader(
                              backgroundColor: Color(0xff7fffd4)),
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          child: GridView.builder(
                            itemCount: value.nearpeoplelist?.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    childAspectRatio: 1.2),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        StackText(
                                          text: value.nearpeoplelist![index]
                                                          .nickname ==
                                                      '' ||
                                                  value.nearpeoplelist![index]
                                                          .nickname ==
                                                      null
                                              ? '不詳'
                                              : value.nearpeoplelist![index]
                                                  .nickname,
                                          size: 12,
                                        ),
                                        StackText(
                                          text: value.nearpeoplelist?[index]
                                                          .introduction ==
                                                      null ||
                                                  value.nearpeoplelist?[index]
                                                          .introduction ==
                                                      ''
                                              ? '不詳'
                                              : '${value.nearpeoplelist?[index].introduction}',
                                          size: 12,
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                size: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            StackText(
                                              text: value.nearpeoplelist?[index]
                                                              .area ==
                                                          null ||
                                                      value
                                                              .nearpeoplelist?[
                                                                  index]
                                                              .area ==
                                                          ''
                                                  ? '不詳'
                                                  : '${ChineseHelper.convertToTraditionalChinese(value.nearpeoplelist?[index].area)}',
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: value.nearpeoplelist![index]
                                                          .avatar_sub !=
                                                      null &&
                                                  value.nearpeoplelist![index]
                                                          .avatar_sub !=
                                                      ''
                                              ? NetworkImage(
                                                  '${value.nearpeoplelist![index].avatar_sub}',
                                                )
                                              : AssetImage(value
                                                                  .nearpeoplelist![
                                                                      index]
                                                                  .sex ==
                                                              null ||
                                                          value
                                                                  .nearpeoplelist![
                                                                      index]
                                                                  .sex ==
                                                              '男'
                                                      ? 'assets/default/sex_man.png'
                                                      : 'assets/default/sex_woman.png')
                                                  as ImageProvider,
                                          fit: BoxFit.cover),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.blue.withOpacity(.3),
                                      )),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OtherProfilePage(
                                                chatroomid: value
                                                    .nearpeoplelist![index]
                                                    .memberid,
                                              )));
                                },
                              );
                            },
                          ),
                        )
              : Container(
                  child: Center(
                    child: Text('未開啟定位服務'),
                  ),
                );
        }),
      ),
    );
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
    await Provider.of<ChatProvider>(context, listen: false).find_near_people();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
    Provider.of<ChatProvider>(context, listen: false).plus_page(4);
    await Provider.of<ChatProvider>(context, listen: false)
        .addpage_find_near_people();
  }
}
