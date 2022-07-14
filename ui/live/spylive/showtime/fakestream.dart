import 'package:flutter/material.dart';
class FakeStream extends StatefulWidget {
  const FakeStream({Key? key}) : super(key: key);

  @override
  State<FakeStream> createState() => _FakeStreamState();
}

class _FakeStreamState extends State<FakeStream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('特務mission/showtime 直播間'),),);
  }
}
