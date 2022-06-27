import 'package:flutter/material.dart';
import 'package:ime_new/ui/date/square/square_near.dart';
import 'package:ime_new/ui/date/square/square_new_login.dart';
import 'package:ime_new/ui/date/square/square_new_register.dart';
import 'package:ime_new/ui/date/square/square_recommend.dart';
import 'package:ime_new/ui/otherpage/other_profile_page.dart';
import 'package:ime_new/ui/widget/stack_text.dart';
import 'package:provider/provider.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:swiping_card_deck/swiping_card_deck.dart';

//交友廣場 方塊
class DateSquare extends StatefulWidget {
  const DateSquare({Key? key}) : super(key: key);

  @override
  State<DateSquare> createState() => _DateSquareState();
}

class _DateSquareState extends State<DateSquare>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    initData();
    super.initState();
  }

  Future initData() async {
    await Provider.of<ChatProvider>(context, listen: false)
        .find_last_login_people();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<ChatProvider>(builder: (context, value, child) {
      return Container(
          child: value.last_login_memberlist != null
              //    卡牌
              ? SwipingCardDeck(
                  message: Container(
                    height: 20,
                    width: 20,
                    color: Colors.transparent,
                  ),
                  cardDeck: List<Card>.generate(
                      value.last_login_memberlist!.length,
                      (i) => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: GestureDetector(
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .75,
                                  width: MediaQuery.of(context).size.width - 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            '${value.last_login_memberlist![i].avatar}'),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .27,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                Colors.black,
                                                Colors.transparent,
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .064,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    value
                                                                    .last_login_memberlist![
                                                                        i]
                                                                    .nickname ==
                                                                null ||
                                                            value.last_login_memberlist![i]
                                                                    .nickname ==
                                                                ''
                                                        ? '不詳'
                                                        : '${value.last_login_memberlist![i].nickname}',
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0),
                                                    child: Text(
                                                      value
                                                                      .last_login_memberlist![
                                                                          i]
                                                                      .birthday ==
                                                                  null ||
                                                              value.last_login_memberlist![i]
                                                                      .birthday ==
                                                                  ''
                                                          ? '不詳'
                                                          : '${DateTime.now().year - value.last_login_memberlist![i].birthday.year}',
                                                      style: TextStyle(
                                                        fontSize: 26,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                value.last_login_memberlist![i]
                                                                .area ==
                                                            null ||
                                                        value.last_login_memberlist![i]
                                                                .area ==
                                                            ''
                                                    ? '不詳'
                                                    : '${value.last_login_memberlist![i].area}',
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                              onTap: () {
                                if (value.last_login_memberlist![i].account !=
                                    value.remoteUserInfo[0].account) {
                                  //成員橫排 點 單一頭像
                                  // 改成先進簡介
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OtherProfilePage(
                                                chatroomid: value
                                                    .last_login_memberlist![i]
                                                    .memberid,
                                              )));
                                } else {
                                  print('同一人');
                                }
                              },
                            ),
                          )),
                  //原本是滑完觸發 改為 最後第三張 觸發 補卡片
                  onDeckEmpty: () =>
                      Provider.of<ChatProvider>(context, listen: false)
                          .addpage_find_last_login_people(),
                  onLeftSwipe:
                      (Card card, List<Card> cardDeck, int cardsSwiped) =>
                          debugPrint("Swiped left!"),
                  onRightSwipe:
                      (Card card, List<Card> cardDeck, int cardsSwiped) =>
                          debugPrint("Swiped right!"),
                  swipeThreshold: MediaQuery.of(context).size.width / 4,
                  minimumVelocity: 1000,
                  cardWidth: 200,
                  rotationFactor: 0.8 / 3.14,
                  swipeAnimationDuration: const Duration(milliseconds: 100),
                )
              : Container(
                  child: Center(
                    child: Text('目前沒有人'),
                  ),
                ));
    }));
  }
}

class Content {
  final String text;
  final Color color;

  Content({required this.text, required this.color});
}
