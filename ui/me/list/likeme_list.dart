import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:intl/intl.dart';

import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';

class LikeMeList extends StatefulWidget {
  const LikeMeList({Key? key}) : super(key: key);

  @override
  _LikeMeListState createState() => _LikeMeListState();
}

class _LikeMeListState extends State<LikeMeList> {
  @override
  void initState() {
    initdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
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
                      Get.back();
                    }),
                Center(
                    child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        '誰喜歡我',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                )),
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.transparent,
                    ),
                    onPressed: () async {
                      await Provider.of<ChatProvider>(context, listen: false)
                          .get_followed_userinfo_list();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Consumer<ChatProvider>(builder: (context, value, child) {
                return value.follow_me_list != null
                    ? Container(
                        height: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: GestureDetector(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 30,
                                        backgroundImage: NetworkImage(value
                                            .follow_me_list[index]
                                            .followed_userinfo
                                            .avatar_sub),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              value
                                                          .follow_me_list[index]
                                                          .followed_userinfo
                                                          .nickname !=
                                                      null
                                                  ? '${value.follow_me_list[index].followed_userinfo.nickname}'
                                                  : '名字不詳',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    '${value.follow_me_list[index].followed_userinfo.sex}'),
                                                Text(value
                                                            .follow_me_list[
                                                                index]
                                                            .followed_userinfo
                                                            .birthday !=
                                                        null
                                                    ? '  / ${DateFormat('yyyy-MM-dd').format(value.follow_me_list[index].followed_userinfo.birthday)}'
                                                    : '  / 生日'),
                                                Text(value
                                                            .follow_me_list[
                                                                index]
                                                            .followed_userinfo
                                                            .height !=
                                                        null
                                                    ? '  / ${value.follow_me_list[index].followed_userinfo.height}cm'
                                                    : '  / 身高不詳'),
                                                Text(value
                                                                .follow_me_list[
                                                                    index]
                                                                .followed_userinfo
                                                                .area !=
                                                            null &&
                                                        value
                                                                .follow_me_list[
                                                                    index]
                                                                .followed_userinfo
                                                                .area !=
                                                            ''
                                                    ? '  / ${ChineseHelper.convertToTraditionalChinese(value.follow_me_list[index].followed_userinfo.area)}'
                                                    : '  / 所在地不詳'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: value.follow_me_list.length,
                          ),
                        ),
                      )
                    : Container();
              }))
        ],
      ),
    ));
  }

  Future initdata() async {
    // await Provider.of<ChatProvider>(context, listen: false).followme_finduserinfolist();
    await Provider.of<ChatProvider>(context, listen: false)
        .get_followed_userinfo_list();
  }
}
