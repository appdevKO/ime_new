import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';

class MyFollowPage extends StatefulWidget {
  const MyFollowPage({Key? key}) : super(key: key);

  @override
  State<MyFollowPage> createState() => _MyFollowPageState();
}

class _MyFollowPageState extends State<MyFollowPage> {
  @override
  void initState() {
    initdata();
    super.initState();
  }

  Future initdata() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .get_follow_info_list();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
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
                        Navigator.pop(context);
                      }),
                  Center(
                      child: Text(
                    '我的好友',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.transparent,
                      ),
                      onPressed: () {
                        // print(
                        //     'default_chat_text:${Provider.of<ChatProvider>(context, listen: false).remoteUserInfo[0].default_chat_text}');
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
                  return value.myfollowlog != null
                      ? Container(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return value.myfollowlog[index]
                                            .following_userinfo !=
                                        null
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: GestureDetector(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    value
                                                        .myfollowlog[index]
                                                        .following_userinfo
                                                        .avatar_sub),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      value
                                                                  .myfollowlog[
                                                                      index]
                                                                  .following_userinfo
                                                                  .nickname !=
                                                              null
                                                          ? '${value.myfollowlog[index].following_userinfo.nickname}'
                                                          : '名字不詳',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            '${value.myfollowlog[index].following_userinfo.sex}'),
                                                        Text(value
                                                                    .myfollowlog[
                                                                        index]
                                                                    .following_userinfo
                                                                    .birthday !=
                                                                null
                                                            ? '  / ${DateFormat('yyyy-MM-dd').format(value.myfollowlog[index].following_userinfo.birthday)}'
                                                            : '  / 生日'),
                                                        Text(value
                                                                    .myfollowlog[
                                                                        index]
                                                                    .following_userinfo
                                                                    .height !=
                                                                null
                                                            ? '  / ${value.myfollowlog[index].following_userinfo.height}cm'
                                                            : '  / 身高不詳'),
                                                        Text(value
                                                                        .myfollowlog[
                                                                            index]
                                                                        .following_userinfo
                                                                        .area !=
                                                                    null &&
                                                                value
                                                                        .myfollowlog[
                                                                            index]
                                                                        .following_userinfo
                                                                        .area !=
                                                                    ''
                                                            ? '  / ${ChineseHelper.convertToTraditionalChinese(value.myfollowlog[index].following_userinfo.area)}'
                                                            : '  / 地區不詳'),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () {},
                                        ),
                                      )
                                    : Container();
                              },
                              itemCount: value.myfollowlog.length,
                            ),
                          ),
                        )
                      : Container();
                }))
          ],
        ),
      )),
    );
  }
}
