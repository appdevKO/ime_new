import 'package:flutter/material.dart';

class MissionDetailPage extends StatefulWidget {
  const MissionDetailPage({Key? key}) : super(key: key);

  @override
  State<MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<MissionDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('特務mission/showtime 細節頁面'),
      ),
    );
  }
}
