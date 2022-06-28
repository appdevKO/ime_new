import 'package:flutter/material.dart';

class CreateMission extends StatefulWidget {
  const CreateMission({Key? key}) : super(key: key);

  @override
  State<CreateMission> createState() => _CreateMissionState();
}

class _CreateMissionState extends State<CreateMission> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('建立新任務'),
        ),
        body: Container(),
      ),
    );
  }
}
