import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ime_new/business_logic/model/settingitem_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/loginpage/loginpage.dart';
import 'package:ime_new/ui/me/profilepage.dart';
import 'package:ime_new/ui/me/profilesetting.dart';
import 'package:ime_new/ui/me/setting/date_setting.dart';
import 'package:ime_new/ui/me/setting/edit_hello.dart';
import 'package:provider/provider.dart';
import '../date/square/upgrade_vip.dart';
import 'list/likeme_list.dart';


/**
 *
 * 點左上角頭像進去  設定頁面
 *
 * */
class ProfileOption extends StatefulWidget {
  const ProfileOption({Key? key}) : super(key: key);

  @override
  _ProfileOptionState createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<ProfileOption> {
  static const flutterChannel =
      const MethodChannel('com.example.flutter/flutter');

  @override
  void initState() {
    initdata();

    ///method channel backbutton
    Future<dynamic> handler(MethodCall call) async {
      switch (call.method) {
        case 'backAction':
          print('1234 backaction');
          Get.back();
          // Navigator.pop(context);
          break;
      }
    }

    flutterChannel.setMethodCallHandler(handler);
    super.initState();
  }

  Future initdata() async {
    if (Provider.of<ChatProvider>(context, listen: false).remoteUserInfo !=
            null &&
        Provider.of<ChatProvider>(context, listen: false)
            .remoteUserInfo
            .isNotEmpty) {
      await Provider.of<ChatProvider>(context, listen: false).createfollowlog();
      await Provider.of<ChatProvider>(context, listen: false).createblocklog();
      await Provider.of<ChatProvider>(context, listen: false).getmyfollowlog();
      await Provider.of<ChatProvider>(context, listen: false).getmyblocklog();
    } else {
      await Provider.of<ChatProvider>(context, listen: false).getaccountinfo();
      await Provider.of<ChatProvider>(context, listen: false).createfollowlog();
      await Provider.of<ChatProvider>(context, listen: false).createblocklog();
      await Provider.of<ChatProvider>(context, listen: false).getmyfollowlog();
      await Provider.of<ChatProvider>(context, listen: false).getmyblocklog();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SettingOption> item = [
      SettingOption(
          title: '編輯打招呼',
          icon: CircleAvatar(
              child: Center(child: Icon(Icons.clean_hands_rounded))),
          callback: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EditHello()));
          }),
      SettingOption(
          title: 'ime收益',
          icon: CircleAvatar(child: Center(child: Icon(Icons.money))),
          callback: () {}),
      SettingOption(
          title: '我的LEVEL',
          icon: CircleAvatar(child: Center(child: Icon(Icons.night_shelter))),
          callback: () {}),
      SettingOption(
          title: '我的錢包',
          icon: CircleAvatar(
              child:
                  Center(child: Icon(Icons.account_balance_wallet_outlined))),
          callback: () {}),
      SettingOption(
          title: '特務任務',
          icon: CircleAvatar(child: Center(child: Icon(Icons.now_wallpaper))),
          callback: () {}),
      SettingOption(
          title: '最愛好友',
          icon: CircleAvatar(child: Center(child: Icon(Icons.star))),
          callback: () {}),
      // SettingOption(
      //     title: '最愛主播',
      //     icon: CircleAvatar(child: Center(child: Icon(Icons.star))),
      //     callback: () {
      //       Provider.of<ChatProvider>(context, listen: false).getaddress();
      //     }),
      // SettingOption(
      //     title: '遇見直播主',
      //     icon: CircleAvatar(child: Center(child: Icon(Icons.favorite))),
      //     callback: () {}),
      SettingOption(
          title: '活動花絮',
          icon: CircleAvatar(child: Center(child: Icon(Icons.note))),
          callback: () {}),
      SettingOption(
          title: '交友設定',
          icon: CircleAvatar(child: Center(child: Icon(Icons.settings))),
          callback: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DateSetting()));
          }),
      SettingOption(
          title: '直播設定',
          icon: CircleAvatar(
              child: Center(
            child: Icon(Icons.settings),
          )),
          callback: () {}),
    ];

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //頭像
                      GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Consumer<ChatProvider>(
                                builder: (context, value, child) {
                              return value.remoteUserInfo != null
                                  ? value.remoteUserInfo[0].avatar_sub != null
                                      ? CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                              '${value.remoteUserInfo[0].avatar_sub}'),
                                        )
                                      : CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.grey,
                                        )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.grey,
                                    );
                            }),
                            Stack(
                              children: [
                                Text(
                                  '修改大頭貼',
                                  style: TextStyle(
                                    fontSize: 15,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.white,
                                  ),
                                ),
                                Text(
                                  '修改大頭貼',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                            Positioned(
                                top: -5,
                                right: 0,
                                child: RotationTransition(
                                    turns: AlwaysStoppedAnimation(360 / 360),
                                    child: Consumer<ChatProvider>(
                                        builder: (context, value, child) {
                                      return Icon(
                                        value.remoteUserInfo[0].sex == '男'
                                            ? Icons.male
                                            : Icons.female,
                                        color:
                                            value.remoteUserInfo[0].sex == '男'
                                                ? Colors.blue
                                                : Colors.pink,
                                        size: 45,
                                      );
                                    })))
                          ],
                        ),
                        onTap: () {
                          Provider.of<ChatProvider>(context, listen: false)
                              .change_avatar();
                        },
                      ),
                      // 按鈕
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileSetting()));
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                  Text(
                                    '編輯檔案',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xffffcccc))),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyProfilePage()));
                              },
                              child: Text(
                                '檢視個人檔案',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xffffffbb))),
                            ),
                          ],
                        ),
                      ),
                      //出去 離開
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Container(
                          height: 56,
                          width: 50,
                          color: Colors.transparent,
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    //四個計數
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 20,
                          ),
                          // Column(
                          //   children: [
                          //     Text('5'),
                          //     Row(
                          //       children: [
                          //         Icon(
                          //           Icons.remove_red_eye_rounded,
                          //           size: 12,
                          //           color: Colors.green,
                          //         ),
                          //         Text(
                          //           '誰看過我',
                          //           style: TextStyle(
                          //               color: Colors.grey, fontSize: 12),
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // ),
                          // Container(
                          //   height: 20,
                          //   width: 1,
                          //   color: Colors.grey,
                          // ),
                          GestureDetector(
                            child: Column(
                              children: [
                                Consumer<ChatProvider>(
                                    builder: (context, value, child) {
                                  return Text(value.follow_me_list is List
                                      ? '${value.follow_me_list.length}'
                                      : '加載中');
                                }),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: 12,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      '誰喜歡我',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    )
                                  ],
                                )
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LikeMeList()));
                            },
                          ),
                          Container(
                            height: 20,
                            width: 1,
                            color: Colors.grey,
                          ),
                          // Column(
                          //   children: [
                          //     Text('5'),
                          //     Row(
                          //       children: [
                          //         Icon(
                          //           Icons.star,
                          //           size: 12,
                          //           color: Colors.red,
                          //         ),
                          //         Text(
                          //           '最愛好友',
                          //           style: TextStyle(
                          //               color: Colors.grey, fontSize: 12),
                          //         )
                          //       ],
                          //     )
                          //   ],
                          // ),
                          // Container(
                          //   height: 20,
                          //   width: 1,
                          //   color: Colors.grey,
                          // ),
                          Column(
                            children: [
                              Consumer<ChatProvider>(
                                  builder: (context, value, child) {
                                return Text(value.myfollowlog is List
                                    ? value.myfollowlog.isNotEmpty
                                        ? value.myfollowlog.length > 0
                                            ? value.myfollowlog[0].list_id !=
                                                    null
                                                ? value.myfollowlog[0].list_id
                                                        is List
                                                    ? '${value.myfollowlog[0].list_id.length}'
                                                    : '0'
                                                : '0'
                                            : '0'
                                        : '0'
                                    : '加載中');
                              }),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    '最愛主播',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    //加入會員
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: GestureDetector(
                        child: Container(
                          height: 50,
                          width: 260,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.king_bed,
                                color: Colors.yellow,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(
                                  '加入會員  升級VIP',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpGradeVIP()));
                        },
                      ),
                    ),
                    //設定
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: item.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                item[index].icon!,
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text('${item[index].title}'),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            item[index].callback();
                          },
                        );
                      },
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.mail_outline,
                                    color: Colors.grey,
                                  )),
                              Text('聯絡我們')
                            ],
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.error,
                                    color: Colors.grey,
                                  )),
                              Text('了解與介紹')
                            ],
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.error_outline_sharp,
                                    color: Colors.grey,
                                  )),
                              Text('說明事項與聲明')
                            ],
                          ),
                          Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      GoogleSignIn().signOut();
                                      FacebookAuth.instance.logOut();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()),
                                          (route) => false);
                                    },
                                    icon: Icon(
                                      Icons.logout,
                                      color: Colors.grey,
                                    )),
                                Text('登出')
                              ],
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        GoogleSignIn().signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false);
                      },
                    ),
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Row(
                    //         children: [
                    //           IconButton(
                    //               onPressed: () {},
                    //               icon: Icon(
                    //                 Icons.logout,
                    //                 color: Colors.grey,
                    //               )),
                    //           Text('登出')
                    //         ],
                    //       ),
                    //       Divider(
                    //         height: 1,
                    //         color: Colors.grey,
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
