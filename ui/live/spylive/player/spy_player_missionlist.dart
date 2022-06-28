import 'package:flutter/material.dart';

class SpyPlayerMission extends StatefulWidget {
  const SpyPlayerMission({Key? key}) : super(key: key);

  @override
  State<SpyPlayerMission> createState() => _SpyPlayerMissionState();
}

class _SpyPlayerMissionState extends State<SpyPlayerMission> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Text('player mission'),
            Container(
              height: MediaQuery.of(context).size.height - 10 - 280,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1.5),
                            ),
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '誰誰誰發起',
                                    style:
                                    TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      '456',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.monetization_on,
                                        color: Colors.amber,
                                        size: 26,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '456',
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '開播時間',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.timelapse,
                                            color: Colors.greenAccent,
                                            size: 26,
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 8.0),
                                            child: Container(
                                              width: 100,
                                              child: Text(
                                                '2022-12-18 20:00:33',
                                                style: TextStyle(
                                                    color: Colors.greenAccent,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 40,child: Text('承接',style: TextStyle(color: Colors.black),),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Container(
                  height: 10,
                ),
                itemCount: 5,
              ),
            ),

          ],
        ));
  }
}
