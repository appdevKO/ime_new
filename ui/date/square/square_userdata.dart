import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/fakeuserdata_model.dart';

/**
 * 廣場點進去的 用戶 資訊介面
 */

class SquareUserInfoPage extends StatefulWidget {
  SquareUserInfoPage({Key? key, required this.user}) : super(key: key);

  Fakeuser user;

  @override
  _SquareUserInfoPageState createState() => _SquareUserInfoPageState();
}

class _SquareUserInfoPageState extends State<SquareUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.red,
                      ),
                      Positioned(
                        top: 0,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage('${widget.user.avatar}'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * .45,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .55,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, left: 15, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.user.name}',
                                  style: TextStyle(
                                      color: Colors.brown, fontSize: 16),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        '${widget.user.introduction}',
                                        style: TextStyle(
                                            color: Colors.brown, fontSize: 16),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          '${widget.user.location}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      ),
                                      Text('誰喜歡我'),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text('0'),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.blue,
                                      ),
                                      Text('誰喜歡我'),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text('0'),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
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
                    '${widget.user.name}',
                    style: TextStyle(
                        color: Colors.transparent, fontWeight: FontWeight.w700),
                  )),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.transparent,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
