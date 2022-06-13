
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'meet_detail_page.dart';

class MeetMatch extends StatefulWidget {
  const MeetMatch({Key? key}) : super(key: key);

  @override
  State<MeetMatch> createState() => _MeetMatchState();
}

class _MeetMatchState extends State<MeetMatch> {
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
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.format_list_numbered_rounded,
              ),
              Icon(Icons.info_outline)
            ],
          ),
          Container(
            height: 15,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 20,
              shrinkWrap: true, //打開只占據所需畫面的大小
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    //圖片
                    GroupSwipe(imglist: imgList, radius: 10),
                    //資訊
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '標題',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              height: 3,
                            ),
                            Text(
                              '價錢\$90',
                              style: TextStyle(
                                color: Color(0xff5e15e7),
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              height: 3,
                            ),
                            Text(
                              '簡介',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Container(
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
                                Container(
                                  width: 10,
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      print('我想了解');
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MeetDetailPage()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffb798fc),
                                              Color(0xff593ff5)
                                            ],
                                          )),
                                      child: Center(
                                        child: Text(
                                          '我想了解',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    )
                  ]),
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 10,
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class GroupSwipe extends StatefulWidget {
  const GroupSwipe({Key? key, required this.imglist, required this.radius})
      : super(key: key);
  final List<String> imglist;
  final double radius;

  @override
  _GroupSwipeState createState() => _GroupSwipeState();
}

class _GroupSwipeState extends State<GroupSwipe> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * .23,
          child: CarouselSlider.builder(
            options: CarouselOptions(
                height: 400.0,
                viewportFraction: 1.0, //放最大
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            carouselController: _controller,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                  borderRadius: widget.radius != 0
                      ? BorderRadius.only(
                          topRight: Radius.circular(widget.radius),
                          topLeft: Radius.circular(widget.radius),
                        )
                      : BorderRadius.zero,
                  child: Image.network(
                    widget.imglist[itemIndex],
                    fit: BoxFit.fitWidth,
                  )),
            ),
            itemCount: widget.imglist.length,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imglist.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff5e15e7)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
