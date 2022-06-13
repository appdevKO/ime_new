import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class FavoriteActionList extends StatefulWidget {
  const FavoriteActionList({Key? key}) : super(key: key);

  @override
  State<FavoriteActionList> createState() => _FavoriteActionListState();
}

class _FavoriteActionListState extends State<FavoriteActionList> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return SingleAction2();
      },
      separatorBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Divider(
            height: 1,
          ),
        );
      },
      itemCount: 10,
    );
  }

  Future initData() async {
    print('init new action');
    await Provider.of<ChatProvider>(context, listen: false).get_favorite_action_list();
  }
}

class SingleAction2 extends StatefulWidget {
  const SingleAction2({Key? key}) : super(key: key);

  @override
  State<SingleAction2> createState() => _SingleAction2State();
}

class _SingleAction2State extends State<SingleAction2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 31,
            backgroundColor: Colors.grey,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 30,
              backgroundImage: AssetImage('assets/default/sex_woman.png'),
            ),
          ),
          Container(
            width: 8,
          ),
          Container(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WE',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 10,
                              width: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Container(
                                  height: 10,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black),
                                ))
                          ],
                        ),
                        //圖片
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/default/lake-scenery.png'),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '2020-4-17',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              '2',
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
                              size: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text(
                                '2',
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
          ),
        ],
      ),
    );
  }
}
