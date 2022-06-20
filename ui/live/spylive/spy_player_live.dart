import 'package:flutter/material.dart';

class SpyPlayerLive extends StatefulWidget {
  const SpyPlayerLive({Key? key}) : super(key: key);

  @override
  State<SpyPlayerLive> createState() => _SpyPlayerLiveState();
}

class _SpyPlayerLiveState extends State<SpyPlayerLive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text('player live'),
        Container(
          height: MediaQuery.of(context).size.height - 10 - 280,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                // color: Colors.red,
                child: Text('456',style: TextStyle(color: Colors.transparent),),
              );
            },
            itemCount: 5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff20b2ea), Color(0xff40e0d0)]),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.format_list_bulleted,
                      color: Colors.white,
                    ),
                    Text(
                      '任務欄',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
              ),
              Container(
                width: 120,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(5)),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app_sharp,
                      color: Colors.white,
                    ),
                    Text(
                      '我要發任務',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
              )
            ],
          ),
        )
      ],
    ));
  }
}
