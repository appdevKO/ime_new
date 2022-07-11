import 'package:flutter/material.dart';

class SpyAnchorLive extends StatefulWidget {
  const SpyAnchorLive({Key? key}) : super(key: key);

  @override
  State<SpyAnchorLive> createState() => _SpyAnchorLiveState();
}

class _SpyAnchorLiveState extends State<SpyAnchorLive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text('anchor live'),
        Container(
            height: MediaQuery.of(context).size.height - 10 - 280,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0, mainAxisSpacing: 10.0,
                  childAspectRatio: .9, //子元素在横轴长度和主轴长度的比例
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width / 2 - 20,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: Colors.pink.withOpacity(.5),
                                      width: 1)),
                            ),
                            Container(
                              height: 25,
                              width: 75,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(8))),
                              child: Center(
                                child: Text(
                                  '直播中',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Positioned(
                                right: 5,
                                top: 3,
                                child: Container(
                                  height: 20,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Color(0xffffbde6),
                                        Color(0xffff73c7)
                                      ]),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      '#顏值',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                )),
                            Positioned(
                                left: 5,
                                bottom: 5,
                                child: Container(
                                  height: 15,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      '旅遊中',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11),
                                    ),
                                  ),
                                )),
                            Positioned(
                                right: 10,
                                bottom: 5,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        '2',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                      Text('456')
                    ],
                  );
                },
                itemCount: 15,
              ),
            )),
      ],
    ));
  }
}
