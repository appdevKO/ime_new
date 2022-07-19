import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/model/mission_model.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class FakeStream extends StatefulWidget {
  FakeStream({Key? key, required this.TheMission}) : super(key: key);
  MissionModel? TheMission;

  @override
  State<FakeStream> createState() => _FakeStreamState();
}

class _FakeStreamState extends State<FakeStream> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('特務mission/showtime 直播間'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${widget.TheMission?.status} ${widget.TheMission?.title} '),
          widget.TheMission?.type == 1 || widget.TheMission?.type == 2
              ? GestureDetector(
                  child: Container(
                    width: 150,
                    height: 50,
                    color: Colors.purple,
                    child: Center(
                      child: Text('開始 mission 直播'),
                    ),
                  ),
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .start_mission(widget.TheMission?.id);
                  },
                )
              : GestureDetector(
                  child: Container(
                    width: 150,
                    height: 50,
                    color: Colors.pink,
                    child: Center(
                      child: Text('開始 showtime 直播'),
                    ),
                  ),
                  onTap: () {
                    Provider.of<ChatProvider>(context, listen: false)
                        .start_showtime(widget.TheMission?.id);
                  },
                ),
          GestureDetector(
            child: Container(
              width: 150,
              height: 50,
              color: Colors.blue,
              child: Center(
                child: Text('關閉直播'),
              ),
            ),
            onTap: () {
              Provider.of<ChatProvider>(context, listen: false)
                  .finish_mission(widget.TheMission?.id);
            },
          )
        ],
      ),
    );
  }
}
