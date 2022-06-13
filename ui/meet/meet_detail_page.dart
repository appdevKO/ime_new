import 'package:flutter/material.dart';

import 'meet_match.dart';

class MeetDetailPage extends StatefulWidget {
  const MeetDetailPage({Key? key, this.MeetID}) : super(key: key);
  final MeetID;

  @override
  _MeetDetailPageState createState() => _MeetDetailPageState();
}

class _MeetDetailPageState extends State<MeetDetailPage> {
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: new Size(MediaQuery.of(context).size.width, 50),
          child: Container(
              height: 54,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(colors: [
                  Color(0xff5832e3),
                  Color(0xffb796f5),
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      '我想了解',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    Icon(
                      Icons.close,
                      color: Colors.transparent,
                    ),
                  ],
                ),
              )),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  GroupSwipe(
                    imglist: imgList,
                    radius: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '標題',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('加入I ME Line @**** 將有專人與您聯絡',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red)),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xff69149e),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '#北部',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('試排價 \$690',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff5e15e7),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text('環境介紹',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                'https://cdn.pixabay.com/photo/2021/12/18/06/01/sunset-6878021_1280.jpg',
                                height:
                                    (MediaQuery.of(context).size.width - 20) /
                                        3.5,
                                width:
                                    (MediaQuery.of(context).size.width - 20) /
                                        3.5,
                                fit: BoxFit.fitHeight,
                              ),
                              Image.network(
                                  'https://cdn.pixabay.com/photo/2017/01/18/16/46/hong-kong-1990268_1280.jpg',
                                  height:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  width:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  fit: BoxFit.fitHeight),
                              Image.network(
                                  'https://cdn.pixabay.com/photo/2017/01/28/02/24/japan-2014618_1280.jpg',
                                  height:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  width:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  fit: BoxFit.fitHeight),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text('配對案例',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                'https://cdn.pixabay.com/photo/2016/09/26/21/01/st-peters-square-1697064_1280.jpg',
                                height:
                                    (MediaQuery.of(context).size.width - 20) /
                                        3.5,
                                width:
                                    (MediaQuery.of(context).size.width - 20) /
                                        3.5,
                                fit: BoxFit.fitHeight,
                              ),
                              Image.network(
                                  'https://cdn.pixabay.com/photo/2018/07/15/23/22/prague-3540883_1280.jpg',
                                  height:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  width:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  fit: BoxFit.fitHeight),
                              Image.network(
                                  'https://media.istockphoto.com/photos/happy-new-year-2022-picture-id1355894965',
                                  height:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  width:
                                      (MediaQuery.of(context).size.width - 20) /
                                          3.5,
                                  fit: BoxFit.fitHeight),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text('關於愛蜜配對',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('測試測試測試測試測試測試測試測試測試測試測試測試測試測試測試測試測試測試測試',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text('注意事項',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('測試測試測試測試\n測試測試測試測試測試',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                  //留白
                  Container(
                    height: 10,
                  ),
                  //留給下面line
                  Container(
                    height: 50,
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(78, 205, 0, 1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                          'https://livedoor.blogimg.jp/line_tw/imgs/e/0/e0e94524-s.png',scale: 3,),
                      Text(
                        '報名請加入I ME官方Line@ 將有專人為您服務',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
