
import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/otherpage/other_profile_page.dart';
import 'package:ime_new/ui/widget/stack_text.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DateRecommend extends StatefulWidget {
  const DateRecommend({Key? key}) : super(key: key);

  @override
  State<DateRecommend> createState() => _DateRecommendState();
}

class _DateRecommendState extends State<DateRecommend> {
  @override
  void initState() {
    // initData();
    super.initState();
  }

  Future initData() async {
    // await Provider.of<ChatProvider>(context, listen: false).getaccountinfo();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Provider.of<ChatProvider>(context, listen: false)
          .find_recommend_people();
    });
  }
  @override
  void didChangeDependencies() {
    initData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      child: Consumer<ChatProvider>(
        builder: (context, value, child) {
          return value.recommend_memberlist == null
              ? Container(
                  child: Center(
                    child: Text('好的緣分即將到來...'),
                  ),
                )
              : value.recommend_memberlist!.isEmpty
                  ? Container(child: Center(child: Text('好的緣分即將到來...')))
                  : SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropMaterialHeader(
                          backgroundColor: Color(0xff7fffd4)),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: GridView.builder(
                          itemCount: value.recommend_memberlist!.length,
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
                                        text: value.recommend_memberlist![index]
                                                    .nickname ==
                                                null
                                            ? '不詳'
                                            : value.recommend_memberlist![index]
                                                .nickname,
                                        size: 12,
                                      ),
                                      StackText(
                                        text: value.recommend_memberlist![index]
                                                        .introduction ==
                                                    null ||
                                                value
                                                        .recommend_memberlist![
                                                            index]
                                                        .introduction ==
                                                    ''
                                            ? '不詳'
                                            : value.recommend_memberlist![index]
                                                .introduction,
                                        size: 12,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: Stack(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  size: 14,
                                                  color: Colors.black,
                                                ),
                                                Positioned(
                                                  top: 1,
                                                  left: 1,
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          StackText(
                                            text: value
                                                        .recommend_memberlist![
                                                            index]
                                                        .area ==
                                                    null
                                                ? '不詳'
                                                : value
                                                    .recommend_memberlist![
                                                        index]
                                                    .area,
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
                                        image: value
                                                        .recommend_memberlist![
                                                            index]
                                                        .avatar_sub !=
                                                    null &&
                                                value
                                                        .recommend_memberlist![
                                                            index]
                                                        .avatar_sub !=
                                                    ''
                                            ? NetworkImage(
                                                '${value.recommend_memberlist![index].avatar_sub}')
                                            : AssetImage(value
                                                                .recommend_memberlist![
                                                                    index]
                                                                .sex ==
                                                            null ||
                                                        value
                                                                .recommend_memberlist![
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
                                        builder: (context) => OtherProfilePage(
                                              chatroomid: value
                                                  .recommend_memberlist![index]
                                                  .memberid,
                                            )));
                              },
                            );
                          }),
                    );
        },
        // ),
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

    await Provider.of<ChatProvider>(context, listen: false)
        .find_recommend_people();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() => {});
    _refreshController.loadComplete();
    Provider.of<ChatProvider>(context, listen: false).plus_page(1);
    await Provider.of<ChatProvider>(context, listen: false)
        .addpage_find_recommend_people();
  }
}
